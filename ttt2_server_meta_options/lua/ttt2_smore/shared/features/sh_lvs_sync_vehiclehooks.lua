local feat = {}

TTT2SMORE.HookAdd("InitPostEntity", "lvs", function()
    if not GetConVar("sv_smore_lvs"):GetBool() then return end

    local plymeta = FindMetaTable( "Player" )
    local oldEnterVehicle = plymeta.EnterVehicle
    local oldExitVehicle = plymeta.ExitVehicle

    function plymeta:EnterVehicle(vehicle)
        hook.Run("PlayerEnteredVehicle", self, vehicle, self:GetRole())
        oldEnterVehicle(self, vehicle)
    end

    function plymeta:ExitVehicle(vehicle)
        hook.Run("PlayerLeaveVehicle", self, vehicle)
        oldExitVehicle(self, vehicle)
    end

    TTT2SMORE.HookAdd("simfphysOnTakeDamage", "lvs", function(vehicle, dmginfo)
        local driver = vehicle:GetDriver()

        if IsValid(driver) and not driver:Alive() then
            driver:ExitVehicle(vehicle)
        end
    end)
end)

TTT2SMORE.HookAdd("LVS.PlayerEnteredVehicle", "lvs", function(ply, vehicle)
    hook.Run("PlayerEnteredVehicle", ply, vehicle, ply:GetRole())
end)

TTT2SMORE.HookAdd("LVS.PlayerLeaveVehicle", "lvs", function(ply, vehicle)
    hook.Run("PlayerLeaveVehicle", ply, vehicle, ply:GetRole())
end)

TTT2SMORE.HookAdd("SMORECreateConVars", "lvs", function()
    TTT2SMORE.MakeCVar("lvs", "0")
end)

TTT2SMORE.HookAdd("SMOREServerAddonSettings", "lvs", function(parent, general)
    TTT2SMORE.MakeElement(general, "lvs", "MakeCheckBox")
end)

TTT2SMORE.AddFeature("LVS", feat)