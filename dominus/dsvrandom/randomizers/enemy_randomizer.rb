require_relative '../rv/ooe_rooms'
require 'set'

=begin
This version of the randomizer needs more playtesting and so it is categorized as somewhat experimental for now.
Points:
- Currently Large Cavern and Training Hall are not randomized.
- Enemies summoned by searchlights and Necromancer are not randomized.
- The code handles many special cases where unrestricted randomization can produce undesirable results, but there are surely more as-yet-unencountered cases.
- There may be more preset-specific adjustments in the future. Currently only vanilla reduces the enemy pool a bit.
- Enemy pools per stage are a limited set of the larger whole, intended to keep each stage's flavor in an open-world map where that's one of the things that makes stages unique. With future options like map randomizer, it may be fine to open up the enemy pools a bit more.
=end

class EnemyRandomizer
  attr_reader :rng

  SPAWNER_ENEMY_IDS = [
    0x00, # Bat
    0x01, # Zombie
    0x03, # Ghost
    0x06, # Sea Stinger
    0x0B, # Necromancer
    0x0F, # Gelso
    0x1B, # Winged Guard
    0x2B, # Saint Elmo
    0x3E, # Altair
    0x48, # Ghoul
    0x60, # Medusa Head
    0x61, # Gorgon Head
    0x65, # Winged Skeleton
  ]
  ENEMY_IDS = (0..0x78)
  COMMON_ENEMY_IDS = [*0x00..0x66, *0x68..0x6A]
  SPECIAL_OBJECT_IDS = (0..0x8C)

  MAX_ASSETS_PER_ROOM = 16

  SECTOR_ID_TO_NAME = {
    0x0 => "Castle Entrance",
    0x1 => "Castle Entrance",
    0x2 => "Underground Labyrinth",
    0x3 => "Library",
    0x4 => "Library",
    0x5 => "Barracks",
    0x6 => "Mechanical Tower",
    0x7 => "Mechanical Tower",
    0x8 => "Arms Depot",
    0x9 => "Forsaken Cloister",
    0xa => "Final Approach",
    0xb => "Final Approach",
  }

  AREA_ID_TO_NAME = {
    0x0 => "Dracula's Castle",
    0x1 => "Wygol Village",
    0x2 => "Ecclesia",
    0x3 => "Training Hall",
    0x4 => "Ruvas Forest",
    0x5 => "Argila Swamp",
    0x6 => "Kalidus Channel",
    0x7 => "Somnus Reef",
    0x8 => "Minera Prison Island",
    0x9 => "Lighthouse",
    0xa => "Tymeo Mountains",
    0xb => "Tristis Pass",
    0xc => "Large Cavern",
    0xd => "Giant's Dwelling",
    0xe => "Mystery Manor",
    0xf => "Misty Forest Road",
    0x10 => "Oblivion Ridge",
    0x11 => "Skeleton Cave",
    0x12 => "Monastery",
    0x13 => "Epilogue"
  }

  ENEMY_ROLES = {
    "Bat" => ["Nuisance", "Persistent"],
    "Zombie" => ["Persistent", "Guard"],
    "Skeleton" => ["Range"],
    "Ghost" => ["Persistent"],
    "Banshee" => ["Seeker"],
    "Bone Scimitar" => ["Challenger"],
    "Sea Stinger" => ["Persistent"],
    "Nominon" => ["Nuisance"],
    "Axe Knight" => ["Range"],
    "Une" => ["Guard"],
    "Merman" => ["Range", "Challenger"],
    "Necromancer" => ["Nuisance"],
    "Bone Archer" => ["Range"],
    "Spear Guard" => ["Challenger", "Guard"],
    "Invisible Man" => ["Challenger"],
    "Gelso" => ["Seeker", "Persistent"],
    "Needles" => ["Guard"],
    "Demon" => ["Nuisance"],
    "Fishhead" => ["Guard", "Range"],
    "Dark Octopus" => ["Guard", "Challenger"],
    "Killer Fish" => ["Nuisance"],
    "Forneus" => ["Nuisance"],
    "The Creature" => ["Guard"],
    "Black Crow" => ["Seeker"],
    "Skull Spider" => ["Challenger"],
    "Scarecrow" => ["Nuisance"],
    "Sea Demon" => ["Nuisance"],
    "Winged Guard" => ["Persistent"],
    "Nightmare" => ["Nuisance"],
    "Rock Knight" => ["Range", "Guard"],
    "Fire Demon" => ["Nuisance"],
    "Bitterfly" => ["Seeker"],
    "Specter" => ["Nuisance"],
    "Grave Digger" => ["Challenger", "Range"],
    "Werebat" => ["Challenger", "Range"],
    "Black Fomor" => ["Nuisance"],
    "Enkidu" => ["Guard", "Range"],
    "Bone Pillar" => ["Guard", "Range"],
    "Skeleton Frisky" => ["Nuisance"],
    "Skeleton Hero" => ["Range"],
    "Dullahan" => ["Challenger"],
    "Skeleton Rex" => ["Challenger"],
    "White Dragon" => ["Guard", "Range"],
    "Saint Elmo" => ["Persistent"],
    "Lorelai" => ["Guard"],
    "Edimmu" => ["Seeker"],
    "Decarabia" => ["Guard"],
    "Ladycat" => ["Challenger"],
    "Ectoplasm" => ["Seeker", "Nuisance"],
    "Curse Diva" => ["Seeker"],
    "Miss Murder" => ["Nuisance", "Seeker"],
    "Automaton ZX26" => ["Guard"],
    "Skeleton Beast" => ["Guard"],
    "Balloon" => ["Nuisance"],
    "Arachne" => ["Guard", "Challenger", "Range"],
    "Lizardman" => ["Challenger", "Guard"],
    "Armored Beast" => ["Challenger", "Guard"],
    "Yeti" => ["Nuisance"],
    "Thunder Demon" => ["Nuisance"],
    "Owl" => ["Seeker", "Nuisance"],
    "Werewolf" => ["Challenger"],
    "Altair" => ["Persistent"],
    "Mandragora" => ["Guard"],
    "Jersey Devil" => ["Nuisance"],
    "Owl Knight" => ["Guard", "Range"],
    "Chosen Une" => ["Challenger", "Guard"],
    "Stone Rose" => ["Guard", "Range"],
    "Mad Butcher" => ["Challenger"],
    "White Fomor" => ["Nuisance"],
    "Evil Force" => ["Seeker"],
    "Flea Man" => ["Nuisance"],
    "Ghoul" => ["Persistent"],
    "Peeping Eye" => ["Seeker"],
    "Gargoyle" => ["Nuisance"],
    "Blood Skeleton" => ["Persistent"],
    "Black Panther" => ["Challenger"],
    "Mimic" => ["Challenger"],
    "Draculina" => ["Nuisance"],
    "Tin Man" => ["Challenger", "Guard"],
    "Polkir" => ["Nuisance"],
    "Nova Skeleton" => ["Range", "Guard"],
    "Gashida" => ["Challenger"],
    "Devil" => ["Range", "Guard"],
    "Gurkha Master" => ["Guard", "Challenger"],
    "Red Smasher" => ["Challenger"],
    "Cave Troll" => ["Challenger", "Guard"],
    "Blade Master" => ["Challenger", "Guard"],
    "Lilith" => ["Range"],
    "Lizardman Blade" => ["Challenger", "Guard"],
    "Hammer Shaker" => ["Guard", "Challenger"],
    "Rebuild" => ["Guard", "Challenger"],
    "Imp" => ["Nuisance"],
    "Bugbear" => ["Seeker"],
    "Spectral Sword" => ["Guard", "Seeker"],
    "Automaton ZX27" => ["Guard"],
    "Medusa Head" => ["Persistent"],
    "Gorgon Head" => ["Persistent"],
    "Mad Snatcher" => ["Challenger"],
    "Great Knight" => ["Guard"],
    "King Skeleton" => ["Guard"],
    "Winged Skeleton" => ["Persistent"],
    "Final Knight" => ["Guard"],
    "Demon Lord" => ["Nuisance"],
    "Double Hammer" => ["Challenger"],
    "Weapon Master" => ["Challenger", "Range"],
    "Giant Skeleton" => ["Guard", "Challenger"]
  }





  ENEMIES_PER_ZONE = {
    "Castle Entrance" =>        [
                                  "Peeping Eye",
                                  "Blood Skeleton",
                                  "Gargoyle",
                                  "Ghoul",
                                  "Black Panther",
                                  "Flea Man",
                                  "Mimic",
                                  "Draculina",
                                  "Mad Butcher",
                                  "White Fomor",
                                  "Black Fomor",
                                  "Polkir",
                                  "Lilith",
                                  "Imp",
                                  "Stone Rose",
                                  "Evil Force",
                                  "Chosen Une",
                                  "Owl Knight",
                                  "Jersey Devil",
                                  "Mandragora",
                                  "Altair",
                                  "Werewolf",
                                  "Owl",
                                  "Thunder Demon",
                                  "Yeti",
                                  "Armored Beast",
                                  "Lizardman",
                                  "Lizardman Blade",
                                  "Balloon",
                                  "Automaton ZX26",
                                  "Automaton ZX27",
                                  "Medusa Head",
                                  "Gorgon Head",
                                  "Winged Guard",
                                  "Ectoplasm",
                                  "Edimmu",
                                  "Arachne",
                                  "Invisible Man",
                                  "Bat"
                                ].to_set,
    "Library" =>                [
                                  "Peeping Eye",
                                  "Blood Skeleton",
                                  "Gargoyle",
                                  "Ghoul",
                                  "Black Panther",
                                  "Flea Man",
                                  "Mimic",
                                  "Draculina",
                                  "Mad Butcher",
                                  "White Fomor",
                                  "Black Fomor",
                                  "Tin Man",
                                  "Polkir",
                                  "Lilith",
                                  "Cave Troll",
                                  "Gashida",
                                  "Gurkha Master",
                                  "Red Smasher",
                                  "Imp",
                                  "Stone Rose",
                                  "Evil Force",
                                  "Chosen Une",
                                  "Owl Knight",
                                  "Mandragora",
                                  "Werewolf",
                                  "Yeti",
                                  "Armored Beast",
                                  "Lizardman",
                                  "Lizardman Blade",
                                  "Balloon",
                                  "Automaton ZX26",
                                  "Automaton ZX27",
                                  "Medusa Head",
                                  "Gorgon Head",
                                  "Winged Guard",
                                  "Ectoplasm",
                                ].to_set,
    "Underground Labyrinth" =>  [
                                 "Polkir",
                                 "Nova Skeleton",
                                 "Gashida",
                                 "Gurkha Master",
                                 "Hammer Shaker",
                                 "Flea Man",
                                 "Red Smasher",
                                 "Owl Knight",
                                 "Winged Guard",
                                 "Winged Skeleton",
                                 "Automaton ZX27",
                                 "Blade Master",
                                 "Blood Skeleton",
                                 "Imp",
                                 "Spectral Sword",
                                 "King Skeleton",
                                 "Skeleton Beast",
                                 "Gargoyle",
                                 "White Fomor",
                                 "Curse Diva",
                                 "Miss Murder",
                                 "White Dragon",
                                 "Skeleton Rex",
                                 "Enkidu",
                                 "Great Knight",
                                 "Draculina",
                                 "White Fomor",
                                 "Black Fomor",
                                 "Peeping Eye",
                                 "Bugbear",
                                ].to_set,
    "Barracks" =>               [
                                 "Nova Skeleton",
                                 "Devil",
                                 "Lizardman Blade",
                                 "Imp",
                                 "Blade Master",
                                 "Gurkha Master",
                                 "Red Smasher",
                                 "Hammer Shaker",
                                 "Tin Man",
                                 "Bugbear",
                                 "Gashida",
                                 "Winged Guard",
                                 "Winged Skeleton",
                                 "Peeping Eye",
                                 "Great Knight",
                                 "King Skeleton",
                                 "Draculina",
                                 "Lilith",
                                 "Gargoyle",
                                 "Blood Skeleton",
                                 "Cave Troll",
                                 "Demon Lord",
                                 "Weapon Master",
                                 "Mad Snatcher",
                                 "Mad Butcher",
                                 "Spectral Sword",
                                 "Gargoyle",
                                 "White Fomor",
                                 "Black Fomor",
                                 "Skeleton Rex",
                                 "White Dragon",
                                ].to_set,
    "Mechanical Tower" =>       [
                                 "Bugbear",
                                 "Imp",
                                 "Lizardman Blade",
                                 "Hammer Shaker",
                                 "Automaton ZX27",
                                 "Medusa Head",
                                 "Gorgon Head",
                                 "Rebuild",
                                 "Red Smasher",
                                 "Gurkha Master",
                                 "King Skeleton",
                                 "Winged Guard",
                                 "Winged Skeleton",
                                 "Peeping Eye",
                                 "Lizardman",
                                 "Double Hammer",
                                 "The Creature",
                                 "Demon Lord",
                                 "Enkidu",
                                 "White Dragon",
                                 "Tin Man",
                                 "Polkir",
                                 "Devil",
                                 "Cave Troll",
                                 "Gashida",
                                 "Draculina",
                                 "Evil Force",
                                 "Flea Man",
                                 "Great Knight",
                                 "Final Knight"
                                ].to_set,
    "Arms Depot" =>             [
                                 "Hammer Shaker",
                                 "Gurkha Master",
                                 "Bugbear",
                                 "Mad Snatcher",
                                 "Great Knight",
                                 "King Skeleton",
                                 "Rebuild",
                                 "Red Smasher",
                                 "Spectral Sword",
                                 "Final Knight",
                                 "Double Hammer",
                                 "Peeping Eye",
                                 "Mad Butcher",
                                 "Skeleton Beast",
                                 "The Creature",
                                 "Enkidu",
                                 "White Dragon",
                                 "Giant Skeleton",
                                 "Nova Skeleton",
                                 "Medusa Head",
                                 "Gorgon Head",
                                 "Winged Guard",
                                 "Winged Skeleton",
                                 "Imp",
                                 "Gashida",
                                 "Polkir",
                                 "Tin Man",
                                 "Evil Force",
                                 "Owl Knight",
                                 "Armored Beast",
                                ].to_set,
    "Forsaken Cloister" =>      [
                                 "Cave Troll",
                                 "Nova Skeleton",
                                 "Blade Master",
                                 "Bugbear",
                                 "Medusa Head",
                                 "Gorgon Head",
                                 "Winged Guard",
                                 "Winged Skeleton",
                                 "Ghoul",
                                 "Lilith",
                                 "Gashida",
                                 "Balloon",
                                 "Arachne",
                                 "Lizardman",
                                 "Lizardman Blade",
                                 "Armored Beast",
                                 "Werewolf",
                                 "Mad Butcher",
                                 "Mad Snatcher",
                                 "Blood Skeleton",
                                 "Automaton ZX26",
                                 "Automaton ZX27",
                                 "Skeleton Hero",
                                 "Dullahan",
                                 "Grave Digger",
                                 "Invisible Man",
                                 "Black Panther",
                                 "Gargoyle",
                                 "Mimic",
                                 "Polkir",
                                 "Peeping Eye",
                                ].to_set,
    "Final Approach" =>         [
                                 "Bugbear",
                                 "Winged Skeleton",
                                 "Final Knight",
                                 "Lilith",
                                 "Cave Troll",
                                 "Devil",
                                 "Blade Master",
                                 "Lizardman Blade",
                                 "Spectral Sword",
                                 "Automaton ZX27",
                                 "Imp",
                                 "Great Knight",
                                 "Peeping Eye",
                                 "Winged Guard",
                                 "Medusa Head",
                                 "Gorgon Head",
                                 "Ghoul",
                                 "Werewolf",
                                 "Double Hammer",
                                 "Weapon Master",
                                 "Hammer Shaker",
                                 "Red Smasher",
                                 "Gurkha Master",
                                 "Demon Lord",
                                 "Stone Rose",
                                 "Owl Knight",
                                 "Tin Man",
                                 "Rebuild",
                                 "The Creature",
                                 "King Skeleton",
                                 "Skeleton Beast",
                                 "Giant Skeleton",
                                 "Evil Force",
                                 "Flea Man",
                                 "Gargoyle",
                                 "Draculina",
                                 "Nova Skeleton",
                                 "Gashida",
                                 "Mad Snatcher",
                                 "White Fomor",
                                 "Jersey Devil",
                                 "Chosen Une",
                                 "Decarabia",
                                 "Lorelai",
                                 "Edimmu",
                                 "Altair",
                                 "Yeti",
                                 "Saint Elmo",
                                 "Enkidu",
                                 "White Dragon",
                                 "Armored Beast",
                                ].to_set,
    "Training Hall" =>          [
                                 "Automaton ZX26",
                                 "Double Hammer",
                                 "Bone Pillar",
                                 "Weapon Master",
                                 "Gurkha Master",
                                 "Hammer Shaker",
                                 "Red Smasher",
                                 "Automaton ZX27",
                                 "Fishhead",
                                 "Skull Spider",
                                 "Rock Knight",
                                 "Stone Rose",
                                 "Blood Skeleton",
                                 "Tin Man",
                                 "Nova Skeleton",
                                 "Blade Master",
                                ].to_set,
    "Ruvas Forest" =>           [
                                 "Nominon",
                                 "Bone Scimitar",
                                 "Une",
                                 "Necromancer",
                                 "Axe Knight",
                                 "Zombie",
                                 "Skeleton",
                                 "Bat",
                                 "Medusa Head",
                                 "Winged Guard",
                                 "Ghost",
                                 "Banshee",
                                 "Sea Stinger",
                                 "Merman",
                                 "Bone Archer",
                                 "Gelso",
                                 "Needles",
                                 "Black Crow",
                                 "Bitterfly",
                                 "Forneus",
                                 "Skeleton Hero"
                                ].to_set,
    "Monastery" =>              [
                                 "Bat",
                                 "Zombie",
                                 "Skeleton",
                                 "Ghost",
                                 "Banshee",
                                 "Bone Scimitar",
                                 "Axe Knight",
                                 "Bone Archer",
                                 "Necromancer",
                                 "Une",
                                 "Nominon",
                                 "Winged Guard",
                                 "Sea Stinger",
                                 "Gelso",
                                 "Needles",
                                 "Black Crow",
                                 "Killer Fish",
                                 "Bitterfly",
                                 "Spear Guard",
                                 "Black Fomor",
                                 "Saint Elmo",
                                 "Werebat",
                                ].to_set,
    "Skeleton Cave" =>          [
                                 "Bone Pillar",
                                 "Skeleton Frisky",
                                 "Skeleton Hero",
                                 "Dullahan",
                                 "Skeleton Rex",
                                 "White Dragon",
                                 "Skeleton Beast",
                                 "Blade Master",
                                 "Skeleton",
                                 "Bone Scimitar",
                                 "Bone Archer",
                                 "Fishhead",
                                 "Skull Spider",
                                 "Winged Guard",
                                 "Nightmare",
                                 "Blood Skeleton",
                                 "Nova Skeleton",
                                ].to_set,
    "Misty Forest Road" =>      [
                                 "Bitterfly",
                                 "Black Fomor",
                                 "Grave Digger",
                                 "Werebat",
                                 "Specter",
                                 "Enkidu",
                                 "Lizardman Blade",
                                 "Bat",
                                 "Zombie",
                                 "Ghost",
                                 "Banshee",
                                 "Sea Stinger",
                                 "Nominon",
                                 "Merman",
                                 "Necromancer",
                                 "Polkir",
                                 "Invisible Man",
                                 "Demon",
                                 "Dark Octopus",
                                 "Forneus",
                                 "The Creature",
                                 "Black Crow",
                                 "Scarecrow",
                                 "Sea Demon",
                                 "White Fomor",
                                 "Fire Demon",
                                 "Ladycat",
                                 "Balloon",
                                 "Lizardman",
                                 "Werewolf",
                                 "Flea Man",
                                 "Black Panther",
                                 "Cave Troll",
                                 "Mad Butcher",
                                 "Ectoplasm",
                                 "Killer Fish"
                                ].to_set,
    "Minera Prison Island" =>   [
                                 "Spear Guard",
                                 "Axe Knight",
                                 "Bone Archer",
                                 "Demon",
                                 "Invisible Man",
                                 "The Creature",
                                 "Winged Guard",
                                 "Skeleton",
                                 "Bone Scimitar",
                                 "Fishhead",
                                 "Skull Spider",
                                 "Sea Demon",
                                 "Nightmare",
                                 "Rock Knight",
                                 "Fire Demon",
                                 "Grave Digger",
                                 "Skeleton Frisky",
                                 "Skeleton Hero",
                                 "Dullahan",
                                 "White Dragon",
                                 "Lorelai",
                                 "Miss Murder",
                                 "Automaton ZX26",
                                 "Owl Knight",
                                 "Blood Skeleton",
                                 "Mimic",
                                 "Une",
                                 "Forneus",
                                ].to_set,
    "Mystery Manor" =>          [
                                 "Flea Man",
                                 "White Fomor",
                                 "Evil Force",
                                 "Mad Butcher",
                                 "Mimic",
                                 "Black Fomor",
                                 "Bat",
                                 "Zombie",
                                 "Ghoul",
                                 "Gelso",
                                 "Thunder Demon",
                                 "Lorelai",
                                 "Edimmu",
                                 "Decarabia",
                                 "Ladycat",
                                 "Black Panther",
                                 "Curse Diva",
                                 "Miss Murder",
                                 "Arachne",
                                 "Lizardman",
                                 "Werewolf",
                                 "Altair",
                                 "Jersey Devil",
                                 "Chosen Une",
                                 "Stone Rose",
                                 "Mad Snatcher",
                                 "Peeping Eye",
                                 "Draculina",
                                 "Lilith",
                                 "Imp",
                                 "Medusa Head",
                                 "Gorgon Head",
                                 "Specter",
                                ].to_set,
    "Tymeo Mountains" =>        [
                                 "Black Crow",
                                 "Winged Guard",
                                 "Medusa Head",
                                 "Rock Knight",
                                 "Nightmare",
                                 "Skull Spider",
                                 "Cave Troll",
                                 "Owl",
                                 "Fire Demon",
                                 "Scarecrow",
                                 "Bat",
                                 "Bone Pillar",
                                 "Skeleton Hero",
                                 "Dullahan",
                                 "Yeti",
                                 "Zombie",
                                 "Ghost",
                                 "Bone Scimitar",
                                 "Axe Knight",
                                 "Necromancer",
                                 "Demon",
                                 "Sea Demon",
                                 "Fishhead",
                                 "Dark Octopus",
                                 "Killer Fish",
                                 "Bitterfly",
                                 "Skeleton Frisky",
                                 "Saint Elmo",
                                 "Miss Murder",
                                 "Arachne",
                                 "Balloon",
                                 "Altair",
                                 "Mandragora",
                                 "Chosen Une",
                                 "Flea Man",
                                 "Mimic",
                                 "Draculina",
                                 "Polkir",
                                 "Blade Master",
                                 "Gorgon Head",
                                 "Banshee",
                                ].to_set,
    "Kalidus Channel" =>        [
                                 "Killer Fish",
                                 "Needles",
                                 "Nominon",
                                 "Merman",
                                 "Sea Stinger",
                                 "Dark Octopus",
                                 "Fishhead",
                                 "Sea Demon",
                                 "Gelso",
                                 "Forneus",
                                 "Skull Spider",
                                 "Specter",
                                 "Decarabia",
                                 "Edimmu",
                                 "Lorelai",
                                 "Une",
                                 "Demon",
                                 "Saint Elmo",
                                 "Ectoplasm",
                                 "Axe Knight",
                                 "Scarecrow",
                                 "Bitterfly",
                                 "Dullahan",
                                 "Werebat",
                                 "Miss Murder",
                                 "Automaton ZX26",
                                 "Balloon",
                                 "Mandragora",
                                 "Chosen Une",
                                 "Black Fomor",
                                 "White Fomor",
                                 "Rock Knight",
                                 "Black Crow",
                                 "Nightmare",
                                 "Dullahan",
                                 "Yeti",
                                 "Ghost",
                                 "Spear Guard",
                                 "Mimic",
                                 "Banshee",
                                ].to_set,
    "Oblivion Ridge" =>         [
                                 "Werewolf",
                                 "Lizardman",
                                 "Armored Beast",
                                 "Skeleton Beast",
                                 "Altair",
                                 "Stone Rose",
                                 "Flea Man",
                                 "Giant Skeleton",
                                 "Arachne",
                                 "Decarabia",
                                 "Owl",
                                 "Chosen Une",
                                 "Mandragora",
                                 "Black Panther",
                                 "Ladycat",
                                 "Polkir",
                                 "Devil",
                                 "Gashida",
                                 "Ghoul",
                                 "Merman",
                                 "Grave Digger",
                                 "Lorelai",
                                 "Skeleton Frisky",
                                 "Nova Skeleton",
                                 "Saint Elmo",
                                 "Enkidu",
                                 "Nightmare",
                                 "Scarecrow",
                                 "Bone Archer"
                                ].to_set,
    "Somnus Reef" =>            [
                                 "Merman",
                                 "Decarabia",
                                 "Edimmu",
                                 "Balloon",
                                 "Sea Demon",
                                 "Needles",
                                 "Lorelai",
                                 "Fishhead",
                                 "Saint Elmo",
                                 "Bone Pillar",
                                 "Curse Diva",
                                 "Gelso",
                                 "Forneus",
                                 "Sea Stinger",
                                 "Killer Fish",
                                 "Dark Octopus",
                                 "Rock Knight",
                                 "Spear Guard",
                                 "White Dragon",
                                 "Enkidu",
                                 "Giant Skeleton",
                                 "Skeleton Beast",
                                 "Automaton ZX27",
                                 "Lizardman",
                                 "Mandragora",
                                 "Chosen Une",
                                 "Stone Rose",
                                 "Black Fomor",
                                 "White Fomor",
                                 "Gargoyle",
                                 "Medusa Head",
                                 "Gorgon Head",
                                 "Arachne",
                                 "Tin Man",
                                 "Specter",
                                ].to_set,
    "Giant's Dwelling" =>       [
                                 "Ectoplasm",
                                 "Skeleton Beast",
                                 "Ladycat",
                                 "Automaton ZX26",
                                 "Miss Murder",
                                 "Curse Diva",
                                 "Zombie",
                                 "Skeleton Frisky",
                                 "Skeleton",
                                 "Evil Force",
                                 "Skeleton Hero",
                                 "Werewolf",
                                 "Altair",
                                 "Flea Man",
                                 "Automaton ZX27",
                                 "Decarabia",
                                 "Jersey Devil",
                                 "Gargoyle",
                                 "Black Panther",
                                 "Draculina",
                                 "Tin Man",
                                 "Nova Skeleton",
                                 "Lizardman",
                                 "Peeping Eye",
                                 "Bat",
                                 "Owl Knight",
                                 "Owl",
                                 "Yeti",
                                 "Saint Elmo",
                                 "Grave Digger",
                                 "Fire Demon",
                                 "Thunder Demon",
                                 "Black Crow",
                                 "Dark Octopus",
                                 "Spear Guard",
                                 "Bone Scimitar",
                                 "Ghost",
                                 "Lorelai",
                                 "Banshee",
                                ].to_set,
    "Tristis Pass" =>           [
                                 "Arachne",
                                 "Balloon",
                                 "Lizardman",
                                 "Giant Skeleton",
                                 "Mimic",
                                 "Bat",
                                 "Medusa Head",
                                 "Armored Beast",
                                 "White Dragon",
                                 "Ectoplasm",
                                 "Altair",
                                 "Owl",
                                 "Thunder Demon",
                                 "Owl Knight",
                                 "Skeleton Beast",
                                 "Lizardman Blade",
                                 "Fire Demon",
                                 "Winged Guard",
                                 "Bitterfly",
                                 "Decarabia",
                                 "Miss Murder",
                                 "Ladycat",
                                 "Black Panther",
                                 "Blade Master",
                                 "Skeleton Hero",
                                 "Ghost",
                                 "Jersey Devil",
                                 "Mad Butcher",
                                 "White Fomor",
                                 "Black Fomor",
                                 "Draculina",
                                 "Nova Skeleton",
                                 "Devil",
                                 "Cave Troll",
                                 "Imp",
                                 "Merman",
                                 "Skeleton Rex",
                                 "The Creature",
                                 "Enkidu",
                                 "Nightmare",
                                 "Spear Guard",
                                 "Necromancer"
                                ].to_set,
    "Argila Swamp" =>           [
                                 "Jersey Devil",
                                 "Chosen Une",
                                 "Owl Knight",
                                 "Stone Rose",
                                 "Mandragora",
                                 "Owl",
                                 "Black Crow",
                                 "Werebat",
                                 "Bat",
                                 "Flea Man",
                                 "Altair",
                                 "Armored Beast",
                                 "Ghoul",
                                 "Necromancer",
                                 "Peeping Eye",
                                 "Mimic",
                                 "Tin Man",
                                 "Gurkha Master",
                                 "Hammer Shaker",
                                 "Mad Butcher",
                                 "Fire Demon",
                                 "Lizardman",
                                 "Lizardman Blade",
                                 "Arachne",
                                 "Ladycat",
                                 "Saint Elmo",
                                 "Merman",
                                 "Specter",
                                 "Bitterfly",
                                 "Rock Knight",
                                 "Demon",
                                 "Scarecrow",
                                 "Dark Octopus"
                                ].to_set,
  }

  def initialize(rng, game, logs)
    @rng = rng
    @game = game
    @dra03 = game.dra03

