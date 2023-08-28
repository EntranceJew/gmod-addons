local config = {
	cooldown = 60,
	maxDistance = 96,
	maxTry = 20,
}

local function isValidPlyPos(pos, hull)
	-- check if in the world with util.IsInWorld
	if !util.IsInWorld(pos) then
		return false
	end

	-- made a box trace to check if the position is available
	local trace = util.TraceHull({
		start = pos + (hull.bottom or Vector(-16, -16, 0)), -- start the trace from the bottom-front-left
		endpos = pos + (hull.top or Vector(16, 16, 72)), -- end the trace at the top-back-right
	})

	-- if the trace hit something, then the position is not available
	if trace.Hit then
		-- identify the entity that was hit
		-- local ent = trace.Entity
		-- ply:ChatPrint("[UNSTUCK] An entity '" .. ent:GetClass() .. "' was in your way.")
		return false
	end

	return pos
end

local function findValidPos(initPos, hull, radius, maxChecks)
	-- get info from the arguments
	local searchRadius = radius or 180
	local maxAttempts = maxChecks or 60

	-- check if the spawn position is valid
	if isValidPlyPos(initPos, hull) then
		return initPos
	end

	-- try to find a valid position in a random direction
	for i = 1, maxAttempts do
		local genPos = initPos + Vector(math.random(-searchRadius, searchRadius), math.random(-searchRadius, searchRadius), math.random(-searchRadius, searchRadius) )
		local validPos = isValidPlyPos(genPos, hull)
		if validPos then
			return validPos
		end
	end

	-- if no valid position was found, return false
	return false
end

local function unstuckMe(ply)
	-- verify if valid player
	if (!IsValid(ply) or !ply:IsPlayer()) then
		return
	end
	-- verify if cooldown
	if (ply.lastUnstuck && ply.lastUnstuck > CurTime()) then
		local rest = math.Round(ply.lastUnstuck - CurTime())
		ply:ChatPrint("[UNSTUCK] Can't unstick you again for " .. rest .. " second(s)!")
		-- sendMsg(ply, "cooldown", { rest })
		return
	end
	ply.lastUnstuck = CurTime() + config.cooldown
	-- find a valid pos
	local bottom, top = ply:GetHull()
	local pos = findValidPos(ply:GetPos(), {bottom = bottom, top = top}, config.maxDistance, config.maxTry)
	if (pos) then
		ply:SetPos(pos)
		-- sendMsg(ply, "unstuck")
		ply:ChatPrint("[UNSTUCK] You're free!")
	else
		-- sendMsg(ply, "fail")
		ply:ChatPrint("[UNSTUCK] Couldn't unstick you, try again later.")
	end
end

hook.Remove( "PlayerSay", "TTT2_UnstuckPlayerExpensive" )
hook.Add( "PlayerSay", "TTT2_UnstuckPlayerExpensive", function( ply, text )
	if text == "!unstuck" then
		unstuckMe(ply)
		return false
	end
end )