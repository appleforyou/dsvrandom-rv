module OoEItems

attr_reader :items,
            :glyphs,
            :relics,
            :consumables,
            :materials,
            :undroppables

def self.items
  return @@total_items
end

def self.glyphs
 glyphs = {
  "Confodere" => {
    name: "Confodere",
    type: "Damaging",
    progression: false,
    id: 0x01
  },
  "Vol Confodere" => {
    name: "Vol Confodere",
    type: "Damaging",
    progression: false,
    id: 0x02
  },
  "Melio Confodere" => {
    name: "Melio Confodere",
    type: "Damaging",
    progression: false,
    id: 0x03
  },
  "Secare" => {
    name: "Secare",
    type: "Damaging",
    progression: false,
    id: 0x04
  },
  "Vol Secare" => {
    name: "Vol Secare",
    type: "Damaging",
    progression: false,
    id: 0x05
  },
  "Melio Secare" => {
    name: "Melio Secare",
    type: "Damaging",
    progression: false,
    id: 0x06
  },
  "Hasta" => {
    name: "Hasta",
    type: "Damaging",
    progression: false,
    id: 0x07
  },
  "Vol Hasta" => {
    name: "Vol Hasta",
    type: "Damaging",
    progression: false,
    id: 0x08
  },
  "Melio Hasta" => {
    name: "Melio Hasta",
    type: "Damaging",
    progression: false,
    id: 0x09
  },
  "Macir" => {
    name: "Macir",
    type: "Damaging",
    progression: false,
    id: 0x0a
  },
  "Vol Macir" => {
    name: "Vol Macir",
    type: "Damaging",
    progression: false,
    id: 0x0b
  },
  "Melio Macir" => {
    name: "Melio Macir",
    type: "Damaging",
    progression: false,
    id: 0x0c
  },
  "Arcus" => {
    name: "Arcus",
    type: "Damaging",
    progression: false,
    id: 0x0d
  },
  "Vol Arcus" => {
    name: "Vol Arcus",
    type: "Damaging",
    progression: false,
    id: 0x0e
  },
  "Melio Arcus" => {
    name: "Melio Arcus",
    type: "Damaging",
    progression: false,
    id: 0x0f
  },
  "Ascia" => {
    name: "Ascia",
    type: "Damaging",
    progression: false,
    id: 0x10
  },
  "Vol Ascia" => {
    name: "Vol Ascia",
    type: "Damaging",
    progression: false,
    id: 0x11
  },
  "Melio Ascia" => {
    name: "Melio Ascia",
    type: "Damaging",
    progression: false,
    id: 0x12
  },
  "Falcis" => {
    name: "Falcis",
    type: "Damaging",
    progression: false,
    id: 0x13
  },
  "Vol Falcis" => {
    name: "Vol Falcis",
    type: "Damaging",
    progression: false,
    id: 0x14
  },
  "Melio Falcis" => {
    name: "Melio Falcis",
    type: "Damaging",
    progression: false,
    id: 0x15
  },
  "Culter" => {
    name: "Culter",
    type: "Damaging",
    progression: false,
    id: 0x16
  },
  "Vol Culter" => {
    name: "Vol Culter",
    type: "Damaging",
    progression: false,
    id: 0x17
  },
  "Melio Culter" => {
    name: "Melio Culter",
    type: "Damaging",
    progression: false,
    id: 0x18
  },
  "Scutum" => {
    name: "Scutum",
    type: "Utility",
    progression: false,
    id: 0x19
  },
  "Vol Scutum" => {
    name: "Vol Scutum",
    type: "Utility",
    progression: false,
    id: 0x1a
  },
  "Melio Scutum" => {
    name: "Melio Scutum",
    type: "Utility",
    progression: false,
    id: 0x1b
  },
  "Redire" => {
    name: "Redire",
    type: "Damaging",
    progression: true,
    id: 0x1c
  },
  "Cubus" => {
    name: "Cubus",
    type: "Damaging",
    progression: false,
    id: 0x1d
  },
  "Torpor" => {
    name: "Torpor",
    type: "Damaging",
    progression: false,
    id: 0x1e
  },
  "Lapiste" => {
    name: "Lapiste",
    type: "Damaging",
    progression: false,
    id: 0x1f
  },
  "Pneuma" => {
    name: "Pneuma",
    type: "Damaging",
    progression: false,
    id: 0x20
  },
  "Ignis" => {
    name: "Ignis",
    type: "Damaging",
    progression: true,
    id: 0x21
  },
  "Vol Ignis" => {
    name: "Vol Ignis",
    type: "Damaging",
    progression: true,
    id: 0x22
  },
  "Grando" => {
    name: "Grando",
    type: "Damaging",
    progression: false,
    id: 0x23
  },
  "Vol Grando" => {
    name: "Vol Grando",
    type: "Damaging",
    progression: false,
    id: 0x24
  },
  "Vol Fulgur" => {
    name: "Vol Fulgur",
    type: "Damaging",
    progression: true,
    id: 0x26
  },
  "Fulgur" => {
    name: "Fulgur",
    type: "Damaging",
    progression: true,
    id: 0x25
  },
  "Luminatio" => {
    name: "Luminatio",
    type: "Damaging",
    progression: false,
    id: 0x27
  },
  "Vol Luminatio" => {
    name: "Vol Luminatio",
    type: "Damaging",
    progression: false,
    id: 0x28
  },
  "Umbra" => {
    name: "Umbra",
    type: "Damaging",
    progression: false,
    id: 0x29
  },
  "Vol Umbra" => {
    name: "Vol Umbra",
    type: "Damaging",
    progression: false,
    id: 0x2a
  },
  "Morbus" => {
    name: "Morbus",
    type: "Damaging",
    progression: false,
    id: 0x2b
  },
  "Nitesco" => {
    name: "Nitesco",
    type: "Damaging",
    progression: true,
    id: 0x2c
  },
  "Acerbatus" => {
    name: "Acerbatus",
    type: "Damaging",
    progression: false,
    id: 0x2d
  },
  "Globus" => {
    name: "Globus",
    type: "Damaging",
    progression: false,
    id: 0x2e
  },
  "Dextro Custos" => {
    name: "Dextro Custos",
    type: "Damaging",
    progression: true,
    id: 0x2f
  },
  "Sinestro Custos" => {
    name: "Sinestro Custos",
    type: "Damaging",
    progression: true,
    id: 0x30
  },
  "Arma Custos" => {
    name: "Arma Custos",
    type: "Utility",
    progression: true,
    id: 0x46
  },
  "Dominus Hatred" => {
    name: "Dominus Hatred",
    type: "Damaging",
    progression: true,
    id: 0x31
  },
  "Dominus Anger" => {
    name: "Dominus Anger",
    type: "Damaging",
    progression: true,
    id: 0x32
  },
  "Dominus Agony" => {
    name: "Dominus Agony",
    type: "Utility",
    progression: true,
    id: 0x4e
  },
  "Magnes" => {
    name: "Magnes",
    type: "Utility",
    progression: true,
    id: 0x38
  },
  "Paries" => {
    name: "Paries",
    type: "Utility",
    progression: true,
    id: 0x39
  },
  "Volaticus" => {
    name: "Volaticus",
    type: "Utility",
    progression: true,
    id: 0x3a
  },
  "Rapidus Fio" => {
    name: "Rapidus Fio",
    type: "Utility",
    progression: true,
    id: 0x3b
  },
  "Vis Fio" => {
    name: "Vis Fio",
    type: "Utility",
    progression: false,
    id: 0x3c
  },
  "Fortis Fio" => {
    name: "Fortis Fio",
    type: "Utility",
    progression: false,
    id: 0x3d
  },
  "Sapiens Fio" => {
    name: "Sapiens Fio",
    type: "Utility",
    progression: false,
    id: 0x3e
  },
  "Fides Fio" => {
    name: "Fides Fio",
    type: "Utility",
    progression: false,
    id: 0x3f
  },
  "Felicem Fio" => {
    name: "Felicem Fio",
    type: "Utility",
    progression: false,
    id: 0x40
  },
  "Inire Pecunia" => {
    name: "Inire Pecunia",
    type: "Utility",
    progression: false,
    id: 0x41
  },
  "Refectio" => {
    name: "Refectio",
    type: "Utility",
    progression: false,
    id: 0x45
  },
  "Arma Felix" => {
    name: "Arma Felix",
    type: "Utility",
    progression: false,
    id: 0x42
  },
  "Arma Chiroptera" => {
    name: "Arma Chiroptera",
    type: "Utility",
    progression: false,
    id: 0x43
  },
  "Arma Machina" => {
    name: "Arma Machina",
    type: "Utility",
    progression: true,
    id: 0x44
  },
  "Cat Tackle" => {
    name: "Cat Tackle",
    type: "Damaging",
    progression: true,
    id: 0x33
  },
  "Fidelis Caries" => {
    name: "Fidelis Caries",
    type: "Utility",
    progression: false,
    id: 0x47
  },
  "Fidelis Alate" => {
    name: "Fidelis Alate",
    type: "Utility",
    progression: false,
    id: 0x48
  },
  "Fidelis Polkir" => {
    name: "Fidelis Polkir",
    type: "Utility",
    progression: false,
    id: 0x49
  },
  "Fidelis Noctua" => {
    name: "Fidelis Noctua",
    type: "Utility",
    progression: false,
    id: 0x4a
  },
  "Fidelis Medusa" => {
    name: "Fidelis Medusa",
    type: "Utility",
    progression: false,
    id: 0x4b
  },
  "Fidelis Aranea" => {
    name: "Fidelis Aranea",
    type: "Utility",
    progression: false,
    id: 0x4c
  },
  "Fidelis Mortus" => {
    name: "Fidelis Mortus",
    type: "Utility",
    progression: false,
    id: 0x4d
  }
}
end

