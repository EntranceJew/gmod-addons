if !LotsOfCurrency.HasWorkshopItem("155365906") then return end

LotsOfCurrency.RegisterDenomination(
  "hl2survivor_jewels",
  {
    ents = {"ent_jewel_l","ent_jewel_m","ent_jewel_s",},
    values = {1000,500,100},
  },
  {
    ent_jewel_l = {
      PrintName = "Jewel (Large)",
      Model = "models/jewel/jewel_l.mdl",
      Worth = 1000,
      CollectNoises = {"hl1/fvox/bell.wav"},
    },
    ent_jewel_m = {
      PrintName = "Jewel (Medium)",
      Model = "models/jewel/jewel_m.mdl",
      Worth = 500,
      CollectNoises = {"hl1/fvox/bell.wav"},
    },
    ent_jewel_s = {
      PrintName = "Jewel (Small)",
      Model = "models/jewel/jewel_s.mdl",
      Worth = 100,
      CollectNoises = {"hl1/fvox/bell.wav"},
    },
  }
)