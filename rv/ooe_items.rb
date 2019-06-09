module OoEItems

attr_reader :items

def self.items
  items = glyphs.merge(equipment).merge(relics).merge(consumables)
end

def self.glyphs
 glyphs = {
   "Confodere" => {
     name: "Confodere",
     type: "Damaging",
     progression: false,
     id: 0x01
   },
   "Secare" => {
     name: "Secare",
     type: "Damaging",
     progression: false,
     id: 0x04
   },
   "Hasta" => {
     name: "Hasta",
     type: "Damaging",
     progression: false,
     id: 0x07
   },
   "Arcus" => {
     name: "Arcus",
     type: "Damaging",
     progression: false,
     id: 0x0D
   },
   "Ascia" => {
     name: "Ascia",
     type: "Damaging",
     progression: false,
     id: 0x10
   },
   "Grando" => {
     name: "Grando",
     type: "Damaging",
     progression: false,
     id: 0x23
   },
  "Torpor" => {
    name: "Torpor",
    type: "Damaging",
    progression: false,
    id: 0x1E
  },
  "Vol Ignis" => {
    name: "Vol Ignis",
    type: "Damaging",
    progression: true,
    id: 0x22
  },
  "Lapiste" => {
    name: "Lapiste",
    type: "Damaging",
    progression: false,
    id: 0x1F
  },
  "Felicem Fio" => {
    name: "Felicem Fio",
    type: "Utility",
    progression: false,
  },
  "Rapidus Fio" => {
    name: "Rapidus Fio",
    type: "Utility",
    progression: true,
    id: 0x3B
  },
  "Paries" => {
    name: "Paries",
    type: "Utility",
    progression: true,
    id: 0x39
  },
  "Melio Confodere" => {
    name: "Melio Confodere",
    type: "Damaging",
    progression: false,
    id: 0x01
  },
  "Refectio" => {
    name: "Refectio",
    type: "Utility",
    progression: false,
    id: 0x45
  },
  "Dextro Custos" => {
    name: "Dextro Custos",
    type: "Damaging",
    progression: true,
    id: 0x2F
  },
  "Melio Hasta" => {
    name: "Melio Hasta",
    type: "Damaging",
    progression: false,
    id: 0x09
  },
  "Sinestro Custos" => {
    name: "Sinestro Custos",
    type: "Damaging",
    progression: true,
    id: 0x30
  },
  "Morbus" => {
    name: "Morbus",
    type: "Damaging",
    progression: false,
    id: 0x2B
  },
  "Vis Fio" => {
    name: "Vis Fio",
    type: "Utility",
    progression: false,
    id: 0x3C
  },
  "Melio Falcis" => {
    name: "Melio Falcis",
    type: "Damaging",
    progression: false,
    id: 0x15
  },
  "Melio Culter" => {
    name: "Melio Culter",
    type: "Damaging",
    progression: false,
    id: 0x18
  },
  "Melio Scutum" => {
    name: "Melio Scutum",
    type: "Utility",
    progression: false,
    id: 0x1B
  },
  "Arma Custos" => {
    name: "Arma Custos",
    type: "Utility",
    progression: true,
    id: 0x46
  },
  "Volaticus" => {
    name: "Volaticus",
    type: "Utility",
    progression: true,
    id: 0x3A
  },
  "Redire" => {
    name: "Redire",
    type: "Damaging",
    progression: true,
    id: 0x1C
  },
  "Macir" => {
    name: "Macir",
    type: "Damaging",
    progression: false,
    id: 0x0A
  },
  "Fortis Fio" => {
    name: "Fortis Fio",
    type: "Utility",
    progression: false,
    id: 0x3D
  },
  "Scutum" => {
    name: "Scutum",
    type: "Utility",
    progression: false,
    id: 0x19
  },
  "Vol Arcus" => {
    name: "Vol Arcus",
    type: "Damaging",
    progression: false,
    id: 0x0E
  },
  "Vol Ascia" => {
    name: "Vol Ascia",
    type: "Damaging",
    progression: false,
    id: 0x11
  },
  "Dominus Hatred" => {
    name: "Dominus Hatred",
    type: "Damaging",
    progression: true,
    id: 0x31
  },
  "Vol Fulgur" => {
    name: "Vol Fulgur",
    type: "Damaging",
    progression: true,
    id: 0x26
  },
  "Falcis" => {
    name: "Falcis",
    type: "Damaging",
    progression: false,
    id: 0x13
  },
  "Luminatio" => {
    name: "Luminatio",
    type: "Damaging",
    progression: true,
    id: 0x27
  },
  "Fides Fio" => {
    name: "Fides Fio",
    type: "Utility",
    progression: false,
    id: 0x08
  },
  "Pneuma" => {
    name: "Pneuma",
    type: "Damaging",
    progression: false,
    id: 0x20
  },
  "Vol Hasta" => {
    name: "Vol Hasta",
    type: "Damaging",
    progression: false,
    id: 0x08
  },
  "Inire Pecunia" => {
    name: "Inire Pecunia",
    type: "Utility",
    progression: false,
    id: 0x41
  },
  "Vol Grando" => {
    name: "Vol Grando",
    type: "Damaging",
    progression: false,
    id: 0x24
  },
  "Vol Secare" => {
    name: "Vol Secare",
    type: "Damaging",
    progression: false,
    id: 0x05
  },
  "Dominus Anger" => {
    name: "Dominus Anger",
    type: "Damaging",
    progression: true,
    id: 0x32
  },
  "Vol Umbra" => {
    name: "Vol Umbra",
    type: "Damaging",
    progression: false,
    id: 0x2A
  },
  "Dominus Agony" => {
    name: "Dominus Agony",
    type: "Utility",
    progression: true,
    id: 0x4E
  },
  "Melio Arcus" => {
    name: "Melio Arcus",
    type: "Damaging",
    progression: false,
    id: 0x0F
  },
  "Vol Macir" => {
    name: "Vol Macir",
    type: "Damaging",
    progression: false,
    id: 0x0B
  },
  "Sapiens Fio" => {
    name: "Sapiens Fio",
    type: "Utility",
    progression: false,
    id: 0x3E
  },
  "Magnes" => {
    name: "Magnes",
    type: "Utility",
    progression: true,
    id: 0x38
  },
  "Cubus" => {
    name: "Cubus",
    type: "Damaging",
    progression: false,
    id: 0x1D
  },
  "Culter" => {
    name: "Culter",
    type: "Damaging",
    progression: false,
    id: 0x16
  },
  "Arma Felix" => {
    name: "Arma Felix",
    type: "Utility",
    progression: true,
    id: 0x42
  },
  "Cat Tackle" => {
    name: "Cat Tackle",
    type: "Damaging",
    progression: true,
    id: 0x33
  },
  "Nitesco" => {
    name: "Nitesco",
    type: "Damaging",
    progression: true,
    id: 0x2C
  },
  "Fulgur" => {
    name: "Fulgur",
    type: "Damaging",
    progression: true,
    id: 0x25
  },
  "Vol Luminatio" => {
    name: "Vol Luminatio",
    type: "Damaging",
    progression: true,
    id: 0x28
  },
  "Ignis" => {
    name: "Ignis",
    type: "Damaging",
    progression: true,
    id: 0x21
  },
  "Arma Machina" => {
    name: "Arma Machina",
    type: "Utility",
    progression: true,
    id: 0x44
  }
}
end