def self.equipment
 equipment = {
  "Casual Clothes" => {
    name: "Casual Clothes",
    type: "Body",
    progression: false,
    id: 0xe6,
    tier: 0,
  },
  "Military Wear" => {
    name: "Military Wear",
    type: "Body",
    progression: false,
    id: 0xe7,
    tier: 0,
  },
  "Rubber Suit" => {
    name: "Rubber Suit",
    type: "Body",
    progression: false,
    id: 0xe8,
    tier: 0,
  },
  "Reinforced Suit" => {
    name: "Reinforced Suit",
    type: "Body",
    progression: false,
    id: 0xe9,
    tier: 2,
  },
  "Body Suit" => {
    name: "Body Suit",
    type: "Body",
    progression: false,
    id: 0xea,
    tier: 1,
  },
  "Leather Cuirass" => {
    name: "Leather Cuirass",
    type: "Body",
    progression: false,
    id: 0xeb,
    tier: 0,
  },
  "Copper Plate" => {
    name: "Copper Plate",
    type: "Body",
    progression: false,
    id: 0xec,
    tier: 0,
  },
  "Iron Plate" => {
    name: "Iron Plate",
    type: "Body",
    progression: false,
    id: 0xed,
    tier: 1,
  },
  "Silver Plate" => {
    name: "Silver Plate",
    type: "Body",
    progression: false,
    id: 0xee,
    tier: 1,
  },
  "Gold Plate" => {
    name: "Gold Plate",
    type: "Body",
    progression: false,
    id: 0xef,
    tier: 2,
  },
  "Platinum Plate" => {
    name: "Platinum Plate",
    type: "Body",
    progression: false,
    id: 0xf0,
    tier: 2,
  },
  "Mirror Cuirass" => {
    name: "Mirror Cuirass",
    type: "Body",
    progression: false,
    id: 0xf1,
    tier: 2,
  },
  "Heart Cuirass" => {
    name: "Heart Cuirass",
    type: "Body",
    progression: false,
    id: 0xf2,
    tier: 1,
  },
  "Barbarian Belt" => {
    name: "Barbarian Belt",
    type: "Body",
    progression: false,
    id: 0xf3,
    tier: 3,
  },
  "Knight Cuirass" => {
    name: "Knight Cuirass",
    type: "Body",
    progression: false,
    id: 0xf4,
    tier: 2,
  },
  "Crimson Mail" => {
    name: "Crimson Mail",
    type: "Body",
    progression: false,
    id: 0xf5,
    tier: 2,
  },
  "Valkyrie Mail" => {
    name: "Valkyrie Mail",
    type: "Body",
    progression: false,
    id: 0xf6,
    tier: 3,
  },
  "Minerva Mail" => {
    name: "Minerva Mail",
    type: "Body",
    progression: false,
    id: 0xf7,
    tier: 4,
  },
  "Cotton Dress" => {
    name: "Cotton Dress",
    type: "Body",
    progression: false,
    id: 0xf8,
    tier: 1,
  },
  "Silk Dress" => {
    name: "Silk Dress",
    type: "Body",
    progression: false,
    id: 0xf9,
    tier: 2,
  },
  "Sequined Dress" => {
    name: "Sequined Dress",
    type: "Body",
    progression: false,
    id: 0xfa,
    tier: 2,
  },
  "Empire Dress" => {
    name: "Empire Dress",
    type: "Body",
    progression: false,
    id: 0xfb,
    tier: 3,
  },
  "Corset Dress" => {
    name: "Corset Dress",
    type: "Body",
    progression: false,
    id: 0xfc,
    tier: 3,
  },
  "Party Dress" => {
    name: "Party Dress",
    type: "Body",
    progression: false,
    id: 0xfd,
    tier: 2,
  },
  "Wedding Dress" => {
    name: "Wedding Dress",
    type: "Body",
    progression: false,
    id: 0xfe,
    tier: 3,
  },
  "Robe Decollete" => {
    name: "Robe Decollete",
    type: "Body",
    progression: false,
    id: 0xff,
    tier: 3,
  },
  "Eye for Decay" => {
    name: "Eye for Decay",
    type: "Head",
    progression: false,
    id: 0x101,
    tier: 0,
  },
  "L. Eye of God" => {
    name: "L. Eye of God",
    type: "Head",
    progression: false,
    id: 0x102,
    tier: 0,
  },
  "R. Eye of Devil" => {
    name: "R. Eye of Devil",
    type: "Head",
    progression: false,
    id: 0x103,
    tier: 0,
  },
  "Cotton Hat" => {
    name: "Cotton Hat",
    type: "Head",
    progression: false,
    id: 0x104,
    tier: 0,
  },
  "Garbo Hat" => {
    name: "Garbo Hat",
    type: "Head",
    progression: false,
    id: 0x105,
    tier: 2,
  },
  "Treasure Hat" => {
    name: "Treasure Hat",
    type: "Head",
    progression: false,
    id: 0x106,
    tier: 1,
  },
  "Dowsing Hat" => {
    name: "Dowsing Hat",
    type: "Head",
    progression: false,
    id: 0x107,
    tier: 0,
  },
  "Traveler's Hat" => {
    name: "Traveler's Hat",
    type: "Head",
    progression: false,
    id: 0x108,
    tier: 2,
  },
  "Ribbon" => {
    name: "Ribbon",
    type: "Head",
    progression: false,
    id: 0x109,
    tier: 1,
  },
  "Cabriolet" => {
    name: "Cabriolet",
    type: "Head",
    progression: false,
    id: 0x10a,
    tier: 2,
  },
  "Babushka" => {
    name: "Babushka",
    type: "Head",
    progression: false,
    id: 0x10b,
    tier: 1,
  },
  "Caprine" => {
    name: "Caprine",
    type: "Head",
    progression: false,
    id: 0x10c,
    tier: 1,
  },
  "Crochet" => {
    name: "Crochet",
    type: "Head",
    progression: false,
    id: 0x10d,
    tier: 3,
  },
  "Barbarian Helm" => {
    name: "Barbarian Helm",
    type: "Head",
    progression: false,
    id: 0x10e,
    tier: 3,
  },
  "Knight Helm" => {
    name: "Knight Helm",
    type: "Head",
    progression: false,
    id: 0x10f,
    tier: 1,
  },
  "Crimson Mask" => {
    name: "Crimson Mask",
    type: "Head",
    progression: false,
    id: 0x110,
    tier: 1,
  },
  "Valkyrie Mask" => {
    name: "Valkyrie Mask",
    type: "Head",
    progression: false,
    id: 0x111,
    tier: 2,
  },
  "Minerva Mask" => {
    name: "Minerva Mask",
    type: "Head",
    progression: false,
    id: 0x112,
    tier: 3,
  },
  "Ruby Pins" => {
    name: "Ruby Pins",
    type: "Head",
    progression: false,
    id: 0x113,
    tier: 2,
  },
  "Sapphire Pins" => {
    name: "Sapphire Pins",
    type: "Head",
    progression: false,
    id: 0x114,
    tier: 2,
  },
  "Emerald Pins" => {
    name: "Emerald Pins",
    type: "Head",
    progression: false,
    id: 0x115,
    tier: 2,
  },
  "Diamond Pins" => {
    name: "Diamond Pins",
    type: "Head",
    progression: false,
    id: 0x116,
    tier: 3,
  },
  "Onyx Pins" => {
    name: "Onyx Pins",
    type: "Head",
    progression: false,
    id: 0x117,
    tier: 3,
  },
  "Stephanie" => {
    name: "Stephanie",
    type: "Head",
    progression: false,
    id: 0x118,
    tier: 4,
  },
  "Royal Crown" => {
    name: "Royal Crown",
    type: "Head",
    progression: false,
    id: 0x119,
    tier: 4,
  },
  "Sword Helm" => {
    name: "Sword Helm",
    type: "Head",
    progression: false,
    id: 0x11a,
    tier: 1,
  },
  "Rapier Helm" => {
    name: "Rapier Helm",
    type: "Head",
    progression: false,
    id: 0x11b,
    tier: 0,
  },
  "Lance Helm" => {
    name: "Lance Helm",
    type: "Head",
    progression: false,
    id: 0x11c,
    tier: 1,
  },
  "Hammer Helm" => {
    name: "Hammer Helm",
    type: "Head",
    progression: false,
    id: 0x11d,
    tier: 1,
  },
  "Arrow Helm" => {
    name: "Arrow Helm",
    type: "Head",
    progression: false,
    id: 0x11e,
    tier: 1,
  },
  "Axe Helm" => {
    name: "Axe Helm",
    type: "Head",
    progression: false,
    id: 0x11f,
    tier: 1,
  },
  "Sickle Helm" => {
    name: "Sickle Helm",
    type: "Head",
    progression: false,
    id: 0x120,
    tier: 1,
  },
  "Knife Helm" => {
    name: "Knife Helm",
    type: "Head",
    progression: false,
    id: 0x121,
    tier: 0,
  },
  "Shield Helm" => {
    name: "Shield Helm",
    type: "Head",
    progression: false,
    id: 0x122,
    tier: 1,
  },
  "Queen of Hearts" => {
    name: "Queen of Hearts",
    type: "Head",
    progression: false,
    id: 0x123,
    tier: 5,
  },
  "Moonwalkers" => {
    name: "Moonwalkers",
    type: "Boots",
    id: 0x125,
    progression: false,
    tier: 2
  },
  "Mercury Boots" => {
    name: "Mercury Boots",
    type: "Boots",
    id: 0x126,
    progression: false,
    tier: 1
  },
  "Winged Boots" => {
    name: "Winged Boots",
    type: "Boots",
    id: 0x127,
    progression: false,
    tier: 1
  },
  "Combo Boots" => {
    name: "Combo Boots",
    type: "Boots",
    id: 0x128,
    progression: false,
    tier: 0
  },
  "Sandals" => {
    name: "Sandals",
    type: "Boots",
    id: 0x129,
    progression: false,
    tier: 0
  },
  "Sabrina Shoes" => {
    name: "Sabrina Shoes",
    type: "Boots",
    id: 0x12a,
    progression: false,
    tier: 0
  },
  "Cossack Boots" => {
    name: "Cossack Boots",
    type: "Boots",
    id: 0x12b,
    progression: false,
    tier: 0
  },
  "Baggy Boots" => {
    name: "Baggy Boots",
    type: "Boots",
    id: 0x12c,
    progression: false,
    tier: 0
  },
  "Battle Boots" => {
    name: "Battle Boots",
    type: "Boots",
    id: 0x12d,
    progression: false,
    tier: 2
  },
  "Ghillie Boots" => {
    name: "Ghillie Boots",
    type: "Boots",
    id: 0x12e,
    progression: false,
    tier: 0
  },
  "Cavalier Boots" => {
    name: "Cavalier Boots",
    type: "Boots",
    id: 0x12f,
    progression: false,
    tier: 1
  },
  "Iron Leggings" => {
    name: "Iron Leggings",
    type: "Boots",
    id: 0x130,
    progression: false,
    tier: 0
  },
  "Silver Leggings" => {
    name: "Silver Leggings",
    type: "Boots",
    id: 0x131,
    progression: false,
    tier: 1
  },
  "Gold Leggings" => {
    name: "Gold Leggings",
    type: "Boots",
    id: 0x132,
    progression: false,
    tier: 2
  },
  "Plat Leggings" => {
    name: "Plat Leggings",
    type: "Boots",
    id: 0x133,
    progression: false,
    tier: 2
  },
  "Barbarian Shoes" => {
    name: "Barbarian Shoes",
    type: "Boots",
    id: 0x134,
    progression: false,
    tier: 3
  },
  "Knight Leggings" => {
    name: "Knight Leggings",
    type: "Boots",
    id: 0x135,
    progression: false,
    tier: 2
  },
  "Crimson Greaves" => {
    name: "Crimson Greaves",
    type: "Boots",
    id: 0x136,
    progression: false,
    tier: 2
  },
  "Valkyrie Greaves" => {
    name: "Valkyrie Greaves",
    type: "Boots",
    id: 0x137,
    progression: false,
    tier: 3
  },
  "Minerva Greaves" => {
    name: "Minerva Greaves",
    type: "Boots",
    id: 0x138,
    progression: false,
    tier: 4
  },
  "Protect Ring" => {
    name: "Protect Ring",
    type: "Ring",
    progression: false,
    id: 0x13a,
    tier: 1
  },
  "Resist Ring" => {
    name: "Resist Ring",
    type: "Ring",
    progression: false,
    id: 0x13b,
    tier: 0
  },
  "Fool Ring" => {
    name: "Fool Ring",
    type: "Ring",
    progression: false,
    id: 0x13c,
    tier: 0
  },
  "Magician Ring" => {
    name: "Magician Ring",
    type: "Ring",
    progression: false,
    id: 0x13d,
    tier: 3
  },
  "Priestess Ring" => {
    name: "Priestess Ring",
    type: "Ring",
    progression: false,
    id: 0x13e,
    tier: 1
  },
  "Empress Ring" => {
    name: "Empress Ring",
    type: "Ring",
    progression: false,
    id: 0x13f,
    tier: 3
  },
  "Emperor Ring" => {
    name: "Emperor Ring",
    type: "Ring",
    progression: false,
    id: 0x140,
    tier: 1
  },
  "Hierophant Ring" => {
    name: "Hierophant Ring",
    type: "Ring",
    progression: false,
    id: 0x141,
    tier: 1
  },
  "Lovers Ring" => {
    name: "Lovers Ring",
    type: "Ring",
    progression: false,
    id: 0x142,
    tier: 1
  },
  "Chariot Ring" => {
    name: "Chariot Ring",
    type: "Ring",
    progression: false,
    id: 0x143,
    tier: 3
  },
  "Justice Ring" => {
    name: "Justice Ring",
    type: "Ring",
    progression: false,
    id: 0x144,
    tier: 0
  },
  "Hermit Ring" => {
    name: "Hermit Ring",
    type: "Ring",
    progression: false,
    id: 0x145,
    tier: 3
  },
  "Fortune Ring" => {
    name: "Fortune Ring",
    type: "Ring",
    progression: false,
    id: 0x146,
    tier: 0
  },
  "Strength Ring" => {
    name: "Strength Ring",
    type: "Ring",
    progression: false,
    id: 0x147,
    tier: 3
  },
  "Hanged Man Ring" => {
    name: "Hanged Man Ring",
    type: "Ring",
    progression: false,
    id: 0x148,
    tier: 2
  },
  "Death Ring" => {
    name: "Death Ring",
    type: "Ring",
    progression: false,
    id: 0x149,
    tier: 5
  },
  "Temperance Ring" => {
    name: "Temperance Ring",
    type: "Ring",
    progression: false,
    id: 0x14A,
    tier: 3
  },
  "Devil Ring" => {
    name: "Devil Ring",
    type: "Ring",
    progression: false,
    id: 0x14B,
    tier: 0
  },
  "Tower Ring" => {
    name: "Tower Ring",
    type: "Ring",
    progression: false,
    id: 0x14c,
    tier: 2
  },
  "Star Ring" => {
    name: "Star Ring",
    type: "Ring",
    progression: false,
    id: 0x14d,
    tier: 3
  },
  "Moon Ring" => {
    name: "Moon Ring",
    type: "Ring",
    progression: false,
    id: 0x14e,
    tier: 4
  },
  "Sun Ring" => {
    name: "Sun Ring",
    type: "Ring",
    progression: false,
    id: 0x14f,
    tier: 4
  },
  "Judgement Ring" => {
    name: "Judgement Ring",
    type: "Ring",
    progression: false,
    id: 0x150,
    tier: 5
  },
  "World Ring" => {
    name: "World Ring",
    type: "Ring",
    progression: false,
    id: 0x151,
    tier: 4
  },
  "Archer Ring" => {
    name: "Archer Ring",
    type: "Ring",
    progression: false,
    id: 0x152,
    tier: 1
  },
  "Blow Ring" => {
    name: "Blow Ring",
    type: "Ring",
    progression: false,
    id: 0x153,
    tier: 3
  },
  "Wind Ring" => {
    name: "Wind Ring",
    type: "Ring",
    progression: false,
    id: 0x154,
    tier: 3
  },
  "Ruby Ring" => {
    name: "Ruby Ring",
    type: "Ring",
    progression: false,
    id: 0x155,
    tier: 2
  },
  "Sapphire Ring" => {
    name: "Sapphire Ring",
    type: "Ring",
    progression: false,
    id: 0x156,
    tier: 1
  },
  "Emerald Ring" => {
    name: "Emerald Ring",
    type: "Ring",
    progression: false,
    id: 0x157,
    tier: 1
  },
  "Diamond Ring" => {
    name: "Diamond Ring",
    type: "Ring",
    progression: false,
    id: 0x158,
    tier: 2
  },
  "Onyx Ring" => {
    name: "Onyx Ring",
    type: "Ring",
    progression: false,
    id: 0x159,
    tier: 1
  },
  "Heart Earrings" => {
    name: "Heart Earrings",
    type: "Ring",
    progression: false,
    id: 0x15a,
    tier: 1
  },
  "Gold Ring" => {
    name: "Gold Ring",
    type: "Ring",
    progression: false,
    id: 0x15b,
    tier: 0
  },
  "Miser Ring" => {
    name: "Miser Ring",
    type: "Ring",
    progression: false,
    id: 0x15c,
    tier: 0
  },
  "Lucky Clover" => {
    name: "Lucky Clover",
    type: "Ring",
    progression: false,
    id: 0x15d,
    tier: 1
  },
  "Thief Ring" => {
    name: "Thief Ring",
    type: "Ring",
    progression: false,
    id: 0x15e,
    tier: 2
  },
  "Master Ring" => {
    name: "Master Ring",
    type: "Ring",
    progression: false,
    id: 0x15f,
    tier: 0
  },
}
end

