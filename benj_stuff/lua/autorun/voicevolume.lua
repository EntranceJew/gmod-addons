--Honestly just re-write this from scratch I don't know what's going on here
if SERVER then
	local filename = "seen_pairs.json"

	local seenPairs = {}
	if file.Exists(filename, "DATA") then
		local json = file.Read(filename, "DATA")
		seenPairs = util.JSONToTable(json) or {}
	end

	local function hasSeenPair(p1, p2)
		local key = p1:SteamID() < p2:SteamID() and p1:SteamID().."-"..p2:SteamID() or p2:SteamID().."-"..p1:SteamID()
		return seenPairs[key]
	end


	local function markSeenPair(p1, p2)
		local key = p1:SteamID() < p2:SteamID() and p1:SteamID().."-"..p2:SteamID() or p2:SteamID().."-"..p1:SteamID()
		seenPairs[key] = true
		local json = util.TableToJSON(seenPairs)
		file.Write(filename, json)

--		local message = p1:GetName() .. " has been seen with " .. p2:GetName() .. " for the first time!"
--		p1:SendLua('chat.AddText(Color(255, 0, 0), "' .. message .. '")')
--		p2:SendLua('chat.AddText(Color(255, 0, 0), "' .. message .. '")')

		p1:SendLua("player.GetBySteamID64( \"" .. tostring(p2:SteamID64()) .. "\" ):SetVoiceVolumeScale(0.5)")
		p2:SendLua("player.GetBySteamID64( \"" .. tostring(p1:SteamID64()) .. "\" ):SetVoiceVolumeScale(0.5)")
	end

	hook.Add("PlayerInitialSpawn", "CheckPlayerPairs", function(ply)
		for _, otherPly in ipairs(player.GetAll()) do
			if otherPly ~= ply and not hasSeenPair(ply, otherPly) then
				print(ply:GetName() .. " has not been seen with " .. otherPly:GetName() .. " before, initializing client voice settings!")
				timer.Simple(20, function() markSeenPair(ply, otherPly) end )
			end
		end
	end)
end