=begin
    game.enemy_dnas.each do |enemy_dna|
      c = 0
      ENEMIES_PER_ZONE.each do |zone, enemy_list|
        if enemy_list.include?(enemy_dna.name)
          c += 1
        end
      end
      puts "#{enemy_dna.name}: #{c}"
    end
=end

    @resource_intensive_enemy_ids = []
    @unused_rooms = []

    randomize_enemies()
  end

  def build_entity_assets_lists
    @assets_for_each_enemy = {}
    @skeletally_animated_enemy_ids = []
    ENEMY_IDS.each do |enemy_id|
      begin
        enemy_dna = @game.enemy_dnas[enemy_id]
        graphics_list = extract_enemy_graphics(enemy_id)
        @assets_for_each_enemy[enemy_id] = graphics_list
        if enemy_dna.name == "Necromancer"
          # Also add Zombie's assets since he summons zombies.
          @assets_for_each_enemy[enemy_id] += @assets_for_each_enemy[1]
        end
      end
    end

    @assets_for_each_special_object = {}
    SPECIAL_OBJECT_IDS.each do |special_object_id|
      #if REUSED_SPECIAL_OBJECT_INFO[special_object_id] && REUSED_SPECIAL_OBJECT_INFO[special_object_id][:init_code] == -1
        #@assets_for_each_special_object[special_object_id] = []
        #next
      #end

      begin
        graphics_list = extract_special_object_graphics(special_object_id)
        #if sprite_info.gfx_file_pointers == common_sprite_gfx_files
          ## Don't count the common sprite.
          #@assets_for_each_special_object[special_object_id] = []
        #elsif special_object_id == AREA_NAME_SUBTYPE
          # Only count one gfx file for area names since the game only loads one.
          #@assets_for_each_special_object[special_object_id] = [sprite_info.gfx_file_pointers.first]
        #else
          @assets_for_each_special_object[special_object_id] = graphics_list
        #end
      end
    end
  end

  def randomize_enemies
    build_entity_assets_lists()

    enemy_rando_info_for_each_room, all_randomizable_enemy_locations = build_enemy_rando_info_list()
    total_enemy_locations = all_randomizable_enemy_locations.length

    @unplaced_enemy_ids = [*0x00..0x66] # For now Demon Lord, Weapon Master, and Double Hammer are excluded from this list so the randomizer doesn't try too hard to place them, since Large Cavern is not randomized.

    locations_done = 0
    all_randomizable_enemy_locations.shuffle!(random: rng)
    all_randomizable_enemy_locations.each do |enemy|
      room = enemy.room
      # Don't randomize Large Cavern. It's balanced around containing the strongest enemies, so it will either make the rooms with those too easy, or make rooms with many enemies way too hard.
      # Also don't randomize Training Hall for now, but both of these might change in the future.
      if [0x3, 0xc, 0x13].include?(room.area_index)
        next
      elsif room.area_index == 0
        zone_name = SECTOR_ID_TO_NAME[room.sector_index]
      else
        zone_name = AREA_ID_TO_NAME[room.area_index]
      end

      room_info = enemy_rando_info_for_each_room[room.room_str]
      enemies_in_room = room_info[:enemies_in_room]
      @enemy_pool_for_room = room_info[:enemy_pool_for_room]
      @num_spawners = room_info[:num_spawners]
      @total_resource_intensive_enemies_in_room = room_info[:total_resource_intensive_enemies_in_room]
      @assets_needed_for_room = room_info[:assets_needed_for_room]
      @allowed_enemies_for_room = room_info[:allowed_enemies_for_room]
      #@coll = room_info[:coll]
      remaining_new_room_difficulty = room_info[:remaining_new_room_difficulty]
      max_allowed_enemy_attack = room_info[:max_allowed_enemy_attack]
      on_first_enemy_of_room = room_info[:on_first_enemy_of_room]

      @allowed_enemies_for_room.select! do |enemy_id|
        enemy_dna = @game.enemy_dnas[enemy_id]
        if enemy_dna.atk <= 0x1E and @game.options[:rv_difficulty] != "Vanilla"
          # Always allow weak enemies in the room. Don't do this for Vanilla difficulty to slightly lower Forest/Monastery difficulty.
          true
        elsif enemy_dna.atk <= remaining_new_room_difficulty && enemy_dna.atk <= max_allowed_enemy_attack
          true
        else
          false
        end
      end

      # Remove enemies that would go over the asset cap.
      asset_slots_left = MAX_ASSETS_PER_ROOM - @assets_needed_for_room.size
      @allowed_enemies_for_room.select! do |enemy_id|
        needed_assets_for_enemy = @assets_for_each_enemy[enemy_id].size
        needed_assets_for_enemy <= asset_slots_left
      end

      disallow_spawners = false
      if @num_spawners >= 1
        disallow_spawners = true
      end
      if disallow_spawners
        @allowed_enemies_for_room -= SPAWNER_ENEMY_IDS
        @enemy_pool_for_room -= SPAWNER_ENEMY_IDS
      end

      if on_first_enemy_of_room && enemies_in_room.length > 1
        # We don't want the first enemy we place to be one that there can only be a limited number in a given room.
        # This is because if this one enemy goes over the asset limit for the room, then we wouldn't have any enemies left to place: the same one we already placed would go over the limit per room, while any new one would go over the asset limit.
        # If the total number of enemies in the room is 1 it doesn't matter.
        limitable_enemy_ids = @resource_intensive_enemy_ids + SPAWNER_ENEMY_IDS
        temporarily_removed_enemies = @allowed_enemies_for_room & limitable_enemy_ids
        @allowed_enemies_for_room -= temporarily_removed_enemies
      end


      randomize_enemy(enemy)
      enemy.location_is_randomized = true

      if temporarily_removed_enemies
        # Add back the limitable enemies now.
        @allowed_enemies_for_room += temporarily_removed_enemies
      end

      if SPAWNER_ENEMY_IDS.include?(enemy.subtype)
        @num_spawners += 1
      end

      enemy_dna = @game.enemy_dnas[enemy.subtype]
      remaining_new_room_difficulty -= enemy_dna.atk

      assets = @assets_for_each_enemy[enemy.subtype]
      @assets_needed_for_room += assets
      @assets_needed_for_room.uniq!

      if @total_resource_intensive_enemies_in_room >= 2
        # We don't want too many skeletally animated enemies on screen at once, as it takes up too much processing power.

        @allowed_enemies_for_room -= @resource_intensive_enemy_ids
        @enemy_pool_for_room -= @resource_intensive_enemy_ids
      end

      room_is_part_of_main_game = true
      #if room.area.name.include?("Boss Rush") || room.sector.name.include?("Boss Rush")
        #room_is_part_of_main_game = false
      #end
      if room_is_part_of_main_game
        # Keep track of enemies that have not yet been made accessible in the main game so we can prioritize them.
        @unplaced_enemy_ids.delete(enemy.subtype)
      end

      room_info[:enemy_pool_for_room] = @enemy_pool_for_room
      room_info[:num_spawners] = @num_spawners
      room_info[:total_resource_intensive_enemies_in_room] = @total_resource_intensive_enemies_in_room
      room_info[:assets_needed_for_room] = @assets_needed_for_room
      room_info[:allowed_enemies_for_room] = @allowed_enemies_for_room
      room_info[:remaining_new_room_difficulty] = remaining_new_room_difficulty
      room_info[:on_first_enemy_of_room] = false

      locations_done += 1
      percent_done = locations_done.to_f / total_enemy_locations
      # Todo: Yielding slows this down by a lot.
      #yield percent_done
    end

    # Delete room-specific instance variables as they are no longer needed.
    @enemy_pool_for_room = nil
    @num_spawners = nil
    @total_resource_intensive_enemies_in_room = nil
    @assets_needed_for_room = nil
    @allowed_enemies_for_room = nil
    #@coll = nil

    if @unplaced_enemy_ids.any?
      puts "Total unplaced enemy types: #{@unplaced_enemy_ids.size} out of #{[*0x00..0x66, *0x68..0x6A].size}"
      for enemy_id in @unplaced_enemy_ids
        puts "  %02X #{@game.enemy_dnas[enemy_id].name}" % enemy_id
      end
    end
  end

  def build_enemy_rando_info_list
    enemy_rando_info_for_each_room = {}
    all_randomizable_enemy_locations = []
    @game.rooms.each do |room|
      next if @unused_rooms.include?(room)

      enemies_in_room = get_common_enemies_in_room(room)
      next if enemies_in_room.empty?

      all_randomizable_enemy_locations += enemies_in_room

      allowed_enemies_for_room = build_initial_allowed_enemy_list_for_room(room)

      assets_needed_for_room = build_base_list_of_assets_for_room(room)

      #collision_checker_for_room = get_room_collision(room)

      remaining_new_room_difficulty, max_allowed_enemy_attack = calculate_allowed_difficulty_and_max_attack_for_room(room)

      enemy_rando_info_for_each_room[room.room_str] = {
        enemies_in_room: enemies_in_room,
        enemy_pool_for_room: [],
        num_spawners: 0,
        total_resource_intensive_enemies_in_room: 0,
        assets_needed_for_room: assets_needed_for_room,
        allowed_enemies_for_room: allowed_enemies_for_room,
        #coll: collision_checker_for_room,
        remaining_new_room_difficulty: remaining_new_room_difficulty,
        max_allowed_enemy_attack: max_allowed_enemy_attack,
        on_first_enemy_of_room: true,
      }
    end

    return [enemy_rando_info_for_each_room, all_randomizable_enemy_locations]
  end

  def calculate_allowed_difficulty_and_max_attack_for_room(room)
    enemies_in_room = get_common_enemies_in_room(room)

    # Calculate how difficult a room originally was by the sum of the Attack value of all enemies in the room.
    original_room_difficulty = enemies_in_room.reduce(0) do |difficulty, enemy|
      enemy_dna = @game.enemy_dnas[enemy.subtype]
      difficulty + enemy_dna.atk
    end

    max_enemy_attack = enemies_in_room.map do |enemy|
      enemy_dna = @game.enemy_dnas[enemy.subtype]
      enemy_dna.atk
    end.max

    # Only allow tough enemies in the room up to the original room's difficulty times a multiplier.
    # Rooms with more enemies have a lower multiplier because having multiple very tough enemies together tends to be unreasonable.
    room_multiplier = 2.0 ** (((1/enemies_in_room.size) + [(2/enemies_in_room.size), 1].min)/2)
    remaining_new_room_difficulty = original_room_difficulty*room_multiplier

    # Only allow enemies up to a certain multiplier higher than the strongest enemy in the original room.
    max_multiplier = @game.options[:rv_difficulty] == "Vanilla" ? 1.2 : 1.3
    max_allowed_enemy_attack = max_enemy_attack*max_multiplier

    if max_enemy_attack > 60
      # If this is a very difficult endgame room in vanilla already, we make the difficulty of the room completely unlimited.
      # This is so that certain enemies that had high stats in vanilla and also had those stats increased by the enemy stat randomizer can still have a chance at being placed somewhere in the game.
      remaining_new_room_difficulty = 9999
      max_allowed_enemy_attack = 9999
    end

    return [remaining_new_room_difficulty, max_allowed_enemy_attack]
  end

  def get_common_enemies_in_room(room)
    enemies_in_room = room.entities.select{|e| e.is_common_enemy?}

    # Randomize the Giant Skeletons that are common enemies.
    enemies_in_room += room.entities.select do |e|
      e.is_enemy? && e.subtype == 0x6B && e.var_a == 0
    end

    # Don't randomize the inanimate Gargoyle's outside the castle. They're supposed to be decorations.
    enemies_in_room.reject! do |e|
      ["00-0C-00_03", "00-0C-02_04", "00-01-06_04"].include?(e.entity_str)
    end

    return enemies_in_room
  end

  def randomize_enemy(enemy, failed_enemies_for_this_spot = [])
    if enemy.room.area_index == 0
      zone_name = SECTOR_ID_TO_NAME[enemy.room.sector_index]
    else
      zone_name = AREA_ID_TO_NAME[enemy.room.area_index]
    end
    if @assets_needed_for_room.size >= MAX_ASSETS_PER_ROOM
      # There's a limit to how many different GFX files can be loaded at once before things start getting very buggy.
      # Once there's too many, just select from enemies already in the room.

      enemy_pool_for_room_minus_failed = @enemy_pool_for_room - failed_enemies_for_this_spot

      if enemy_pool_for_room_minus_failed.any?
        random_enemy_id = enemy_pool_for_room_minus_failed.sample(random: rng)
      else
        # Placing any more enemies would go over the asset limit, but none of the existing ones work in this spot.
        # Just delete this enemy.
        enemy.type = 0
        return
      end
    else
      # Enemies are chosen weighted closer to the ID of what the original enemy was so that early game enemies are less likely to roll into endgame enemies.
      # Method taken from: https://gist.github.com/O-I/3e0654509dd8057b539a

      possible_enemy_ids = @allowed_enemies_for_room
      possible_enemy_ids -= failed_enemies_for_this_spot
      possible_unplaced_enemy_ids = possible_enemy_ids & @unplaced_enemy_ids
      if possible_unplaced_enemy_ids.any?
        possible_enemy_ids = possible_unplaced_enemy_ids
      end
      if possible_enemy_ids.empty?
        enemy.type = 0
        return
      end

      max_enemy_id = 0x78
      weights = possible_enemy_ids.map do |possible_enemy_id|
        curr_enemy_id_for_id_weighting = enemy.subtype
        id_difference = (possible_enemy_id - curr_enemy_id_for_id_weighting).abs
        weight = max_enemy_id - id_difference
        weight**3.0

        #Also weight for matching the role of the initial enemy, which helps avoid unfair layouts and retain some degree of room flavor.
        if ENEMIES_PER_ZONE.has_key?(zone_name)
          target_room = enemy.entity_str[0..7]
          target_slot = enemy.entity_str[9..10]
          #puts target_room + "_" + target_slot
          loc = OoERooms.enemies_by_room[target_room][target_slot]
          old_role = loc.type.first
          if ["Vanguard", "Ambush", "Threat"].include?(old_role)
            if loc.type.include?("Air")
              old_role = "Seeker"
            else
              old_role = "Challenger"
            end
          end
          new_roles = ENEMY_ROLES[@game.enemy_dnas[possible_enemy_id].name]
          if new_roles.include?(old_role)
            weight *= 3
          end
          # Helps a little bit to avoid having hardmode enemies raise the normal mode difficulty of a room.
          if loc.type.include?("Hardmode")
            weight *= @game.enemy_dnas[possible_enemy_id].atk
          end
        end
        #Weight against spawners in rooms with many enemies, unless the position was already for a respawning enemy
        if ENEMIES_PER_ZONE.has_key?(zone_name) and OoERooms.enemies_by_room[target_room].size > 3 and (not SPAWNER_ENEMY_IDS.include?(possible_enemy_id)) and (not loc.type.include?("Persistent"))
          weight *= OoERooms.enemies_by_room[target_room].size - 3
        end
        weight
      end

      ps = weights.map{|w| w.to_f / weights.reduce(:+)}
      weighted_enemy_ids = possible_enemy_ids.zip(ps).to_h
      random_enemy_id = weighted_enemy_ids.max_by{|_, weight| rng.rand ** (1.0 / weight)}.first

    end

    #fix_enemy_position(enemy)

    enemy_dna = @game.enemy_dnas[random_enemy_id]

    enemy.var_a = 0
    enemy.var_b = 0
    result = ooe_adjust_randomized_enemy_rv(enemy, enemy_dna)

    # We fix the enemy position twice in case the enemy-specific adjustment moved it down onto a door or something.
    #fix_enemy_position(enemy)

    if result == :redo
      failed_enemies_for_this_spot << random_enemy_id
      randomize_enemy(enemy, failed_enemies_for_this_spot)
    else
      enemy.subtype = random_enemy_id
      @enemy_pool_for_room << random_enemy_id
      @enemy_pool_for_room.uniq!

      if @resource_intensive_enemy_ids.include?(random_enemy_id)
        @total_resource_intensive_enemies_in_room += 1
      end
    end
  end

  def ooe_adjust_randomized_enemy(enemy, enemy_dna)
    if enemy_dna.glyph != 0
      glyphs_in_room = [].to_set
      enemy.room.entities.each do |e|
        if e.is_glyph? or e.is_glyph_statue?
          glyphs_in_room << e.var_b - 1
        elsif e.is_villager?
          glyphs_in_room << 0x1e # Torpor
        elsif e.is_common_enemy? and e.location_is_randomized and e.subtype != enemy_dna.enemy_id and @game.enemy_dnas[e.subtype].glyph != 0
          glyphs_in_room << @game.enemy_dnas[e.subtype].glyph - 1
        end
      end
      glyphs_in_room << enemy_dna.glyph - 1
      if glyphs_in_room.length >= 3
        # If the room already has 2+ glyphs in it, don't put any enemies that create glyphs in the room too.
        # (Applies to both enemies that drop glyphs when they die, as well as ones that use glyphs while they're alive.)
        return :redo
      end
    end

    case enemy_dna.name
    when "Bat"
      # 50% chance to be a single bat, 50% chance to be a spawner.
      if rng.rand <= 0.5
        enemy.var_a = 0
        enemy.var_b = 0 # Teleport to the closest ceiling.
      else
        enemy.var_a = 0x100
      end
    when "Medusa Head"
      enemy.var_b = rng.rand(0..1) # Type of Medusa Head
      if enemy.var_b == 1 # Golden Medusa Head that petrifies
        enemy.var_a = 1
      else # Blue Medusa Head
        enemy.var_a = rng.rand(1..7) # Max at once
      end
    when "Bone Pillar", "Fish Head"
      enemy.var_a = rng.rand(1..8)

      # Move down to the nearest floor
      #y = coll.get_floor_y(enemy, allow_jumpthrough: true)
      #if y.nil?
        # No floor
        #return :redo
      #end
      #enemy.y_pos = y

      #room_has_left_doors = !!enemy.room.doors.find{|door| door.direction == :left}
      #room_has_right_doors = !!enemy.room.doors.find{|door| door.direction == :right}
      #if room_has_left_doors
        #enemy.x_pos = [enemy.x_pos, 0x20].max
      #end
      #if room_has_right_doors
        #room_width = enemy.room.width*SCREEN_WIDTH_IN_PIXELS
        #enemy.x_pos = [enemy.x_pos, room_width-0x20].min
      #end
    when "White Dragon"
      #right_x = coll.get_right_wall_x(enemy)
      #left_x = coll.get_left_wall_x(enemy)
      #if right_x && left_x
        #if rng.rand <= 0.50
          #enemy.x_pos = right_x
          #enemy.var_a = 1
        #else
          #enemy.x_pos = left_x
          #enemy.var_a = 0
        #end
      #elsif right_x
        #enemy.x_pos = right_x
        #enemy.var_a = 1
      #elsif left_x
        #enemy.x_pos = left_x
        #enemy.var_a = 0
      #else
        # No walls to the left or right, don't place this enemy here.
        #return :redo
      #end
    when "Black Crow"
      enemy.var_a = 1 # Teleport to the closest floor.
    when "Zombie", "Ghoul"
      if rng.rand <= 0.30 # 30% chance to be a single Zombie
        enemy.var_a = 0
        enemy.var_b = 0
      else # 70% chance to be a spawner
        enemy.var_a = rng.rand(3..6) # Max at once

        #room_width = enemy.room.width*SCREEN_WIDTH_IN_PIXELS
        #enemy.var_b = rng.rand(100..room_width) # Max horizontal distance in pixels from the spawner to spawn the Zombies
      end
    when "Sea Stinger"
      if rng.rand <= 0.10 # 10% chance to be a single Sea Stinger
        enemy.var_a = 0
        enemy.var_b = 0
      else # 90% chance to be a spawner
        enemy.var_a = rng.rand(2..6) # Max at once
      end
    when "Skeleton"
      enemy.var_a = rng.rand(0..1) # Can jump away.
    when "Bone Archer"
      enemy.var_a = rng.rand(0..8) # Arrow speed.
    when "Axe Knight"
      # 80% chance to be normal, 20% chance to start out in pieces.
      if rng.rand() <= 0.80
        enemy.var_b = 0
      else
        enemy.var_b = 1
      end
    when "Flea Man"
      enemy.var_b = 0
    when "Ghost"
      enemy.var_a = rng.rand(1..4) # Max ghosts on screen at once.
    when "Skull Spider"
      # Move out of the floor TODO this doesn't work
      enemy.y_pos -= 0x08

      enemy.var_a = rng.rand(0x600..0x1800) # speed
    when "Skeleton Frisky"
      #y = coll.get_floor_y(enemy, allow_jumpthrough: true)
      #if y.nil?
        # No floor, Frisky will crash the game
        #return :redo
      #end
      #enemy.y_pos = y
    when "Gelso"
      if rng.rand <= 0.40 # 40% chance to be a single Gelso
        enemy.var_a = 0
        enemy.var_b = 0
      else # 60% chance to be a spawner
        enemy.var_a = rng.rand(1..6) # Max at once
        enemy.var_b = rng.rand(180..480) # Frames in between spawning them
      end
    when "Merman"
      # Move out of the floor
      enemy.y_pos -= 0x10
    when "Saint Elmo"
      enemy.var_a = rng.rand(1..3)
      enemy.var_b = 0x78
    when "Winged Guard"
      enemy.var_a = rng.rand(1..5) # Max at once
    when "Winged Skeleton"
      enemy.var_a = rng.rand(40..80) # Minimum delay between spawns
      enemy.var_b = rng.rand(40..80) # Random range to add to delay between spawns
    when "Altair"
      if rng.rand <= 0.40 # 40% chance to carry fleamen
        enemy.var_a = 0
      else # 60% chance to attack by swooping down
        enemy.var_a = 1
      end
      enemy.var_b = rng.rand(240..720) # Spawn rate is somewhere from every 2 seconds to one every 6 seconds.
    when "Gorgon Head"
      enemy.var_a = rng.rand(300..700) # Minimum delay between spawns
      enemy.var_b = rng.rand(120..700) # Random range to add to delay between spawns
    when "Nightmare"
      #if enemy.room.width <= 1
        # Don't let Nightmare appear in 1-screen wide rooms as he will just fade in and out constantly if he doesn't have a wide area.
        #return :redo
      #end
    when "Tin Man"
      # If Tin Man is placed on a 1-tile-wide jump-through-platform he will crash the game because his AI isn't sure where to put him.
      # So move him downwards to the nearest *solid* floor to prevent this.
      #y = coll.get_floor_y(enemy, allow_jumpthrough: false)
      #if y.nil?
        # No floor
        #return :redo
      #end
      #enemy.y_pos = y

      #y = coll.push_up_out_of_floor(enemy)
      #if y.nil?
        # Floor extends up infinitely. He would be stuck inside the wall, which crashes the game.
        #return :redo
      #end
      #enemy.y_pos = y

      #right_type, right_x, right_y = coll.follow_floor_right(enemy.x_pos, enemy.y_pos)
      #left_type, left_x, left_y = coll.follow_floor_left(enemy.x_pos, enemy.y_pos)

      #if right_type == :unknown || left_type == :unknown
        #return :redo
      #end

      #distance_left = enemy.x_pos - left_x
      #distance_right = right_x - enemy.x_pos
      #if (right_type == :roomedge && distance_right < 0x100) || (left_type == :roomedge && distance_left < 0x100)
        # Prevent Tin Man from being able to access a door as soon as the player enters through it - Tin Man is so fast that the damage would be unavoidable.
        #return :redo
      #end

      # If var A is nonzero, Tin Man will be able to fall off ledges - but long falls will crash the game, so disable this.
      enemy.var_a = 0
    when "Mimic"
      # If a Mimic isn't on the floor it's impossible for the player to open it, and therefore impossible to kill.

      #y = coll.get_floor_y(enemy, allow_jumpthrough: false)
      #if y.nil?
        # No floor
        #return :redo
      #end
      #enemy.y_pos = y
    when "Giant Skeleton"
      enemy.var_a = 0 # Common enemy Giant Skeleton.
      enemy.var_b = 0 # Faces the player when they enter the room.
    end
  end

  def ooe_adjust_randomized_enemy_rv(enemy, enemy_dna)
    if enemy_dna.glyph != 0
      glyphs_in_room = enemy.room.entities.select{|e| e.is_glyph? || e.is_glyph_statue? || e.is_villager? || (e.is_common_enemy? and e.subtype != enemy.subtype and @game.enemy_dnas[e.subtype].glyph != 0)}
      if glyphs_in_room.length >= 2
        # If the room already has 2+ glyphs in it, don't put any enemies that create glyphs in the room too.
        # (Applies to both enemies that drop glyphs when they die, as well as ones that use glyphs while they're alive.)
        return :redo
      end
    end

    room_str = enemy.entity_str[0..7]
    entity_id = enemy.entity_str[9..10]
    loc = OoERooms.enemies_by_room[room_str][entity_id]

    target_room = OoERooms.all_rooms[room_str]
    if target_room.kind_of?(Array)
      target_room = target_room.first
    end
    room_width = target_room.width
    room_height = target_room.height

    # Skeleton Cave and Tymeo Mountains contain a few enemies which are far out of their normal level range, even in vanilla. Some of these are hard-mode-only enemies.
    # This can easily make some rooms unreasonable when those enemies are placed in close quarters, so add a special case to avoid that specific situation.
    if [0xa, 0x11,].include?(enemy.room.area_index) and enemy_dna.enemy_id >= 0x4c and (loc.type.include?("Enclosed") or loc.type.include?("Semi-Enclosed"))
      return :redo
    end

    ambush_okay_ids = [1,2,3,4,7,8,9,0xa,0xb,0xc,0xe,0xf,0x10,0x11,0x1a,0x1b,0x1e,0x21,0x23,0x2b,0x2e,0x33,0x34,0x3a,0x3b,0x3c,0x40,0x42,0x44,0x45,0x48,0x49,0x4a,0x4b,0x4d,0x4e,0x50,0x51,0x58,0x59,0x5d,0x5f,0x60,0x61,0x62]
    if loc.type.include?("Ambush") and not ambush_okay_ids.include?(enemy_dna.enemy_id)
      return :redo
    end
    # Enemies that aggro from the start of the room regardless of how far they are can be impossible to avoid in enclosed areas.
    large_aggressive_enemies = ["Double Hammer", "Weapon Master", "Red Smasher", "Tin Man", "Nightmare", "Skeleton Frisky", "Skeleton Rex", "Edimmu", "Evil Force", "Gashida"]
    if ((loc.type.include?("Enclosed") or loc.type.include?("Semi-Enclosed")) and not (loc.type.include?("Separated"))) and large_aggressive_enemies.include?(enemy_dna.name)
      return :redo
    end
    large_tanky_enemies = ["Double Hammer", "Weapon Master", "Red Smasher", "Skeleton Rex", "Edimmu", "Evil Force", "Enkidu", "The Creature", "Final Knight", "Great Knight", "Rebuild", "King Skeleton", "Skeleton Beast", "Spectral Sword", "Demon Lord"]
    if large_tanky_enemies.include?(enemy_dna.name)
      # Don't put hard-to-clear enemies for their ATK value too close to each other. The game does sometimes include more than one in a room, but they tend to be spaced apart.
      already_randomized_enemies = enemy.room.entities.select {|e| e.is_common_enemy? and e.location_is_randomized}
      already_randomized_enemies.each do |other_enemy|
        if large_tanky_enemies.include?(@game.enemy_dnas[other_enemy.subtype].name)
          distance = Math.sqrt((enemy.x_pos - other_enemy.x_pos) ** 2.0 + (enemy.y_pos - other_enemy.y_pos) ** 2.0)
          if distance < 0x80
            return :redo
          end
        end
      end
      # Also avoid putting them in flat rooms with many enemies since things can easily get out of hand.
      if room_height == 1 and enemy.room.entities.select {|e| e.is_common_enemy?}.size > 4
        return :redo
      end
    end
    # There are some enemies like the above where we don't want to stack too many of this enemy, but it's also not especially a problem for them to be in a room with many other enemies.
    other_spaced_enemies = ["White Dragon", "Demon", "Invisible Man", "Armored Beast"]
    if other_spaced_enemies.include?(enemy_dna.name)
      already_randomized_enemies = enemy.room.entities.select {|e| e.is_common_enemy? and e.location_is_randomized}
      already_randomized_enemies.each do |other_enemy|
        if (other_spaced_enemies+large_tanky_enemies).include?(@game.enemy_dnas[other_enemy.subtype].name)
          distance = Math.sqrt((enemy.x_pos - other_enemy.x_pos) ** 2.0 + (enemy.y_pos - other_enemy.y_pos) ** 2.0)
          if distance < 0x80
            return :redo
          end
        end
      end
    end
    too_fast_enemies = ["Red Smasher", "Tin Man"]
    if room_width == 1 and room_height == 1 and too_fast_enemies.include?(enemy_dna.name)
      return :redo
    end
    airborne_enemies = ["Bat", "Ghost", "Banshee", "Sea Stinger", "Nominon", "Gelso", "Needles", "Demon", "Killer Fish", "Forneus", "Black Crow", "Sea Demon", "Winged Guard", "Nightmare", "Fire Demon", "Bitterfly", "Specter", "Black Fomor",
     "Saint Elmo", "Lorelai", "Edimmu", "Ectoplasm", "Curse Diva", "Miss Murder", "Balloon", "Thunder Demon", "Owl", "Altair", "Jersey Devil", "White Fomor", "Evil Force", "Peeping Eye", "Polkir", "Imp", "Bugbear",
     "Spectral Sword", "Medusa Head", "Gorgon Head", "Winged Skeleton", "Demon Lord"]
    if loc.type.include?("AirOnly") and not airborne_enemies.include?(enemy_dna.name)
      return :redo
    end
    if loc.type.include?("Offscreen") and not (SPAWNER_ENEMY_IDS.include?(enemy_dna.enemy_id) and airborne_enemies.include?(enemy_dna.name))
      return :redo
    end
    swimming_enemies = ["Merman"] + airborne_enemies
    if loc.type.include?("Water") and not swimming_enemies.include?(enemy_dna.name)
      return :redo
    end
    platform_incapable_enemies = ["Werebat", "Grave Digger", "Tin Man", "Lizardman Blade", "Ghoul", "Zombie", "Dullahan", "Dark Octopus", "Bone Scimitar", "Lilith"]
    if loc.type.include?("Platform") and platform_incapable_enemies.include?(enemy_dna.name)
      return :redo
    end
    enclosed_incapable_enemies = ["King Skeleton", "Skeleton Beast", "Final Knight", "Great Knight", "Skeleton Rex", "Devil", "Scarecrow", "Enkidu"]
    if loc.type.include?("Enclosed") and enclosed_incapable_enemies.include?(enemy_dna.name)
      return :redo
    end
    semienclosed_unsuited_enemies = ["Weapon Master"]
    if (loc.type.include?("Enclosed") or loc.type.include?("Semi-Enclosed")) and semienclosed_unsuited_enemies.include?(enemy_dna.name)
      return :redo
    end
    extra_large_enemies = ["Final Knight", "Great Knight", "Weapon Master", "Spectral Sword", "Giant Skeleton", "King Skeleton", "Skeleton Beast"]
    if loc.type.include?("Vanguard") and (not loc.type.include?("Guard")) and extra_large_enemies.include?(enemy_dna.name)
      return :redo
    end
    large_enemies = extra_large_enemies + ["Hammer Shaker", "Gurkha Master", "Devil", "Rebuild", "The Creature", "Rock Knight", "Lorelai"]
    if (loc.type.include?("Enclosed") or loc.type.include?("Semi-Enclosed")) and loc.type.include?("Vanguard") and large_enemies.include?(enemy_dna.name)
      return :redo
    end
    collision_issue_enemies = "Decarabia", "Hammer Shaker", "Double Hammer"
    #Some enemy locations placed in a floor barrier cause a large enemy to spawn on the wrong side.
    if loc.type.include?("CollisionIssue") and collision_issue_enemies.include?(enemy_dna.name)
      return :redo
    end
    passthrough_issue_enemies = ["Skeleton Rex", "The Creature", "Giant Skeleton", "Skeleton Beast", "King Skeleton"]
    if loc.type.include?("Passthrough") and passthrough_issue_enemies.include?(enemy_dna.name)
      return :redo
    end

    if SPAWNER_ENEMY_IDS.include?(enemy_dna.enemy_id)
      x_offset = rng.rand - 0.5 * room_width * 20
    end

    case enemy_dna.name
    when "Bat"
      # 50% chance to be a single bat, 50% chance to be a spawner.
      if rng.rand <= 0.5
        enemy.var_a = 0
        enemy.var_b = 1 # Appears where placed.
      else
        enemy.var_a = 0x100
      end
    when "Medusa Head"
      enemy.var_b = rng.rand(0..1) # Type of Medusa Head
      if enemy.var_b == 1 # Golden Medusa Head that petrifies
        enemy.var_a = 1
      else # Blue Medusa Head
        enemy.var_a = rng.rand(1..7) # Max at once
      end
    when "Bone Pillar", "Fishhead"
      first_stage = rng.rand(1..4)
      # Adds another 1-4 stacks, weighted to not add much, so that high stacks are rare.
      second_stage = (5 - rng.rand(1..124) ** (1.0/3.0)).floor
      enemy.var_a = first_stage + second_stage
      if loc.type.include?("Enclosed") or loc.type.include?("Ambush")
        enemy.var_a = [3, enemy.var_a].min
      end
      # Move down to the nearest floor
      #y = coll.get_floor_y(enemy, allow_jumpthrough: true)
      #if y.nil?
        # No floor
        #return :redo
      #end
      #enemy.y_pos = y

      #room_has_left_doors = !!enemy.room.doors.find{|door| door.direction == :left}
      #room_has_right_doors = !!enemy.room.doors.find{|door| door.direction == :right}
      #if room_has_left_doors
        #enemy.x_pos = [enemy.x_pos, 0x20].max
      #end
      #if room_has_right_doors
        #room_width = enemy.room.width*SCREEN_WIDTH_IN_PIXELS
        #enemy.x_pos = [enemy.x_pos, room_width-0x20].min
      #end
    when "White Dragon"
      #right_x = coll.get_right_wall_x(enemy)
      #left_x = coll.get_left_wall_x(enemy)
      #if right_x && left_x
        #if rng.rand <= 0.50
          #enemy.x_pos = right_x
          #enemy.var_a = 1
        #else
          #enemy.x_pos = left_x
          #enemy.var_a = 0
        #end
      #elsif right_x
        #enemy.x_pos = right_x
        #enemy.var_a = 1
      #elsif left_x
        #enemy.x_pos = left_x
        #enemy.var_a = 0
      #else
        # No walls to the left or right, don't place this enemy here.
        #return :redo
      #end
      if not (loc.type.include?("Wall") or loc.type.include?("WallR"))
        return :redo
      else
        direction_weight = 0.5
        if loc.type.include?("Wall")
          direction_weight -= 0.5
        end
        if loc.type.include?("WallR")
          direction_weight += 0.5
        end
        enemy.var_a = rng.rand < direction_weight ? 1 : 0
      end
    when "Black Crow"
      enemy.var_a = 0 # Stay where placed instead of teleporting to the nearest floor, so that it doesn't block entrances and such. Also more variety.
    when "Zombie", "Ghoul"
      if rng.rand <= 0.30 # 30% chance to be a single Zombie
        enemy.var_a = 0
        enemy.var_b = 0
      else # 70% chance to be a spawner
        enemy.var_a = rng.rand(3..6) # Max at once

        #room_width = enemy.room.width*SCREEN_WIDTH_IN_PIXELS
        #enemy.var_b = rng.rand(100..room_width) # Max horizontal distance in pixels from the spawner to spawn the Zombies
      end
    when "Sea Stinger"
      # Single Sea Stingers seem to not function outside of shallow water?
      if rng.rand <= 0.10 and loc.type.include?("Water") # 10% chance to be a single Sea Stinger
        enemy.var_a = 0
        enemy.var_b = 0
      else # 90% chance to be a spawner
        enemy.var_a = rng.rand(2..6) # Max at once
      end
    when "Skeleton"
      enemy.var_a = rng.rand(0..1) # Can jump away.
    when "Bone Archer"
      enemy.var_a = rng.rand(0..8) # Arrow speed.
    when "Axe Knight"
      # 80% chance to be normal, 20% chance to start out in pieces.
      if rng.rand() <= 0.80
        enemy.var_b = 0
      else
        enemy.var_b = 1
      end
    when "Flea Man"
      enemy.var_b = 0
    when "Ghost"
      enemy.var_a = rng.rand(1..4) # Max ghosts on screen at once.
    when "Skull Spider"
      # Move out of the floor TODO this doesn't work
      enemy.y_pos -= 0x08
      #Don't randomize speed when there are a lot of enemies.
      if enemy.room.entities.select {|e| e.is_common_enemy?}.size <= 4
        enemy.var_a = rng.rand(0x600..0x1800) # speed
      else
        enemy.var_a = 0 #default
      end
    when "Skeleton Frisky"
      #y = coll.get_floor_y(enemy, allow_jumpthrough: true)
      #if y.nil?
        # No floor, Frisky will crash the game
        #return :redo
      #end
      #enemy.y_pos = y
    when "Gelso"
      if rng.rand <= 0.40 # 40% chance to be a single Gelso
        enemy.var_a = 0
        enemy.var_b = 0
      else # 60% chance to be a spawner
        enemy.var_a = rng.rand(1..6) # Max at once
        enemy.var_b = rng.rand(180..480) # Frames in between spawning them
      end
    when "Merman"
      # Move out of the floor
      enemy.y_pos -= 0x10
      if loc.type.include?("Water")
        enemy.var_a = 0 # Swim on surface of water and leap out
      else
        enemy.var_a = 1 # Walk normally and shoot fireballs
      end
    when "Saint Elmo"
      enemy.var_a = rng.rand(1..3)
      enemy.var_b = 0x78
    when "Winged Guard"
      enemy.var_a = rng.rand(1..5) # Max at once
    when "Winged Skeleton"
      enemy.var_a = rng.rand(40..80) # Minimum delay between spawns
      enemy.var_b = rng.rand(40..80) # Random range to add to delay between spawns
    when "Altair"
      if rng.rand <= 0.40 # 40% chance to carry fleamen
        enemy.var_a = 0
      else # 60% chance to attack by swooping down
        enemy.var_a = 1
      end
      enemy.var_b = rng.rand(240..720) # Spawn rate is somewhere from every 2 seconds to one every 6 seconds.
    when "Gorgon Head"
      enemy.var_a = rng.rand(300..700) # Minimum delay between spawns
      enemy.var_b = rng.rand(120..700) # Random range to add to delay between spawns
    when "Nightmare"
      #if enemy.room.width <= 1
        # Don't let Nightmare appear in 1-screen wide rooms as he will just fade in and out constantly if he doesn't have a wide area.
        #return :redo
      #end
      if room_width == 1
        return :redo
      end
    when "Tin Man"
      # If Tin Man is placed on a 1-tile-wide jump-through-platform he will crash the game because his AI isn't sure where to put him.
      # So move him downwards to the nearest *solid* floor to prevent this.
      #y = coll.get_floor_y(enemy, allow_jumpthrough: false)
      #if y.nil?
        # No floor
        #return :redo
      #end
      #enemy.y_pos = y

      #y = coll.push_up_out_of_floor(enemy)
      #if y.nil?
        # Floor extends up infinitely. He would be stuck inside the wall, which crashes the game.
        #return :redo
      #end
      #enemy.y_pos = y

      #right_type, right_x, right_y = coll.follow_floor_right(enemy.x_pos, enemy.y_pos)
      #left_type, left_x, left_y = coll.follow_floor_left(enemy.x_pos, enemy.y_pos)

      #if right_type == :unknown || left_type == :unknown
        #return :redo
      #end

      #distance_left = enemy.x_pos - left_x
      #distance_right = right_x - enemy.x_pos
      #if (right_type == :roomedge && distance_right < 0x100) || (left_type == :roomedge && distance_left < 0x100)
        # Prevent Tin Man from being able to access a door as soon as the player enters through it - Tin Man is so fast that the damage would be unavoidable.
        #return :redo
      #end

      # If var A is nonzero, Tin Man will be able to fall off ledges - but long falls will crash the game, so disable this.
      enemy.var_a = 0
    when "Mimic", "Une"
      # If a Mimic isn't on the floor it's impossible for the player to open it, and therefore impossible to kill.

      #y = coll.get_floor_y(enemy, allow_jumpthrough: false)
      #if y.nil?
        # No floor
        #return :redo
      #end
      #enemy.y_pos = y
      if loc.type.include?("Air") or ((loc.type.include?("Nuisance") or loc.type.include?("Seeker")) and not loc.type.include?("Floor"))
        return :redo
      end
    when "Balloon"
      if loc.type.include?("Enclosed")
        return :redo
      end
    when "Enkidu", "Spectral Sword", "Demon", "Final Knight", "Great Knight"
      if room_width == 1
        return :redo
      end
    when "Double Hammer", "Weapon Master"
      if (not ["Large Cavern", "Training Hall"].include?(target_room.zone)) and target_room.enemies.size > 1
        return :redo
      end
    when "Decarabia"
      if room_height == 1
        return :redo
      end
      enemy.var_b = rng.rand < 0.5 ? 0 : 1 # 0 = moves right, 1 = moves left
    when "Skeleton Rex", "The Creature"
      if loc.type.include?("Passthrough")
        return :redo
      end
    when "Giant Skeleton"
      enemy.var_a = 0 # Common enemy Giant Skeleton.
      enemy.var_b = 0 # Faces the player when they enter the room.
    end

    #All redos must pass before we start changing positions
    if loc.type.include?("MustMove") and (not SPAWNER_ENEMY_IDS.include?(enemy_dna.enemy_id)) and (not enemy_dna.name == "White Dragon")
      center = room_width * 0x80
      if enemy.x_pos != center
        enemy.x_pos = (enemy.x_pos + center) / 2
      else # The barrier room between Castle Entrance and Barracks
        enemy.x_pos = enemy.x_pos - 0x20
      end
    end
  end

  def fix_enemy_position(enemy)
    room_width = enemy.room.width*SCREEN_WIDTH_IN_PIXELS
    room_height = enemy.room.height*SCREEN_HEIGHT_IN_PIXELS

    if enemy.x_pos <= 0
      #puts "X IS ZERO: %02X-%02X-%02X_%02X" % [enemy.room.area_index, enemy.room.sector_index, enemy.room.room_index, enemy.room.entities.index(enemy)]
      buffer_width_from_room_edge = SCREEN_WIDTH_IN_PIXELS/2
      enemy.x_pos = rng.rand(buffer_width_from_room_edge..room_width-buffer_width_from_room_edge)
    end
    if enemy.y_pos <= 0
      #puts "Y IS ZERO: %02X-%02X-%02X_%02X" % [enemy.room.area_index, enemy.room.sector_index, enemy.room.room_index, enemy.room.entities.index(enemy)]
      buffer_height_from_room_edge = SCREEN_HEIGHT_IN_PIXELS/2
      enemy.y_pos = rng.rand(buffer_height_from_room_edge..room_height-buffer_height_from_room_edge)
    end

    enemy.x_pos = [enemy.x_pos, 0x10].max
    enemy.y_pos = [enemy.y_pos, 0x10].max

    enemy.x_pos = [enemy.x_pos, room_width-0x10].min
    enemy.y_pos = [enemy.y_pos, room_height-0x10].min

    if enemy.x_pos < 0x40
      close_to_left_door = enemy.room.doors.find{|door| door.direction == :left && door.y_pos == enemy.y_pos/SCREEN_HEIGHT_IN_PIXELS}
      if close_to_left_door
        #puts "CLOSE LEFT %02X-%02X-%02X_%02X" % [enemy.room.area_index, enemy.room.sector_index, enemy.room.room_index, enemy.room.entities.index(enemy)]
        enemy.x_pos = 0x40
      end
    elsif enemy.x_pos > room_width - 0x40
      close_to_right_door = enemy.room.doors.find{|door| door.direction == :right && door.y_pos == enemy.y_pos/SCREEN_HEIGHT_IN_PIXELS}
      if close_to_right_door
        #puts "CLOSE RIGHT %02X-%02X-%02X_%02X" % [enemy.room.area_index, enemy.room.sector_index, enemy.room.room_index, enemy.room.entities.index(enemy)]
        enemy.x_pos = room_width - 0x40
      end
    end
    if enemy.y_pos < 0x60
      close_to_up_door = enemy.room.doors.find{|door| door.direction == :up && door.x_pos == enemy.x_pos/SCREEN_WIDTH_IN_PIXELS}
      if close_to_up_door
        #puts "CLOSE UP %02X-%02X-%02X_%02X" % [enemy.room.area_index, enemy.room.sector_index, enemy.room.room_index, enemy.room.entities.index(enemy)]
        enemy.y_pos = 0x60
      end
    end
    if enemy.y_pos > room_height - 0x80
      close_to_down_door = enemy.room.doors.find{|door| door.direction == :down && door.x_pos == enemy.x_pos/SCREEN_WIDTH_IN_PIXELS}
      if close_to_down_door
        #puts "CLOSE DOWN %02X-%02X-%02X_%02X" % [enemy.room.area_index, enemy.room.sector_index, enemy.room.room_index, enemy.room.entities.index(enemy)]
        enemy.y_pos = room_height - 0x80
      end
    end

    # We either want the enemy to have a solid floor below it, or to have a jumpthrough floor which is not right at the bottom of the room.
    # No floor at all would cause some enemies to crash the game, and others to be inside the door.
    # A jumpthrough platform right at the bottom of the room would be on top of a door, and we don't want enemies on that since it would block the player.
    solid_y = coll.get_floor_y(enemy, allow_jumpthrough: false)
    jumpthrough_y = coll.get_floor_y(enemy, allow_jumpthrough: true)
    if jumpthrough_y.nil? || (solid_y.nil? && jumpthrough_y >= room_height - 0x20)
      #puts "NO FLOOR! %02X-%02X-%02X" % [enemy.room.area_index, enemy.room.sector_index, enemy.room.room_index]

      # Try to move it 4 blocks left or right, that should fix it most of the time.
      enemy.x_pos += 0x40

      solid_y = coll.get_floor_y(enemy, allow_jumpthrough: false)
      jumpthrough_y = coll.get_floor_y(enemy, allow_jumpthrough: true)
      if jumpthrough_y.nil? || (solid_y.nil? && jumpthrough_y >= room_height - 0x20)
        enemy.x_pos -= 0x80 # Try 4 blocks to the left of its original position

        solid_y = coll.get_floor_y(enemy, allow_jumpthrough: false)
        jumpthrough_y = coll.get_floor_y(enemy, allow_jumpthrough: true)
        if jumpthrough_y.nil? || (solid_y.nil? && jumpthrough_y >= room_height - 0x20)
          # If moving it left or right didn't fix it, select a random floor position in the room.
          # This code should never be run, it's not necessary for any known positions. It's just a failsafe.
          random_floor_pos = coll.all_floor_positions.sample(random: rng)
          enemy.x_pos, enemy.y_pos = random_floor_pos
        end
      end
    end
  end

  def build_initial_allowed_enemy_list_for_room(room)
    # Initialize the list of which enemies can be in this room.
    allowed_enemies_for_room = [*0x00..0x66, *0x68..0x6A]
    allowed_enemies_for_room << 0x6B # Count Giant Skeleton as a common enemy
    if room.area_index == 0
      zone_name = SECTOR_ID_TO_NAME[room.sector_index]
    else
      zone_name = AREA_ID_TO_NAME[room.area_index]
    end
    # For the room in Library that connects to Final Approach, use Final Approach's enemy pool instead of Library so that we don't have to allow Great Knight in Library.
    if room.room_str == "00-03-0B"
      zone_name = "Final Approach"
    end
    if ENEMIES_PER_ZONE.has_key?(zone_name)
      allowed_enemies_for_room.delete_if {|enemy_id| not ENEMIES_PER_ZONE[zone_name].include?(@game.enemy_dnas[enemy_id].name)}
    end

    enemies_in_room = get_common_enemies_in_room(room)
    if enemies_in_room.length >= 6
      # Don't let cpu intensive enemies in rooms that have lots of enemies.

      allowed_enemies_for_room -= @resource_intensive_enemy_ids
    end
    # Don't allow spawners in Nest of Evil/Large Cavern.
    if room.area_index == 0xC
      allowed_enemies_for_room -= SPAWNER_ENEMY_IDS
    end
    # Don't allow Blood Skeletons in Large Cavern since they can't be killed.
    if room.area_index == 0xC
      allowed_enemies_for_room -= [0x4B]
    end
    # Don't allow Mimics in Large Cavern since they can't be opened there, for some unknown reason.
    if room.area_index == 0xC
      allowed_enemies_for_room -= [0x4D]
    end

    return allowed_enemies_for_room
  end

  def build_base_list_of_assets_for_room(room)
    # Builds a list of assets that always need to be loaded for this room regardless of what the enemies are randomized into.

    assets_needed_for_room = []

    objects_in_room = room.entities.select{|e| e.is_special_object?}
    objects_in_room.each do |object|
      assets = @assets_for_each_special_object[object.subtype]
      #puts "OBJ: %02X, ASSETS: #{assets}" % object.subtype
      assets_needed_for_room += assets
      assets_needed_for_room.uniq!
    end

    return assets_needed_for_room
  end

  def extract_enemy_graphics(enemy_id)
    graphics_list_start = 0x2dda30
    asset_ptr_raw = @dra03[graphics_list_start + enemy_id*8, 1, 8]
    asset_offset = asset_ptr_raw[0..2] + [0x0]
    dra03_offset = 0x1a00
    asset_ptr = asset_offset.pack("C*").unpack("V").first - dra03_offset

    file_list_start = 0x298962
    graphics_list = []
    while @dra03[asset_ptr+8] != 0
      file_type = @dra03[asset_ptr+8]
      file_offset = @dra03[asset_ptr, 4]
      file_ptr = file_list_start + file_offset*0x30
      if file_type == 1
        graphics_list << file_ptr
      elsif file_type == 2 and @dra03[file_ptr,1,4] == [0x2f,0x6a,0x6e,0x74] #/jnt for a skeletal joint file
        graphics_list << file_ptr
      end
      asset_ptr += 0x10
    end
    return graphics_list
  end

  def extract_special_object_graphics(special_object_id)
    graphics_list_start = 0x2df280
    asset_ptr_raw = @dra03[graphics_list_start + special_object_id*8, 1, 8]
    asset_offset = asset_ptr_raw[0..2] + [0x0]
    dra03_offset = 0x1a00
    asset_ptr = asset_offset.pack("C*").unpack("V").first - dra03_offset

    file_list_start = 0x298962
    graphics_list = []
    while @dra03[asset_ptr+8] != 0
      file_type = @dra03[asset_ptr+8]
      file_offset = @dra03[asset_ptr, 4]
      file_ptr = file_list_start + file_offset*0x30
      if file_type == 1
        graphics_list << file_ptr
      end
      asset_ptr += 0x10
    end
    return graphics_list
  end
end