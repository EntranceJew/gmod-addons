local CATEGORY_NAME = "TTT Fun"
local gamemode_error = "The current gamemode is not trouble in terrorest town"

local function giveitem(calling_ply, target_plys, item_name, should_silent)
	if GetConVar("gamemode"):GetString() ~= "terrortown" then
		ULib.tsayError(calling_ply, gamemode_error, true)
	else
		local thing
		for i = 1, #target_plys do
			thing = target_plys[i]:GiveEquipmentItem(item_name)
		end

		ulx.fancyLogAdmin(calling_ply, true, "#A gave item #s to #T", thing, target_plys)
	end
end
local giveitemcmd = ulx.command(CATEGORY_NAME, "ulx giveitem", giveitem, "!giveitem")
giveitemcmd:addParam{type = ULib.cmds.PlayersArg}
giveitemcmd:addParam{type = ULib.cmds.StringArg, hint = "item"}
giveitemcmd:defaultAccess(ULib.ACCESS_SUPERADMIN)
giveitemcmd:help("Gives the <target(s)> the item by name.")