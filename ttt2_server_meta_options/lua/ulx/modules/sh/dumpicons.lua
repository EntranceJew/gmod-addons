local CATEGORY_NAME = "TTT Fun"
local gamemode_error = "The current gamemode is not trouble in terrorest town"

local function givewep(calling_ply, target_plys, weapon_name, should_silent)
	if GetConVar("gamemode"):GetString() ~= "terrortown" then
		ULib.tsayError(calling_ply, gamemode_error, true)
	else
		local thing
		for i = 1, #target_plys do
			thing = target_plys[i]:GiveEquipmentWeapon(weapon_name)
		end

		ulx.fancyLogAdmin(calling_ply, true, "#A gave weapon #s to #T", thing, target_plys)
	end


if true then
    local dump = {}
    for _, wep in ipairs(weapons.GetList()) do
        local class = wep.ClassName
        local SWEP = weapons.GetStored(class)

        dump[#dump + 1] = {
            class,
            tostring(SWEP.Icon or SWEP.material or "vgui/ttt/icon_id"),
        }
    end
    for _, item in ipairs(items.GetList()) do
        local class = item.ClassName
        local ITEM = items.GetStored(class)

        dump[#dump + 1] = {
            class,
            tostring(ITEM.Icon or ITEM.material or "vgui/ttt/icon_id"),
        }
    end

  	print("== INITIATING ICON DUMP == ")
    file.CreateDir( "dumped_icons" )
    for _, icon in ipairs(dump) do
        local path = "materials/" .. icon[2]
    	local out_path = ""
    	local found = false

    	if file.Exists( path, "GAME" ) then
      		found = true
      		out_path = path
    	end

    	if not found and file.Exists( path .. ".png", "GAME" ) then
        	found = true
        	out_path = path .. ".png"
      	end
      	if not found and file.Exists( path .. ".vmt", "GAME" ) then
        	found = true
        	out_path = path .. ".vmt"
      	end
    	if not found then
      		print("could not locate file:", icon[1], icon[2], out_path)
    	end

    	if file.Exists( out_path, "GAME" ) then
      		icon[3] = out_path
        	local data = file.Read( out_path, "GAME" )
        	file.Write("dumped_icons/" .. icon[1] .. ".png", data)
    	else
      		print("could not copy file for", icon[1], icon[2], out_path)
    	end
    end
    file.Write("dumped_icons/_manifest_.json", util.TableToJSON( dump, true ) )
    --PrintTable(dump) --
end
end
local givewepcmd = ulx.command(CATEGORY_NAME, "ulx givewep", givewep, "!givewep")
givewepcmd:addParam{type = ULib.cmds.PlayersArg}
givewepcmd:addParam{type = ULib.cmds.StringArg, hint = "weapon"}
givewepcmd:defaultAccess(ULib.ACCESS_SUPERADMIN)
givewepcmd:help("Gives the <target(s)> the weapon by name.")