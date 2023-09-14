local feat = {}

TTT2SMORE.RegisterRoundData("SentHurryUpMessage", false)
TTT2SMORE.RegisterRoundData("HurryUpRadarOwners", {})

feat.HurryUpTimeCheck = function()
	if GetRoundState() ~= ROUND_ACTIVE then return end
	local the_endtime = math.max(0, GetGlobalFloat("ttt_round_end", 0) - CurTime())

	if the_endtime <= GetConVar("sv_smore_hurry_up_min_time"):GetFloat()
		and not TTT2SMORE.RDATA.SentHurryUpMessage then
		TTT2SMORE.RDATA.SentHurryUpMessage = true
		LANG.Msg("smore_hurry_up", {seconds = GetConVar("sv_smore_hurry_up_min_time"):GetFloat()})
		for _, ply in ipairs(player.GetAll()) do
			if not ply:HasEquipmentItem("item_ttt_radar") then -- only give radar if player doesn't already have one
				ply:GiveEquipmentItem("item_ttt_radar")
			else
				TTT2SMORE.RDATA.HurryUpRadarOwners[ply:UserID()] = true
			end
		end
	elseif the_endtime >= GetConVar("sv_smore_hurry_up_max_time"):GetFloat() and TTT2SMORE.RDATA.SentHurryUpMessage then
		TTT2SMORE.RDATA.SentHurryUpMessage = false
		LANG.Msg("smore_hurry_up_extended", {seconds = GetConVar("sv_smore_hurry_up_max_time"):GetFloat()})
		for _, ply in ipairs(player.GetAll()) do
			if ply:HasEquipmentItem("item_ttt_radar") and not TTT2SMORE.RDATA.HurryUpRadarOwners[ply:UserID()] then
				ply:RemoveEquipmentItem("item_ttt_radar")
			end
		end
	end
end

TTT2SMORE.HookAdd("SMORECreateConVars", "hurry_up_radars", function()
	TTT2SMORE.MakeCVar("hurry_up_min_time", "15")
	TTT2SMORE.MakeCVar("hurry_up_max_time", "45")
end)

TTT2SMORE.HookAdd("SMOREServerAddonSettings", "hurry_up_radars", function(parent, general)
	TTT2SMORE.MakeElement(general, "hurry_up_min_time", "MakeSlider", {max = 600})
	TTT2SMORE.MakeElement(general, "hurry_up_max_time", "MakeSlider", {max = 600})
end)

if SERVER then
	TTT2SMORE.HookAdd("SMORESlowThink", "hurry_up_radars", feat.HurryUpTimeCheck)
end

TTT2SMORE.AddFeature("HurryUp", feat)