def self.consumables
 consumables = {
  "Potion" => {
    name: "Potion",
    type: "Health",
    id: 0x75
  },
  "High Potion" => {
    name: "High Potion",
    type: "Health",
    id: 0x76
  },
  "Super Potion" => {
    name: "Super Potion",
    type: "Health",
    id: 0x77
  },
  "Tonic" => {
    name: "Tonic",
    type: "Mana",
    id: 0x78
  },
  "High Tonic" => {
    name: "High Tonic",
    type: "Mana",
    id: 0x79
  },
  "Super Tonic" => {
    name: "Super Tonic",
    type: "Mana",
    id: 0x7a
  },
  "Heart Repair" => {
    name: "Tonic",
    type: "Hearts",
    id: 0x7b
  },
  "Uncurse Potion" => {
    name: "Uncurse Potion",
    type: "Other",
    id: 0x7e
  },
  "Meat" => {
    name: "Meat",
    type: "Health",
    id: 0x82
  },
  "Tasty Meat" => {
    name: "Tasty Meat",
    type: "Health",
    id: 0x83
  },
  "Thick Steak" => {
    name: "Thick Steak",
    type: "Health",
    id: 0x84
  },
  "Raw Killer Fish" => {
    name: "Raw Killer Fish",
    type: "Health",
    id: 0x85
  },
  "Rice Ball" => {
    name: "Rice Ball",
    type: "Health",
    id: 0x86
  },
  "Corn Soup" => {
    name: "Tasty Meat",
    type: "Health",
    id: 0x88
  },
  "Minestrone" => {
    name: "Minestrone",
    type: "Health",
    id: 0x89
  },
  "Curry" => {
    name: "Curry",
    type: "Health",
    id: 0x8a
  },
  "Ramen Noodles" => {
    name: "Ramen Noodles",
    type: "Health",
    id: 0x8b
  },
  "Cream Puff" => {
    name: "Cream Puff",
    type: "Health",
    id: 0x8c
  },
  "Pudding" => {
    name: "Pudding",
    type: "Health",
    id: 0x8d
  },
  "Mocha Eclair" => {
    name: "Mocha Eclair",
    type: "Health",
    id: 0x8e
  },
  "Tart Tatin" => {
    name: "Tart Tatin",
    type: "Health",
    id: 0x8f
  },
  "Choco Souffle" => {
    name: "Choco Souffle",
    type: "Health",
    id: 0x90
  },
  "Crepes Suzette" => {
    name: "Curry",
    type: "Health",
    id: 0x91
  },
  "Croque Monsieur" => {
    name: "Croque Monsieur",
    type: "Health",
    id: 0x92
  },
  "Killer Fish BBQ" => {
    name: "Killer Fish BBQ",
    type: "Health",
    id: 0x95
  },
  "Mint Sundae" => {
    name: "Mint Sundae",
    type: "Hearts",
    id: 0x97
  },
  "Milk" => {
    name: "Milk",
    type: "Hearts",
    id: 0x98
  },
  "Coffee" => {
    name: "Coffee",
    type: "Hearts",
    id: 0x99
  },
  "Earl Grey" => {
    name: "Earl Grey",
    type: "Hearts",
    id: 0x9a
  },
  "Darjeeling Tea" => {
    name: "Darjeeling Tea",
    type: "Hearts",
    id: 0x9b
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
    id: 0xa1
  },
  "Rotten Meat" => {
    name: "Rotten Meat",
    type: "Other",
    id: 0xa2
  },
  "Spoiled Milk" => {
    name: "Spoiled Milk",
    type: "Other",
    id: 0xa3
  },
  "Schnitzel" => {
    name: "Schnitzel",
    type: "Health",
    id: 0x93
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
  "Book of Spirits" => {
    name: "Book of Spirits",
    type: "Relic",
    id: 0x74,
    progression: false
  },
  "Lizard Tail" => {
    name: "Lizard Tail",
    type: "Relic",
    id: 0x6f,
    start_with: true
  },
  "Glyph Sleeve" => {
    name: "Glyph Sleeve",
    type: "Relic",
    id: 0x73,
    start_with: true
  },
  "Glyph Union" => {
    name: "Glyph Union",
    type: "Relic",
    id: 0x72,
    start_with: true
  }
  }
end

def self.materials
  materials = {
  "Mouse" => {
    name: "Mouse",
    type: "Quest",
    id: 0xac
  },
  "Cat Collar" => {
    name: "Cat Collar",
    type: "Quest",
    id: 0xad
  },
  "Camera" => {
    name: "Camera",
    type: "Quest",
    id: 0xae
  },
  "Photo 1" => {
    name: "Photo 1",
    type: "Quest",
    id: 0xaf
  },
  "Photo 2" => {
    name: "Photo 2",
    type: "Quest",
    id: 0xb0
  },
  "Photo 3" => {
    name: "Photo 3",
    type: "Quest",
    id: 0xb1
  },
  "\"Frontier\" Issue 1" => {
    name: "\"Frontier\" Issue 1",
    type: "Quest",
    id: 0xb3
  },
  "\"Frontier\" Issue 2" => {
    name: "\"Frontier\" Issue 2",
    type: "Quest",
    id: 0xb4
  },
  "\"Frontier\" Final" => {
    name: "\"Frontier\" Final",
    type: "Quest",
    id: 0xb5
  },
  "Sketchbook" => {
    name: "Sketchbook",
    type: "Quest",
    id: 0xb6
  },
  "Lighthouse Art" => {
    name: "Lighthouse Art",
    type: "Quest",
    id: 0xb7
  },
  "Waterfall Art" => {
    name: "Waterfall Art",
    type: "Quest",
    id: 0xb8
  },
  "Church Art" => {
    name: "Church Art",
    type: "Quest",
    id: 0xb9
  },
  "Horse Hair" => {
    name: "Horse Hair",
    type: "Quest",
    id: 0xba
  },
  "Eagle Feather" => {
    name: "Eagle Feather",
    type: "Quest",
    id: 0xbb
  },
  "Black Ink" => {
    name: "Black Ink",
    type: "Quest",
    id: 0xbc
  },
  "Cotton Thread" => {
    name: "Cotton Thread",
    type: "Quest",
    id: 0xbd
  },
  "Silk Thread" => {
    name: "Silk Thread",
    type: "Quest",
    id: 0xbe
  },
  "Cashmere Thread" => {
    name: "Cashmere Thread",
    type: "Quest",
    id: 0xbf
  },
  "Salt" => {
    name: "Salt",
    type: "Quest",
    id: 0x96
  },
  "Sage" => {
    name: "Sage",
    type: "Quest",
    id: 0xc0
  },
  "Chamomile" => {
    name: "Chamomile",
    type: "Quest",
    id: 0xc1
  },
  "Rue" => {
    name: "Rue",
    type: "Quest",
    id: 0xc2
  },
  "Mandrake Root" => {
    name: "Mandrake Root",
    type: "Quest",
    id: 0xc3
  },
  "Merman Meat" => {
    name: "Merman Meat",
    type: "Quest",
    id: 0xc4
  },
  "Zircon" => {
    name: "Zircon",
    type: "Quest",
    id: 0xc5
  },
  "Lapis Lazuli" => {
    name: "Lapis Lazuli",
    type: "Quest",
    id: 0xc6
  },
  "Chrysoberyl" => {
    name: "Chrysoberyl",
    type: "Quest",
    id: 0xc7
  },
  "Ruby" => {
    name: "Ruby",
    type: "Quest",
    id: 0xc8
  },
  "Sapphire" => {
    name: "Sapphire",
    type: "Quest",
    id: 0xc9
  },
  "Emerald" => {
    name: "Emerald",
    type: "Quest",
    id: 0xca
  },
  "Onyx" => {
    name: "Onyx",
    type: "Quest",
    id: 0xcb
  },
  "Diamond" => {
    name: "Diamond",
    type: "Quest",
    id: 0xcc
  },
  "Alexandrite" => {
    name: "Alexandrite",
    type: "Quest",
    id: 0xcd
  },
  "Copper Ore" => {
    name: "Copper Ore",
    type: "Quest",
    id: 0xce
  },
  "Iron Ore" => {
    name: "Iron Ore",
    type: "Quest",
    id: 0xcf
  },
  "Silver Ore" => {
    name: "Silver Ore",
    type: "Quest",
    id: 0xd0
  },
  "Gold Ore" => {
    name: "Gold Ore",
    type: "Quest",
    id: 0xd1
  },
  "VIP Card" => {
    name: "VIP Card",
    type: "Bonus",
    id: 0xd2
  },
  "Konami Man" => {
    name: "Konami Man",
    type: "Bonus",
    id: 0xd3
  },
  "Twinbee" => {
    name: "Twinbee",
    type: "Bonus",
    id: 0xd4
  },
  "Vic Viper" => {
    name: "Vic Viper",
    type: "Bonus",
    id: 0xd5
  },
  "Phonograph" => {
    name: "Phonograph",
    type: "Quest",
    id: 0xd6
  },
  "Record 1" => {
    name: "Record 1",
    type: "Bonus",
    id: 0xa4
  },
  "Record 2" => {
    name: "Record 2",
    type: "Bonus",
    id: 0xa5
  },
  "Record 3" => {
    name: "Record 3",
    type: "Bonus",
    id: 0xa6
  },
  "Record 4" => {
    name: "Record 4",
    type: "Bonus",
    id: 0xa7
  },
  "Record 5" => {
    name: "Record 5",
    type: "Bonus",
    id: 0xa8
  },
  "Record 6" => {
    name: "Record 6",
    type: "Bonus",
    id: 0xa9
  },
  "Record 7" => {
    name: "Record 7",
    type: "Bonus",
    id: 0xaa
  },
  "Record 8" => {
    name: "Record 8",
    type: "Bonus",
    id: 0xab
  }
  }
end

def self.undroppables
  return @@undroppables
end

def self.extra_item(k, v)
  @@total_items[k] = v
  @@undroppables[k] = v
end

@@total_items = self.glyphs.merge(equipment).merge(relics).merge(consumables).merge(materials)
@@undroppables = self.relics

end