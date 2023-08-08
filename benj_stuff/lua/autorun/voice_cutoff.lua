
local maxDistance = 1000

hook.Add("PlayerCanHearPlayersVoice", "PlayerVoiceCutoff", function(listener, talker)
    if IsValid(listener) and IsValid(talker) then
        local listenerPos = listener:GetPos()
        local talkerPos = talker:GetPos()
        local distance = listenerPos:Distance(talkerPos)

        local listenerTeam = listener:Team()
        local talkerTeam = talker:Team()
        local isSpectator = listenerTeam == TEAM_SPECTATOR or talkerTeam == TEAM_SPECTATOR
        local isSameTeam = listenerTeam == talkerTeam

        if not isSpectator and distance > maxDistance then
            return false
        end
    end
end)
