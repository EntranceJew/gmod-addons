
local models = {}

hook.Add("PlayerSpawn", "CacheModels", function()
	models = {}
	for _, ply in ipairs(player.GetAll()) do
		models[tostring(ply)] = tostring(ply:GetModel())
	end
end)


hook.Add("TTTBeginRound", "RoleDistro", function()

	local detectdel = 0
	local defectives = 0
	local players = player.GetAll()
	local hasInfected = false


	for _, ply in ipairs(players) do
		if ply:GetSubRole() == ROLE_INFECTED then
			hasInfected = true
		end
		if ply:GetSubRole() == ROLE_DEFECTIVE then
			ply:SetModel("models/player/elispolice/police.mdl")
		   defectives = defectives + 1
		   detectdel = defectives
		   defectivepresent = true
	   end
	end

	-- for i = #players, 2, -1 do
	-- 	local j = math.random(i)
	-- 	players[i], players[j] = players[j], players[i]
	-- end
	table.Shuffle(players)

	if hasInfected then
		for _, ply in ipairs(player.GetAll()) do
			if  ply:GetSubRole() == ROLE_DEFECTIVE or ply:GetSubRole() == ROLE_TRAITOR then
				ply:SetRole(ROLE_INNOCENT)
				ply:SetModel(models[tostring(ply)])
				ply:SetCredits(0)
				SendFullStateUpdate()
			end
		end
	else
		for _, ply in ipairs(players) do
			if defectives > 0 and ply:GetSubRole() == ROLE_TRAITOR and ply:GetSubRole() ~= ROLE_DEFECTIVE then
				print(tostring(ply) .. tostring(models[tostring(ply)]) .. "wawawawa")
				ply:SetRole(ROLE_INNOCENT)
				ply:SetModel(models[tostring(ply)])
				ply:SetCredits(0)
				defectives = defectives - 1
				SendFullStateUpdate()
			end
		end
		--[[
			if detectdel > 0 then
				if ply:GetSubRole() == ROLE_DETECTIVE then
					print(tostring(ply) .. tostring(models[tostring(ply)]) .. "wawawawa")
					ply:SetRole(ROLE_INNOCENT)
					ply:SetModel(models[tostring(ply)])
					ply:SetCredits(0)
					detectdel = detectdel - 1
					SendFullStateUpdate()
				end
			end
		]]--
	end

	for _, ply in ipairs(players) do
		if ply:GetSubRole() == ROLE_DEFECTIVE then
			ply:SetModel("models/player/elispolice/police.mdl")
		end
		timer.Simple(0, function()
			if (ply:GetSubRole() ~= ROLE_DETECTIVE and ply:GetSubRole() ~= ROLE_DEFECTIVE) then
				ply:SetModel(models[tostring(ply)])
				print(tostring(models[tostring(ply)]))
			end
		end)
	end

	SendFullStateUpdate()
end)