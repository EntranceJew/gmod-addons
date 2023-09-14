local mech = {}

mech.DoorOpenState = function(door)
	return IsValid(door) and door:GetSaveTable().m_eDoorState ~= 1 and door:GetSaveTable().m_eDoorState ~= 3
end

mech.DoorFlush = function(door)
	if mech.DoorOpenState(door) then
		door:SetSaveValue( "Speed", door.old_speed )
		door.hasteopen = false
		door.stealthopen = false
		return true
	end
	return false
end
-- eek
mech.DoorID = function(door)
	return door:EntIndex() and door:EntIndex() or tostring( door:GetPos() )
end

mech.IsDoor = function(door)
	return door ~= NULL and IsValid(door) and (door:GetClass() == "prop_door_rotating" or door:GetClass() == "func_door_rotating")
end

mech.GetDoorTravelDistance = function(door)
	return (door:GetClass() == "prop_door_rotating" and door:GetInternalVariable( "distance" ) or door:GetInternalVariable( "m_flMoveDistance" )) or 1
end

mech.GetLinkedDoors = function(door)
	local doors = {door}
	if door:GetInternalVariable( "slavename" ) then
		for _, v in pairs( ents.FindByName( door:GetInternalVariable( "slavename" ) ) ) do
			table.insert(doors, v)
		end
	end
	for _, v in pairs( ents.GetAll() ) do
		if door == v:GetInternalVariable( "m_hMaster" ) then
			table.insert(doors, v)
		end
	end
	if door:GetInternalVariable( "m_hMaster" ) and mech.IsDoor(door:GetInternalVariable( "m_hMaster" )) then
		table.insert(doors, door:GetInternalVariable( "m_hMaster" ))
	end
	return doors
end

mech.OpenDoorAtSpeed = function(door, speed, hesitate)
	if door.old_speed == nil then
		door.old_speed = door:GetInternalVariable( "Speed" )
	end
	local new_speed = door.old_speed * speed
	door:SetSaveValue( "Speed",  new_speed )
	local real_hesitate = GetConVar("sv_smore_door_stealth_and_haste_open_reset_hesitation"):GetFloat()

	local uniqueIdent = mech.DoorID( door )
	local dist = mech.GetDoorTravelDistance( door )
	local final = (dist / new_speed) * real_hesitate
	-- print("opening door", uniqueIdent, "at speed", new_speed, "across distance", dist, "calculated hesitance", final)
	timer.Create( "resetdoormodifiedval" .. uniqueIdent, final, 1, function()
		local was_ready = mech.DoorFlush(door)
		-- print("checking for ready?", was_ready)
		if not was_ready then
			timer.Create( "checkfordoorreset" .. uniqueIdent, 0.1, 0, function()
				-- print("thinking about", uniqueIdent)
				mech.DoorFlush(door)
				timer.Remove( "checkfordoorreset" .. uniqueIdent )
			end)
		end
	end )
end

mech.StealthOpenDoor = function(door)
	-- if not (door.stealthopen or door.hasteopen) then
		door.stealthopen = true
		mech.OpenDoorAtSpeed(door, GetConVar("sv_smore_door_stealth_open_speed_modifier"):GetFloat())
	-- end
end

mech.HasteOpenDoor = function(door)
	-- if not (door.stealthopen or door.hasteopen) then
		door.hasteopen = true
		mech.OpenDoorAtSpeed(door, GetConVar("sv_smore_door_haste_open_speed_modifier"):GetFloat())
	-- end
end

TTT2SMORE.HookAdd( "AcceptInput", "door_stealth_and_haste_open", function( ent, inp, act, ply, val )
	if inp == "Use" and mech.IsDoor(ent) then
		local is_haste = ply.isSprinting
		local is_stealth = ply:KeyDown( IN_WALK )
		local linked

		if is_haste or is_stealth then
			linked = mech.GetLinkedDoors(ent)
		end

		if is_haste then
			for _, v in ipairs(linked) do
				mech.HasteOpenDoor(v)
			end
		elseif is_stealth then
			for _, v in ipairs(linked) do
				mech.StealthOpenDoor(v)
			end
		end
	end
end)

TTT2SMORE.HookAdd( "EntityEmitSound", "door_stealth_and_haste_open", function( data )
	if mech.IsDoor(data.Entity) then
		if data.Entity.hasteopen then
			data.Volume = data.Volume * GetConVar("sv_smore_door_haste_open_volume_modifier"):GetFloat()
			return true
		elseif data.Entity.stealthopen then
			data.Volume = data.Volume * GetConVar("sv_smore_door_stealth_open_volume_modifier"):GetFloat()
			return true
		end
	end
end)

if CLIENT then
TTT2SMORE.HookAdd("SMORETTTLanguageChanged", "door_stealth_and_haste_open", function()
	if GetConVar("sv_smore_door_stealth_open_enable"):GetBool() then
		LANG.AddToLanguage(LANG.ActiveLanguage, "door_open", LANG.GetTranslationFromLanguage("door_open_stealth", LANG.ActiveLanguage))
		LANG.AddToLanguage(LANG.ActiveLanguage, "door_close", LANG.GetTranslationFromLanguage("door_close_stealth", LANG.ActiveLanguage))
	end
end)
end

TTT2SMORE.HookAdd("SMORECreateConVars", "door_stealth_and_haste_open", function()
	TTT2SMORE.MakeCVar("door_stealth_and_haste_open_reset_hesitation", "1.5")

	TTT2SMORE.MakeCVar("door_stealth_open_enable", "0")
	TTT2SMORE.MakeCVar("door_stealth_open_speed_modifier", "0.5")
	TTT2SMORE.MakeCVar("door_stealth_open_volume_modifier", "0.25")

	TTT2SMORE.MakeCVar("door_haste_open_enable", "0")
	TTT2SMORE.MakeCVar("door_haste_open_speed_modifier", "2")
	TTT2SMORE.MakeCVar("door_haste_open_volume_modifier", "4")
end)

TTT2SMORE.HookAdd("SMOREServerAddonSettings", "door_stealth_and_haste_open", function(parent, general)
	local door_stealth_and_haste_open = vgui.CreateTTT2Form(parent, "smore_settings_mechanic_door_stealth_and_haste_open")

	TTT2SMORE.MakeElement(door_stealth_and_haste_open, "door_stealth_and_haste_open_reset_hesitation", "MakeSlider", {max = 32, decimal = 2})

	TTT2SMORE.MakeElement(door_stealth_and_haste_open, "door_stealth_open_enable", "MakeCheckBox")
	TTT2SMORE.MakeElement(door_stealth_and_haste_open, "door_stealth_open_speed_modifier", "MakeSlider", {max = 1, decimal = 2})
	TTT2SMORE.MakeElement(door_stealth_and_haste_open, "door_stealth_open_volume_modifier", "MakeSlider", {max = 2, decimal = 2})

	TTT2SMORE.MakeElement(door_stealth_and_haste_open, "door_haste_open_enable", "MakeCheckBox")
	TTT2SMORE.MakeElement(door_stealth_and_haste_open, "door_haste_open_speed_modifier", "MakeSlider", {max = 4, decimal = 2})
	TTT2SMORE.MakeElement(door_stealth_and_haste_open, "door_haste_open_volume_modifier", "MakeSlider", {max = 8, decimal = 2})
end)

TTT2SMORE.AddMechanic("DoorStealthAndHasteOpen", mech)