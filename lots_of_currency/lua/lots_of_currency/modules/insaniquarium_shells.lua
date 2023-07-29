-- no workhsop items, comes as an example

local generic_collect = {"insaniquarium_shells/POINTS1.wav", "insaniquarium_shells/POINTS2.wav", "insaniquarium_shells/POINTS3.wav", "insaniquarium_shells/POINTS4.wav"}

-- TODO: make the shells resize based on their sprite dimensions
LotsOfCurrency.RegisterDenomination(
  "insaniquarium_shells",
  {
    ents = {
      "insaniquarium_cashshells_treasure_chest",
      "insaniquarium_cashshells_pearl",
      "insaniquarium_cashshells_diamond",
      "insaniquarium_cashshells_beetle",
      "insaniquarium_cashshells_star",
      "insaniquarium_cashshells_gold_coin",
      "insaniquarium_shells_bag",
      "insaniquarium_cashshells_silver_coin",
      "insaniquarium_shells_spiral",
      "insaniquarium_shells_blue",
      "insaniquarium_shells_gold",
      "insaniquarium_shells_silver"
    },
    values = {2000, 500, 200, 150, 40, 35, 20, 15, 10, 5, 2, 1},
  },
  {
    insaniquarium_cashshells_treasure_chest = {
      PrintName = "Treasure Chest",
      Worth = 2000,
      SpriteMaterial = "sprites/insaniquarium_cashshells/shellcash_treasure_chest",
      CollectNoises	= {"insaniquarium_shells/TREASURE.wav"},
      HullSize = 32,
    },
    insaniquarium_cashshells_pearl = {
      PrintName = "Pearl",
      Worth = 500,
      SpriteMaterial = "sprites/insaniquarium_cashshells/shellcash_pearl",
      CollectNoises = generic_collect,
      HullSize = 32,
    },
    insaniquarium_cashshells_diamond = {
      PrintName = "Diamond",
      Worth = 200,
      SpriteMaterial = "sprites/insaniquarium_cashshells/shellcash_diamond",
      CollectNoises = {"insaniquarium_shells/diamond.wav"},
    },
    insaniquarium_cashshells_beetle = {
      PrintName = "Beetle",
      Worth = 150,
      SpriteMaterial = "sprites/insaniquarium_cashshells/shellcash_beetle",
      CollectNoises = generic_collect,
      HullSize = 32,
    },
    insaniquarium_cashshells_star = {
      PrintName = "Star",
      Worth = 40,
      SpriteMaterial = "sprites/insaniquarium_cashshells/shellcash_star",
      CollectNoises = generic_collect,
      HullSize = 32,
    },
    insaniquarium_cashshells_gold_coin = {
      PrintName = "Gold Coin",
      Worth = 35,
      SpriteMaterial = "sprites/insaniquarium_cashshells/shellcash_gold_coin",
      CollectNoises = generic_collect,
    },
    insaniquarium_shells_bag = {
      PrintName = "Bag O' Shells",
      Worth = 20,
      SpriteMaterial = "sprites/insaniquarium_shells/shell_bag",
      CollectNoises = generic_collect,
      HullSize = 32,
    },
    insaniquarium_cashshells_silver_coin = {
      PrintName = "Silver Coin",
      Worth = 15,
      SpriteMaterial = "sprites/insaniquarium_cashshells/shellcash_silver_coin",
      CollectNoises = generic_collect,
    },
    insaniquarium_shells_spiral = {
      PrintName = "Silver Spiral Shell",
      Worth = 10,
      SpriteMaterial = "sprites/insaniquarium_shells/shell_spiral",
      CollectNoises = generic_collect,
    },
    insaniquarium_shells_blue = {
      PrintName = "Blue Conch Shell",
      Worth = 5,
      SpriteMaterial = "sprites/insaniquarium_shells/shell_blue",
      CollectNoises = generic_collect,
    },
    insaniquarium_shells_gold = {
      PrintName = "Gold Shell",
      Worth = 2,
      SpriteMaterial = "sprites/insaniquarium_shells/shell_gold",
      CollectNoises = generic_collect,
    },
    insaniquarium_shells_silver = {
      PrintName = "Silver Shell",
      Worth = 1,
      SpriteMaterial = "sprites/insaniquarium_shells/shell_silver",
      CollectNoises = generic_collect,
    },
  }
)
