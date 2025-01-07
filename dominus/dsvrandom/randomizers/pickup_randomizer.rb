require_relative '../rv/ooe_locations'
require_relative '../rv/ooe_items'
require_relative '../rv/ooe_checker'
require 'set'

class PickupRandomizer

  attr_reader :rng,
              :game,
              :checker,
              :spoiler_log,
              :non_spoiler_log

  def initialize(rng, game, logs, &block)
    @rng = rng
    @game = game
    @checker = game.checker
    @logic = OoELogic.new(game.checker, game.options)
    @options = game.options
    Locations.set_logic(@logic)
    @all_rooms = []
    @used_pickup_flags = []
    # For OoE we sometimes need pickup flags for when a glyph statue gets randomized into something that's not a glyph statue.
    @unused_pickup_flags = (0x71..0x15F).to_a
    @spoiler_log, @non_spoiler_log = logs
    pre_rando_tweaks()
    randomize_starting_glyph()
    randomize() do |response|
      yield response
    end
  end

  def randomize_starting_glyph()
    # Glyph given by Barlowe.
    # We randomize this, but only to a starter weapon glyph, not to any glyph.
    possible_starter_weapons = ["Confodere", "Secare", "Hasta", "Macir", "Arcus", "Ascia", "Falcis", "Culter", "Grando", "Vol Fulgur", "Umbra"]
    pickup_name = possible_starter_weapons.sample(random: rng)
    pickup_id = OoEItems.items[pickup_name][:id]
    game.tweaks.modify_hardcoded_glyph_event(0x63, pickup_id + 1)
    checker.add_item(pickup_name)
  end

  def randomize(&block)
    # Pickup flags 160-16D and 170-17D exist but are used by no-damage blue chests so we don't use those. 16E, 16F, 17E, and 17F could probably be used by the randomizer safely but currently are not.
    use_pickup_flag(0xB5) # Pickup flag for the Strength Ring chest.
    use_pickup_flag(0xB2) # This appears to be used by something hardcoded, though I can't find what it is.

    #Not currently used for anything, but might factor into future changes (randomized Glyph Union?)
    checker.add_item("Casual Clothes")
    checker.add_item("Lizard Tail")
    checker.add_item("Glyph Union")
    checker.add_item("Torpor")

    checker.add_item("Glyph Sleeve")

    if @options[:rv_randomize_quest_rewards]
      nonrelic_items = OoEItems.equipment.merge(OoEItems.consumables)
      game.quests.each do |quest|
        next if quest.quest_index == 0 #unused quest
        next unless quest.reward_is_pickup?
        final_quest_indices = [4, 8, 11, 14, 17, 20, 23, 26, 29, 32, 35]
        possible_rewards = final_quest_indices.include?(quest.quest_index) ? OoEItems.glyphs : nonrelic_items
        reward_key = possible_rewards.keys.sample(random: rng)
        quest.reward = possible_rewards[reward_key][:id] + 1
      end
    end

    @total_pickups = checker.all_pickups.length
    place_pickups(checker) do |pickups_placed|
      percent_done = pickups_placed.to_f / Locations.locs.size
      yield percent_done
    end

    if !checker.game_beatable?
      raise "Bug: Game is not beatable on this seed!\nThis error shouldn't happen.\nSeed: #{@seed}\n\nItems:\n#{checker.current_items.join(", ")}"
    end
  end

  def place_pickups(checker, &block)
    previous_accessible_locations = []
    locations_randomized_to_have_useful_pickups = []
    rooms_that_already_have_an_event = []
    pickups_placed = 0
    total_pickups = checker.all_pickups.length
    on_leftovers = false
    @rooms_by_progression_order_accessed = []

    game.rooms.each do |room|
      room.entities.each do |entity|
        if entity.is_special_object? && (0x5f..0x88).include?(entity.subtype)
          room_str = "%02X-%02X-%02X" % [room.area_index, room.sector_index, room.room_index]
          rooms_that_already_have_an_event << room_str
          break
        end
      end
    end

    verbose = false

    @spoiler_log.puts "Placing main route static pickups:"
    on_first_item = true
    retries = 0
    temp_bans = []

    if @options[:rv_hint_cat_locations] != "No Hints"
      transformation = ["Arma Felix", "Arma Chiroptera", "Arma Machina"].sample(random: rng)
      @game.tweaks.set_chosen_transformation(transformation)
      @checker.all_progression_pickups[transformation] = OoEItems.glyphs[transformation]
      cats = ["SoybeanFlour", "Tofu", "Ink"]
      if @options[:rv_hint_cat_locations] == "Randomized Among Villager Locations"
        #Randomize cats among villager locations
        villager_locations = Locations.locs.select {|loc| loc[:type].include?("Villager")}
        cats.each do |cat|
          loc = villager_locations.sample(random: rng)
          cat_entity = @game.get_entity_by_id(loc[:id])
          cat_entity.type = 2 #special object
          cat_entity.subtype = 0x3f #cat
          cat_indexes = {"Tofu" => 0, "Ink" => 1, "SoybeanFlour" => 2}
          cat_entity.var_a = cat_indexes[cat]
          cat_entity.var_b = 2 #needs rescuing
          villager_locations.delete(loc)
        end
        #Also null out the original cat locations
        ["12-00-07_07", "0E-00-03_00", "08-02-01-10"].each do |loc|
          original_cat = @game.get_entity_by_id(loc)
          original_cat.type = 0
        end
        #Populate the rest of the villager locations with skeletons for fun
        villager_locations.each do |loc|
          skele_entity = @game.get_entity_by_id(loc[:id])
          skele_entity.type = 1 #enemy
          skele_entity.subtype = 2 #skeleton
          skele_entity.var_a = 1 #can jump
        end
      end
    else
      transformation = nil
    end


    all_custos = ["Dextro Custos", "Sinestro Custos", "Arma Custos"]
    all_dominus = ["Dominus Hatred", "Dominus Anger", "Dominus Agony"]
    all_custos_dominus = all_custos + all_dominus
    if @options[:rv_hint_cat_locations] != "No Hints"
      if @options[:rv_unlock_cerberus]
        hints_to_use = all_dominus
      else
        hints_to_use = all_dominus + all_custos
        nums = (1..6).to_a
        weights = (1..6).flat_map {|w| Math.sqrt(w)}
        weights = weights.map{|w| w.to_f / weights.reduce(:+)}
        weighted_nums = nums.zip(weights).to_h
        hint_numbers = weighted_nums.max_by(3){|_, w| rng.rand ** (1.0 / w)}.map{|k, v| k}
        hint_counter = 1
      end
    end
    all_progression_glyphs = checker.all_progression_pickups.select {|k, v| OoEItems.glyphs.has_key?(k)}
    all_non_progression_glyphs = OoEItems.glyphs.select {|k, v| not all_progression_glyphs.has_key?(k)}
    # To prevent the randomizer from filling too many spaces with useless items too often and making the seed uncompleteable, we reserve some slots for progression glyphs.
    # But this could result in seeds becoming too similar to each other, so we add some random glyphs in here too as a safeguard against that.
    if @options[:rv_unlock_cerberus]
      all_spacer_glyphs = all_non_progression_glyphs.reject {|k, v| checker.current_items.include?(k)}.keys.sample(5, random: rng)
    else
      all_spacer_glyphs = all_custos + all_non_progression_glyphs.keys.sample(2, random: rng)
    end
    #The same thing tends to happen with sticking lots of "undroppables" like max ups in final approach, so let's pick some random items as spacers too.
    #It mostly affects end game and weighting for tiers will be handled by later code.
    all_spacer_items = checker.all_pickups.reject {|k, v| checker.current_items.include?(k) or OoEItems.undroppables.has_key?(k) or OoEItems.glyphs.has_key?(k)}.keys.sample(30, random: rng)

    ensured_quest_items = []

    while true
      possible_locations = checker.get_accessible_locations().reject {|loc| locations_randomized_to_have_useful_pickups.include?(loc[:id])}
      puts "Total possible locations: #{possible_locations.size}" if verbose
      if possible_locations.empty?
        break
      end
      glyph_locations = filter_locations_valid_for_pickup(checker, possible_locations, "Magnes")
      relic_locations = filter_locations_valid_for_pickup(checker, possible_locations, "Ordinary Rock")

      pickups_by_locations = checker.pickups_by_current_num_locations_they_access()
      custos = checker.current_items.select {|item| all_custos.include?(item)}
      dominus = checker.current_items.select {|item| all_dominus.include?(item)}
      spacer_glyphs = checker.current_items.select {|item| all_spacer_glyphs.include?(item)}
      current_relics = checker.current_items.select {|item| OoEItems.relics.has_key?(item)}
      progression_relics = checker.current_items.select {|item| ["Ordinary Rock", "Serpent Scale"].include?(item)}
      spacer_items = checker.current_items.select {|item| all_spacer_items.include?(item)}


      # Much of the following (spacer etc.) code is a total mess and relatively slow. Needs some cleanup, but function was first priority.

      # In the end game it's possible to run out of room to put progresion glyphs. We'll track the total number remaining and move to progression-only mode when the number is low enough.
      total_remaining_locations = Locations.locs.reject {|loc| locations_randomized_to_have_useful_pickups.include?(loc[:id])}
      total_remaining_progression_glyph_locations = filter_locations_valid_for_pickup(checker, total_remaining_locations, "Magnes")
      current_progression_glyphs = checker.current_items.select{|item| OoEItems.glyphs.has_key?(item) and checker.all_progression_pickups.has_key?(item)}
      progression_glyph_gap = all_progression_glyphs.size + all_spacer_glyphs.size - current_progression_glyphs.size - spacer_glyphs.size + checker.unfinished_glyph_task_count

      if @options[:rv_split_pools]
        if progression_glyph_gap > 0 and total_remaining_progression_glyph_locations.size <= progression_glyph_gap
          #Ensure we don't put any other glyphs in these slots anymore.
          pickups_by_locations = pickups_by_locations.select {|pickup, num_locations| (not OoEItems.glyphs.has_key?(pickup)) or all_progression_glyphs.has_key?(pickup) or all_spacer_glyphs.include?(pickup) or num_locations > 0}
        end
      end


      # Same for relics and max ups (we won't make these drop from other sources like enemies, but we can do that with glyphs/equipment/consumables so it's fine to miss them.)
      total_remaining_undroppable_locations = filter_locations_valid_for_pickup(checker, total_remaining_locations, "Ordinary Rock")
      current_undroppables = checker.current_items.select{|item| OoEItems.undroppables.has_key?(item)}
      undroppable_gap = OoEItems.undroppables.size + all_spacer_items.size - current_undroppables.size - spacer_items.size

      if @options[:rv_split_pools]
        if undroppable_gap > 0 and total_remaining_undroppable_locations.size <= undroppable_gap
          #Ensure we don't put any other items in these slots anymore.
          pickups_by_locations = pickups_by_locations.select {|pickup, num_locations| OoEItems.glyphs.has_key?(pickup) or OoEItems.undroppables.has_key?(pickup) or all_spacer_items.include?(pickup)}
        end
      end

      if @options[:rv_split_pools]
        if (glyph_locations.size <= (8 - dominus.size - spacer_glyphs.size)) and (dominus.size + spacer_glyphs.size != 8)
          # Ensure that we don't fill up glyph slots with every other possible glyph and then not have enough to access Final Approach. Leaving slots open also helps with variety of pickup placement in early game.
          pickups_by_locations = pickups_by_locations.select {|pickup, num_locations| (not OoEItems.glyphs.has_key?(pickup)) or num_locations > 0 or all_dominus.include?(pickup) or all_spacer_glyphs.include?(pickup)}
        elsif glyph_locations.size == 0
          #Every glyph location has been filled. Skip them to save time.
          pickups_by_locations = pickups_by_locations.reject {|pickup, num_locations| OoEItems.glyphs.has_key?(pickup)}
        end
        if relic_locations.size == 1 and progression_relics.size < 2 and pickups_by_locations.values.max > 0
          pickups_by_locations = pickups_by_locations.select {|pickup, num_locations| OoEItems.glyphs.has_key?(pickup) or (OoEItems.relics.has_key?(pickup) and num_locations > 0) or num_locations > 0}
        elsif relic_locations.size == 1 and current_relics.size < 3 and pickups_by_locations.values.max == 0
          #don't forget to leave room for Book of Spirits, but don't prioritize it
          pickups_by_locations = pickups_by_locations.select {|pickup, num_locations| OoEItems.glyphs.has_key?(pickup) or OoEItems.relics.has_key?(pickup) or num_locations > 0}
        elsif glyph_locations.size == possible_locations.size
          #Every item location has been filled, so skip everything but glyphs to save time.
          pickups_by_locations = pickups_by_locations.select {|pickup, num_locations| OoEItems.glyphs.has_key?(pickup)}
        end
      else
        combined_gap = undroppable_gap + progression_glyph_gap
        if total_remaining_undroppable_locations.size <= combined_gap and combined_gap > 0
          pickups_by_locations = pickups_by_locations.select {|pickup, num_locations| OoEItems.undroppables.has_key?(pickup) or all_spacer_items.include?(pickup) or all_progression_glyphs.has_key?(pickup) or all_spacer_glyphs.include?(pickup) or num_locations > 0}
        end
      end

      #emergency valve for when the seed hasn't placed enough equipment to reach lategame progression requirements. Also used to reduce the chance of maxups clumping together.
      equipment_locations = filter_locations_valid_for_pickup(checker, possible_locations, "Battle Boots")
      if @options[:rv_split_pools]
        if equipment_locations.size - OoEItems.undroppables.size - all_spacer_items.size + spacer_items.size + checker.current_items.select {|item| OoEItems.undroppables.has_key?(item)}.size <= checker.unfinished_gear_task_count and checker.unfinished_gear_task_count != 0
          pickups_by_locations = pickups_by_locations.select {|pickup, num_locations| OoEItems.glyphs.has_key?(pickup) or OoEItems.undroppables.has_key?(pickup) or num_locations > 0 or all_spacer_items.include?(pickup) or \
                                                            (OoEItems.equipment.has_key?(pickup) and checker.tentative_gear_level(pickup).first > checker.gear_level)}
        end
      else
        if equipment_locations.size - OoEItems.undroppables.size - all_spacer_items.size - all_spacer_glyphs.size - all_progression_glyphs.size + spacer_items.size + checker.current_items.select {|item| OoEItems.undroppables.has_key?(item)}.size + spacer_glyphs.size + current_progression_glyphs.size <= checker.unfinished_gear_task_count + checker.unfinished_glyph_task_count and checker.unfinished_gear_task_count + checker.unfinished_glyph_task_count != 0
          pickups_by_locations = pickups_by_locations.select {|pickup, num_locations| OoEItems.undroppables.has_key?(pickup) or num_locations > 0 or all_spacer_items.include?(pickup) or \
                                                              (OoEItems.equipment.has_key?(pickup) and checker.tentative_gear_level(pickup).first > checker.gear_level) or all_spacer_glyphs.include?(pickup) or \
                                                             all_progression_glyphs.has_key?(pickup)}
        elsif glyph_locations.size == 0
          #Every glyph location has been filled. Skip them to save time.
          pickups_by_locations = pickups_by_locations.reject {|pickup, num_locations| OoEItems.glyphs.has_key?(pickup)}
        elsif equipment_locations.size == 0
          #Every item location has been filled, so skip everything but glyphs to save time.
          pickups_by_locations = pickups_by_locations.select {|pickup, num_locations| OoEItems.glyphs.has_key?(pickup)}
        end
      end

      pickups_by_usefulness = pickups_by_locations.select{|pickup, num_locations| num_locations > 0}
      currently_useless_pickups = pickups_by_locations.select{|pickup, num_locations| num_locations == 0}
      puts "Num useless pickups: #{currently_useless_pickups.size}" if verbose
      placing_temporarily_useless_pickup = false

      if pickups_by_locations.any?
        if (glyph_locations.size == 1 and pickups_by_locations.values.max > 0) or (relic_locations.size == 1 and progression_relics.size < 2 and pickups_by_locations.values.max > 0)
          # Glyph/relic slots are in danger of running out, so we have to pick something that advances the game.
          # This could include equipment that would raise your stats high enough to fight a boss according to your difficulty setting.
          # Earlier checks already account for custos glyphs which could block progress with more than one pickup.
          pickups_to_use = pickups_by_usefulness
        else
          pickups_to_use = pickups_by_locations
        end
        pickups_to_use = pickups_to_use.reject{|pickup, num_locations| temp_bans.include?(pickup)}

        if pickups_to_use.any?
          max_usefulness = pickups_to_use.values.max

          weights = pickups_to_use.map do |pickup, usefulness|
            #Weight less useful pickups for progressioon as more likely to be chosen.
            weight = max_usefulness - usefulness + 1
            #Weight higher tier equipment as less likely to be chosen.
            if OoEItems.equipment.has_key?(pickup)
              if @options[:rv_difficulty] == "Do Your Worst"
                weight /= (OoEItems.equipment[pickup][:tier]*2.0+1.0).to_f
              else
                weight /= (OoEItems.equipment[pickup][:tier]*0.5+1.0).to_f
              end
            #Weight "useless" progression items as being less likely to be chosen. This helps avoid waiting too long to place real progression too often.
            elsif (checker.all_progression_pickups.has_key?(pickup) or ["Moonwalkers", "Mercury Boots", "Winged Boots"].include?(pickup)) and usefulness == 0 and not all_custos_dominus.include?(pickup) and pickup != transformation
              weight *= @options[:rv_difficulty] == "Vanilla" ? 0.7 : 0.5
            elsif OoEItems.consumables.has_key?(pickup) or OoEItems.materials.has_key?(pickup)
              #Lightly weight these lower since we prefer to put them in brown chests.
              weight *= 0.8
            elsif @options[:rv_difficulty] == "Vanilla" and pickup == transformation
              #The chosen transformation shows up less than usual in Vanilla because it's never chosen as a last-second progression item.'
              weight *= 1.2
            end
            weight = Math.sqrt(weight)
            if checker.preferences.has_key?(pickup)
              weight *= checker.preferences[pickup]
            end
            weight
          end
          ps = weights.map{|w| w.to_f / weights.reduce(:+)}
          pickups = pickups_to_use.keys
          weighted_pickups = pickups.zip(ps).to_h
          pickup_name = weighted_pickups.max_by{|_, weight| rng.rand ** (1.0 / weight)}.first
          pickup_usefulness = pickups_by_locations[pickup_name]

          if checker.game_beatable?
            if !on_leftovers
              @spoiler_log.puts "Game is now beatable. Placing leftover pickups."
              on_leftovers = true
            end
          end
        else
          #All pickups placed
          break
        end

        puts "Trying to place #{pickup_name}" if verbose

        new_possible_locations = possible_locations - previous_accessible_locations.flatten

        filtered_new_possible_locations = filter_locations_valid_for_pickup(checker, new_possible_locations, pickup_name)
        puts "Filtered new possible locations: #{filtered_new_possible_locations.size}" if verbose
        #puts "  " + filtered_new_possible_locations.join(", ") if verbose

        valid_previous_accessible_regions = previous_accessible_locations.map do |previous_accessible_region|
          possible_locations = previous_accessible_region.dup
          old_possible_locations = possible_locations
          possible_locations = possible_locations.reject {|loc| locations_randomized_to_have_useful_pickups.include?(loc[:id])}

          possible_locations = filter_locations_valid_for_pickup(checker, possible_locations, pickup_name)

          possible_locations = nil if possible_locations.empty?

          possible_locations
        end.compact

        possible_locations_to_choose_from = filtered_new_possible_locations.dup

        if pickup_usefulness == 0
          # Place items that don't immediately open up new areas anywhere in the game, with no weighting towards later areas. Yet.

          valid_accessible_locations = previous_accessible_locations.map do |previous_accessible_region|
            possible_locations = previous_accessible_region.dup
            possible_locations = possible_locations.reject {|loc| locations_randomized_to_have_useful_pickups.include?(loc[:id])}

            possible_locations = filter_locations_valid_for_pickup(checker, possible_locations, pickup_name)

            possible_locations = nil if possible_locations.empty?

            possible_locations
          end.compact.flatten

          valid_accessible_locations += filtered_new_possible_locations

          possible_locations_to_choose_from = valid_accessible_locations

        elsif filtered_new_possible_locations.empty? && valid_previous_accessible_regions.any?
          if OoEItems.items[pickup_name][:type].include?("Progression")
            if on_leftovers
              # Placing a leftover progression pickup.
              # Weighted to be more likely to select locations you got access to later rather than earlier.

              i = 1
              weights = valid_previous_accessible_regions.map do |region|
                # Weight later accessible regions as more likely than earlier accessible regions (exponential)
                weight = i**2
                i += 1
                weight
              end
              ps = weights.map{|w| w.to_f / weights.reduce(:+)}
              weighted_accessible_regions = valid_previous_accessible_regions.zip(ps).to_h
              previous_accessible_region = weighted_accessible_regions.max_by{|_, weight| rng.rand ** (1.0 / weight)}.first

              possible_locations_to_choose_from = previous_accessible_region
            else
              # Placing a main route progression pickup, just not one that immediately opens up new areas.
              # Always place in the most recent accessible region.
              possible_locations_to_choose_from = valid_previous_accessible_regions.last
              puts "No new locations, using previous accessible location, total available: #{valid_previous_accessible_regions.last.size}" if verbose
            end
          else
            # Placing a non-progression item
            # For now, just place it anywhere.

            valid_accessible_locations = previous_accessible_locations.map do |previous_accessible_region|
              possible_locations = previous_accessible_region.dup
              possible_locations = possible_locations.reject {|loc| locations_randomized_to_have_useful_pickups.include?(loc[:id])}

              possible_locations = filter_locations_valid_for_pickup(checker, possible_locations, pickup_name)

              possible_locations = nil if possible_locations.empty?

              possible_locations
            end.compact.flatten

            valid_accessible_locations += filtered_new_possible_locations

            possible_locations_to_choose_from = valid_accessible_locations
          end
        elsif filtered_new_possible_locations.empty? && valid_previous_accessible_regions.empty?
          # No new locations, but there's no old locations either.
          possible_locations_to_choose_from = []
          #Todo: clean up this next block
        elsif filtered_new_possible_locations.size <= 5 && !valid_previous_accessible_regions.empty? && valid_previous_accessible_regions.last.size >= 15
          # There aren't many new locations unlocked by the last item we placed.
          # But there are a lot of other locations unlocked by the one we placed before that.
          # So we give it a chance to put it in one of those last spots, instead of the new spots.
          # The chance is proportional to how few new locations there are. 1 = 70%, 2 = 60%, 3 = 50%, 4 = 40%, 5 = 30%.
          chance = 0.30 + (5-filtered_new_possible_locations.size)*10
          if rng.rand() <= chance
            possible_locations_to_choose_from = valid_previous_accessible_regions.last
            puts "Not many new locations, using previous accessible location, total available: #{valid_previous_accessible_regions.last.size}" if verbose
          end
        end
      else
        #No pickups to place.
        break
      end

      if new_possible_locations.size > 0
        previous_accessible_locations << new_possible_locations
      end

      if possible_locations_to_choose_from.empty?
        if pickups_by_locations.empty?
          if not checker.game_beatable?
            #raise "Bug: Failed to find any spots to place pickup.\nSeed: #{@seed}\n\nItems:\n#{checker.current_items.join(", ")}"
            raise "Failed to find any spots to place pickup.\nTrying to place #{pickup_name}. Possible locations:\n#{possible_locations}. Retries: #{retries}. Items skipped: #{temp_bans.to_s}"
          else
            puts "Unable to place #{pickups_by_locations.size} pickups, but game should be beatable."
            break
          end
        else
          retries += 1
          #Try again with a different item
          temp_bans += [pickup_name]
          next
        end
      end
      retries = 0
      temp_bans = []

      location = possible_locations_to_choose_from.sample(random: rng)
      locations_randomized_to_have_useful_pickups << location[:id]

      item = OoEItems.items[pickup_name]
      if item[:type].include?("Villager")
        # Villager
        pickup_str = "villager #{pickup_name}"
      elsif item[:type].include?("Money")
        pickup_str = "Pickup #{pickup_name} (Money)"
      else
        pickup_str = "pickup %04X (#{pickup_name})" % item[:id]
      end

      is_enemy_str = checker.enemy_locations.include?(location) ? " (boss)" : ""
      is_event_str = checker.event_locations.include?(location) ? " (event)" : ""
      is_hidden_str = checker.hidden_locations.include?(location) ? " (hidden)" : ""
      spoiler_str = "  Placing #{pickup_str} at #{location[:name]}#{is_enemy_str}#{is_event_str}#{is_hidden_str} - #{location[:room]}"


      change_entity_location_to_pickup_id(location, item[:id], pickup_name) #pickup name is only needed to disambiguate money items since they all have the same ID

      checker.add_item(pickup_name)
      if pickups_to_use[pickup_name] > 0 or checker.all_progression_pickups.has_key?(pickup_name)
        @spoiler_log.puts spoiler_str
        if not checker.all_progression_pickups.has_key?(pickup_name)
        end
      end
      puts spoiler_str if verbose

      if @options[:rv_hint_cat_locations] != "No Hints" and hints_to_use.include?(pickup_name) and not cats.empty?
        if (@options[:rv_unlock_cerberus]) or (not @options[:rv_unlock_cerberus] and hint_numbers.include?(hint_counter))
          cats = cats.shuffle(random: rng)
          cat_to_use = cats.pop()
          game.tweaks.change_cat_hint(cat_to_use, pickup_name, location, transformation)
        end
        if not @options[:rv_unlock_cerberus]
          hint_counter += 1
        end
      end

      if /Drops/.match?(pickup_name)
        if rng.rand() <= 0.7
          game.tweaks.create_super_drop(pickup_name)
          checker.upgraded_static_pickups << item[:id]
        end
      end

      #Some items are required in amounts greater than 1 to complete all quests. When it's placed as a static pickup, it's quite possible completing the quest will be impossible.
      items_required_in_multiple = ["Sage", "Iron Ore", "Silver Ore", "Gold Ore", "Cotton Thread", "Silk Thread", "Cashmere Thread"]
      #May add a chance of making the static pickup enough to complete the quest, but for now the randomizer ensures that the pickup will also be placed elsewhere as an enemy drop or wooden chest item.
      if items_required_in_multiple.include?(pickup_name)
        #if rng.rand <= 0.7
          #handle_static_quest_requirement(pickup_name)
        #else
          ensured_quest_items << pickup_name
        #end
      end

      on_first_item = false
      pickups_placed += 1
      yield(pickups_placed)
    end
    checker.progression_locations = locations_randomized_to_have_useful_pickups
    checker.unplaced_droppable_pickups.delete_if {|k, v| checker.current_items.include?(k) and (not ensured_quest_items.include?(k))}
    checker.used_droppable_pickups += checker.current_items.select {|item| checker.all_droppable_pickups.has_key?(item)}
    puts "Unplaced items: #{@total_pickups - checker.progression_locations.size} - #{checker.pickups_by_current_num_locations_they_access().keys}" if verbose
    spoiler_log.puts "All pickups placed successfully."
    #Currently the only locations that can be inaccessible are Training Hall if difficulty is Vanilla, and Morbus/Cubus if puzzle progression is turned off.
    #So only the glyph code should actually happen when split pools is on, but just in case we'll cover items anyway.
    inaccessible_locations = Locations.locs.reject {|loc| locations_randomized_to_have_useful_pickups.include?(loc[:id]) or loc[:type].include?("Villager")}
    inaccessible_locations.each do |loc|
      if @options[:rv_split_pools]
        if loc[:type].include?("Glyph")
          pickup_id = checker.get_unplaced_non_progression_skill()
        else
          pickup_id = checker.get_unplaced_non_progression_item()
        end
      else
        if loc[:type].include?("Event")
          pickup_id = checker.get_unplaced_non_progression_skill()
        else
          pickup_id = checker.get_unplaced_non_progression_pickup()
        end
      end
      change_entity_location_to_pickup_id(loc, pickup_id)
    end
  end

  def handle_static_quest_requirement(pickup)
    requirement_to_quest = {
      "Sage" => [0x3,0x4],
      "Iron Ore" => [0x9],
      "Silver Ore" => [0xa],
      "Gold Ore" => [0xb],
      "Cotton Thread" => [0x1b],
      "Silk Thread" => [0x1c],
      "Cashmere Thread" => [0x1d]
    }
    quest_ids = requirement_to_quest[pickup]
    quest_ids.each do |id|
      game.quests[id].handle_static_quest_requirement()
    end
    checker.upgraded_static_pickups << OoEItems.items[pickup][:id]
  end

  def place_progression_pickups(checker, &block)
    previous_accessible_locations = []
    locations_randomized_to_have_useful_pickups = []
    rooms_that_already_have_an_event = []
    progression_pickups_placed = 0
    total_progression_pickups = checker.all_progression_pickups.length
    on_leftovers = false
    @rooms_by_progression_order_accessed = []

    game.rooms do |room|
      room.entities.each do |entity|
        if entity.is_special_object? && (0x5f..0x88).include?(entity.subtype)
          room_str = "%02X-%02X-%02X" % [room.area_index, room.sector_index, room.room_index]
          rooms_that_already_have_an_event << room_str
          break
        end
      end
    end

    verbose = true

    @spoiler_log.puts "Placing main route progression pickups:"
    on_first_item = true
    retries = 0

    while true
      possible_locations = checker.get_accessible_locations()
      possible_locations = possible_locations.reject {|loc| locations_randomized_to_have_useful_pickups.include?(loc[:id])}
      puts "Total possible locations: #{possible_locations.size}" if verbose

      pickups_by_locations = checker.progression_pickups_by_current_num_locations_they_access()
      pickups_by_usefulness = pickups_by_locations.select{|pickup, num_locations| num_locations > 0}
      currently_useless_pickups = pickups_by_locations.select{|pickup, num_locations| num_locations == 0}
      puts "Num useless pickups: #{currently_useless_pickups.size}" if verbose
      placing_temporarily_useless_pickup = false

      if pickups_by_usefulness.any?
        max_usefulness = pickups_by_usefulness.values.max

        weights = pickups_by_usefulness.map do |pickup, usefulness|
          # Weight less useful pickups as more likely to be chosen.
          weight = max_usefulness - usefulness + 1
          weight = Math.sqrt(weight)
          if checker.preferences.has_key?(pickup)
            weight *= checker.preferences[pickup]
          end
          weight
        end
        ps = weights.map{|w| w.to_f / weights.reduce(:+)}
        useful_pickups = pickups_by_usefulness.keys
        weighted_useful_pickups = useful_pickups.zip(ps).to_h
        pickup_name = weighted_useful_pickups.max_by{|_, weight| rng.rand ** (1.0 / weight)}.first
      elsif pickups_by_locations.any? && checker.game_beatable?
        #The player can access all locations.
        #So we just randomly place one progression pickup.

        if !on_leftovers
          @spoiler_log.puts "Placing leftover progression pickups."
          on_leftovers = true
        end

        pickup_name = pickups_by_locations.keys.sample(random: rng)
      elsif pickups_by_locations.any?
        # No locations can access new areas, but the game isn't beatable yet.
        # This means any new areas will need at least two new items to access.
        # So just place a random pickup for now.

        valid_pickups = pickups_by_locations.keys

        pickup_name = valid_pickups.sample(random: rng)

        placing_temporarily_useless_pickup = true
      else
        #All progression pickups placed
        break
      end

      puts "Trying to place #{pickup_name}" if verbose

      new_possible_locations = possible_locations - previous_accessible_locations.flatten

      filtered_new_possible_locations = filter_locations_valid_for_pickup(checker, new_possible_locations, pickup_name)
      puts "Filtered new possible locations: #{filtered_new_possible_locations.size}" if verbose
      #puts "  " + filtered_new_possible_locations.join(", ") if verbose

      valid_previous_accessible_regions = previous_accessible_locations.map do |previous_accessible_region|
        possible_locations = previous_accessible_region.dup
        old_possible_locations = possible_locations
        possible_locations = possible_locations.reject {|loc| locations_randomized_to_have_useful_pickups.include?(loc[:id])}

        possible_locations = filter_locations_valid_for_pickup(checker, possible_locations, pickup_name)

        possible_locations = nil if possible_locations.empty?

        possible_locations
      end.compact

      possible_locations_to_choose_from = filtered_new_possible_locations.dup

      if placing_temporarily_useless_pickup
        # Place items that don't immediately open up new areas anywhere in the game, with no weighting towards later areas.

        valid_accessible_locations = previous_accessible_locations.map do |previous_accessible_region|
          possible_locations = previous_accessible_region.dup
          possible_locations = possible_locations.reject {|loc| locations_randomized_to_have_useful_pickups.include?(loc[:id])}

          possible_locations = filter_locations_valid_for_pickup(checker, possible_locations, pickup_name)

          possible_locations = nil if possible_locations.empty?

          possible_locations
        end.compact.flatten

        valid_accessible_locations += filtered_new_possible_locations

        possible_locations_to_choose_from = valid_accessible_locations

      elsif filtered_new_possible_locations.empty? && valid_previous_accessible_regions.any?
        # No new locations, so select an old location.
        if on_leftovers
          # Placing a leftover progression pickup.
          # Weighted to be more likely to select locations you got access to later rather than earlier.

          i = 1
          weights = valid_previous_accessible_regions.map do |region|
            # Weight later accessible regions as more likely than earlier accessible regions (exponential)
            # More heavily weighted as such for main route progression pickups.
            weight = i**2
            i += 1
            weight
          end
          ps = weights.map{|w| w.to_f / weights.reduce(:+)}
          weighted_accessible_regions = valid_previous_accessible_regions.zip(ps).to_h
          previous_accessible_region = weighted_accessible_regions.max_by{|_, weight| rng.rand ** (1.0 / weight)}.first

          possible_locations_to_choose_from = previous_accessible_region
        else
          # Placing a main route progression pickup, just not one that immediately opens up new areas.
          # Always place in the most recent accessible region.
          possible_locations_to_choose_from = valid_previous_accessible_regions.last
          puts "No new locations, using previous accessible location, total available: #{valid_previous_accessible_regions.last.size}" if verbose
        end
      elsif filtered_new_possible_locations.empty? && valid_previous_accessible_regions.empty?
        # No new locations, but there's no old locations either.
        possible_locations_to_choose_from = []
      #Todo: clean up this next block
      elsif filtered_new_possible_locations.size <= 5 && !valid_previous_accessible_regions.empty? && valid_previous_accessible_regions.last.size >= 15
        # There aren't many new locations unlocked by the last item we placed.
        # But there are a lot of other locations unlocked by the one we placed before that.
        # So we give it a chance to put it in one of those last spots, instead of the new spots.
        # The chance is proportional to how few new locations there are. 1 = 70%, 2 = 60%, 3 = 50%, 4 = 40%, 5 = 30%.
        chance = 0.30 + (5-filtered_new_possible_locations.size)*10
        if rng.rand() <= chance
          possible_locations_to_choose_from = valid_previous_accessible_regions.last
          puts "Not many new locations, using previous accessible location, total available: #{valid_previous_accessible_regions.last.size}" if verbose
        end
      end

      previous_accessible_locations << new_possible_locations

      if possible_locations_to_choose_from.empty?
        if retries > 10
          #raise "Bug: Failed to find any spots to place pickup.\nSeed: #{@seed}\n\nItems:\n#{checker.current_items.join(", ")}"
          raise "Failed to find any spots to place pickup.\nTrying to place #{pickup_name}. Possible locations:\n#{possible_locations}"
        else
          retries += 1
          next
        end
      end
      retries = 0

      location = possible_locations_to_choose_from.sample(random: rng)
      locations_randomized_to_have_useful_pickups << location[:id]

      item = OoEItems.items[pickup_name]
      if item[:type].include?("Villager")
        # Villager
        pickup_str = "villager #{item[:name]}"
      else
        pickup_str = "pickup %04X (#{item[:name]})" % item[:id]
      end

      is_enemy_str = checker.enemy_locations.include?(location) ? " (boss)" : ""
      is_event_str = checker.event_locations.include?(location) ? " (event)" : ""
      is_hidden_str = checker.hidden_locations.include?(location) ? " (hidden)" : ""
      spoiler_str = "  Placing #{pickup_str} at #{location[:name]}#{is_enemy_str}#{is_event_str}#{is_hidden_str} - #{location[:room]}"
      @spoiler_log.puts spoiler_str
      puts spoiler_str if verbose

      change_entity_location_to_pickup_id(location, item[:id], pickup_name) #pickup name is only needed to disambiguate money items since they all have the same ID

      checker.add_item(pickup_name)

      on_first_item = false
      progression_pickups_placed += 1
      yield(progression_pickups_placed)
    end
    checker.progression_locations = locations_randomized_to_have_useful_pickups
    spoiler_log.puts "All progression pickups placed successfully."
  end

  def filter_locations_valid_for_pickup(checker, locations, pickup_name)
    old_locs = locations
    locations = locations.dup

    locations.delete_if {|loc| loc[:type].include?("Villager")}

    if OoEItems.glyphs.include?(pickup_name)
      # Don't put progression glyphs in certain locations where the player could easily get them early.
      locations.delete_if {|loc| loc[:type].include?("No Glyphs")}
      if @options[:rv_split_pools]
        locations.delete_if {|loc| loc[:type].include?("Item")}
      end
    else
      # If the pickup is an item instead of a skill, don't put it at Wallman or an event location that must be a glyph.
      locations.delete_if {|loc| loc[:container] == "Spell"}
      locations.delete_if {|loc| loc[:type].include?("Event")}
      if @options[:rv_split_pools]
        locations.delete_if {|loc| loc[:type].include?("Glyph")}
      end
      if /\$/.match(pickup_name) # Money can't go in the Strength Ring chest.
        locations.delete_if {|loc| loc[:name] == "Strength Ring"}
      end
    end

    # Don't let progression items be in certain problematic locations.
    if checker.all_progression_pickups.include?(pickup_name)
      locations.delete_if {|loc| loc[:type].include?("No Progression")}
    end

    if @options[:rv_difficulty] == "Vanilla"
      locations.delete_if {|loc| loc[:zone] == "Training Hall"}
    end
    if not @options[:rv_puzzle_progression]
      locations.delete_if {|loc| ["Morbus","Cubus"].include?(loc[:name])}
    end

    locations
  end

  def get_entity_by_location_str(location)
    return game.get_entity_by_id(location)
  end

  def change_entity_location_to_pickup_id(location, pickup_id, pickup_name = nil)
    if @options[:rv_arthrovertas_revenge]
      if location[:id][0..7] == game.arthroverta.boss_room_id
        if location[:id][9..10] == "00"
          location[:id] = game.arthroverta.boss_room_id + "_" + game.arthroverta.boss_loc
        elsif location[:id][9..10] == "01"
          location[:id] = game.arthroverta.boss_room_id + "_" + game.arthroverta.magnes_loc
        elsif location[:id][9..10] == "02"
          if game.arthroverta.skip_hider
            #Do nothing
          elsif game.arthroverta.skip_door
            location[:id] = game.arthroverta.boss_room_id + "_" + game.arthroverta.hider_loc
          else
            location[:id] = game.arthroverta.boss_room_id + "_" + game.arthroverta.door_loc
          end
        elsif location[:id][9..10] == "03"
          if not game.arthroverta.skip_door
            location[:id] = game.arthroverta.boss_room_id + "_" + game.arthroverta.hider_loc
          end
        end
      end
    end

    entity = game.get_entity_by_id(location[:id])
    if location[:type].include?("Event")
      #Event with a hardcoded item/glyph.
      change_hardcoded_event_pickup(entity, pickup_id)
      return
    end

    if location[:id] == "08-02-06_01" # Strength Ring blue chest spawned by the searchlights after you kill the Tin Man
      if entity.var_a != 2
        raise "Searchlights are not of type 2 (Tin Man spawn)"
      end

      #Strength ring chest does not require particularly special handling in dominus version
      change_hardcoded_event_pickup(entity, pickup_id)

    elsif entity.type == 1
      # Wallman
      game.tweaks.modify_wallman_glyph(pickup_id + 1)

    else
      pickup_flag = get_unused_pickup_flag_for_entity(entity)

      if entity.is_glyph? && !entity.is_hidden_pickup?
        entity.y_pos += 0x20
      end

      if pickup_id == :money
        if entity.is_hidden_pickup?
          entity.type = 7
        else
          entity.type = 4
        end
        entity.subtype = 1
        entity.var_a = pickup_flag
        use_pickup_flag(pickup_flag)
        if pickup_name.include?("$500")
          entity.var_b = 4
        elsif pickup_name.include?("$1000")
          entity.var_b = 5
        else #$2000
          entity.var_b = 6
        end
        return
      end

      if (0x6F..0x74).include?(pickup_id) and not entity.is_hidden_pickup?
        # Relic. With edited code relics can be placed free and still auto-equip, but let's place them in gold chests anyway when they're not in walls.
        entity.type = 2
        entity.subtype = 0x16
        entity.var_a = pickup_id + 1
        entity.var_b = pickup_flag
        use_pickup_flag(pickup_flag)
        return
      end

      if pickup_id >= 0x6F
        # Item
        if entity.is_hidden_pickup?
          entity.type = 7
          entity.subtype = 0xFF
          entity.var_a = pickup_flag
          use_pickup_flag(pickup_flag)
          entity.var_b = pickup_id + 1
        else
          case rng.rand
          when 0.00..0.70
            # 70% chance for a red chest
            entity.type = 2
            entity.subtype = 0x16
            entity.var_a = pickup_id + 1
            entity.var_b = pickup_flag
            use_pickup_flag(pickup_flag)
          when 0.70..0.95
            # 15% chance for an item on the ground
            entity.type = 4
            entity.subtype = 0xFF
            entity.var_a = pickup_flag
            use_pickup_flag(pickup_flag)
            entity.var_b = pickup_id + 1
          else
            # 5% chance for a hidden blue chest
            entity.type = 2
            entity.subtype = 0x17
            entity.var_a = pickup_id + 1
            entity.var_b = pickup_flag
            use_pickup_flag(pickup_flag)
          end
        end
      else
        # Glyph

        if entity.is_hidden_pickup?
          entity.type = 7
          entity.subtype = 2
          entity.var_a = pickup_flag
          use_pickup_flag(pickup_flag)
          entity.var_b = pickup_id + 1
        else
          puzzle_glyph_ids = [0x1D, 0x1F, 0x20, 0x22, 0x24, 0x26, 0x27, 0x2A, 0x2B, 0x2F, 0x30, 0x31, 0x32, 0x46, 0x4E]
          #if puzzle_glyph_ids.include?(pickup_id)
          if rng.rand < 0.30
            # Free glyph
            entity.type = 4
            entity.subtype = 2
            entity.var_a = pickup_flag
            use_pickup_flag(pickup_flag)
            entity.var_b = pickup_id + 1
          else
            # Glyph statue
            entity.type = 2
            entity.subtype = 2
            entity.var_a = 0
            entity.var_b = pickup_id + 1

            # We didn't use the pickup flag, so put it back
            @unused_pickup_flags << pickup_flag
          end
        end
      end

      if entity.is_glyph? && !entity.is_hidden_pickup?
        entity.y_pos -= 0x20
      end
    end
  end

  def change_hardcoded_event_pickup(entity, pickup_id)
    if entity.subtype == 0x8A #Magnes
      # Get rid of the event, turn it into a normal free glyph
      # We can't keep the event because it automatically equips Magnes even if the glyph it gives is not Magnes.
      # Changing what it equips would just make the event not work right, so we may as well remove it.
      pickup_flag = get_unused_pickup_flag()
      entity.type = 4
      entity.subtype = 2
      entity.var_a = pickup_flag
      use_pickup_flag(pickup_flag)
      entity.var_b = pickup_id + 1
      entity.x_pos = 0x80
      entity.y_pos = 0x2b0
    elsif entity.subtype == 0x81 #Cerberus
      # Get rid of the event, turn it into a normal free glyph
      # We can't keep the event because it has special programming to always spawn them in order even if you get to the locations out of order.
      pickup_flag = get_unused_pickup_flag()
      entity.type = 4
      entity.subtype = 2
      entity.var_a = pickup_flag
      use_pickup_flag(pickup_flag)
      entity.var_b = pickup_id + 1
      entity.x_pos = 0x80
      entity.y_pos = 0x60

      #Removing the other cerberus-related events in the room
      r = entity.room
      r.entities.each do |ent|
        if ent.type == 0x2 and [0x82,0x83].include?(ent.subtype)
          ent.type = 0
        end
      end
    elsif [0x2f,0x3b,0x3e,0x40,0x44,0x47,0x4c,0x52,0x53,0x54,0x63,0x69,0x6f,0x76].include?(entity.subtype) #Locations that require editing game functions in dra03.dll in order to randomize the glyph
      game.tweaks.modify_hardcoded_glyph_event(entity.subtype, pickup_id + 1)
    end
    if entity.subtype != 0x3e #Strength Ring
      checker.glyphs_placed_as_event_glyphs += [pickup_id]
    end
  end

  def get_unused_pickup_flag_for_entity(entity)
    if entity.is_item_chest?
      pickup_flag = entity.var_b
    elsif entity.is_pickup?
      pickup_flag = entity.var_a
    end

    if (0..0x51).include?(pickup_flag)
      # In OoE, these pickup flags are used by glyph statues automatically and we can't control those.
      # Therefore we need to reassign pickups that were free glyphs in the original game a new pickup flag, so it doesn't conflict with where those glyphs (Rapidus Fio and Volaticus) got moved to when randomized.
      pickup_flag = nil
    end

    if pickup_flag.nil? || @used_pickup_flags.include?(pickup_flag)
      pickup_flag = @unused_pickup_flags.pop()

      if pickup_flag.nil?
        raise "No pickup flag for this item, this error shouldn't happen"
      end
    end

    return pickup_flag
  end

  def pre_rando_tweaks()
    # Since the glyph sleeve location will be randomized, here we'll unlock the one that appears for free in hard mode in Ecclesia.
    # In normal mode this is hidden by an entity hider object, so we'll nullify it.
    entity_hider = game.get_entity_by_id("02-00-04-06")
    entity_hider.type = 0
    # But we also need to give the chest a unique flag, because it shares the flag with the one from Minera in normal mode.
    sleeve_chest = game.get_entity_by_id("02-00-04-07")
    pickup_flag = get_unused_pickup_flag()
    sleeve_chest.var_b = pickup_flag
    use_pickup_flag(pickup_flag)
    # We also make sure the chest in Minera appears even on hard mode.
    entity_hider = game.get_entity_by_id("08-02-07-01")
    entity_hider.type = 0

    # Room in the Final Approach that has two overlapping chests both containing diamonds.
    # We don't want these to overlap as the player could easily think it's just one item and not see the one beneath it.
    # Move one a bit to the left and the other a bit to the right. Also give one a different pickup flag.
    chest_a = game.get_entity_by_id("00-0A-0B-01")
    chest_b = game.get_entity_by_id("00-0A-0B-02")
    chest_a.x_pos = 0xe0
    chest_b.x_pos = 0x130
    pickup_flag = get_unused_pickup_flag()
    chest_b.var_b = pickup_flag
    use_pickup_flag(pickup_flag)
  end

  def get_unused_pickup_flag()
    pickup_flag = @unused_pickup_flags.pop()

    if pickup_flag.nil?
      raise "No pickup flag for this item, this error shouldn't happen"
    end

    return pickup_flag
  end

  def use_pickup_flag(pickup_flag)
    @used_pickup_flags << pickup_flag
    @unused_pickup_flags -= @used_pickup_flags
  end

  def get_pickup_location_by_id(id)
    rooms = {
        "00-00-01" => 0x21a218a0,
        "00-00-03" => 0x21a21950,
        "00-00-04" => 0x21a219c0,
        "00-00-09" => 0x21a21ba0,
        "00-01-05" => 0x21a21d70,
        "00-02-02" => 0x21a220a0,
        "00-02-06" => 0x21a22280,
        "00-02-08" => 0x21a22340,
        "00-02-11" => 0x21a22600,
        "00-02-14" => 0x21a22730,
        "00-02-17" => 0x21a22900,
        "00-02-18" => 0x21a22950,
        "00-02-19" => 0x21a22980,
        "00-02-1B" => 0x21a22a90,
        "00-03-02" => 0x21a22be0,
        "00-03-07" => 0x21a22cf0,
        "00-03-09" => 0x21a22db0,
        "00-04-02" => 0x21a23110,
        "00-04-07" => 0x21a23270,
        "00-04-08" => 0x21a232b0,
        "00-05-00" => 0x21a23320,
        "00-05-04" => 0x21a23440,
        "00-05-07" => 0x21a23500,
        "00-05-08" => 0x21a23550,
        "00-05-09" => 0x21a235b0,
        "00-05-0A" => 0x21a23640,
        "00-05-0C" => 0x21a236f0,
        "00-05-0D" => 0x21a23720,
        "00-05-0E" => 0x21a23750,
        "00-05-0F" => 0x21a23780,
        "00-06-09" => 0x21a23cc0,
        "00-06-0E" => 0x21a23fa0,
        "00-06-15" => 0x21a24240,
        "00-06-1B" => 0x21a24460,
        "00-06-1C" => 0x21a24490,
        "00-07-02" => 0x21a24550,
        "00-08-00" => 0x21a24f50,
        "00-08-05" => 0x21a25070,
        "00-08-07" => 0x21a25120,
        "00-08-08" => 0x21a25190,
        "00-08-0C" => 0x21a252b0,
        "00-08-0F" => 0x21a25380,
        "00-09-01" => 0x21a253f0,
        "00-0A-02" => 0x21a24740,
        "00-0A-03" => 0x21a247d0,
        "00-0A-08" => 0x21a24930,
        "00-0A-0B" => 0x21a249a0,
        "00-0A-0C" => 0x21a24a20,
        "00-0B-02" => 0x21a24ed0,
        "02-00-00" => 0x21a1b520,
        "02-00-04" => 0x21a1b5f0,
        "03-00-01" => 0x21a1b750,
        "04-00-01" => 0x21a1be60,
        "06-00-01" => 0x21a1c4e0,
        "06-00-02" => 0x21a1c5a0,
        "06-00-04" => 0x21a1c810,
        "06-00-07" => 0x21a1c8a0,
        "06-00-09" => 0x21a1ca60,
        "06-00-0D" => 0x21a1cba0,
        "06-00-10" => 0x21a1cd00,
        "06-00-15" => 0x21a1cea0,
        "06-00-17" => 0x21a1cf30,
        "06-00-18" => 0x21a1cf90,
        "06-00-1A" => 0x21a1d040,
        "06-01-01" => 0x21a1d150,
        "06-01-04" => 0x21a1d230,
        "06-01-05" => 0x21a1d350,
        "06-01-07" => 0x21a1d3a0,
        "07-00-04" => 0x21a1d6e0,
        "07-00-06" => 0x21a1d790,
        "07-00-07" => 0x21a1d7c0,
        "07-00-09" => 0x21a1d870,
        "07-00-0A" => 0x21a1d8f0,
        "07-00-0D" => 0x21a1da10,
        "07-00-12" => 0x21a1db50,
        "07-00-14" => 0x21a1dc00,
        "08-00-05" => 0x21a1df00,
        "08-00-07" => 0x21a1dff0,
        "08-00-09" => 0x21a1e0d0,
        "08-01-01" => 0x21a1e180,
        "08-01-02" => 0x21a1e1b0,
        "08-01-05" => 0x21a1e240,
        "08-01-07" => 0x21a1e350,
        "08-01-08" => 0x21a1e380,
        "08-01-09" => 0x21a1e3f0,
        "08-02-00" => 0x21a1e500,
        "08-02-03" => 0x21a1e660,
        "08-02-05" => 0x21a1e6a0,
        "08-02-06" => 0x21a1e6e0,
        "08-02-07" => 0x21a1e720,
        "09-00-03" => 0x21a1e800,
        "09-00-06" => 0x21a1e8b0,
        "09-00-07" => 0x21a1e8d0,
        "0A-00-00" => 0x21a1e900,
        "0A-00-05" => 0x21a1ea20,
        "0A-00-09" => 0x21a1eb70,
        "0A-00-0C" => 0x21a1ed30,
        "0A-00-10" => 0x21a1ef40,
        "0A-00-11" => 0x21a1efc0,
        "0A-00-13" => 0x21a1f0e0,
        "0A-01-01" => 0x21a1f250,
        "0A-01-03" => 0x21a1f360,
        "0A-01-08" => 0x21a1f500,
        "0A-01-09" => 0x21a1f570,
        "0B-00-0D" => 0x21a1f970,
        "0B-00-0F" => 0x21a1fae0,
        "0B-01-01" => 0x21a1fc60,
        "0B-01-02" => 0x21a1fc90,
        "0B-01-03" => 0x21a1fd00,
        "0B-01-05" => 0x21a1fde0,
        "0B-01-07" => 0x21a1fe60,
        "0D-00-03" => 0x21a203f0,
        "0D-00-04" => 0x21a20430,
        "0D-00-05" => 0x21a204b0,
        "0D-00-06" => 0x21a204d0,
        "0D-00-08" => 0x21a20530,
        "0D-00-0C" => 0x21a20610,
        "0E-00-00" => 0x21a20880,
        "0E-00-02" => 0x21a209e0,
        "0E-00-07" => 0x21a20bb0,
        "0E-00-08" => 0x21a20bf0,
        "0E-00-09" => 0x21a20c40,
        "0F-00-02" => 0x21a20e10,
        "0F-00-04" => 0x21a20e90,
        "0F-00-05" => 0x21a20f20,
        "10-00-00" => 0x21a21080,
        "10-01-01" => 0x21a21140,
        "10-01-03" => 0x21a21200,
        "11-00-03" => 0x21a21470,
        "11-00-05" => 0x21a21510,
        "11-00-08" => 0x21a21630,
        "11-00-09" => 0x21a21680,
        "12-00-03" => 0x21a257b0,
        "12-00-05" => 0x21a25890,
        "12-00-07" => 0x21a25910,
        "12-00-08" => 0x21a25980,
        "12-00-09" => 0x21a259b0,
        "12-00-0A" => 0x21a25a30,
        "12-00-0B" => 0x21a25ac0,
        "12-00-0D" => 0x21a25b80,
        "12-00-10" => 0x21a25d70
    }
    return rooms[id]
  end
end
