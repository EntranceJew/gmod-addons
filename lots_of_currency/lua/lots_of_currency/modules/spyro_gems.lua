if !LotsOfCurrency.HasWorkshopItem("375836289") then return end

LotsOfCurrency.RegisterDenomination(
  "spyro_gems",
  {
    ents = {"spyro_gems_purple", "spyro_gems_yellow", "spyro_gems_blue", "spyro_gems_green", "spyro_gems_red"},
    values = {25, 10, 5, 2, 1},
  },
  {
    spyro_gems_purple = {
      PrintName = "Purple Gem",
      Model = "models/morganicism/spyro/gempurple.mdl",
      Worth = 25,
      CollectNoises = {"spyro_gems/GemGet1.wav"},
      BounceNoises = {"spyro_gems/Ping1.wav"},
    },
    spyro_gems_yellow = {
      PrintName = "Yellow Gem",
      Model = "models/morganicism/spyro/gemyellow.mdl",
      Worth = 10,
      CollectNoises = {"spyro_gems/GemGet1.wav"},
      BounceNoises = {"spyro_gems/Ping1.wav"},
    },
    spyro_gems_blue = {
      PrintName = "Blue Gem",
      Model = "models/morganicism/spyro/gemblue.mdl",
      Worth = 5,
      CollectNoises = {"spyro_gems/GemGet1.wav"},
      BounceNoises = {"spyro_gems/Ping1.wav"},
    },
    spyro_gems_green = {
      PrintName = "Green Gem",
      Model = "models/morganicism/spyro/gemgreen.mdl",
      Worth = 2,
      CollectNoises = {"spyro_gems/GemGet1.wav"},
      BounceNoises = {"spyro_gems/Ping1.wav"},
    },
    spyro_gems_red = {
      PrintName = "Red Gem",
      Model = "models/morganicism/spyro/gemred.mdl",
      Worth = 1,
      CollectNoises = {"spyro_gems/GemGet1.wav"},
      BounceNoises = {"spyro_gems/Ping1.wav"},
    },
  }
)