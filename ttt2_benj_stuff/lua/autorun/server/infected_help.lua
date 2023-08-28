if SERVER then
    hook.Add("TTTBeginRound", "InfectionCredits", function()
      	local validply = 0
        local players = player.GetAll()
      	for _, ply in pairs(players) do
        	if ply:Alive() and not ply:IsSpec() then
          		validply = validply + 1
        	end
   		end

      	if validply >= 8 then
        	local extraCredits = math.floor((validply - 8) / 2)

        	for _, ply in pairs(players) do
        	    if ply:GetSubRole() == ROLE_INFECTED then
        	        ply:AddCredits(extraCredits)
        	        LANG.Msg(ply, "You have recieved " .. tostring(extracredits) .. " extra credits for the amount of players this round!")
        	    end
        	end
      	end
    end)
end