if !LotsOfCurrency.HasWorkshopItem("377654698") then return end

LotsOfCurrency.RegisterDenomination(
  "luigis_mansion_money",
  {
    ents = {
      "luigis_mansion_gold_diamond",
      "luigis_mansion_silver_diamond",
      {"luigis_mansion_red_jewel", "luigis_mansion_big_pearl"},
      "luigis_mansion_green_jewel",
      "luigis_mansion_blue_jewel",
      {"luigis_mansion_gold_bar", "luigis_mansion_medium_pearl"},
      "luigis_mansion_small_pearl",
      -- "luigis_mansion_bill",
      {
        ["luigis_mansion_coin"] = 1000,
        ["luigis_mansion_red_diamond"] = 10,
        ["luigis_mansion_king_boos_crown"] = 1,
      },
    },
    values = {
      20000000,
      2000000,
      1000000,
      800000,
      500000,
      100000,
      50000,
      --20000,
      5000,
    },
  },
  {
    luigis_mansion_gold_diamond = {
      PrintName = "Gold Diamond",
      Model = "models/brewstersmodels/luigis_mansion/diamond.mdl",
      Skin = 2,
      Worth = 20000000,
      CollectNoises = {"hl1/fvox/bell.wav"},
    },
    luigis_mansion_silver_diamond = {
      PrintName = "Silver Diamond",
      Model = "models/brewstersmodels/luigis_mansion/diamond.mdl",
      Skin = 1,
      Worth = 2000000,
      CollectNoises = {"hl1/fvox/bell.wav"},
    },
    luigis_mansion_red_jewel = {
      PrintName = "Red Jewel",
      Model = "models/brewstersmodels/luigis_mansion/stone.mdl",
      Skin = 2,
      Worth = 1000000,
      CollectNoises = {"hl1/fvox/bell.wav"},
    },
    luigis_mansion_big_pearl = {
      PrintName = "Big Pearl",
      Model = "models/brewstersmodels/luigis_mansion/pearl(large).mdl",
      Worth = 1000000,
      CollectNoises = {"hl1/fvox/bell.wav"},
    },
    luigis_mansion_green_jewel = {
      PrintName = "Green Jewel",
      Model = "models/brewstersmodels/luigis_mansion/stone.mdl",
      Skin = 0,
      Worth = 800000,
      CollectNoises = {"hl1/fvox/bell.wav"},
    },
    luigis_mansion_blue_jewel = {
      PrintName = "Blue Jewel",
      Model = "models/brewstersmodels/luigis_mansion/stone.mdl",
      Skin = 1,
      Worth = 500000,
      CollectNoises = {"hl1/fvox/bell.wav"},
    },
    luigis_mansion_gold_bar = {
      PrintName = "Gold Bar",
      Model = "models/brewstersmodels/luigis_mansion/gold_bar.mdl",
      Worth = 100000,
      CollectNoises = {"hl1/fvox/bell.wav"},
    },
    luigis_mansion_medium_pearl = {
      PrintName = "Medium Pearl",
      Model = "models/brewstersmodels/luigis_mansion/pearl(medium).mdl",
      Worth = 100000,
      CollectNoises = {"hl1/fvox/bell.wav"},
    },
    luigis_mansion_small_pearl = {
      PrintName = "Small Pearl",
      Model = "models/brewstersmodels/luigis_mansion/pearl(small).mdl",
      Worth = 50000,
      CollectNoises = {"hl1/fvox/bell.wav"},
    },
    -- luigis_mansion_bill = {
    --   PrintName = "Bill",
    --   Model = "models/brewstersmodels/luigis_mansion/coin.mdl",
    --   Worth = 20000,
    --   CollectNoises = {"hl1/fvox/bell.wav"},
    -- },
    luigis_mansion_king_boos_crown = {
      PrintName = "King Boo's Crown",
      Model = "models/brewstersmodels/luigis_mansion/king_boo_crown.mdl",
      Worth = 5000,
      CollectNoises = {"hl1/fvox/bell.wav"},
    },
    luigis_mansion_red_diamond = {
      PrintName = "Red Diamond",
      Model = "models/brewstersmodels/luigis_mansion/diamond.mdl",
      Skin = 2,
      Worth = 5000,
      CollectNoises = {"hl1/fvox/bell.wav"},
    },
    luigis_mansion_coin = {
      PrintName = "Coin",
      Model = "models/brewstersmodels/luigis_mansion/coin.mdl",
      Worth = 5000,
      CollectNoises = {"hl1/fvox/bell.wav"},
    },
  }
)