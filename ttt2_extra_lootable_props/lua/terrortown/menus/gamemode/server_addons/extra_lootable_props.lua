CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"
CLGAMEMODESUBMENU.title = "extra_lootable_props_addon_info"

include("extra_lootable_props/shared/sh_dtextentry_ttt2.lua")

local go_go_gadget_extendo_dick = vgui.GetControlTable("DFormTTT2")
if not go_go_gadget_extendo_dick then return end

local function MakeReset(parent)
	local reset = vgui.Create("DButtonTTT2", parent)

	reset:SetText("button_default")
	reset:SetSize(32, 32)

	reset.Paint = function(slf, w, h)
		derma.SkinHook("Paint", "FormButtonIconTTT2", slf, w, h)

		return true
	end

	reset.material = Material("vgui/ttt/vskin/icon_reset")

	return reset
end

local function getHighestParent(slf)
	local parent = slf
	local checkParent = slf:GetParent()

	while ispanel(checkParent) do
		parent = checkParent
		checkParent = parent:GetParent()
	end

	return parent
end

---
-- Adds a slider to the form
-- @param table data The data for the slider
-- @return Panel The created slider
-- @realm client
function go_go_gadget_extendo_dick:MakeTextEntry(data)
	local left = vgui.Create("DLabelTTT2", self)

	left:SetText(data.label)

	left.Paint = function(slf, w, h)
		derma.SkinHook("Paint", "FormLabelTTT2", slf, w, h)

		return true
	end

	local right = vgui.Create("DTextEntryTTT2", self)

	local reset = MakeReset(self)
	right:SetResetButton(reset)

	right:SetUpdateOnType(false)
	right:SetHeightMult(1)

	right.OnGetFocus = function(slf)
		getHighestParent(self):SetKeyboardInputEnabled(true)
	end

	right.OnLoseFocus = function(slf)
		getHighestParent(self):SetKeyboardInputEnabled(false)
	end



	right:SetPlaceholderText("")
	right:SetCurrentPlaceholderText("")

	-- Set default if possible even if the convar could still overwrite it
	right:SetDefaultValue(data.default)
	right:SetConVar(data.convar)
	right:SetServerConVar(data.serverConvar)
	-- right:SizeToContents()
	-- right:PerformLayout()

	if not data.convar and not data.serverConvar and data.initial then
		right:SetValue(data.initial)
	end

	right.OnValueChanged = function(slf, value)
		if isfunction(data.OnChange) then
			-- print("ovc:", slf, value)
			data.OnChange(slf, value)
		end
	end

	right:SetTall(32)
	right:Dock(TOP)


	self:AddItem(left, right, reset)

	if IsValid(data.master) and isfunction(data.master.AddSlave) then
		data.master:AddSlave(left)
		data.master:AddSlave(right)
		data.master:AddSlave(reset)
	end

	return left
end

function CLGAMEMODESUBMENU:Populate(parent)
	-- possession:MakeHelp({
	--     label = "help_ttt2_sv_psng_transparent_render_mode"
	-- })

	local general = vgui.CreateTTT2Form(parent, "extra_lootable_props_settings_general")

	general:MakeHelp({
		label = "help_ttt2_sv_elp_enabled",
	})
	general:MakeCheckBox({
	    label = "label_ttt2_sv_elp_enabled",
	    serverConvar = "sv_elp_enabled"
	})

	general:MakeHelp({
		label = "help_ttt2_sv_elp_only_appropriate_props",
	})
	general:MakeCheckBox({
	    label = "label_ttt2_sv_elp_only_appropriate_props",
	    serverConvar = "sv_elp_only_appropriate_props"
	})

	general:MakeHelp({
		label = "help_ttt2_sv_elp_prop_name_matches",
	})
	general:MakeTextEntry({
		label = "label_ttt2_sv_elp_prop_name_matches",
		serverConvar = "sv_elp_prop_name_matches",
		-- OnChange = function(...) print("g.mte.oc:", ...) end,
	})

	general:MakeHelp({
		label = "help_ttt2_sv_elp_max_items_per_prop",
	})
	general:MakeSlider({
		label = "label_ttt2_sv_elp_max_items_per_prop",
		serverConvar = "sv_elp_max_items_per_prop",
		min = 0,
		max = 16,
		decimal = 0,
	})

	general:MakeHelp({
		label = "help_ttt2_sv_elp_drop_chance",
	})
	general:MakeSlider({
		label = "label_ttt2_sv_elp_drop_chance",
		serverConvar = "sv_elp_drop_chance",
		min = 0,
		max = 100,
		decimal = 0,
	})

	general:MakeHelp({
		label = "help_ttt2_sv_elp_weapon_drop_chance",
	})
	general:MakeSlider({
		label = "label_ttt2_sv_elp_weapon_drop_chance",
		serverConvar = "sv_elp_weapon_drop_chance",
		min = 0,
		max = 100,
		decimal = 0,
	})
end