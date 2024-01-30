include("shared.lua")
local pearl
function ENT:Initialize()



end
function ENT:Draw()
  pearl = Material("models/weapons/weapon_ttt_enderpearl/enddust" .. self:GetNWInt( "skin" ) .. ".png", "smooth mips")
  render.SetMaterial( pearl )
  render.DrawSprite(self:GetPos(), 16, 16)
end
-- hmm