def self.equipment
 equipment = {
  "Casual Clothes" => {
    name: "Casual Clothes",
    type: "Body",
    progression: false,
    id: 0xE6
  },
  "Valkyrie Greaves" => {
    name: "Valkyrie Greaves",
    type: "Boots",
    progression: false,
    id: 0x137
  },
  "Mercury Boots" => {
    name: "Mercury Boots",
    type: "Boots",
    id: 0x126,
    progression: true,
  },
  "Star Ring" => {
    name: "Star Ring",
    type: "Ring",
    progression: false,
    id: 0x14D
  },
  "Hanged Man Ring" => {
    name: "Hanged Man Ring",
    type: "Ring",
    progression: false,
    id: 0x148
  },
  "Moon Ring" => {
    name: "Moon Ring",
    type: "Ring",
    progression: false,
    id: 0x14E
  },
  "Valkyrie Mail" => {
    name: "Valkyrie Mail",
    type: "Body",
    progression: false,
    id: 0xF6
  },
  "Valkyrie Mask" => {
    name: "Valkyrie Mask",
    type: "Head",
    progression: false,
    id: 0x111
  },
  "Heart Cuirass" => {
    name: "Heart Cuirass",
    type: "Body",
    progression: false,
    id: 0xF2
  },
  "Death Ring" => {
    name: "Death Ring",
    type: "Ring",
    progression: false,
    id: 0x149
  },
  "Sun Ring" => {
    name: "Sun Ring",
    type: "Ring",
    progression: false,
    id: 0x14F
  },
  "World Ring" => {
    name: "World Ring",
    type: "Ring",
    progression: false,
    id: 0x151
  },
  "Judgement Ring" => {
    name: "Judgement Ring",
    type: "Ring",
    progression: false,
    id: 0x150
  },
  "Magician Ring" => {
    name: "Magician Ring",
    type: "Ring",
    progression: false,
    id: 0x13D
  },
  "Reinforced Suit" => {
    name: "Reinforced Suit",
    type: "Body",
    progression: false,
    id: 0xE9
  },
  "Cabriolet" => {
    name: "Cabriolet",
    type: "Head",
    progression: false,
    id: 0x10A
  },
  "Priestess Ring" => {
    name: "Priestess Ring",
    type: "Ring",
    progression: false,
    id: 0x13E
  },
  "Tower Ring" => {
    name: "Tower Ring",
    type: "Ring",
    progression: false,
    id: 0x14C
  },
  "Strength Ring" => {
    name: "Strength Ring",
    type: "Ring",
    progression: false,
    id: 0x147
  },
  "Crimson Mask" => {
    name: "Crimson Mask",
    type: "Head",
    progression: false,
    id: 0x110
  },
  "Moonwalkers" => {
    name: "Moonwalkers",
    type: "Boots",
    id: 0x125,
    progression: true,
  },
  "Devil Ring" => {
    name: "Devil Ring",
    type: "Ring",
    progression: false,
    id: 0x14B
  },
  "Emperor Ring" => {
    name: "Emperor Ring",
    type: "Ring",
    progression: false,
    id: 0x140
  },
  "Empress Ring" => {
    name: "Empress Ring",
    type: "Ring",
    progression: false,
    id: 0x13F
  },
  "Lovers Ring" => {
    name: "Lovers Ring",
    type: "Ring",
    progression: false,
    id: 0x142
  },
  "Temperance Ring" => {
    name: "Temperance Ring",
    type: "Ring",
    progression: false,
    id: 0x14A
  },
  "Caprine" => {
    name: "Caprine",
    type: "Head",
    progression: false,
    id: 0x10C
  },
  "Hierophant Ring" => {
    name: "Hierophant Ring",
    type: "Ring",
    progression: false,
    id: 0x141
  },
  "Sandals" => {
    name: "Sandals",
    type: "Boots",
    progression: false,
    id: 0x129
  },
  "Cotton Hat" => {
    name: "Cotton Hat",
    type: "Head",
    progression: false,
    id: 0x104
  },
  "Fool Ring" => {
    name: "Fool Ring",
    type: "Ring",
    progression: false,
    id: 0x13C
  },
  "Winged Boots" => {
    name: "Winged Boots",
    type: "Boots",
    id: 0x127,
    progression: true,
  }
}
end

