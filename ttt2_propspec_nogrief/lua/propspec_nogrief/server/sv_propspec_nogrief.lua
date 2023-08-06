PropSpec_NoGrief.PROPS = PropSpec_NoGrief.PROPS or {}
PropSpec_NoGrief.HOOKS = PropSpec_NoGrief.HOOKS or {}
PropSpec_NoGrief.CVARS = PropSpec_NoGrief.CVARS or {
    ghost_alpha = CreateConVar(
        "sv_psng_ghost_alpha",
        "128",
        {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}
    ),
    transparent_render_mode = CreateConVar(
        "sv_psng_transparent_render_mode",
        "1",
        {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}
    ),

    debug_print = CreateConVar(
        "sv_psng_debug_print",
        "0",
        {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}
    ),
    think_interval = CreateConVar(
        "sv_psng_think_interval",
        "1",
        {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}
    ),
    resolidify_all_clear_wait = CreateConVar(
        "sv_psng_resolidify_all_clear_wait",
        "3",
        {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}
    ),
    resolidify_only_grounded = CreateConVar(
        "sv_psng_resolidify_only_grounded",
        "1",
        {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}
    ),
    resolidify_grounded_check_distance = CreateConVar(
        "sv_psng_resolidify_grounded_check_distance",
        "9",
        {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}
    ),
    resolidify_grounded_min_time = CreateConVar(
        "sv_psng_resolidify_grounded_min_time",
        "3",
        {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}
    ),
    ejection_radius = CreateConVar(
        "sv_psng_ejection_radius",
        "250",
        {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}
    ),

    --[[
    physobj_contents = CreateConVar(
        "sv_psng_physobj_contents",
        CONTENTS_GRATE,
        {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}
    ),
    ]]
}

local dprint = function(...)
    if PropSpec_NoGrief.CVARS.debug_print:GetBool() then
        print(...)
    end
end

-- TODO: all these variations of things and i still cannot set something to be shot through and world-solid at the same time

-- local OverrideTestCollision = function(self, startpos, delta, isbox, extents, mask)
--     if bit.band(mask, CONTENTS_GRATE) != 0 then return true end
-- end

PropSpec_NoGrief.GenerateDesiredJUNK = function(junk)
    local color_changed = Color( junk.color.r, junk.color.g, junk.color.b, PropSpec_NoGrief.CVARS.ghost_alpha:GetInt() )
    local out_junk = {
        -- physics_object_contents = CONTENTS_GRATE,
        color = color_changed,
        collision_group = COLLISION_GROUP_WORLD,
        render_mode = junk.render_mode,
        -- solid = SOLID_VPHYSICS,
        -- solid_flags = bit.bor(FSOLID_CUSTOMRAYTEST)

        -- custom_collisions = true,
        -- not_solid = true,
    }
    if PropSpec_NoGrief.CVARS.transparent_render_mode:GetBool() then
        out_junk.render_mode = RENDERMODE_TRANSCOLOR
    end
    return out_junk
end

PropSpec_NoGrief.CaptureJUNK = function(ent)
    return {
        -- physics_object_contents = ent:GetPhysicsObject():GetContents(),
        color = ent:GetColor(),
        collision_group = ent:GetCollisionGroup(),
        render_mode = ent:GetRenderMode(),
        -- solid = ent:GetSolid(),
        -- solid_flags = ent:GetSolidFlags(),

        -- custom_collisions = false,
        -- not_solid = false,
    }
end

PropSpec_NoGrief.ApplyJUNK = function(ent, junk)
    if IsValid(ent) and junk ~= nil then
        -- ent:GetPhysicsObject():SetContents( junk.physics_object_contents )
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

--[[ asscheek ]]

PropSpec_NoGrief.ClearAll = function()
    local count = #PropSpec_NoGrief.PROPS
    dprint("EJEW: clearing props [", count, "]")
    PropSpec_NoGrief.PROPS = {}
end

PropSpec_NoGrief.IsPropClearFromEnts = function(ent)
    local ent_id = ent:EntIndex()
    local p_data = PropSpec_NoGrief.PROPS[ ent_id ]
    local trace = {
        start = ent:LocalToWorld( ent:OBBCenter() ),
        filter = ent,
        collisiongroup = p_data.junk and p_data.junk.collision_group or COLLISION_GROUP_NONE,
        ignoreworld = true,
    }
    trace.endpos = trace.start
    local tr = util.TraceEntity(trace, ent)
    if tr.Hit then
        dprint("EJEW: did not restore [", ent, "] due to collision with [", tr.Entity, "]")
        return false
    else
        return true
    end
