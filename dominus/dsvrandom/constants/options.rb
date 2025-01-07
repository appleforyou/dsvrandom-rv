module Options
attr_reader :options,
            :game_specific_options

def self.options
  options = {
  rv_open_castle: "Opens the world map, including access to Dracula's Castle without defeating Barlowe.",
  rv_unlock_albus: "If checked: All villagers will be automatically rescued, which means Albus and Barlowe can be defeated without triggering the Bad Ending.",
  #rv_non_vanilla_glyphs: "Allows custom glyphs (Albus's gun, and the individual attacks from Arma Felix and Arma Chiroptera) to appear as glyphs in the game. It's unknown if these cause crashes in the Dominus version.",
  rv_unlock_cerberus: "The Cerberus Gate in Dracula's castle will be open without requiring Custos glyphs.",
  rv_split_pools: "If checked, glyphs can only appear at vanilla glyph locations, and items can only appear at vanilla item locations.",
  rv_puzzle_progression: "If checked, progression items can be placed at locations which require certain elemental attack glyphs to solve the puzzle.",
  rv_randomize_quest_rewards: "Quests in Wygol Village which give items will change to give random rewards. Quest requirements do not change. The final quest per villager will give a random glyph, and other quests will give a random equipment or consumable item. Progression glyphs can appear, but they are not required by logic.",
  rv_arthrovertas_revenge: "Tired of not being fought in the randomizer, Arthroverta has decided to take the matter into its own claws... (Pickups will not spawn in the boss's room. Re-enter the room after it dies.)",


  randomize_pickups: "Randomizes items and glyphs you find in static locations.",
  

  randomize_enemy_drops: "Randomizes the non-required items and glyphs dropped or cast by enemies.",

  randomize_shop: "Randomizes what items are for sale in the shop as well as item prices.",
  randomize_wooden_chests: "Randomizes the pool of items for wooden chests in each area.",
  
  reveal_breakable_walls: "Breakable walls will always blink as if you have Eye for Decay on.",
  remove_area_names: "Removes the area names that appear on screen when you first enter an area.",
  
  always_dowsing: "Hidden blue chests always make a beeping sound.",
  
  randomize_bgm: "Randomizes what songs play in what areas.",
}
end

def self.game_specific_options
  game_specific_options = {
  "ooe" => [
    :randomize_wooden_chests,
    
    :always_dowsing,
  ],
}
end
end
