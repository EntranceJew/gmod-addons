local feat = {}

feat.CheckForWin = function()
	if not GetConVar("sv_smore_tie_breaker_enable"):GetBool() then return end
	local plys = util.GetAlivePlayers()
	local living_count = #plys

	local is_was_alive = GetConVar("sv_smore_tie_breaker_was_alive"):GetBool()
	local is_win_team_only = GetConVar("sv_smore_tie_breaker_win_team_only"):GetBool()
	local is_all_dead = living_count <= 0

	-- catalog teams that were alive prior to the check
	if not is_all_dead then
		local real_teams = {}
		for i = 1, living_count do
			local ply = plys[i]
			real_teams[ ply:GetRealTeam() ] = true
		end
		TTT2SMORE.RDATA.TieBreakerTeams = real_teams
		return
	end

	if is_all_dead then
		-- nobody is alive anymore
		local team_priorities = TTT2SMORE.GetListFromConVar("tie_breaker_team_priority")
		local win_teams = (is_win_team_only and roles.GetWinTeams()) or roles.GetAvailableTeams()
		for _, team in ipairs(team_priorities) do
			if not table.HasValue(win_teams, team) then
				continue
			end
			if is_was_alive and not TTT2SMORE.RDATA.TieBreakerTeams[team] then
				continue
			end
			return team
		end
	end
end

TTT2SMORE.RegisterRoundData("TieBreakerTeams", {})

TTT2SMORE.HookAdd("SMORECreateConVars", "tie_breaker", function()
	TTT2SMORE.MakeCVar("tie_breaker_enable", "0")
	TTT2SMORE.MakeCVar("tie_breaker_was_alive", "1")
	TTT2SMORE.MakeCVar("tie_breaker_win_team_only", "1")
	TTT2SMORE.MakeCVar("tie_breaker_team_priority", "")
end)

TTT2SMORE.HookAdd("SMOREServerAddonSettings", "tie_breaker", function(parent, general)
	local all_teams = table.concat(roles.GetAvailableTeams(), ", ")
	TTT2SMORE.MakeElement(general, "tie_breaker_enable", "MakeCheckBox")
	TTT2SMORE.MakeElement(general, "tie_breaker_was_alive", "MakeCheckBox")
	TTT2SMORE.MakeElement(general, "tie_breaker_win_team_only", "MakeCheckBox")
	TTT2SMORE.MakeElement(general, "tie_breaker_team_priority", "MakeTextEntry", { help_params = {teams = all_teams}})
end)

if SERVER then
	TTT2SMORE.HookAdd("TTT2PreWinChecker", "tie_breaker", feat.CheckForWin)
	TTT2SMORE.HookAdd("TTTCheckForWin", "tie_breaker", feat.CheckForWin)
end

TTT2SMORE.AddFeature("TieBreaker", feat)
