local max,min = Vector(2,2,2),Vector(-2,-2,-2)
local FreezeColor = Color(100,150,255,100)
function EFFECT:Init(data)
	local mR,cm,vr,sred=math.Rand,ClientsideModel,VectorRand,SafeRemoveEntityDelayed
	local pos = data:GetOrigin()
	local norm = data:GetNormal()
	local ent = data:GetEntity()
	local scale = data:GetScale()
	for i=1, math.random(5, 8) do
		local dir = ((norm + vr())*0.75)
		local ent = cm("models/weapons/ice_grenade/shards/ice_shard0"..math.random(1,6)..".mdl", RENDERGROUP_OPAQUE)
		if IsValid(ent) then
			ent:PhysicsInitBox(min, max)
			ent:SetCollisionBounds(min, max)
			ent:SetColor(FreezeColor)
			ent:SetModelScale(mR(0.4,0.7)*scale, 0)
			ent:SetPos(pos + dir*5)
			sred(ent, mR(5, 10))
			local phys = ent:GetPhysicsObject()
			if IsValid(phys) then
				phys:ApplyForceOffset(ent:GetPos()+vr()*6,dir*mR(300, 800))
			end
		end
	end
end
function EFFECT:Think()
	return false
end
function EFFECT:Render()
end