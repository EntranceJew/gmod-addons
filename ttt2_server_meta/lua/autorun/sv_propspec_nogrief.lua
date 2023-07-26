if not SERVER then return end

-- TODO: all these variations of things and i still cannot set something to be shot through and world-solid at the same time

-- local OverrideTestCollision = function(self, startpos, delta, isbox, extents, mask)
--     if bit.band(mask, CONTENTS_GRATE) != 0 then return true end
-- end

local JUNKDEX = {}

local GenerateDesiredJUNK = function(junk)
    local color_changed = Color( junk.color.r, junk.color.g, junk.color.b, 128 )
    return {
        physics_object_contents = CONTENTS_GRATE,
        color = color_changed,
        collision_group = COLLISION_GROUP_WORLD,
        render_mode = RENDERMODE_TRANSCOLOR,
        -- solid = SOLID_VPHYSICS,
        -- solid_flags = bit.bor(FSOLID_CUSTOMRAYTEST)

        -- custom_collisions = true,
        -- not_solid = true,
    }
end

local CaptureJUNK = function(ent)
    return {
        physics_object_contents = ent:GetPhysicsObject():GetContents(),
        color = ent:GetColor(),
        collision_group = ent:GetCollisionGroup(),
        render_mode = ent:GetRenderMode(),
        -- solid = ent:GetSolid(),
        -- solid_flags = ent:GetSolidFlags(),

        -- custom_collisions = false,
        -- not_solid = false,
    }
end

local ApplyJUNK = function(ent, junk)
    if IsValid(ent) and junk ~= nil then
        ent:GetPhysicsObject():SetContents( junk.physics_object_contents )
        ent:SetColor( junk.color )
        ent:SetCollisionGroup( junk.collision_group )
        ent:SetRenderMode( junk.render_mode )
        -- ent:SetSolid( junk.solid )
        -- ent:SetSolidFlags( junk.solid_flags )

        -- ent:EnableCustomCollisions( junk.custom_collisions )
        -- if junk.custom_collisions then
        --     ent.TestCollision = OverrideTestCollision
        -- else
        --     ent.TestCollision = nil
        -- end
        -- ent:SetNotSolid( junk.not_solid )
    end
end

local Resolidify = function(ent)
    local junk = JUNKDEX[ ent:EntIndex() ]

    if junk ~= nil then
        ApplyJUNK(ent, junk)
    else
        print("EJEW: [ERROR] resolidify failed, no JUNK")
    end
end

local ResolidifyWhenClear = function(ent)
    if IsValid(ent) then
        local junk = JUNKDEX[ ent:EntIndex() ]
        local trace = {
            start = ent:GetPos(),
            endpos = ent:GetPos(),
            filter = ent,
            collisiongroup = junk and junk.collision_group or COLLISION_GROUP_NONE,
            ignoreworld = true
        }
        local tr = util.TraceEntity(trace, ent)
        if tr.Hit then
            print("EJEW: did not restore [" .. tostring(ent) .. "] due to collision with [" .. tostring(tr.Entity) .. "]")
        else
            Resolidify(ent)
            timer.Remove( tostring(ent) .. "_resolidify" )
        end
    end
end

hook.Add( "Initialize", "PropSpecNoGrief_Initialize", function()
    if GAMEMODE_NAME == "terrortown" and SERVER then
        JUNKDEX = {}
        local _propspec_start = PROPSPEC.Start
        PROPSPEC.Start = function(ply, ent)

            -- only capture the collision group one time if we can help it
            local junk = JUNKDEX[ ent:EntIndex() ]
            if JUNKDEX[ ent:EntIndex() ] == nil then
                junk = CaptureJUNK(ent)
                JUNKDEX[ ent:EntIndex() ] = junk
            end

            local new_junk = GenerateDesiredJUNK(junk)
            ApplyJUNK(ent, new_junk)

            _propspec_start(ply, ent)
        end

        local _propspec_clear = PROPSPEC.Clear
        PROPSPEC.Clear = function(ply)
            local ent = (ply.propspec and ply.propspec.ent) or ply:GetObserverTarget()
            if IsValid(ent) then
                local junk = JUNKDEX[ ent:EntIndex() ]

                if junk ~= nil then
                    timer.Create( "resolidify_" .. ent:EntIndex(), 1, 0, function() ResolidifyWhenClear(ent) end)
                else
                    print("EJEW: did not attempt to resolidfy target lacking JUNK")
                end
            end
            _propspec_clear(ply)
        end
    end
end)
