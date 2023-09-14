ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "EndDust"
ENT.Spawnable = true;
function ENT:SetupDataTables()
  self:SetNWFloat("Time",CurTime())
  self:SetNWInt("skin", math.random(1,3))
end
ENT.NextEffect = 0.1
