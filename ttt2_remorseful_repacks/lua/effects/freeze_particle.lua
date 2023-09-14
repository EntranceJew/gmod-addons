local mat = Material( "effects/spark" )
local amount = 5 -- how many particles per shot
local dietime = 0.45 -- how fast particles die
function EFFECT:Init( data )
	local mr,mR,vr=math.random,math.Rand,VectorRand
	local StartPos = self:GetTracerShootPos(data:GetStart(), data:GetEntity(), data:GetAttachment())
	local EndPos = data:GetOrigin()
	self:SetRenderBoundsWS( StartPos, EndPos )
	self.Color = Color(125, 155, 255, 255)
	local emitter = ParticleEmitter(StartPos) 
	for i = 0, mr(4,11) do
		local rand = mr(1,16)
		local particle = emitter:Add("particles/snow.vmt"..(rand < 10 and "0"..rand or rand), StartPos + VectorRand() * 1)
		particle:SetVelocity((EndPos - StartPos):GetNormal() * mr(100, 700))
		particle:SetDieTime(dietime)
		particle:SetStartAlpha(100)
		particle:SetEndAlpha(0)
		particle:SetStartSize(mR(20, 40))
		particle:SetEndSize(mR(30, 50))  
		particle:SetRoll(0)
		particle:SetRollDelta(0)
		particle:SetAirResistance(0)
		local g = mr(180, 230)
		particle:SetColor(g, g, mr(200,235))
	end
	for i = 0, mr(4,11) do
		local rand = mr(1,16)
		local particle = emitter:Add("particles/freeze_cloud.vmt"..(rand < 10 and "0"..rand or rand), StartPos + VectorRand() * 1)
		particle:SetVelocity((EndPos - StartPos):GetNormal() * mr(100, 700))
		particle:SetDieTime(dietime)
		particle:SetStartAlpha(100)
		particle:SetEndAlpha(0)
		particle:SetStartSize(mR(20, 40))
		particle:SetEndSize(mR(30, 50))  
		particle:SetRoll(0)
		particle:SetRollDelta(0)
		particle:SetAirResistance(0)
		local g = mr(180, 230)
		particle:SetColor(g, g, mr(200,235))
	end
	emitter:Finish()
end
function EFFECT:Think()
	return false
end
function EFFECT:Render()
end