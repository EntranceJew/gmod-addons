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
end
local givewepcmd = ulx.command(CATEGORY_NAME, "ulx givewep", givewep, "!givewep")
givewepcmd:addParam{type = ULib.cmds.PlayersArg}
givewepcmd:addParam{type = ULib.cmds.StringArg, hint = "weapon"}
givewepcmd:defaultAccess(ULib.ACCESS_SUPERADMIN)
givewepcmd:help("Gives the <target(s)> the weapon by name.")