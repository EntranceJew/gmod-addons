if !LotsOfCurrency.HasWorkshopItem("2078014442") then return end

-- TODO: find noises for this, the models are too good for placeholders :(
LotsOfCurrency.RegisterDenomination(
  "play_coins",
  {
    ents = {"play_coins_supercoin", "play_coins_five", "play_coins_one"},
    values = {25, 5, 1},
  },
  {
    play_coins_supercoin = {
      PrintName = "Super Playcoin",
      Model = "models/freeman/playcoin_supercoin.mdl",
      Worth = 25,
      CollectNoises = {"spyro_gems/GemGet1.wav"},
      SpawnNoises = {"spyro_gems/Ping1.wav"},
      BounceNoises = {"spyro_gems/Ping1.wav"},
      -- prevent orb from spamming noises
      EnergeticBounce = true,
    },
    play_coins_five = {
      PrintName = "Five Playcoins",
      Model = "models/freeman/playcoin_five.mdl",
      Worth = 5,
      CollectNoises = {"spyro_gems/GemGet1.wav"},
      SpawnNoises = {"spyro_gems/Ping1.wav"},
      BounceNoises = {"spyro_gems/Ping1.wav"},
    },
    play_coins_one = {
      PrintName = "One Playcoin",
      Model = "models/freeman/playcoin_one.mdl",
      Worth = 1,
      CollectNoises = {"spyro_gems/GemGet1.wav"},
      SpawnNoises = {"spyro_gems/Ping1.wav"},
      BounceNoises = {"spyro_gems/Ping1.wav"},
    }
  }
)
