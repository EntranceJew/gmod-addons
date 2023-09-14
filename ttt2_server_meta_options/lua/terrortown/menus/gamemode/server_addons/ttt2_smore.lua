CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"
CLGAMEMODESUBMENU.title = "smore_addon_info"

function CLGAMEMODESUBMENU:Populate(parent)
	local general = vgui.CreateTTT2Form(parent, "smore_settings_general")

	hook.Run("SMOREServerAddonSettings", parent, general)
end