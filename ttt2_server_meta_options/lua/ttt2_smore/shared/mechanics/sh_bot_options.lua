local feat = {}

if SERVER then
	feat.CheckIfQuotaMet = function()
		local quota = GetConVar("sv_smore_bot_quota"):GetInt()
		if quota <= 0 then return end

		local bots = player.GetBots()
		local plys = player.GetCount()
		if quota > plys then
			RunConsoleCommand(GetConVar("sv_smore_bot_spawn_command"):GetString())
			if quota > plys + 1 and not timer.Exists("sv_smore_bot_quota_timer") then
				timer.Create("sv_smore_bot_quota_timer", 1, 0, feat.CheckIfQuotaMet)
			end
		elseif quota < plys and #bots > 0 then
			bots[1]:Kick("TOO MANY BOTS")
		elseif quota == plys and timer.Exists("sv_smore_bot_quota_timer") then
			timer.Remove("sv_smore_bot_quota_timer")
		end
	end

	feat.FindNearestWeapon = function(ply)
		local nearest = nil
		local nearest_dist = GetConVar("sv_smore_bot_pickup_nearby_range"):GetInt() or math.huge
		for _, weapon in pairs(ents.GetAll()) do
			if weapon:IsWeapon() and weapon:GetOwner() == NULL then
				local dist = ply:GetPos():DistToSqr( weapon:GetPos() )
				if dist < nearest_dist then
					nearest = weapon
					nearest_dist = dist
				end
			end
		end
		return nearest ~= nil, nearest, nearest_dist
	end

	feat.PickupNearbyWeapon = function(ply, weapon)
		local range = GetConVar("sv_smore_bot_pickup_nearby_range"):GetInt()
		if not IsValid(ply) or not ply:IsTerror() or not ply:Alive() or range <= 0 then return end

		local vec1 = weapon:GetPos()
		local vec2 = ply:GetShootPos()
		ply:SetEyeAngles( ( vec1 - vec2 ):Angle() )
		-- local tracedWeapon = ply:GetEyeTrace().Entity

		-- if not IsValid(tracedWeapon) or not tracedWeapon:IsWeapon() then return end
		if ply:GetPos():Distance(weapon:GetPos()) > range then return end

		ply:SafePickupWeapon(weapon, false, true, true, nil)
	end

	feat.BotPickupNearby = function()
		local range = GetConVar("sv_smore_bot_pickup_nearby_range"):GetInt()
		if range <= 0 then return end
		local alive = util.GetAlivePlayers()
		for _, ply in ipairs(alive) do
			if not ply:IsBot() then continue end
			local succ, weapon, dist = feat.FindNearestWeapon(ply)
			if succ and dist <= range then
				print("BPN:",ply,"would really like", weapon)
				feat.PickupNearbyWeapon(ply, weapon)
			end
		end
	end

	feat.SwapRolesAwayFromBots = function(finalRoles)
		if not GetConVar("sv_smore_prevent_bot_roles"):GetBool() then return end
		local un_roled = {}
		for ply, role in pairs(finalRoles) do
			if role == ROLE_INNOCENT and not ply:IsBot() then
				table.insert(un_roled, ply)
			end
		end

		table.Shuffle(un_roled)
		local players = player.GetAll()
		table.Shuffle(players)

		local swap_count = 1
		for _, ply in pairs(players) do
			local role = finalRoles[ply]
			if role ~= ROLE_INNOCENT and role ~= ROLE_NONE and ply:IsBot() and IsValid(un_roled[swap_count]) then
				finalRoles[ply] = ROLE_INNOCENT
				finalRoles[ un_roled[swap_count] ] = role
				swap_count = swap_count + 1
			end
		end
	end

	TTT2SMORE.HookAdd("TTT2ModifyFinalRoles", "prevent_bot_roles", feat.SwapRolesAwayFromBots)
	TTT2SMORE.HookAdd("SMORESlowThink", "bot_quota", feat.CheckIfQuotaMet)
	TTT2SMORE.HookAdd("SMORESlowThink", "bot_pickup_nearby", feat.BotPickupNearby)
	TTT2SMORE.HookAdd("PlayerInitialSpawn", "bot_initial_spawn", function(ply)
		if ply:IsPlayer() and not ply:IsBot() then
			feat.CheckIfQuotaMet()
		end
	end)
	TTT2SMORE.HookAdd("PlayerDisconnected","bot_quota",function(ply)
		if ply:IsPlayer() and not ply:IsBot() then
			feat.CheckIfQuotaMet()
		end
	end)
end

TTT2SMORE.HookAdd("SMORECreateConVars", "prevent_bot_roles", function()
	TTT2SMORE.MakeCVar("prevent_bot_roles", "0")
	TTT2SMORE.MakeCVar("bot_quota", "0")
	TTT2SMORE.MakeCVar("bot_spawn_command", "bot")
	TTT2SMORE.MakeCVar("bot_pickup_nearby_range", "0")
end)

TTT2SMORE.HookAdd("SMOREServerAddonSettings", "prevent_bot_roles", function(parent, general)
	local bot_options = vgui.CreateTTT2Form(parent, "smore_settings_mechanic_bot_options")

	TTT2SMORE.MakeElement(bot_options, "prevent_bot_roles", "MakeCheckBox")
	TTT2SMORE.MakeElement(bot_options, "bot_quota", "MakeSlider", {max = game.MaxPlayers(), decimal = 0})
	TTT2SMORE.MakeElement(bot_options, "bot_pickup_nearby_range", "MakeSlider", {max = 250, decimal = 0})
	TTT2SMORE.MakeElement(bot_options, "bot_spawn_command", "MakeTextEntry")
end)

TTT2SMORE.AddFeature("PreventBotRoles", feat)
