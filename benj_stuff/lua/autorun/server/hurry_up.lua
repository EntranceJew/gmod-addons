if SERVER then
	RADAR = RADAR or {}
	local roundrunning = false
	local radarowners = {}
	local dead = 0
	local sentmessage = false

	hook.Add("PlayerDeath", "LMAO_Dead", function()
		dead = dead + 1
	end)

	local function CheckRoundTime()
		local haste_end = GetGlobalFloat("ttt_haste_end", 0)
		local haste_remaining = haste_end - CurTime()
		local remaining = math.floor(GetConVar("ttt_haste_minutes_per_death"):GetFloat() * 60) * dead + haste_remaining

		if roundrunning and remaining <= 15 and not sentmessage then
			sentmessage = true
			LANG.Msg("15 seconds remaining, All players have radar!")
			for _, ply in ipairs(player.GetAll()) do

				if not ply:HasEquipmentItem("item_ttt_radar") then -- only give radar if player doesn't already have one
					ply:GiveEquipmentItem("item_ttt_radar")
				else
					table.insert(radarowners, ply)
				end

			end
		elseif roundrunning and remaining >= 45 and sentmessage then
			sentmessage = false
			LANG.Msg("Round extended, Radars removed.")
			for _, ply in ipairs(player.GetAll()) do
				if ply:HasEquipmentItem("item_ttt_radar") and not (list.Contains(radarowners, ply)) then
					ply:RemoveEquipmentItem("item_ttt_radar")
				end
			end
		end
	end

	hook.Add("TTTBeginRound", "HasteRadar", function()
		roundrunning = true
		timer.Simple(0, function()
			timer.Create("HasteRadarCheck", 1, 0, CheckRoundTime)
		end)
		radarowners = {}
		sentmessage = false
		dead = 0
	end)

	hook.Add("TTTEndRound", "HasteRadar", function()
		roundrunning = false
		timer.Remove("HasteRadarCheck")
		radarowners = {}
		sentmessage = false
		dead = 0
		for _, ply in ipairs(player.GetAll()) do
			if ply:HasEquipmentItem("item_ttt_radar") then
				ply:RemoveEquipmentItem("item_ttt_radar")
			end
		end
	end)
end