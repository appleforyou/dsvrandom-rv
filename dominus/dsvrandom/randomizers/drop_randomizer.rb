class DropRandomizer
  attr_reader :rng,
              :game,
              :checker,
              :spoiler_log,
              :non_spoiler_log

  def initialize(rng, game, logs, &block)
    @rng = rng
    @game = game
    @checker = game.checker
    @options = game.options
    @all_rooms = []
    @spoiler_log, @non_spoiler_log = logs
    randomize_enemy_drops() do |placed_drops|
      yield placed_drops.to_f / [*0x00..0x66, *0x68..0x6A].size.to_f
    end
  end

  def randomize_enemy_drops
    #Bosses that cast glyphs. Wallman's glyph is not handled here, as that can be a progression glyph.
    progress_skills = OoEItems.glyphs.select {|key, item| checker.all_progression_pickups.has_key?(key) and not checker.glyphs_placed_as_event_glyphs.include?(item[:id])}
    progress_damage_skills = OoEItems.glyphs.select {|key, item| checker.all_progression_pickups.has_key?(key) and (item[:type] == "Damaging") and (not checker.glyphs_placed_as_event_glyphs.include?(item[:id]))}
    damage_skills = OoEItems.glyphs.select {|key, item| item[:type] == "Damaging" and not checker.glyphs_placed_as_event_glyphs.include?(item[:id])}
    #It's possible that all progress skills could be placed on events, leaving us with nothing to place.
    if progress_skills.empty?
      progress_skills = damage_skills
    end
    if progress_damage_skills.empty?
      progress_damage_skills = damage_skills
    end
    [0x67, 0x72, 0x73].each do |enemy_id|
      pickup_name = ""
      jiangshi_pickup_name = ""

      enemy = game.enemy_dnas[enemy_id]
      if (not @options[:rv_unlock_albus]) or (enemy_id == 0x67) #Jiangshi
        pickup_name = progress_skills.keys.sample(random: rng)
        enemy.glyph = progress_skills[pickup_name][:id] + 1
        if enemy_id == 0x67
          jiangshi_pickup_name = pickup_name
        end
      elsif enemy_id == 0x72 #Albus
        pickup_name = damage_skills.keys.sample(random: rng)
        enemy.glyph = damage_skills[pickup_name][:id] + 1
      else #Barlowe
        pickup_name = progress_skills.keys.sample(random: rng)
        enemy.glyph = progress_skills[pickup_name][:id] + 1
      end
      #@spoiler_log.puts enemy.name
      @spoiler_log.puts "Placing #{pickup_name} as the cast glyph on #{enemy.name}"
    end

    placed_drops = 0

    # Regular enemies
    [*0x00..0x66, *0x68..0x6A].shuffle!(random: rng).each do |enemy_id|
      enemy = game.enemy_dnas[enemy_id]

      can_drop_items = true
      if enemy.name == "Blood Skeleton"
        # Blood Skeletons can't be killed so they can't drop items.
        can_drop_items = false
      end

      if rng.rand <= 0.5 && can_drop_items # 50% chance to have an item drop
        # Don't let enemies drop relics since they won't auto-equip.
        enemy.item_1 = checker.get_unplaced_non_progression_item_except_relics_for_enemy_drop(enemy_id) + 1

        if rng.rand <= 0.5 # Further 50% chance (25% total) to have a second item drop
          # Don't let enemies drop relics since they won't auto-equip.
          enemy.item_2 = checker.get_unplaced_non_progression_item_except_relics_for_enemy_drop(enemy_id) + 1
        else
          enemy.item_2 = 0
        end
      else
        enemy.item_1 = 0
        enemy.item_2 = 0
      end

      if enemy.glyph != 0
        # Only give glyph drops to enemies that originally had a glyph drop.
        # Other enemies cannot drop a glyph anyway.

        if /[(Fomor)(Demon)]/.match?(enemy.name)
          # Fomors and Demons can actually use the glyph you give them, but only if it's a projectile arm glyph.
          enemy.glyph = checker.get_unplaced_non_progression_projectile_glyph() + 1
        else
          enemy.glyph = checker.get_unplaced_non_progression_skill() + 1
        end
      end
      placed_drops += 1
      yield placed_drops
    end
  end
end