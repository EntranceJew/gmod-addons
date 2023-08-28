if SERVER then
	RADAR = RADAR or {}
	local roundrunning = false
	local radarowners = {}
	local sentmessage = false
	local function CheckRoundTime()
		local the_endtime = math.max(0, GetGlobalFloat("ttt_round_end", 0) - CurTime())

		if roundrunning and the_endtime <= 15 and not sentmessage then
			sentmessage = true
			LANG.Msg("15 seconds remaining, All players have radar!")
			for _, ply in ipairs(player.GetAll()) do
				if not ply:HasEquipmentItem("item_ttt_radar") then -- only give radar if player doesn't already have one
					ply:GiveEquipmentItem("item_ttt_radar")
				else
					table.insert(radarowners, ply)
				end
			end
		elseif roundrunning and the_endtime >= 45 and sentmessage then
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
	end)

	hook.Add("TTTEndRound", "HasteRadar", function()
		roundrunning = false
		timer.Remove("HasteRadarCheck")
		radarowners = {}
		sentmessage = false
		-- for _, ply in ipairs(player.GetAll()) do
		-- 	if ply:HasEquipmentItem("item_ttt_radar") then
		-- 		ply:RemoveEquipmentItem("item_ttt_radar")
		-- 	end
		-- end
	end)
end