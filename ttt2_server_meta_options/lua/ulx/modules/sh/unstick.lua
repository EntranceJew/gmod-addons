local CATEGORY_NAME = "Utility"

send_messages = send_messages or function(v, message)
	if type(v) == "Players" then
		v:ChatPrint(message)
	elseif type(v) == "table" then
		for i = 1, #v do
			v[i]:ChatPrint(message)
		end
	end
end

local function is_valid_ply_pos(pos, hull)
	-- check if in the world with util.IsInWorld
	if not util.IsInWorld(pos) then
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

local function find_valid_pos(initPos, hull, radius, maxChecks)
	-- get info from the arguments
	local searchRadius = radius or 180
	local maxAttempts = maxChecks or 60

	-- check if the spawn position is valid
	if is_valid_ply_pos(initPos, hull) then
		return initPos
	end

	-- try to find a valid position in a random direction
	for _ = 1, maxAttempts do
		local genPos = initPos + Vector(math.random(-searchRadius, searchRadius), math.random(-searchRadius, searchRadius), math.random(-searchRadius, searchRadius) )
		local validPos = is_valid_ply_pos(genPos, hull)
		if validPos then
			return validPos
		end
	end

	-- if no valid position was found, return false
	return false
end

local function unstick(calling_ply, target_plys, max_distance, max_tries)
	local affected_plys = {}
	local unaffected_plys = {}
	local caller_admin = ULib.ucl.query(calling_ply, "ulx unstick")

	if not caller_admin or not target_plys then
		target_plys = {calling_ply}
	end

	for i = 1, #target_plys do
		local ply = target_plys[i]
		if (not IsValid(ply) or not ply:IsPlayer() or not ply:Alive()) then
			ULib.tsayError(calling_ply, ply:Nick() .. " is dead, cannot unstick them.", true)
			continue
		end

		if (not caller_admin and ply.last_unstick and ply.last_unstick > CurTime() and calling_ply == ply) then
			local rest = math.Round(ply.last_unstick - CurTime())
			send_messages(ply, "Can't unstick you again for " .. rest .. " second(s)!")
			return
		end
		ply.last_unstick = CurTime() + 60

		local bottom, top = ply:GetHull()
		local pos = find_valid_pos(ply:GetPos(), {bottom = bottom, top = top}, max_distance, max_tries)
		if (pos) then
			ply:SetPos(pos)
			table.insert(affected_plys, ply)
		else
			table.insert(unaffected_plys, ply)
		end
	end

	if #affected_plys > 0 then
		ulx.fancyLogAdmin(calling_ply, "#A unstuck #T", affected_plys)
		send_messages(affected_plys, "Your were unstuck!")
	end
	if #unaffected_plys > 0 then
		for _, v in ipairs(unaffected_plys) do
			ULib.tsayError(calling_ply, v:Nick() .. " cannot be unstuck.", true)
		end

		ulx.fancyLogAdmin(calling_ply, "#A couldn't unstick #T", unaffected_plys)
	end
end

local unstickcmd = ulx.command(CATEGORY_NAME, "ulx unstick", unstick, "!unstick")
unstickcmd:addParam{type = ULib.cmds.PlayersArg}
unstickcmd:addParam{type = ULib.cmds.NumArg, min = 0, default = 96, hint = "max_distance", ULib.cmds.optional}
unstickcmd:addParam{type = ULib.cmds.NumArg, min = 1, default = 20, hint = "max_tries", ULib.cmds.optional}
unstickcmd:defaultAccess(ULib.ACCESS_ADMIN)
unstickcmd:help("Unsticks target(s) within a max range and max attempt count.")

local unstuckcmd = ulx.command(CATEGORY_NAME, "ulx unstuck", unstick, "!unstuck")
unstuckcmd:defaultAccess(ULib.ACCESS_ALL)
unstuckcmd:help("Attempts to unstick yourself.")