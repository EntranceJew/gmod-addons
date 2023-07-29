if !LotsOfCurrency.HasWorkshopItem("813137944") then return end

LotsOfCurrency.RegisterDenomination(
  "wario_world_coins",
  {
    ents = {"wario_world_coin_large","wario_world_coin_medium","wario_world_coin_small",},
    values = {1000,500,100},
  },
  {
    wario_world_coin_large = {
      PrintName = "Jewel (Large)",
      Model = "models/brewstersmodels/wario_world/treasure_coin(large).mdl",
      Worth = 1000,
      CollectNoises = {"hl1/fvox/bell.wav"},
    },
    wario_world_coin_medium = {
      PrintName = "Jewel (Medium)",
      Model = "models/brewstersmodels/wario_world/treasure_coin(medium).mdl",
      Worth = 500,
      CollectNoises = {"hl1/fvox/bell.wav"},
    },
    wario_world_coin_small = {
      PrintName = "Jewel (Small)",
      Model = "models/brewstersmodels/wario_world/treasure_coin(small).mdl",
      Worth = 100,
      CollectNoises = {"hl1/fvox/bell.wav"},
    },
  }
)