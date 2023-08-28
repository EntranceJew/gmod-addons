
local function ShouldShowJesterToTeam(ply)
	local visibletoevil = GetConVar("ttt2_jes_exppose_to_all_evils")
	return (visibletoevil:GetBool() and ply:GetTeam() ~= TEAM_INNOCENT and not ply:GetSubRoleData().unknownTeam)
		or (not visibletoevil:GetBool() and ply:GetTeam() == TEAM_TRAITOR)
end

function TellPlayersAboutJester(jester_string, jester_amnt)
	-- NOTIFY ALL PLAYERS IF THERE IS A JESTER THIS ROUND
	if GetConVar("ttt2_jes_announce"):GetBool() then
		if jester_amnt == 0 then
			LANG.MsgAll("ttt2_role_jester_info_no_jester", nil, MSG_MSTACK_PLAIN)
		else
			LANG.MsgAll("ttt2_role_jester_info_no_kill", nil, MSG_MSTACK_WARN)
		end
	end
	if jester_amnt == 0 then return end
	-- NOTIFY TRAITORS ABOUT JESTERS THIS ROUND
	local plys = player.GetAll()
	for i = 1, #plys do
		local ply = plys[i]
		if ply:GetTeam() == TEAM_JESTER or not ShouldShowJesterToTeam(ply) then continue end
		if jester_amnt == 1 then
			LANG.Msg(ply, "ttt2_role_jester_info_jester_single", {playername = jester_string}, MSG_MSTACK_ROLE)
		else
			LANG.Msg(ply, "ttt2_role_jester_info_jester_multiple", {playernames = jester_string}, MSG_MSTACK_ROLE)
		end
	end
end

hook.Add("Initialize", "JesterRoundStartMessageJacker", function()
  hook.Remove("Initialize", "JesterRoundStartMessageJacker")
  hook.Remove("TTTBeginRound", "JesterRoundStartMessage")

  -- inform other players about the jesters in this round
  hook.Add("TTTBeginRound", "JesterRoundStartMessageFix", function()
		local jesPlys = util.GetFilteredPlayers(function(p)
			return p:GetTeam() == TEAM_JESTER
		end)
		hook.Run("TTT2JesterModifyList", jesPlys)
		local jester_amnt = 0
		local jester_string = ""
		for i = 1, #jesPlys do
			local ply = jesPlys[i]
			if jester_amnt > 0 then
				jester_string = jester_string .. ", "
			end
			jester_string = jester_string .. ply:Nick()
			jester_amnt = jester_amnt + 1
		end
		timer.Simple(1.5, function() TellPlayersAboutJester(jester_string, jester_amnt) end)
  end)
end)