end

PropSpec_NoGrief.IsPropGrounded = function(ent)
    local ent_id = ent:EntIndex()
    local p_data = PropSpec_NoGrief.PROPS[ ent_id ]
    local trace = {}
    local max = ent:OBBMaxs()
    local min = ent:OBBMins()
    local size = max - min
    local rsize = math.min( size.x, size.y ) / 2
    local pos = ent:OBBCenter()
    Vector(pos.x, pos.y, pos.z)
    trace.start 	= ent:LocalToWorld( pos )
    trace.endpos 	= trace.start + Vector(0,0,-rsize - PropSpec_NoGrief.CVARS.resolidify_grounded_check_distance:GetFloat())
    trace.filter 	= ent

    -- we're touching the cache in a query because physics is expensive
    local tr = util.TraceLine( trace )
    if tr.HitWorld then
        if p_data.grounded == math.huge then
            p_data.grounded = CurTime()
        end
        return true
    else
        p_data = math.huge
        return false
    end
end

PropSpec_NoGrief.IsPropGroundedLongEnough = function(ent)
    if PropSpec_NoGrief.CVARS.resolidify_only_grounded:GetBool() then
        if PropSpec_NoGrief.IsPropGrounded(ent) then
            local min_time = PropSpec_NoGrief.CVARS.resolidify_grounded_min_time:GetFloat()
            local p_data = PropSpec_NoGrief.PROPS[ ent:EntIndex() ]
            if min_time > 0 and (CurTime() > (p_data.grounded + min_time)) then
                -- dprint(ent, "is grounded for sufficient time")
                return true
            else
                dprint("EJEW:", ent, "was not grounded for long enough")
                return false
            end
        else
            dprint("EJEW:", ent, "was not grounded, at all")
            return false
        end
    end
end

PropSpec_NoGrief.IsPropAllClear = function(ent)
    local min_time = PropSpec_NoGrief.CVARS.resolidify_all_clear_wait:GetFloat()
    local p_data = PropSpec_NoGrief.PROPS[ ent:EntIndex() ]
    if min_time > 0 and (CurTime() > (p_data.all_clear + min_time)) then
        return true
    else
        return false
    end
end

-- Vector, Player, number
PropSpec_NoGrief.IsPropNearPlayer = function( origin, ply, dist )
    local pdist = ply:GetPos():DistToSqr( origin )
    local sqdist = dist * dist
    local cond = pdist < sqdist
    return cond
end

-- Vector, number
PropSpec_NoGrief.IsPropOutOfPlayerRange = function( origin )
    local dist = PropSpec_NoGrief.CVARS.ejection_radius:GetFloat()
    for _, ply in ipairs( player.GetAll() ) do
        if (not ply:IsSpec()) and PropSpec_NoGrief.IsPropNearPlayer(origin, ply, dist) then
            return false
        end
    end
    return true
end

--[[ internal functioning ]]

PropSpec_NoGrief.Resolidify = function(ent)
    local ent_id = ent:EntIndex()
    local p_data = PropSpec_NoGrief.PROPS[ ent_id ]

    if p_data.junk ~= nil then
        dprint("EJEW: resolidifying [", ent, "]")
        PropSpec_NoGrief.ApplyJUNK(ent, p_data.junk)
        PropSpec_NoGrief.PROPS[ ent_id ] = nil
        return true
    else
        dprint("EJEW: [ERROR] resolidify failed, no JUNK")
        return false
    end
end

