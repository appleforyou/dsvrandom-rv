module Locations
require_relative 'ooe_logic'

  attr_reader :locs

  def self.set_logic(obj)
    @logic = obj
  end

  def self.locs
    locs = [
    #Dracula's Castle
    #Castle Entrance
      {
        zone: "Dracula's Castle",
        subzone: "Castle Entrance",
        name: "HEART Max Up",
        type: ["Item", "Powerup"],
        container: "Chest",
        id: "00-00-01_00",
        room: "Castle Entrance (Lobby)",
        available: lambda { @logic.castleEntry() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Castle Entrance",
        name: "Tasty Meat",
        type: ["Item", "Consumable"],
        container: "Wall",
        id: "00-00-03_01",
        room: "Castle Entrance (Tasty Stairs)",
        available: lambda { @logic.castleEntry() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Castle Entrance",
        name: "White Drops",
        type: ["Item", "Consumable"],
        container: "Chest",
        id: "00-00-04_01",
        room: "Castle Entrance (Left Fork)",
        available: lambda { @logic.castleEntry() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Castle Entrance",
        name: "HP Max Up",
        type: ["Item", "Powerup"],
        container: "Chest",
        id: "00-00-09_00",
        room: "Castle Entrance (Right Fork)",
        available: lambda { @logic.castleEntranceEast() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Castle Entrance",
        name: "Valkyrie Greaves",
        type: ["Item", "Equipment", "Boots"],
        container: "Chest",
        id: "00-01-05_00",
        room: "Castle Entrance (Valkyrie Greaves Room)",
        available: lambda { @logic.castleEntranceEast() }
      },
    #Underground Labyrinth
      {
        zone: "Dracula's Castle",
        subzone: "Underground Labyrinth",
        name: "Vol Ignis",
        type: ["Glyph", "Damage", "Event"],
        container: "Visible",
        id: "00-02-02_00",
        room: "Underground Labyrinth (Vol Ignis Gauntlet)",
        available: lambda { @logic.castleEntranceEast() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Underground Labyrinth",
        name: "Mercury Boots",
        type: ["Item", "Equipment", "Boots"],
        container: "Chest",
        id: "00-02-06_00",
        room: "Underground Labyrinth (Second Fork Attic)",
        available: lambda { @logic.castleEntranceEast() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Underground Labyrinth",
        name: "MP Max Up",
        type: ["Item", "Powerup"],
        container: "Chest",
        id: "00-02-08_00",
        room: "Underground Labyrinth (Second Fork South)",
        available: lambda { @logic.castleEntranceEast() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Underground Labyrinth",
        name: "White Drops",
        type: ["Item", "Consumable"],
        container: "Wall",
        id: "00-02-11_06",
        room: "Underground Labyrinth (Nova Skeleton Cubby)",
        available: lambda { @logic.beatBlackmore() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Underground Labyrinth",
        name: "Lapiste",
        type: ["Glyph", "Damage", "Event"],
        container: "Visible",
        id: "00-02-14_04",
        room: "Underground Labyrinth (Boulder Stairs)",
        available: lambda { @logic.beatBlackmore() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Underground Labyrinth",
        name: "Star Ring",
        type: ["Item", "Equipment", "Ring"],
        container: "Secret",
        id: "00-02-14_05",
        room: "Underground Labyrinth (Boulder Stairs)",
        available: lambda { @logic.beatBlackmore() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Underground Labyrinth",
        name: "HEART Max Up",
        type: ["Item", "Powerup"],
        container: "Chest",
        id: "00-02-17_00",
        room: "Underground Labyrinth (Basement Dead End)",
        available: lambda { @logic.beatBlackmore() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Underground Labyrinth",
        name: "Super Potion",
        type: ["Item", "Consumable"],
        container: "Chest",
        id: "00-02-18_00",
        room: "Underground Labyrinth (Basement Potion Room)",
        available: lambda { @logic.beatBlackmore() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Underground Labyrinth",
        name: "Felicem Fio",
        type: ["Glyph"],
        container: "Statue",
        id: "00-02-19_06",
        room: "Underground Labyrinth (Basement Midway)",
        available: lambda { @logic.beatBlackmore() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Underground Labyrinth",
        name: "Rapidus Fio",
        type: ["Glyph"],
        container: "Statue",
        id: "00-02-1B_01",
        room: "Underground Labyrinth (Basement Exit)",
        available: lambda { @logic.beatBlackmore() }
      },
    #Library
      {
        zone: "Dracula's Castle",
        subzone: "Library",
        name: "HP Max Up",
        type: ["Item", "Powerup"],
        container: "Chest",
        id: "00-03-02_00",
        room: "Library (First Bend)",
        available: lambda { @logic.castleEntry() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Library",
        name: "MP Max Up",
        type: ["Item", "Powerup"],
        container: "Chest",
        id: "00-03-07_00",
        room: "Library (Pre-Wallman)",
        available: lambda { @logic.castleEntry() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Library",
        name: "Paries",
        type: ["Glyph"],
        container: "Spell",
        id: "00-03-09_02",
        room: "Library (Wallman's Room)",
        available: lambda { @logic.castleEntry() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Library",
        name: "Melio Confodere",
        type: ["Glyph", "Damage"],
        container: "Statue",
        id: "00-03-09_05",
        room: "Library (Wallman's Room)",
        available: lambda { @logic.castleEntranceEast() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Library",
        name: "Refectio",
        type: ["Glyph"],
        container: "Statue",
        id: "00-04-02_00",
        room: "Library (Hidden Room)",
        available: lambda { @logic.castleEntranceEast() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Library",
        name: "Hanged Man Ring",
        type: ["Item", "Equipment", "Ring"],
        container: "Chest",
        id: "00-04-02_01",
        room: "Library (Hidden Room)",
        available: lambda { @logic.castleEntranceEast() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Library",
        name: "Cream Puff",
        type: ["Item", "Consumable"],
        container: "Wall",
        id: "00-04-07_03",
        room: "Library (Last Bend)",
        available: lambda { @logic.castleEntranceEast() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Library",
        name: "Dextro Custos",
        type: ["Glyph", "Damage", "Event"],
        container: "Visible",
        id: "00-04-08_00",
        room: "Library (Custos Room)",
        available: lambda { @logic.castleEntranceEast() }
      },
    #Barracks
      {
        zone: "Dracula's Castle",
        subzone: "Barracks",
        name: "HEART Max Up",
        type: ["Item", "Powerup"],
        container: "Chest",
        id: "00-05-00_00",
        room: "Barracks (Heart Room)",
        available: lambda { @logic.beatBlackmore() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Barracks",
        name: "Melio Hasta",
        type: ["Glyph", "Damage"],
        container: "Statue",
        id: "00-05-04_02",
        room: "Barracks (Lobby)",
        available: lambda { @logic.beatBlackmore() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Barracks",
        name: "$2000",
        type: ["Item", "Other"],
        container: "Visible",
        id: "00-05-07_01",
        room: "Barracks (Other Room)",
        available: lambda { @logic.beatBlackmore() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Barracks",
        name: "$2000",
        type: ["Item", "Other"],
        container: "Visible",
        id: "00-05-07_02",
        room: "Barracks (Other Room)",
        available: lambda { @logic.beatBlackmore() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Barracks",
        name: "Green Drops",
        type: ["Item", "Consumable"],
        container: "Secret",
        id: "00-05-08_02",
        room: "Barracks (Dead End)",
        available: lambda { @logic.beatBlackmore() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Barracks",
        name: "$2000",
        type: ["Item", "Other"],
        container: "Visible",
        id: "00-05-08_03",
        room: "Barracks (Dead End)",
        available: lambda { @logic.beatBlackmore() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Barracks",
        name: "Green Drops",
        type: ["Item", "Consumable"],
        container: "Wall",
        id: "00-05-09_02",
        room: "Barracks (Descending Stairs Top)",
        available: lambda { @logic.beatBlackmore() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Barracks",
        name: "MP Max Up",
        type: ["Item", "Powerup"],
        container: "Chest",
        id: "00-05-0A_00",
        room: "Barracks (Descending Stairs Bottom)",
        available: lambda { @logic.beatBlackmore() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Barracks",
        name: "Red Drops",
        type: ["Item", "Consumable"],
        container: "Secret",
        id: "00-05-0C_01",
        room: "Barracks (Red Drops Room)",
        available: lambda { @logic.beatBlackmore() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Barracks",
        name: "Moon Ring",
        type: ["Item", "Equipment", "Ring"],
        container: "Chest",
        id: "00-05-0D_00",
        room: "Barracks (Moon Ring Room)",
        available: lambda { @logic.beatBlackmore() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Barracks",
        name: "Valkyrie Mail",
        type: ["Item", "Equipment", "Body"],
        container: "Chest",
        id: "00-05-0E_00",
        room: "Barracks (Valkyrie Mail Room)",
        available: lambda { @logic.beatBlackmore() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Barracks",
        name: "HP Max Up",
        type: ["Item", "Powerup"],
        container: "Chest",
        id: "00-05-0F_00",
        room: "Barracks (HP Room)",
        available: lambda { @logic.beatBlackmore() }
      },
    #Mechanical Tower
      {
        zone: "Dracula's Castle",
        subzone: "Mechanical Tower",
        name: "Valkyrie Mask",
        type: ["Item", "Equipment", "Head"],
        container: "Chest",
        id: "00-06-09_00",
        room: "Mechanical Tower (Triple Chamber)",
        available: lambda { @logic.mechTower() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Mechanical Tower",
        name: "Heart Cuirass",
        type: ["Item", "Equipment", "Body"],
        container: "Chest",
        id: "00-06-0E_00",
        room: "Mechanical Tower (Spike Fork)",
        available: lambda { @logic.mechTower() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Mechanical Tower",
        name: "HP Max Up",
        type: ["Item", "Powerup"],
        container: "Wall",
        id: "00-06-0E_03",
        room: "Mechanical Tower (Spike Fork)",
        available: lambda { @logic.mechTower() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Mechanical Tower",
        name: "Sinestro Custos",
        type: ["Glyph", "Damage", "Event"],
        container: "Visible",
        id: "00-06-15_01",
        room: "Mechanical Tower (Custos Room)",
        available: lambda { @logic.beatDeath() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Mechanical Tower",
        name: "Death Ring",
        type: ["Item", "Equipment", "Ring"],
        container: "Chest",
        id: "00-06-1B_00",
        room: "Mechanical Tower (Death Ring Room)",
        available: lambda { @logic.mechTower() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Mechanical Tower",
        name: "Morbus",
        type: ["Glyph", "Damage", "Event"],
        container: "Visible",
        id: "00-06-1C_01",
        room: "Mechanical Tower (Electric Room)",
        available: lambda { @logic.fulgurPuzzle() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Mechanical Tower",
        name: "Vis Fio",
        type: ["Glyph"],
        container: "Statue",
        id: "00-07-02_00",
        room: "Mechanical Tower (Hub Room)",
        available: lambda { @logic.beatBlackmore() }
      },
    #Arms Depot
      {
        zone: "Dracula's Castle",
        subzone: "Arms Depot",
        name: "HP Max Up",
        type: ["Item", "Powerup"],
        container: "Chest",
        id: "00-08-00_00",
        room: "Arms Depot (HP Room)",
        available: lambda { @logic.armsDepot() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Arms Depot",
        name: "Melio Falcis",
        type: ["Glyph", "Damage"],
        container: "Statue",
        id: "00-08-05_00",
        room: "Arms Depot (Northwest Corridor)",
        available: lambda { @logic.armsDepot() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Arms Depot",
        name: "Melio Culter",
        type: ["Glyph", "Damage"],
        container: "Statue",
        id: "00-08-07_00",
        room: "Arms Depot (Northeast Corridor)",
        available: lambda { @logic.armsDepot() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Arms Depot",
        name: "Melio Scutum",
        type: ["Glyph"],
        container: "Statue",
        id: "00-08-08_00",
        room: "Arms Depot (Northeast Alcove)",
        available: lambda { @logic.armsDepot() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Arms Depot",
        name: "Mint Sundae",
        type: ["Item", "Consumable"],
        container: "Wall",
        id: "00-08-0C_02",
        room: "Arms Depot (Pre-Eligor)",
        available: lambda { @logic.armsDepot() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Arms Depot",
        name: "Arma Custos",
        type: ["Glyph", "Event"],
        container: "Visible",
        id: "00-08-0F_00",
        room: "Arms Depot (Custos Room)",
        available: lambda { @logic.beatEligor() }
      },
    #Forsaken Cloister
      {
        zone: "Dracula's Castle",
        subzone: "Forsaken Cloister",
        name: "Eisbein",
        type: ["Item", "Consumable"],
        container: "Wall",
        id: "00-09-01_02",
        room: "Forsaken Cloister (Custos Stairs)",
        available: lambda { @logic.finalApproach() }
      },
    #Final Approach
      {
        zone: "Dracula's Castle",
        subzone: "Final Approach",
        name: "Sun Ring",
        type: ["Item", "Equipment", "Ring"],
        container: "Chest",
        id: "00-0A-02_00",
        room: "Final Approach (Volaticus Attic)",
        available: lambda { @logic.volaticusAttic() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Final Approach",
        name: "Blue Drops",
        type: ["Item", "Consumable"],
        container: "Chest",
        id: "00-0A-02_01",
        room: "Final Approach (Volaticus Attic)",
        available: lambda { @logic.volaticusAttic() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Final Approach",
        name: "MP Max Up",
        type: ["Item", "Powerup"],
        container: "Chest",
        id: "00-0A-02_02",
        room: "Final Approach (Volaticus Attic)",
        available: lambda { @logic.volaticusAttic() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Final Approach",
        name: "HEART Max Up",
        type: ["Item", "Powerup"],
        container: "Chest",
        id: "00-0A-02_03",
        room: "Final Approach (Volaticus Attic)",
        available: lambda { @logic.volaticusAttic() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Final Approach",
        name: "Volaticus",
        type: ["Glyph"],
        container: "Statue",
        id: "00-0A-03_00",
        room: "Final Approach (Volaticus Courtyard)",
        available: lambda { @logic.finalApproach() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Final Approach",
        name: "MP Max Up",
        type: ["Item", "Powerup"],
        container: "Chest",
        id: "00-0A-03_02",
        room: "Final Approach (Volaticus Courtyard)",
        available: lambda { @logic.finalApproach() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Final Approach",
        name: "HEART Max Up",
        type: ["Item", "Powerup"],
        container: "Chest",
        id: "00-0A-08_00",
        room: "Final Approach (Hub Heart Room)",
        available: lambda { @logic.finalApproach() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Final Approach",
        name: "Gold Ore",
        type: ["Item", "Other"],
        container: "Chest",
        id: "00-0A-0B_00",
        room: "Final Approach (Hub Attic)",
        available: lambda { @logic.volaticusAttic() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Final Approach",
        name: "Diamond",
        type: ["Item", "Other"],
        container: "Chest",
        id: "00-0A-0B_01",
        room: "Final Approach (Hub Attic)",
        available: lambda { @logic.volaticusAttic() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Final Approach",
        name: "Diamond",
        type: ["Item", "Other"],
        container: "Chest",
        id: "00-0A-0B_02",
        room: "Final Approach (Hub Attic)",
        available: lambda { @logic.volaticusAttic() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Final Approach",
        name: "Onyx",
        type: ["Item", "Other"],
        container: "Chest",
        id: "00-0A-0B_03",
        room: "Final Approach (Hub Attic)",
        available: lambda { @logic.volaticusAttic() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Final Approach",
        name: "World Ring",
        type: ["Item", "Equipment", "Ring"],
        container: "Chest",
        id: "00-0A-0B_04",
        room: "Final Approach (Hub Attic)",
        available: lambda { @logic.volaticusAttic() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Final Approach",
        name: "Judgement Ring",
        type: ["Item", "Equipment", "Ring"],
        container: "Wall",
        id: "00-0A-0C_02",
        room: "Final Approach (Hub Room)",
        available: lambda { @logic.finalApproach() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Final Approach",
        name: "Super Potion",
        type: ["Item", "Consumable"],
        container: "Chest",
        id: "00-0B-02_07",
        room: "Final Approach (Final Stairs)",
        available: lambda { @logic.finalApproach() }
      },
      {
        zone: "Dracula's Castle",
        subzone: "Final Approach",
        name: "MP Max Up",
        type: ["Item", "Powerup"],
        container: "Chest",
        id: "00-0B-02_08",
        room: "Final Approach (Final Stairs)",
        available: lambda { @logic.finalApproach() }
      },
        
    #Ecclesia
      {
        zone: "Ecclesia",
        name: "Record 5",
        type: ["Item", "Other"],
        container: "Chest",
        id: "02-00-00_04",
        room: "Ecclesia (Tutorial Start)",
        available: lambda { return true }
      },
      {
        zone: "Ecclesia",
        name: "Record 1",
        type: ["Item", "Other"],
        container: "Secret",
        id: "02-00-04_05",
        room: "Ecclesia (Hub)",
        available: lambda { return true }
      },
    #Training Hall  
      {
        zone: "Training Hall",
        name: "Redire",
        type: ["Glyph","Damage"],
        container: "Statue",
        id: "03-00-01_01",
        room: "Training Hall Ending",
        available: lambda { @logic.trainingHall() }
      },
    #Ruvas Forest
      {
        zone: "Ruvas Forest",
        name: "Macir",
        type: ["Glyph", "Damage"],
        container: "Statue",
        id: "04-00-01_00",
        room: "Ruvas Forest (Macir Statue)",
        available: lambda { return true }
      },
    #Kalidus Channel  
      {
        zone: "Kalidus Channel",
        name: "HEART Max Up",
        type: ["Item", "Powerup"],
        container: "Chest",
        id: "06-00-01_00",
        room: "Kalidus Channel (Shallows Far Left)",
        available: lambda { @logic.underwater() }
      },
      {
        zone: "Kalidus Channel",
        name: "Chamomile",
        type: ["Item", "Consumable"],
        container: "Chest",
        id: "06-00-02_00",
        room: "Kalidus Channel (Shallows Mid Left)",
        available: lambda { @logic.underwater() }
      },
      {
        zone: "Kalidus Channel",
        name: "Jacob",
        type: ["Villager"],
        container: "Visible",
        id: "06-00-04_00",
        room: "Kalidus Channel (Surface Tunnel)",
        available: lambda { return true }
      },
      {
        zone: "Kalidus Channel",
        name: "Magical Ticket",
        type: ["Item", "Consumable"],
        container: "Visible",
        id: "06-00-04_01",
        room: "Kalidus Channel (Surface Tunnel)",
        available: lambda { return true }
      },
      {
        zone: "Kalidus Channel",
        name: "MP Max Up",
        type: ["Item", "Powerup"],
        container: "Chest",
        id: "06-00-07_00",
        room: "Kalidus Channel (Shallows Mid Right)",
        available: lambda { @logic.underwater() }
      },
      {
        zone: "Kalidus Channel",
        name: "Twinbee",
        type: ["Item", "Other"],
        container: "Wall",
        id: "06-00-07_04",
        room: "Kalidus Channel (Shallows Mid Right)",
        available: lambda { return true }
      },
      {
        zone: "Kalidus Channel",
        name: "HP Max Up",
        type: ["Item", "Powerup"],
        container: "Chest",
        id: "06-00-09_00",
        room: "Kalidus Channel (Shallows Far Right)",
        available: lambda { @logic.underwater() }
      },
      {
        zone: "Kalidus Channel",
        name: "Fortis Fio",
        type: ["Glyph"],
        container: "Statue",
        id: "06-00-0D_01",
        room: "Kalidus Depths (West Pre-Balloon)",
        available: lambda { @logic.kalidusDepths() }
      },
      {
        zone: "Kalidus Channel",
        name: "Scutum",
        type: ["Glyph"],
        container: "Statue",
        id: "06-00-10_00",
        room: "Kalidus Depths (Scutum Room)",
        available: lambda { @logic.kalidusDepths() }
      },
      {
        zone: "Kalidus Channel",
        name: "Super Potion",
        type: ["Item","Consumable"],
        container: "Chest",
        id: "06-00-15_00",
        room: "Kalidus Depths (East Balloon)",
        available: lambda { @logic.kalidusDepths() }
      },
      {
        zone: "Kalidus Channel",
        name: "MP Max Up",
        type: ["Item","Powerup"],
        container: "Chest",
        id: "06-00-15_01",
        room: "Kalidus Depths (East Balloon)",
        available: lambda { @logic.kalidusDepths() }
      },
      {
        zone: "Kalidus Channel",
        name: "HEART Max Up",
        type: ["Item","Powerup"],
        container: "Chest",
        id: "06-00-15_02",
        room: "Kalidus Depths (East Balloon)",
        available: lambda { @logic.kalidusDepths() }
      },
      {
        zone: "Kalidus Channel",
        name: "Sapphire",
        type: ["Item","Other"],
        container: "Chest",
        id: "06-00-17_00",
        room: "Kalidus Depths (East Bone Tower)",
        available: lambda { @logic.kalidusDepths() }
      },
      {
        zone: "Kalidus Channel",
        name: "HP Max Up",
        type: ["Item","Powerup"],
        container: "Chest",
        id: "06-00-18_00",
        room: "Kalidus Depths (East HP Room)",
        available: lambda { @logic.kalidusDepths() }
      },
      {
        zone: "Kalidus Channel",
        name: "HEART Max Up",
        type: ["Item","Powerup"],
        container: "Chest",
        id: "06-00-1A_00",
        room: "Kalidus Depths (Anti-Venom Room)",
        available: lambda { @logic.kalidusDepths() }
      },
      {
        zone: "Kalidus Channel",
        name: "Anti-Venom",
        type: ["Item","Consumable"],
        container: "Chest",
        id: "06-00-1A_02",
        room: "Kalidus Depths (Anti-Venom Room)",
        available: lambda { @logic.kalidusDepths() }
      },
      {
        zone: "Kalidus Channel",
        name: "Iron Ore",
        type: ["Item","Other"],
        container: "Chest",
        id: "06-01-01_00",
        room: "Kalidus Depths (Southwest Lobby)",
        available: lambda { @logic.kalidusDepths() }
      },
      {
        zone: "Kalidus Channel",
        name: "Magician Ring",
        type: ["Item","Equipment","Ring"],
        container: "Chest",
        id: "06-01-04_01",
        room: "Kalidus Depths (Ship)",
        available: lambda { @logic.kalidusDepths() }
      },
      {
        zone: "Kalidus Channel",
        name: "Emerald",
        type: ["Item","Other"],
        container: "Visible",
        id: "06-01-04_02",
        room: "Kalidus Depths (Ship)",
        available: lambda { @logic.kalidusDepths() }
      },
      {
        zone: "Kalidus Channel",
        name: "MP Max Up",
        type: ["Item","Powerup"],
        container: "Chest",
        id: "06-01-04_03",
        room: "Kalidus Depths (Ship)",
        available: lambda { @logic.kalidusDepths() }
      },
      {
        zone: "Kalidus Channel",
        name: "$1000",
        type: ["Item","Other"],
        container: "Visible",
        id: "06-01-04_04",
        room: "Kalidus Depths (Ship)",
        available: lambda { @logic.kalidusDepths() }
      },
      {
        zone: "Kalidus Channel",
        name: "$1000",
        type: ["Item","Other"],
        container: "Visible",
        id: "06-01-04_05",
        room: "Kalidus Depths (Ship)",
        available: lambda { @logic.kalidusDepths() }
      },
      {
        zone: "Kalidus Channel",
        name: "$1000",
        type: ["Item","Other"],
        container: "Visible",
        id: "06-01-04_06",
        room: "Kalidus Depths (Ship)",
        available: lambda { @logic.kalidusDepths() }
      },
      {
        zone: "Kalidus Channel",
        name: "Monica",
        type: ["Villager"],
        container: "Visible",
        id: "06-01-05_00",
        room: "Kalidus Depths (Ship Villager)",
        available: lambda { @logic.kalidusDepths() }
      },
      {
        zone: "Kalidus Channel",
        name: "Potion",
        type: ["Item","Consumable"],
        container: "Chest",
        id: "06-01-07_00",
        room: "Kalidus Depths (Southeast Lobby)",
        available: lambda { @logic.kalidusDepths() }
      },
    #Somnus Reef
      {
        zone: "Somnus Reef",
        name: "$2000",
        type: ["Item","Other"],
        container: "Visible",
        id: "07-00-04_02",
        room: "Somnus Reef (Entry Shaft)",
        available: lambda { @logic.kalidusDepths() }
      },
      {
        zone: "Somnus Reef",
        name: "Anna",
        type: ["Villager"],
        container: "Visible",
        id: "07-00-06_01",
        room: "Somnus Reef (Anna's Room)",
        available: lambda { @logic.kalidusDepths() }
      },
      {
        zone: "Somnus Reef",
        name: "ReinForced Suit",
        type: ["Item", "Equipment", "Body"],
        container: "Chest",
        id: "07-00-07_00",
        room: "Somnus Reef (Starfish Room)",
        available: lambda { @logic.kalidusDepths() }
      },
      {
        zone: "Somnus Reef",
        name: "Vol Arcus",
        type: ["Glyph","Damage"],
        container: "Statue",
        id: "07-00-09_01",
        room: "Somnus Reef (Fish Tank)",
        available: lambda { @logic.kalidusDepths() }
      },
      {
        zone: "Somnus Reef",
        name: "MP Max Up",
        type: ["Item", "Powerup"],
        container: "Chest",
        id: "07-00-09_02",
        room: "Somnus Reef (Fish Tank)",
        available: lambda { @logic.kalidusDepths() }
      },
      {
        zone: "Somnus Reef",
        name: "Vic Viper",
        type: ["Item", "Other"],
        container: "Wall",
        id: "07-00-0A_01",
        room: "Somnus Reef (Serge's Room)",
        available: lambda { @logic.kalidusDepths() }
      },
      {
        zone: "Somnus Reef",
        name: "Serge",
        type: ["Villager"],
        container: "Visible",
        id: "07-00-0A_02",
        room: "Somnus Reef (Serge's Room)",
        available: lambda { @logic.kalidusDepths() }
      },
      {
        zone: "Somnus Reef",
        name: "Vol Ascia",
        type: ["Glyph","Damage"],
        container: "Statue",
        id: "07-00-0D_01",
        room: "Somnus Reef (Northeast Shallows)",
        available: lambda { @logic.kalidusDepths() }
      },
      {
        zone: "Somnus Reef",
        name: "HEART Max Up",
        type: ["Item", "Powerup"],
        container: "Chest",
        id: "07-00-12_01",
        room: "Somnus Reef (Ghost Hearts)",
        available: lambda { @logic.kalidusDepths() }
      },
      {
        zone: "Somnus Reef",
        name: "HP Max Up",
        type: ["Item", "Powerup"],
        container: "Chest",
        id: "07-00-14_00",
        room: "Somnus Reef (East HP Room)",
        available: lambda { @logic.kalidusDepths() }
      },
      {
        zone: "Somnus Reef",
        name: "HP Max Up",
        type: ["Item", "Powerup"],
        container: "Chest",
        id: "07-00-14_00",
        room: "Somnus Reef (East HP Room)",
        available: lambda { @logic.kalidusDepths() }
      },
    #Minera Prison Island  
      {
        zone: "Minera Prison Island",
        name: "$500",
        type: ["Item", "Other"],
        container: "Visible",
        id: "08-00-05_01",
        room: "Minera Island (West Lobby)",
        available: lambda { @logic.beatGiantSkeleton() }
      },
      {
        zone: "Minera Prison Island",
        name: "MP Max Up",
        type: ["Item", "Powerup"],
        container: "Chest",
        id: "08-00-07_00",
        room: "Minera Island (Southwest Loop)",
        available: lambda { @logic.beatGiantSkeleton() }
      },
      {
        zone: "Minera Prison Island",
        name: "Cabriolet",
        type: ["Item", "Equipment", "Head"],
        container: "Chest",
        id: "08-00-07_02",
        room: "Minera Island (Southwest Loop)",
        available: lambda { @logic.beatGiantSkeleton() }
      },
      {
        zone: "Minera Prison Island",
        name: "Priestess Ring",
        type: ["Item", "Equipment", "Ring"],
        container: "Chest",
        id: "08-00-09_00",
        room: "Minera Island (Hidden Room)",
        available: lambda { @logic.beatGiantSkeleton() }
      },
      {
        zone: "Minera Prison Island",
        name: "Tower Ring",
        type: ["Item", "Equipment", "Ring"],
        container: "Chest",
        id: "08-01-01_00",
        room: "Minera Island (Tower Top)",
        available: lambda { @logic.mineraTower() }
      },
      {
        zone: "Minera Prison Island",
        name: "Aeon",
        type: ["Villager"],
        container: "Visible",
        id: "08-01-01_01",
        room: "Minera Island (Tower Top)",
        available: lambda { @logic.mineraTower()  }
      },
      {
        zone: "Minera Prison Island",
        name: "Anti-Venom",
        type: ["Item", "Consumable"],
        container: "Chest",
        id: "08-01-02_00",
        room: "Minera Island (Tower Bottom)",
        available: lambda { @logic.beatGiantSkeleton() }
      },
      {
        zone: "Minera Prison Island",
        name: "HP Max Up",
        type: ["Item", "Powerup"],
        container: "Chest",
        id: "08-01-05_00",
        room: "Minera Island (West Invisible Man)",
        available: lambda { @logic.beatGiantSkeleton() }
      },
      {
        zone: "Minera Prison Island",
        name: "Dominus Hatred",
        type: ["Glyph", "Damage", "Event"],
        container: "Visible",
        id: "08-01-07_00",
        room: "Minera Island (Albus Room)",
        available: lambda { @logic.beatGiantSkeleton() }
      },
      {
        zone: "Minera Prison Island",
        name: "$500",
        type: ["Item", "Other"],
        container: "Visible",
        id: "08-01-08_00",
        room: "Minera Island (Iron Maidens)",
        available: lambda { @logic.beatGiantSkeleton() }
      },
      {
        zone: "Minera Prison Island",
        name: "Abram",
        type: ["Villager"],
        container: "Visible",
        id: "08-01-09_00",
        room: "Minera Island (Abram's Room)",
        available: lambda { @logic.beatGiantSkeleton() }
      },
      {
        zone: "Minera Prison Island",
        name: "HEART Max Up",
        type: ["Item", "Powerup"],
        container: "Chest",
        id: "08-02-00_00",
        room: "Minera Island (Magnes Jump)",
        available: lambda { @logic.mineraEnd() }
      },
      {
        zone: "Minera Prison Island",
        name: "Konami Man",
        type: ["Item", "Other"],
        container: "Wall",
        id: "08-02-00_02",
        room: "Minera Island (Magnes Jump)",
        available: lambda { @logic.mineraEnd() }
      },
      {
        zone: "Minera Prison Island",
        name: "Vol Fulgur",
        type: ["Glyph", "Damage", "Event"],
        container: "Visible",
        id: "08-02-03_00",
        room: "Minera Island (Electric Corridor)",
        available: lambda { @logic.mineraEnd() }
      },
      {
        zone: "Minera Prison Island",
        name: "Falcis",
        type: ["Glyph", "Damage"],
        container: "Statue",
        id: "08-02-05_00",
        room: "Minera Island (East Lobby)",
        available: lambda { @logic.mineraEnd() }
      },
      {
        zone: "Minera Prison Island",
        name: "Strength Ring",
        type: ["Item", "Equipment", "Ring", "No Progression"],
        container: "Secret",
        id: "08-02-06_01",
        room: "Minera Island (Robot Plaza)",
        available: lambda { @logic.mineraEnd() }
      },
      {
        zone: "Minera Prison Island",
        name: "Glyph Sleeve",
        type: ["Item", "Relic"],
        container: "Chest",
        id: "08-02-07_02",
        room: "Minera Island (Exit)",
        available: lambda { @logic.mineraEnd() }
      },
    #Lighthouse
      {
        zone: "Lighthouse",
        name: "Luminatio",
        type: ["Glyph", "Damage"],
        container: "Visible",
        id: "09-00-03_00",
        room: "Lighthouse (Top)",
        available: lambda { @logic.beatCrab() }
      },
      {
        zone: "Lighthouse",
        name: "Eugen",
        type: ["Villager"],
        container: "Visible",
        id: "09-00-06_00",
        room: "Lighthouse (Eugen's Room)",
        available: lambda { @logic.beatCrab() }
      },
      {
        zone: "Lighthouse",
        name: "Serpent Scale",
        type: ["Item", "Relic"],
        container: "Chest",
        id: "09-00-07_01",
        room: "Lighthouse (Exit)",
        available: lambda { @logic.beatCrab() }
      },
    #Tymeo Mountains  
      {
        zone: "Tymeo Mountains",
        name: "Blue Drops",
        type: ["Item", "Consumable"],
        container: "Secret",
        id: "0A-00-00_02",
        room: "Tymeo Mountains (Entrance)",
        available: lambda { return true }
      },
      {
        zone: "Tymeo Mountains",
        name: "Laura",
        type: ["Villager"],
        container: "Visible",
        id: "0A-00-05_00",
        room: "Tymeo Mountains (Laura)",
        available: lambda { @logic.tymeoMidway() }
      },
      {
        zone: "Tymeo Mountains",
        name: "Fides Fio",
        type: ["Glyph"],
        container: "Statue",
        id: "0A-00-09_00",
        room: "Tymeo Mountains (Northwest Underground)",
        available: lambda { @logic.tymeoMidway() }
      },
      {
        zone: "Tymeo Mountains",
        name: "MP Max Up",
        type: ["Item", "Powerup"],
        container: "Statue",
        id: "0A-00-09_01",
        room: "Tymeo Mountains (Northwest Underground)",
        available: lambda { @logic.tymeoMidway() }
      },
      {
        zone: "Tymeo Mountains",
        name: "Crimson Mask",
        type: ["Item", "Equipment", "Head"],
        container: "Chest",
        id: "0A-00-0C_00",
        room: "Tymeo Mountains (Paries Underground)",
        available: lambda { @logic.tymeoEast() }
      },
      {
        zone: "Tymeo Mountains",
        name: "Moonwalkers",
        type: ["Item", "Equipment", "Boots"],
        container: "Chest",
        id: "0A-00-0C_01",
        room: "Tymeo Mountains (Paries Undergroun)",
        available: lambda { @logic.tymeoParies() }
      },
      {
        zone: "Tymeo Mountains",
        name: "Devil Ring",
        type: ["Item", "Equipment", "Ring"],
        container: "Chest",
        id: "0A-00-0C_02",
        room: "Tymeo Mountains (Paries Undergroun)",
        available: lambda { @logic.tymeoParies() }
      },
      {
        zone: "Tymeo Mountains",
        name: "HEART Max Up",
        type: ["Item", "Powerup"],
        container: "Chest",
        id: "0A-00-10_00",
        room: "Tymeo Mountains (Mid Underground)",
        available: lambda { @logic.tymeoEast() }
      },
      {
        zone: "Tymeo Mountains",
        name: "Emperor Ring",
        type: ["Item", "Equipment", "Ring"],
        container: "Secret",
        id: "0A-00-11_00",
        room: "Tymeo Mountains (East Underground)",
        available: lambda { @logic.tymeoEast() }
      },
      {
        zone: "Tymeo Mountains",
        name: "Marcel",
        type: ["Villager"],
        container: "Visible",
        id: "0A-00-13_01",
        room: "Tymeo Mountains (Exit)",
        available: lambda { @logic.tymeoEast() }
      },
      {
        zone: "Tymeo Mountains",
        name: "Mushroom",
        type: ["Item", "Consumable"],
        container: "Visible",
        id: "0A-01-01_01",
        room: "Tymeo Mountains (Spider Ascent)",
        available: lambda { return true }
      },
      {
        zone: "Tymeo Mountains",
        name: "Empress Ring",
        type: ["Item", "Equipment", "Ring"],
        container: "Visible",
        id: "0A-01-03_00",
        room: "Tymeo Mountains (Empress Ring Room)",
        available: lambda { return true }
      },
      {
        zone: "Tymeo Mountains",
        name: "HP Max Up",
        type: ["Item", "Powerup"],
        container: "Chest",
        id: "0A-01-08_00",
        room: "Tymeo Mountains (Spider Descent)",
        available: lambda { @logic.tymeoEast() }
      },
      {
        zone: "Tymeo Mountains",
        name: "Ruby",
        type: ["Item", "Other"],
        container: "Wall",
        id: "0A-01-08_03",
        room: "Tymeo Mountains (Spider Descent)",
        available: lambda { @logic.tymeoEast() }
      },
      {
        zone: "Tymeo Mountains",
        name: "Pneuma",
        type: ["Glyph", "Damage", "Event"],
        container: "Visible",
        id: "0A-01-09_00",
        room: "Tymeo Mountains (Wind Room)",
        available: lambda { @logic.pneumaPuzzle() }
      },
    #Tristis Pass  
      {
        zone: "Tristis Pass",
        name: "Vol Hasta",
        type: ["Glyph", "Damage"],
        container: "Statue",
        id: "0B-00-0D_00",
        room: "Tristis Pass (Demon Room)",
        available: lambda { @logic.tristisWaterfall() }
      },
      {
        zone: "Tristis Pass",
        name: "Chariot Ring",
        type: ["Item", "Equip", "Ring"],
        container: "Chest",
        id: "0B-00-0D_01",
        room: "Tristis Pass (Demon Slope)",
        available: lambda { @logic.tristisWaterfall() }
      },
      {
        zone: "Tristis Pass",
        name: "Inire Pecunia",
        type: ["Glyph"],
        container: "Statue",
        id: "0B-00-0F_00",
        room: "Tristis Pass (Exit Slope)",
        available: lambda { @logic.tristisWaterfall() }
      },
      {
        zone: "Tristis Pass",
        name: "Body Suit",
        type: ["Item", "Equip", "Body"],
        container: "Chest",
        id: "0B-00-0F_01",
        room: "Tristis Pass (Exit Slope)",
        available: lambda { @logic.tristisWaterfall() }
      },
      {
        zone: "Tristis Pass",
        name: "MP Max Up",
        type: ["Item", "Powerup"],
        container: "Chest",
        id: "0B-00-0F_02",
        room: "Tristis Pass (Exit Slope)",
        available: lambda { @logic.tristisWaterfall() }
      },
      {
        zone: "Tristis Pass",
        name: "Vol Grando",
        type: ["Glyph", "Damage", "Event"],
        container: "Visible",
        id: "0B-01-01_01",
        room: "Tristis Pass (Waterfall Top)",
        available: lambda { @logic.tristisWaterfall() }
      },
      {
        zone: "Tristis Pass",
        name: "Lovers Ring",
        type: ["Item", "Equipment", "Ring", "No Glyphs"],
        container: "Secret",
        id: "0B-01-02_00",
        room: "Tristis Pass (Waterfall Platforms)",
        available: lambda { @logic.tristisWaterfall() }
      },
      {
        zone: "Tristis Pass",
        name: "HEART Max Up",
        type: ["Item", "Powerup", "No Glyphs"],
        container: "Chest",
        id: "0B-01-02_01",
        room: "Tristis Pass (Waterfall Platforms)",
        available: lambda { @logic.tristisWaterfall() }
      },
      {
        zone: "Tristis Pass",
        name: "Amanita",
        type: ["Item", "Consumable", "No Glyphs"],
        container: "Visible",
        id: "0B-01-02_03",
        room: "Tristis Pass (Waterfall Platforms)",
        available: lambda { @logic.tristisWaterfall() }
      },
      {
        zone: "Tristis Pass",
        name: "Irina",
        type: ["Villager"],
        container: "Visible",
        id: "0B-01-03_00",
        room: "Tristis Pass (Behind Waterfall)",
        available: lambda { @logic.tristisWaterfall() }
      },
      {
        zone: "Tristis Pass",
        name: "HP Max Up",
        type: ["Item", "Powerup"],
        container: "Chest",
        id: "0B-01-05_00",
        room: "Tristis Pass (Lion's Cubby)",
        available: lambda { @logic.tristisWaterfall() }
      },
      {
        zone: "Tristis Pass",
        name: "Onyx",
        type: ["Item", "Other"],
        container: "Wall",
        id: "0B-01-07_01",
        room: "Tristis Pass (Ectoplasm Stairs)",
        available: lambda { @logic.tristisWaterfall() }
      },
    #Giant's Dwelling
      {
        zone: "Giant's Dwelling",
        name: "Temperance Ring",
        type: ["Item", "Equipment", "Ring"],
        container: "Wall",
        id: "0D-00-03_01",
        room: "Giant's Dwelling (Entrance)",
        available: lambda { return true }
      },
      {
        zone: "Giant's Dwelling",
        name: "Caprine",
        type: ["Item", "Equipment", "Head"],
        container: "Chest",
        id: "0D-00-04_00",
        room: "Giant's Dwelling (Lobby)",
        available: lambda { @logic.giantsDwelling() }
      },
      {
        zone: "Giant's Dwelling",
        name: "Daniela",
        type: ["Villager"],
        container: "Visible",
        id: "0D-00-05_00",
        room: "Giant's Dwelling (Daniela's Room)",
        available: lambda { @logic.giantsDwelling() }
      },
      {
        zone: "Giant's Dwelling",
        name: "Vol Secare",
        type: ["Glyph", "Damage"],
        container: "Statue",
        id: "0D-00-06_00",
        room: "Giant's Dwelling (Vol Secare Room)",
        available: lambda { @logic.giantsDwelling() }
      },
      {
        zone: "Giant's Dwelling",
        name: "Dominus Anger",
        type: ["Glyph", "Damage", "Event"],
        container: "Visible",
        id: "0D-00-08_00",
        room: "Giant's Dwelling (Albus Room)",
        available: lambda { @logic.giantsDwelling() }
      },
      {
        zone: "Giant's Dwelling",
        name: "Black Drops",
        type: ["Item", "Consumable"],
        container: "Secret",
        id: "0D-00-0C_00",
        room: "Giant's Dwelling (Zombie Connector)",
        available: lambda { @logic.giantsDwelling() }
      },
    #Mystery Manor  
      {
        zone: "Mystery Manor",
        name: "Vol Umbra",
        type: ["Glyph", "Damage", "Event"],
        container: "Visible",
        id: "0E-00-00_00",
        room: "Mystery Manor (Dark Room)",
        available: lambda { @logic.mysteryManor() }
      },
      {
        zone: "Mystery Manor",
        name: "Schnitzel",
        type: ["Item", "Consumable"],
        container: "Wall",
        id: "0E-00-02_01",
        room: "Mystery Manor (Schnitzel Room)",
        available: lambda { @logic.mysteryManor() }
      },
      {
        zone: "Mystery Manor",
        name: "$2000",
        type: ["Item", "Other"],
        container: "Visible",
        id: "0E-00-02_02",
        room: "Mystery Manor (Schnitzel Room)",
        available: lambda { @logic.mysteryManor() }
      },
      {
        zone: "Mystery Manor",
        name: "$2000",
        type: ["Item", "Other"],
        container: "Visible",
        id: "0E-00-07_00",
        room: "Mystery Manor (Flea Bank)",
        available: lambda { @logic.mysteryManor() }
      },
      {
        zone: "Mystery Manor",
        name: "Gold Ore",
        type: ["Item", "Other"],
        container: "Chest",
        id: "0E-00-08_00",
        room: "Mystery Manor (Interior Dead End)",
        available: lambda { @logic.mysteryManor() }
      },
      {
        zone: "Mystery Manor",
        name: "Dominus Agony",
        type: ["Glyph", "Event"],
        container: "Visible",
        id: "0E-00-09_06",
        room: "Mystery Manor (Albus Room)",
        available: lambda { @logic.beatAlbus() }
      },
    #Misty Forest Road  
      {
        zone: "Misty Forest Road",
        name: "Rue",
        type: ["Item", "Other"],
        container: "Chest",
        id: "0F-00-02_01",
        room: "Misty Forest Road (West Hill)",
        available: lambda { @logic.mistyJumpWest() }
      },
      {
        zone: "Misty Forest Road",
        name: "Melio Arcus",
        type: ["Glyph", "Damage"],
        container: "Statue",
        id: "0F-00-04_00",
        room: "Misty Forest Road (Paries Room)",
        available: lambda { @logic.mistyParies() }
      },
      {
        zone: "Misty Forest Road",
        name: "Hierophant Ring",
        type: ["Item", "Equipment", "Ring"],
        container: "Chest",
        id: "0F-00-04_01",
        room: "Misty Forest Road (Paries Room)",
        available: lambda { @logic.mistyParies() }
      },
      {
        zone: "Misty Forest Road",
        name: "White Drops",
        type: ["Item", "Consumable"],
        container: "Wall",
        id: "0F-00-04_03",
        room: "Misty Forest Road (Paries Room)",
        available: lambda { @logic.mistyParies() }
      },
      {
        zone: "Misty Forest Road",
        name: "Vol Macir",
        type: ["Glyph", "Damage"],
        container: "Statue",
        id: "0F-00-05_00",
        room: "Misty Forest Road (East Hill)",
        available: lambda { @logic.mistyRoad() }
      },
      {
        zone: "Misty Forest Road",
        name: "Sage",
        type: ["Item", "Other"],
        container: "Chest",
        id: "0F-00-05_02",
        room: "Misty Forest Road (East Hill)",
        available: lambda { @logic.mistyJumpEast() }
      },
    #Oblivion Ridge  
      {
        zone: "Oblivion Ridge",
        name: "Hermit Ring",
        type: ["Item", "Equip", "Ring"],
        container: "Wall",
        id: "10-00-00_02",
        room: "Oblivion Ridge (Albus Room)",
        available: lambda { @logic.beatFish() }
      },
      {
        zone: "Oblivion Ridge",
        name: "Diamond",
        type: ["Item", "Other"],
        container: "Wall",
        id: "10-01-01_02",
        room: "Oblivion Ridge (West Hill)",
        available: lambda { @logic.beatFish() }
      },
      {
        zone: "Oblivion Ridge",
        name: "Chamomile",
        type: ["Item", "Consumable"],
        container: "Chest",
        id: "10-01-01_03",
        room: "Oblivion Ridge (West Hill)",
        available: lambda { @logic.oblivionJump() }
      },
      {
        zone: "Oblivion Ridge",
        name: "Sapiens Fio",
        type: ["Glyph"],
        container: "Statue",
        id: "10-01-03_01",
        room: "Oblivion Ridge (East Hill)",
        available: lambda { @logic.oblivionJump() }
      },
    #Skeleton Cave  
      {
        zone: "Skeleton Cave",
        name: "HP Max Up",
        type: ["Item", "Powerup", "No Glyphs"],
        container: "Chest",
        id: "11-00-03_00",
        room: "Skeleton Cave (Upper Sanctum)",
        available: lambda { @logic.skeleCave() and @logic.highJump() }
      },
      {
        zone: "Skeleton Cave",
        name: "Black Drops",
        type: ["Item", "Consumable"],
        container: "Wall",
        id: "11-00-05_01",
        room: "Skeleton Cave (Bone Pile)",
        available: lambda { @logic.skeleCave() }
      },
      {
        zone: "Skeleton Cave",
        name: "MP Max Up",
        type: ["Item", "Powerup"],
        container: "Chest",
        id: "11-00-05_02",
        room: "Skeleton Cave (Bone Pile)",
        available: lambda { @logic.skeleCave() }
      },
      {
        zone: "Skeleton Cave",
        name: "Ordinary Rock",
        type: ["Item", "Relic"],
        container: "Chest",
        id: "11-00-08_00",
        room: "Skeleton Cave (Lower Sanctum)",
        available: lambda { @logic.skeleCave() }
      },
      {
        zone: "Skeleton Cave",
        name: "HEART Max Up",
        type: ["Item", "Powerup"],
        container: "Chest",
        id: "11-00-09_00",
        room: "Skeleton Cave (Lobby)",
        available: lambda { @logic.skeleCave() and @logic.highJump() }
      },
    #Monastery
      {
        zone: "Monastery",
        name: "Sandals",
        type: ["Item", "Equipment", "Boots"],
        container: "Chest",
        id: "12-00-03_00",
        room: "Monastery (Sandals Room)",
        available: lambda { return true }
      },
      {
        zone: "Monastery",
        name: "Cotton Hat",
        type: ["Item", "Equipment", "Head"],
        container: "Chest",
        id: "12-00-05_00",
        room: "Monastery (Magnes Tower)",
        available: lambda { @logic.monasteryUpper() }
      },
      {
        zone: "Monastery",
        name: "Magnes",
        type: ["Glyph", "Event"],
        container: "Visible",
        id: "12-00-05_05",
        room: "Monastery (Magnes Tower)",
        available: lambda { return true }
      },
      {
        zone: "Monastery",
        name: "Fool Ring",
        type: ["Item", "Equipment", "Ring", "No Glyphs"],
        container: "Chest",
        id: "12-00-07_00",
        room: "Monastery (Cat Room)",
        available: lambda { @logic.monasteryFoolRing() }
      },
      {
        zone: "Monastery",
        name: "HP Max Up",
        type: ["Item", "Powerup"],
        container: "Chest",
        id: "12-00-07_01",
        room: "Monastery (Cat Room)",
        available: lambda { @logic.monasteryUpper() }
      },
      {
        zone: "Monastery",
        name: "Cubus",
        type: ["Glyph", "Damage", "Event"],
        container: "Visible",
        id: "12-00-08_00",
        room: "Monastery (Cube Room)",
        available: lambda { @logic.cubusPuzzle() }
      },
      {
        zone: "Monastery",
        name: "Culter",
        type: ["Glyph", "Damage"],
        container: "Statue",
        id: "12-00-09_00",
        room: "Monastery (Culter Room)",
        available: lambda { @logic.monasteryUpper() }
      },
      {
        zone: "Monastery",
        name: "Book of Spirits",
        type: ["Item", "Relic"],
        container: "Chest",
        id: "12-00-0A_00",
        room: "Monastery (Book of Spirits Room)",
        available: lambda { @logic.monasteryUpper() }
      },
      {
        zone: "Monastery",
        name: "HEART Max Up",
        type: ["Item", "Powerup"],
        container: "Chest",
        id: "12-00-0B_00",
        room: "Monastery (Hidden Room)",
        available: lambda { @logic.monasteryUpper() }
      },
      {
        zone: "Monastery",
        name: "Red Drops",
        type: ["Item", "Consumable"],
        container: "Wall",
        id: "12-00-0D_02",
        room: "Monastery (Northeast Stairs)",
        available: lambda { @logic.monasteryUpper() }
      },
      {
        zone: "Monastery",
        name: "$500",
        type: ["Item", "Other"],
        container: "Visible",
        id: "12-00-0D_04",
        room: "Monastery (Northeast Stairs)",
        available: lambda { @logic.monasteryUpper() }
      },
      {
        zone: "Monastery",
        name: "MP Max Up",
        type: ["Item", "Powerup"],
        container: "Chest",
        id: "12-00-10_00",
        room: "Monastery (Pre-Boss Room)",
        available: lambda { @logic.monasteryUpper() }
      }
    ]
  end
end