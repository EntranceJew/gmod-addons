if !LotsOfCurrency.HasWorkshopItem("2564379523") then return end

LotsOfCurrency.RegisterDenomination(
  "acnh_bells",
  {
    ents = {"acnh_bells_huge_sack", "acnh_bells_large_sack", "acnh_bells_small_sack", "acnh_bells_large_coin", "acnh_bells_small_coin", "acnh_bells_tiny_coin"},
    values = {99000, 30000, 1000, 100, 10, 1},
  },
  {
    acnh_bells_huge_sack = {
      PrintName = "Huge Sack of Bells",
      Model = "models/catcraze777/animal_crossing/items_acnh/moneybag.mdl",
      ModelScale = 1.25,
      Worth = 99000,
      CollectNoises = {"spyro_gems/GemGet1.wav"},
      BounceNoises = {"spyro_gems/Ping1.wav"},
    },
    acnh_bells_large_sack = {
      PrintName = "Large Sack of Bells",
      Model = "models/catcraze777/animal_crossing/items_acnh/moneybag.mdl",
      Worth = 30000,
      CollectNoises = {"spyro_gems/GemGet1.wav"},
      BounceNoises = {"spyro_gems/Ping1.wav"},
    },
    acnh_bells_small_sack = {
      PrintName = "Small Sack of Bells",
      Model = "models/catcraze777/animal_crossing/items_acnh/moneybag.mdl",
      ModelScale = 0.75,
      Worth = 1000,
      CollectNoises = {"spyro_gems/GemGet1.wav"},
      BounceNoises = {"spyro_gems/Ping1.wav"},
    },
    acnh_bells_large_coin = {
      PrintName = "100 Bell Coin",
      Model = "models/catcraze777/animal_crossing/items_acnh/coin.mdl",
      ModelScale = 1,
      Worth = 100,
      CollectNoises = {"spyro_gems/GemGet1.wav"},
      BounceNoises = {"spyro_gems/Ping1.wav"},
    },
    acnh_bells_small_coin = {
      PrintName = "10 Bell Coin",
      Model = "models/catcraze777/animal_crossing/items_acnh/coin.mdl",
      ModelScale = 0.75,
      Worth = 10,
      CollectNoises = {"spyro_gems/GemGet1.wav"},
      BounceNoises = {"spyro_gems/Ping1.wav"},
    },
    acnh_bells_tiny_coin = {
      PrintName = "1 Bell Coin",
      Model = "models/catcraze777/animal_crossing/items_acnh/coin.mdl",
      ModelScale = 0.5,
      Worth = 1,
      CollectNoises = {"spyro_gems/GemGet1.wav"},
      BounceNoises = {"spyro_gems/Ping1.wav"},
    },
  }
)