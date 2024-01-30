-- local mech = {}

-- mech.DoorFlush = function(ent)
-- 	if IsValid(ent) and not ent:DoorIsTransitioning() then
-- 		ent:SetSaveValue( "Speed", ent.old_speed )
-- 		ent.hasteopen = false
-- 		ent.stealthopen = false
-- 		return true
-- 	end
-- 	return false
-- end
-- -- eek

-- mech.OpenDoorAtSpeed = function(ent, speed, hesitate)
-- 	if ent.old_speed == nil then
-- 		ent.old_speed = ent:GetInternalVariable( "Speed" )
-- 	end
-- 	local new_speed = ent.old_speed * speed
-- 	ent:SetSaveValue( "Speed",  new_speed )
-- 	local real_hesitate = GetConVar("sv_smore_door_stealth_and_haste_open_reset_hesitation"):GetFloat()

-- 	local uniqueIdent = ent:EntIndex()
-- 	local dist = door.GetTravelDistance( ent )
-- 	local final = (dist / new_speed) * real_hesitate
-- 	-- print("opening door", uniqueIdent, "at speed", new_speed, "across distance", dist, "calculated hesitance", final)
-- 	timer.Create( "resetdoormodifiedval" .. uniqueIdent, final, 1, function()
-- 		local was_ready = mech.DoorFlush(ent)
-- 		-- print("checking for ready?", was_ready)
-- 		if not was_ready then
-- 			timer.Create( "checkfordoorreset" .. uniqueIdent, 0.1, 0, function()
-- 				-- print("thinking about", uniqueIdent)
-- 				mech.DoorFlush(ent)
-- 				timer.Remove( "checkfordoorreset" .. uniqueIdent )
-- 			end)
-- 		end
-- 	end )
-- end

-- mech.StealthOpenDoor = function(ent)
-- 	-- if not (door.stealthopen or door.hasteopen) then
-- 	ent.stealthopen = true
-- 	mech.OpenDoorAtSpeed(ent, GetConVar("sv_smore_door_stealth_open_speed_modifier"):GetFloat())
-- 	-- end
-- end

-- mech.HasteOpenDoor = function(ent)
-- 	-- if not (door.stealthopen or door.hasteopen) then
-- 	ent.hasteopen = true
-- 	mech.OpenDoorAtSpeed(ent, GetConVar("sv_smore_door_haste_open_speed_modifier"):GetFloat())
-- 	-- end
-- end

-- TTT2SMORE.HookAdd( "AcceptInput", "door_stealth_and_haste_open", function( ent, inp, act, ply, val )
-- 	if inp == "Use" and IsValid(ent) and ent:IsDoor() then
-- 		local is_haste = ply:KeyDown( IN_SPEED )
-- 		local is_stealth = ply:KeyDown( IN_WALK )

-- 		if is_haste then
-- 			mech.HasteOpenDoor(ent)
-- 			if ent.otherDoorPair then
-- 				mech.HasteOpenDoor(ent.otherDoorPair)
-- 			end
-- 		elseif is_stealth then
-- 			mech.StealthOpenDoor(ent)
-- 			if ent.otherDoorPair then
-- 				mech.StealthOpenDoor(ent.otherDoorPair)
-- 			end
-- 		end
-- 	end
-- end)

-- TTT2SMORE.HookAdd( "EntityEmitSound", "door_stealth_and_haste_open", function( data )
-- 	if IsValid(data.Entity) and data.Entity:IsDoor(data.Entity) then
-- 		if data.Entity.hasteopen then
-- 			data.Volume = data.Volume * GetConVar("sv_smore_door_haste_open_volume_modifier"):GetFloat()
-- 			return true
-- 		elseif data.Entity.stealthopen then
-- 			data.Volume = data.Volume * GetConVar("sv_smore_door_stealth_open_volume_modifier"):GetFloat()
-- 			return true
-- 		end
-- 	end
-- end)

-- if CLIENT then
-- TTT2SMORE.HookAdd("SMORETTTLanguageChanged", "door_stealth_and_haste_open", function()
-- 	if GetConVar("sv_smore_door_stealth_open_enable"):GetBool() then
-- 		LANG.AddToLanguage(LANG.ActiveLanguage, "door_open", LANG.GetTranslationFromLanguage("door_open_stealth", LANG.ActiveLanguage))
-- 		LANG.AddToLanguage(LANG.ActiveLanguage, "door_close", LANG.GetTranslationFromLanguage("door_close_stealth", LANG.ActiveLanguage))
-- 	end
-- end)
-- end

-- TTT2SMORE.HookAdd("SMORECreateConVars", "door_stealth_and_haste_open", function()
-- 	TTT2SMORE.MakeCVar("door_stealth_and_haste_open_reset_hesitation", "1.5")

-- 	TTT2SMORE.MakeCVar("door_stealth_open_enable", "0")
-- 	TTT2SMORE.MakeCVar("door_stealth_open_speed_modifier", "0.5")
-- 	TTT2SMORE.MakeCVar("door_stealth_open_volume_modifier", "0.25")

-- 	TTT2SMORE.MakeCVar("door_haste_open_enable", "0")
-- 	TTT2SMORE.MakeCVar("door_haste_open_speed_modifier", "2")
-- 	TTT2SMORE.MakeCVar("door_haste_open_volume_modifier", "4")
-- end)

-- TTT2SMORE.HookAdd("SMOREServerAddonSettings", "door_stealth_and_haste_open", function(parent, general)
-- 	local door_stealth_and_haste_open = vgui.CreateTTT2Form(parent, "smore_settings_mechanic_door_stealth_and_haste_open")

-- 	TTT2SMORE.MakeElement(door_stealth_and_haste_open, "door_stealth_and_haste_open_reset_hesitation", "MakeSlider", {max = 32, decimal = 2})

-- 	TTT2SMORE.MakeElement(door_stealth_and_haste_open, "door_stealth_open_enable", "MakeCheckBox")
-- 	TTT2SMORE.MakeElement(door_stealth_and_haste_open, "door_stealth_open_speed_modifier", "MakeSlider", {max = 1, decimal = 2})
-- 	TTT2SMORE.MakeElement(door_stealth_and_haste_open, "door_stealth_open_volume_modifier", "MakeSlider", {max = 2, decimal = 2})

-- 	TTT2SMORE.MakeElement(door_stealth_and_haste_open, "door_haste_open_enable", "MakeCheckBox")
-- 	TTT2SMORE.MakeElement(door_stealth_and_haste_open, "door_haste_open_speed_modifier", "MakeSlider", {max = 4, decimal = 2})
-- 	TTT2SMORE.MakeElement(door_stealth_and_haste_open, "door_haste_open_volume_modifier", "MakeSlider", {max = 8, decimal = 2})
-- end)

-- TTT2SMORE.AddMechanic("DoorStealthAndHasteOpen", mech)