class OoEChecker
require_relative 'ooe_items'
require_relative 'ooe_locations'
require_relative 'ooe_logic'
require 'set'

  attr_reader :current_items,
              :all_pickups,
              :all_progression_pickups,
              :no_progression_locations,
              :event_locations,
              :enemy_locations,
              :easter_egg_locations,
              :no_glyph_locations,
              :hidden_locations,
              :villager_locations,
              :preferences,
              :game_beatable,
              :logic,
              :progression_locations,
              :gear_level,
              :tentative_gear_level,
              :all_droppable_pickups,
              :rng

  attr_writer :progression_locations

  attr_accessor :glyphs_placed_as_event_glyphs,
                :unplaced_droppable_pickups,
                :used_droppable_pickups,
                :upgraded_static_pickups

  def initialize(options, rng)
    @options = options
    @rng = rng
    @logic = OoELogic.new(self, options)
    Locations.set_logic(@logic)
    Locations.set_locs()
    OoEItems.set_items()
    @all_spacer_glyphs = {}
    @current_items = [].to_set
    @gear_level = 0
    @best_gear = {head: 0,
                  body: 0,
                  boots: 0,
                  rings: [0, 0]
                 }
    @upgraded_static_pickups = []
    @quest_item_status = {
      "Sage" => 3,
      "Iron Ore" => 3,
      "Silver Ore" => 3,
      "Gold Ore" => 3,
      "Cotton Thread" => 5,
      "Silk Thread" => 5,
      "Cashmere Thread" => 5
    }
    @latest_accessible_locations = []
    @progression_locations = []
    add_extra_item("HP Max Up", "Max Up", 0x7f, 13)
    add_extra_item("MP Max Up", "Max Up", 0x80, 15)
    add_extra_item("HEART Max Up", "Max Up", 0x81, 14)
    add_extra_item("$500", "Money", :money, 3)
    add_extra_item("$1000", "Money", :money, 3)
    add_extra_item("$2000", "Money", :money, 6)
    @all_pickups = OoEItems.items
    @all_pickups.delete("Cat Tackle")
    @all_progression_pickups = @all_pickups.select {|key, item| item[:progression]}
    #if !options[:rv_puzzle_progression]
      @all_progression_pickups.delete("Fulgur")
      @all_progression_pickups.delete("Vol Fulgur")
      @all_progression_pickups.delete("Ignis")
      @all_progression_pickups.delete("Vol Ignis")
      @all_progression_pickups.delete("Nitesco")
    #end
    if options[:rv_unlock_cerberus]
      @all_progression_pickups.delete("Sinestro Custos")
      @all_progression_pickups.delete("Dextro Custos")
      @all_progression_pickups.delete("Arma Custos")
    end
    #if options[:rv_difficulty] == "Do Your Worst"
      @all_progression_pickups.delete("Arma Machina")
    #end
    @no_progression_locations = Locations.locs.select {|loc| loc[:type].include?("No Progression")}
    @all_droppable_pickups = @all_pickups.select {|key, item| (not item[:progression]) and (not OoEItems.undroppables.has_key?(key))}
    @unplaced_droppable_pickups = @all_droppable_pickups.dup
    @used_droppable_pickups = []
    @glyphs_placed_as_event_glyphs = []
    @enemy_locations = Locations.locs.select {|loc| loc[:container] == "Spell"}
    @event_locations = Locations.locs.select {|loc| loc[:type].include?("Event")}
    @easter_egg_locations = []
    @no_glyph_locations = Locations.locs.select {|loc| loc[:type].include?("No Glyphs")}
    @hidden_locations = Locations.locs.select {|loc| loc[:container] == "Wall"}
    @villager_locations = Locations.locs.select {|loc| loc[:type].include?("Villager")}
    @preferences =   {
      "Cat Tackle" => 1, #0.1,
      "Arma Felix"=> 1, #0.1,
      "Moonwalkers"=> 1, #0.1,
      "Mercury Boots"=> 1, #0.1,
      "Winged Boots"=> 1, #0.1,
      "Rapidus Fio"=> 1, #0.1
      "Dominus Hatred"=> 1,
      "Dominus Anger"=> 1,
      "Dominus Agony"=> 1
    }
  end

  def logic
    @logic
  end

  def add_item(item_name)
    #current_items << OoEItems.get_item(item_name)
    @current_items << item_name
    if OoEItems.relics.has_key?(item_name) or OoEItems.glyphs.has_key?(item_name) or OoEItems.equipment.has_key?(item_name)
      if OoEItems.equipment.has_key?(item_name)
        update_gear_level(item_name)
      end
      update_accessible_locations()
    end
  end

  def update_accessible_locations
    accessible_locations = []

    Locations.locs.each do |loc|
      if loc[:available][] and not loc[:type].include?("Villager")
        accessible_locations << loc
      end
    end

    @latest_accessible_locations = accessible_locations
  end

  def get_accessible_locations_uncached
    accessible_locations = []

    Locations.locs.each do |loc|
      if loc[:available][] and not loc[:type].include?("Villager")
        accessible_locations << loc
      end
    end

    return accessible_locations
  end

  def get_accessible_locations
    return @latest_accessible_locations
  end

  def progression_pickups_by_current_num_locations_they_access
    orig_current_items = @current_items

    possibly_useful_pickups = @all_progression_pickups.reject {|key , item| @current_items.include?(key)}

    # Subtract no_progression_locations since we don't want those messing up the numbers.
    # Also ruling out villagers because they're auto-unlocked at the moment.
    currently_accessible_locations = get_accessible_locations().reject {|loc| (loc[:type].include?("No Progression")) or (loc[:type].include?("Villager"))}

    pickups_by_locations = {}

    possibly_useful_pickups.each do |key, item|
      @current_items = orig_current_items + [key]
      new_accessible_locations = get_accessible_locations().reject {|loc| loc[:type].include?("No Progression")}
      next_accessible_pickups = new_accessible_locations.reject {|new_loc| currently_accessible_locations.any? {|cur_loc| cur_loc[:id] == new_loc[:id]} }

      pickups_by_locations[key] = next_accessible_pickups.length
    end

    return pickups_by_locations
  ensure
    @current_items = orig_current_items
  end

  def pickups_by_current_num_locations_they_access
    orig_current_items = @current_items
    orig_gear_level = @gear_level

    possibly_useful_pickups = @all_pickups.reject {|key , item| @current_items.include?(key)}

    # Subtract no_progression_locations since we don't want those messing up the numbers.
    # Also ruling out villagers because they're auto-unlocked at the moment.
    currently_accessible_locations = get_accessible_locations().reject {|loc| (loc[:type].include?("No Progression")) or (loc[:type].include?("Villager"))}

    pickups_by_locations = {}

    possibly_useful_pickups.each do |key, item|
      if OoEItems.relics.has_key?(key) or OoEItems.glyphs.has_key?(key) or OoEItems.equipment.has_key?(key)
        @current_items = orig_current_items + [key]
        if OoEItems.equipment.has_key?(key)
          @gear_level = tentative_gear_level(key).first
        end
        new_accessible_locations = get_accessible_locations_uncached().reject {|loc| loc[:type].include?("No Progression")}
      else
        new_accessible_locations = get_accessible_locations().reject {|loc| loc[:type].include?("No Progression")}
      end
      next_accessible_pickups = new_accessible_locations.reject {|new_loc| currently_accessible_locations.any? {|cur_loc| cur_loc[:id] == new_loc[:id]} }

      pickups_by_locations[key] = next_accessible_pickups.length
    end

    return pickups_by_locations
  ensure
    @current_items = orig_current_items
    @gear_level = orig_gear_level
  end

  def game_beatable?
    @logic.beatDracula()
  end

  def add_extra_item(name, type, id, n)
    j = 1
    while j <= n
      v = {
        name: name,
        type: type,
        progression: false,
        id: id
      }
      OoEItems.extra_item(name + " " + j.to_s, v)
      j += 1
    end
  end

  def tentative_gear_level(item_name)
    item = OoEItems.items[item_name]
    tentative_best_gear = {}
    case item[:type]
    when "Head"
      tentative_best_gear = {
        head: [@best_gear[:head], item[:tier]].max,
        body: @best_gear[:body],
        boots: @best_gear[:boots],
        rings: @best_gear[:rings]
      }
    when "Body"
      tentative_best_gear = {
        head: @best_gear[:head],
        body: [@best_gear[:body], item[:tier]].max,
        boots: @best_gear[:boots],
        rings: @best_gear[:rings]
      }
    when "Boots"
      tentative_best_gear = {
        head: @best_gear[:head],
        body: @best_gear[:body],
        boots: [@best_gear[:boots], item[:tier]].max,
        rings: @best_gear[:rings]
      }
    when "Ring"
      tentative_best_gear = {
        head: @best_gear[:head],
        body: @best_gear[:body],
        boots: @best_gear[:boots],
        rings: (@best_gear[:rings] + [item[:tier]]).max(2)
      }
    end
    return [tentative_best_gear[:head] + tentative_best_gear[:body] + tentative_best_gear[:boots] + tentative_best_gear[:rings].sum, tentative_best_gear]
  end

  def update_gear_level(item_name)
    @gear_level, @best_gear = tentative_gear_level(item_name)
  end

  # If we don't put the glyphs in the progression set, the pickup randomizer can leave tasks that require an undetermined item (like any light glyph) for too long if we don't tell it what it needs.
  def unfinished_glyph_task_count()
    n = 0
    n += 1 if not logic.beatDeath #Light. The only one that's actually needed as it's a requirement for Dracula in most difficulty presets. But we'll try to make everything accessible anyway.
    n += 1 if @options[:rv_puzzle_progression] and not logic.cubusPuzzle #Fire
    n += 1 if @options[:rv_puzzle_progression] and not logic.fulgurPuzzle #Lightning
    n += 1 if not logic.beatAlbus #Slash/Dark
    return n
  end

  def unfinished_gear_task_count()
    if @options[:rv_difficulty] == "Do Your Worst"
      return 0
    end
    return (20 - @gear_level)
  end
  def unfinished_gear_task_count_old()
    if @options[:rv_difficulty] == "Do Your Worst"
      return 0
    end
    n = 0
    n += 1 if not logic.gearExceeds(20)
    n += 1 if not logic.gearExceeds(16)
    n += 1 if not logic.gearExceeds(12)
    n += 1 if not logic.gearExceeds(8)
    n += 1 if not logic.gearExceeds(4)
    return n
  end

  def get_unplaced_non_progression_pickup(valid_ids: (0..0x161).to_a)
    valid_possible_items = @unplaced_droppable_pickups.select do |name, item|
      valid_ids.include?(item[:id])
    end

    pickup_name = valid_possible_items.keys.sample(random: rng)

    if pickup_name.nil?
      # Ran out of unplaced pickups, so place a duplicate instead.
      @all_droppable_pickups.each do |k, v|
        if valid_ids.include?(v[:id])
          @unplaced_droppable_pickups[k] = v
        end
      end
      @unplaced_droppable_pickups.delete_if {|name, item| @all_progression_pickups.include?(name)}

      # If a glyph has already been placed as an event glyph, do not place it again somewhere.
      # If the player gets one from a glyph statue first, then the one in the event/puzzle won't appear.
      @unplaced_droppable_pickups.delete_if {|name, item| @glyphs_placed_as_event_glyphs.include?(item[:id]) or @upgraded_static_pickups.include?(item[:id])}

      return get_unplaced_non_progression_pickup(valid_ids: valid_ids)
    end

    @unplaced_droppable_pickups.delete(pickup_name)

    return OoEItems.items[pickup_name][:id]
  end

  def get_unplaced_non_progression_item
    return get_unplaced_non_progression_pickup(valid_ids: (0x6F..0x161).to_a)
  end

  def get_unplaced_non_progression_skill
    return get_unplaced_non_progression_pickup(valid_ids: (0..0x6E).to_a)
  end

  def get_unplaced_non_progression_item_except_relics
    valid_ids = (0x6F..0x161).to_a
    valid_ids -= (0x6F..0x74).to_a
    return get_unplaced_non_progression_pickup(valid_ids: valid_ids)
  end

  def get_unplaced_non_progression_projectile_glyph
    projectile_glyph_ids = (0x16..0x18).to_a + (0x1C..0x32).to_a
    return get_unplaced_non_progression_pickup(valid_ids: projectile_glyph_ids)
  end

  def get_unplaced_non_progression_pickup_for_enemy_drop(enemy_id, valid_ids: (0..0x161).to_a)
    valid_possible_items = @unplaced_droppable_pickups.select do |name, item|
      valid_ids.include?(item[:id])
    end

    if valid_possible_items.empty?
      # Ran out of unplaced pickups, so place a duplicate instead.
      @all_droppable_pickups.each do |k, v|
        if valid_ids.include?(v[:id])
          @unplaced_droppable_pickups[k] = v
        end
      end
      @unplaced_droppable_pickups.delete_if {|name, item| @all_progression_pickups.include?(name)}

      # If a glyph has already been placed as an event glyph, do not place it again somewhere.
      # If the player gets one from a glyph statue first, then the one in the event/puzzle won't appear.
      @unplaced_droppable_pickups.delete_if {|name, item| @glyphs_placed_as_event_glyphs.include?(item[:id]) or @upgraded_static_pickups.include?(item[:id])}

      return get_unplaced_non_progression_pickup_for_enemy_drop(enemy_id, valid_ids: valid_ids)
    end

    weights = valid_possible_items.map do |key, item|
      #Weight less useful pickups as more likely to be chosen by enemies with a lower ID. Higher-ID enemies care less about tiers.
      weight = 1.0
      enemy_scale = enemy_id.to_f / 0x78.to_f
      if OoEItems.equipment.has_key?(key)
        item_tier = OoEItems.equipment[key][:tier].to_f
        item_tier = (1.0-enemy_scale)*item_tier*0.5
        weight /= item_tier+1.0
      end
      weight = Math.sqrt(weight)
      if @preferences.has_key?(key)
        weight *= @preferences[key]
      end
      weight
    end
    ps = weights.map{|w| w.to_f / weights.reduce(:+)}
    items = valid_possible_items.keys
    weighted_items = items.zip(ps).to_h
    pickup_name = weighted_items.max_by{|_, weight| rng.rand ** (1.0 / weight)}.first

    @unplaced_droppable_pickups.delete(pickup_name)

    return OoEItems.items[pickup_name][:id]
  end

  def get_unplaced_non_progression_item_for_enemy_drop(enemy_id)
    return get_unplaced_non_progression_pickup_for_enemy_drop(enemy_id, valid_ids: (0x6F..0x161).to_a)
  end

  def get_unplaced_non_progression_item_except_relics_for_enemy_drop(enemy_id)
    valid_ids = (0x6F..0x161).to_a
    valid_ids -= (0x6F..0x74).to_a
    return get_unplaced_non_progression_pickup_for_enemy_drop(enemy_id, valid_ids: valid_ids)
  end

  def get_unplaced_non_progression_pickup_for_wooden_chest(valid_ids: (0x6F..0x161).to_a) #wooden chests won't have glyphs
    valid_possible_items = @unplaced_droppable_pickups.select do |name, item|
      valid_ids.include?(item[:id])
    end

    if valid_possible_items.empty?
      # Ran out of unplaced pickups, so place a duplicate instead.
      @all_droppable_pickups.each do |k, v|
        if valid_ids.include?(v[:id])
          @unplaced_droppable_pickups[k] = v
        end
      end
      @unplaced_droppable_pickups.delete_if {|name, item| @all_progression_pickups.include?(name)}

      # If a glyph has already been placed as an event glyph, do not place it again somewhere.
      # If the player gets one from a glyph statue first, then the one in the event/puzzle won't appear.
      @unplaced_droppable_pickups.delete_if {|name, item| @glyphs_placed_as_event_glyphs.include?(item[:id]) or @upgraded_static_pickups.include?(item[:id])}

      return get_unplaced_non_progression_pickup_for_wooden_chest(pool_id, valid_ids: valid_ids)
    end

    weights = valid_possible_items.map do |key, item|
      #Weight less useful pickups as more likely to be chosen by pools with a lower ID.
      weight = 1.0
      if not OoEItems.equipment.has_key?(key)
        weight *= 10.0 #Make equipment less likely to appear in wooden chests. More weighting will happen in the wooden chest randomizer itself.
      else
        weight *= (5 - OoEItems.equipment[key][:tier])*0.25 + 1
      end
      weight = Math.sqrt(weight)
      if @preferences.has_key?(key)
        weight *= @preferences[key]
      end
      weight
    end
    ps = weights.map{|w| w.to_f / weights.reduce(:+)}
    items = valid_possible_items.keys
    weighted_items = items.zip(ps).to_h
    pickup_name = weighted_items.max_by{|_, weight| rng.rand ** (1.0 / weight)}.first

    #Give quest items which are required more than once a chance to stay in the contention to be in multiple chest pools
    if @quest_item_status.has_key?(pickup_name) and @quest_item_status[pickup_name] > 0
      threshold = (@quest_item_status[pickup_name] - 1).to_f / @quest_item_status[pickup_name].to_f
      if rng.rand > threshold #Threshold is the chance for the item to stay in the pool
        @unplaced_droppable_pickups.delete(pickup_name)
      end
      @quest_item_status[pickup_name] -= 1
    else
      @unplaced_droppable_pickups.delete(pickup_name)
    end

    return [pickup_name, OoEItems.items[pickup_name]]
  end

  def get_unplaced_non_progression_item_except_relics_for_wooden_chest()
    valid_ids = (0x6F..0x161).to_a
    valid_ids -= (0x6F..0x74).to_a
    return get_unplaced_non_progression_pickup_for_wooden_chest(valid_ids: valid_ids)
  end
end
