hook.Remove("TTT2ModifyFinalRoles", "HOUSERULES_TTT2ModifyFinalRoles")
-- @param table finalRoles list of @{Player}s as key and their @{ROLE}s as the value
hook.Add("TTT2ModifyFinalRoles", "HOUSERULES_TTT2ModifyFinalRoles", function(finalRoles)
	local role_convert_all_traitors = {
		[ROLE_INFECTED] = true,
		[ROLE_MARKER] = true,
	}

	local role_traitor_adjacent = {
		[ROLE_TRAITOR] = true,
		[ROLE_DEFECTIVE] = true,
		[ROLE_MARKER] = true,
		[ROLE_INFECTED] = true,
	}

	local role_count = {}

	for ply, role in pairs(finalRoles) do
		role_count[role] = (role_count[role] or 0) + 1
	end

	local players = player.GetAll()
	table.Shuffle(players)

	for role in pairs(role_convert_all_traitors) do
		if (role_count[role] or 0) > 0 then
			for _, ply in ipairs(players) do
				if role_traitor_adjacent[ finalRoles[ply] ] then
					finalRoles[ply] = role
				end
			end
			break
		else
			for _, ply in ipairs(players) do
				if (role_count[ROLE_DEFECTIVE] or 0) > 0 and finalRoles[ply] == ROLE_TRAITOR and finalRoles[ply] ~= ROLE_DEFECTIVE then
					role_count[ROLE_DEFECTIVE] = role_count[ROLE_DEFECTIVE] - 1
					finalRoles[ply] = ROLE_INNOCENT
				end
			end
		end
	end
end)