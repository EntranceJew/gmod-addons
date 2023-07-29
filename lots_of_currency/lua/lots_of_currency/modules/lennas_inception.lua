if !LotsOfCurrency.HasWorkshopItem("357286512") then return end

LotsOfCurrency.RegisterDenomination(
  "lennas_inception_32bit",
  {
    ents = {"lennas_inception_32bit_coin"},
    values = {1},
  },
  {
    lennas_inception_32bit_coin = {
      PrintName = "Coin",
      Worth = 1,
      SpriteMaterial = "sprites/lennas_inception/32bit/lennas_inception_32bit_coin",
      HullSize = 8,
      BounceNoises = {"lennas_inception/8bit/bounce-item.wav"},
      CollectNoises = {"lennas_inception/8bit/pickup-coin.wav"},
      -- SpriteColor = Color(255,255,0),
      -- EnergeticBounce = true,
    }
  }
)
