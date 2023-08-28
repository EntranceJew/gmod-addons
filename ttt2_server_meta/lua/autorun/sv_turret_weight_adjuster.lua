if SERVER then
    hook.Add( "OnEntityCreated", "HOUSERULES_TurretWeightAdjuster", function( ent )
        timer.Simple(0.5, function()
            if ( IsValid(ent) and ent:GetClass() == "npc_turret_floor" ) then
                ent:GetPhysicsObject():SetMass(43)
            end
        end)
    end )
end