def self.consumables
 consumables = {
  "Tasty Meat" => {
    name: "Tasty Meat",
    type: "Health",
    id: 0x83
  },
  "Cream Puff" => {
    name: "Cream Puff",
    type: "Health",
    id: 0x8C
  },
  "Mint Sundae" => {
    name: "Mint Sundae",
    type: "Hearts",
    id: 0x97
  },
  "Eisbein" => {
    name: "Eisbein",
    type: "Health",
    id: 0x94
  },
  "Magical Ticket" => {
    name: "Magical Ticket",
    type: "Other",
    id: 0x7C
  },
  "Super Potion" => {
    name: "Super Potion",
    type: "Health",
    id: 0x77
  },
  "Potion" => {
    name: "Potion",
    type: "Health",
    id: 0x75
  },
  "Anti-Venom" => {
    name: "Anti-Venom",
    type: "Other",
    id: 0x7D
  },
  "Mushroom" => {
    name: "Mushroom",
    type: "Health",
    id: 0x87
  },
  "Amanita" => {
    name: "Amanita",
    type: "Other",
    id: 0xA1
  },
  "Schnitzel" => {
    name: "Schnitzel",
    type: "Health",
    id: 0x93
  },
  "Chamomile" => {
    name: "Chamomile",
    type: "Mana",
    id: 0xC1
  },
  "White Drops" => {
    name: "White Drops",
    type: "Drops",
    id: 0x9F
  },
  "Black Drops" => {
    name: "Black Drops",
    type: "Drops",
    id: 0xA0
  },
  "Green Drops" => {
    name: "Green Drops",
    type: "Drops",
    id: 0x9E
  },
  "Blue Drops" => {
    name: "Blue Drops",
    type: "Drops",
    id: 0x9D
  },
  "Red Drops" => {
    name: "Red Drops",
    type: "Drops",
    id: 0x9C
  }
}
end

def self.relics
 relics = {
  "Ordinary Rock" => {
    name: "Ordinary Rock",
    type: "Relic",
    id: 0x70,
    progression: true
  },
  "Serpent Scale" => {
    name: "Serpent Scale",
    type: "Relic",
    id: 0x71,
    progression: true
  },
  "Lizard Tail" => {
    name: "Lizard Tail",
    type: "Relic",
    id: 0x6F
  },
  "Glyph Sleeve" => {
    name: "Glyph Sleeve",
    type: "Relic",
    id: 0x73,
  },
  "Glyph Union" => {
    name: "Glyph Union",
    type: "Relic",
    id: 0x72
  }
  }
end

end
