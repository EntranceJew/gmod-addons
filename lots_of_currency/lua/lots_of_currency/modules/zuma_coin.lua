LotsOfCurrency.RegisterDenomination(
  "zuma_coin",
  {
    ents = {"zuma_coin",},
    values = {10},
  },
  {
    zuma_coin = {
      PrintName = "Zuma Coin",
      SpriteMaterial = "sprites/zuma_coin/zuma_coin",
      CollectNoises = {"zuma_coin/zuma_coin_grab.ogg"},
      SpawnNoises = {"zuma_coin/zuma_coin_appear.ogg"},
      HullSize = 24,
    },
  }
)