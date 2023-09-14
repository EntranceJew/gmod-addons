local feat = {}

if SERVER then
feat.GivePlayerExtraCredits = function(ply, total_players)
	local abbr = ply:GetSubRoleData().abbr
	local min_players = GetConVar("sv_smore_" .. abbr .. "_extra_credits_min_players"):GetInt()

	-- print("extra credit:", ply, min_players, total_players)
	if total_players >= min_players then
		local ppc = GetConVar("sv_smore_" .. abbr .. "_extra_credits_players_per_credit"):GetInt()
		if ppc > 0 then
			local credits = math.floor((total_players - min_players) / ppc)
			ply:AddCredits(credits)
			LANG.Msg(ply, "smore_all_role_notify_extra_credits", {credits = credits})
		end
	end
end
end

TTT2SMORE.HookAdd("TTT2OnRoleAddToSettingsMenu", "all_role_extra_credits", function(role, parent)
	local form = TTT2SMORE.ExtendRoleMenu(role, parent, "header_roles_smore_all_role_general")

	TTT2SMORE.MakeRoleElement(form, role, "extra_credits_min_players", "MakeSlider", {max = game.MaxPlayers()})
	TTT2SMORE.MakeRoleElement(form, role, "extra_credits_players_per_credit", "MakeSlider", {max = game.MaxPlayers()})
end)

TTT2SMORE.HookAdd("SMORECreateRoleConVars", "all_role_extra_credits", function(role)
	TTT2SMORE.MakeCVar(role.abbr .. "_extra_credits_min_players", "0")
	TTT2SMORE.MakeCVar(role.abbr .. "_extra_credits_players_per_credit", "0")
end)

if SERVER then
TTT2SMORE.HookAdd("SMORETTTBeginRoundLivingPlayer", "extra_credits", feat.GivePlayerExtraCredits)
end

TTT2SMORE.AddFeature("ExtraCredits", feat)