PropSpec_NoGrief.SlowThink = function()
    local resolid_ids = {}
    local kill_ents = {}
    for ent_id, ent_meta in pairs(PropSpec_NoGrief.PROPS) do
        -- working through known posessed props, they have not resolidified yet
        local ent = Entity( ent_id )
        local can_resolidify = true
        if not IsValid(ent) then
            -- we have to erase ourselves in this circumstance
            table.insert(kill_ents, ent_id)
            continue
        end
        if can_resolidify and ent_meta.possessor ~= nil then
            -- not orphaned yet, no work to do
            dprint("EJEW:", ent, "aborting, still possessed")
            can_resolidify = false
        end
        -- always do the range check so we can eject
        if not PropSpec_NoGrief.IsPropOutOfPlayerRange(ent:GetPos()) then
            can_resolidify = false
            if ent_meta.possessor then
                dprint("EJEW:", ent, "aborting, within range of player; also ejecting")
                local ply = Entity( ent_meta.possessor )
                if IsValid(ply) and ply:IsPlayer() and not ply:Alive() then
                    PROPSPEC.End(ply)
                end
            else
                dprint("EJEW:", ent, "aborting, within range of player")
            end
        end
        if can_resolidify and not PropSpec_NoGrief.IsPropGroundedLongEnough(ent) then
            dprint("EJEW:", ent, "aborting, not grounded long enough")
            can_resolidify = false
        end
        if can_resolidify and not PropSpec_NoGrief.IsPropClearFromEnts(ent) then
            dprint("EJEW:", ent, "aborting, obstructed by entity")
            can_resolidify = false
        end

        if can_resolidify then
            if ent_meta.all_clear == math.huge then
                dprint("EJEW:", ent, "PRAISE, first frame of all clear")
                ent_meta.all_clear = CurTime()
            end
        else
            if ent_meta.all_clear ~= math.huge then
                dprint("EJEW:", ent, "RUINED, first frame of all clear invalid")
                ent_meta.all_clear = math.huge
            end
        end

        if can_resolidify and PropSpec_NoGrief.IsPropAllClear(ent) then
            table.insert(resolid_ids, ent_id)
        end
    end

    for _, resolid_id in ipairs(resolid_ids) do
        PropSpec_NoGrief.Resolidify( Entity(resolid_id) )
    end
    for _, kill_id in ipairs(kill_ents) do
        PropSpec_NoGrief.PROPS[ kill_id ] = nil
    end
end

PropSpec_NoGrief.Start = function(ply, ent)
    if not PropSpec_NoGrief.IsPropOutOfPlayerRange(ent:GetPos()) then
        dprint("EJEW:", ply, "cannot possess prop [", ent, "] because it is too near someone")
        -- we're doing a clear and not an End because it is disorienting to be sent back
        PropSpec_NoGrief.Clear(ply)
        return
    end

    local this = {
        junk = PropSpec_NoGrief.CaptureJUNK(ent),
        possessor = ply:EntIndex(),
        grounded = CurTime(),
        all_clear = math.huge,
    }

    local ent_id = ent:EntIndex()
    PropSpec_NoGrief.PROPS[ ent_id ] = this

    local new_junk = PropSpec_NoGrief.GenerateDesiredJUNK(this.junk)
    PropSpec_NoGrief.ApplyJUNK(ent, new_junk)

    PropSpec_NoGrief.HOOKS._propspec_start(ply, ent)
end

PropSpec_NoGrief.Clear = function(ply, maybe_ent)
    -- the prop can remain unsolid after being Cleared so we can't let the handle go yet
    local ent = (ply.propspec and ply.propspec.ent) or ply:GetObserverTarget()
    local p_data = PropSpec_NoGrief.PROPS[ ent:EntIndex() ]
    if IsValid(ent) and p_data then
        p_data.possessor = nil
    end
    dprint("EJEW: clearing [", ply, "] from [", ent, "]")
    PropSpec_NoGrief.HOOKS._propspec_clear(ply)
end

PropSpec_NoGrief.Initialize = function()
    if GAMEMODE_NAME == "terrortown" and SERVER then
        if not PropSpec_NoGrief.HOOKS._propspec_start then
            PropSpec_NoGrief.HOOKS._propspec_start = PROPSPEC.Start
            PROPSPEC.Start = PropSpec_NoGrief.Start
        end

        if not PropSpec_NoGrief.HOOKS._propspec_clear then
            PropSpec_NoGrief.HOOKS._propspec_clear = PROPSPEC.Clear
            PROPSPEC.Clear = PropSpec_NoGrief.Clear
        end

        timer.Create(
            "PropSpec_NoGrief_SlowThink",
            PropSpec_NoGrief.CVARS.think_interval:GetFloat(),
            0,
            PropSpec_NoGrief.SlowThink
        )
    end
end

hook.Remove("TTTEndRound", "PropSpec_NoGrief_ClearAll")
hook.Remove("TTTPrepareRound", "PropSpec_NoGrief_ClearAll")
hook.Remove("TTTBeginRound", "PropSpec_NoGrief_ClearAll")
hook.Add("TTTEndRound", "PropSpec_NoGrief_ClearAll", PropSpec_NoGrief.ClearAll)
hook.Add("TTTPrepareRound", "PropSpec_NoGrief_ClearAll", PropSpec_NoGrief.ClearAll)
hook.Add("TTTBeginRound", "PropSpec_NoGrief_ClearAll", PropSpec_NoGrief.ClearAll)

hook.Remove("Initialize", "PropSpec_NoGrief_Initialize")
hook.Add( "Initialize", "PropSpec_NoGrief_Initialize", PropSpec_NoGrief.Initialize)
