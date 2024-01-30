TTT2SMORE.GetListFromConVar = function(convar)
	return string.Split(GetConVar( "sv_smore_" .. convar):GetString(),   "|")
end

TTT2SMORE.GetColorFromConVar = function(convar)
	local cv = GetConVar( "sv_smore_" .. convar)
	local str = string.Explode(" ", cv:GetString())
	return Color(str[1], str[2], str[3], str[4])
end

TTT2SMORE.GetStringFromColor = function(clr)
	return string.format("%d %d %d %d", clr.r, clr.g, clr.b, clr.a)
end

TTT2SMORE.MakeCVar = function(name, default)
---@diagnostic disable-next-line: missing-parameter
	TTT2SMORE.CVARS[name] = CreateConVar(
		"sv_smore_" .. name,
		default,
---@diagnostic disable-next-line: param-type-mismatch
		{FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}
	)
	return TTT2SMORE.CVARS[name]
end

TTT2SMORE.MakeElement = function(form, name, typ, data, no_help)
	local real_data = table.Merge({
		label = "label_ttt2_sv_smore_" .. name,
		help = "help_ttt2_sv_smore_" .. name,
		serverConvar = "sv_smore_" .. name,
		min = 0,
		max = 100,
		decimal = 0,
	}, data or {})
	if not no_help then
		form:MakeHelp({
			label = real_data.help,
			params = real_data.help_params or {},
		})
	end
	return form[typ](form, real_data)
end

TTT2SMORE.MakeRoleElement = function(form, role, name, typ, data, no_help)
	local real_data = table.Merge(data or {}, {
		label = "label_ttt2_sv_smore_all_role_" .. name,
		help = "help_ttt2_sv_smore_all_role_" .. name,
		serverConvar = "sv_smore_" .. role.abbr .. "_" .. name,
	})
	TTT2SMORE.MakeElement(form, name, typ, real_data, no_help)
end

TTT2SMORE.FindChildByName = function(panel, name)
	for i = 0, panel:ChildCount() do
		local child = panel:GetChild(i)
		if child ~= nil and child:GetName() == name then
			return child
		end
	end
end

---comment
---@diagnostic disable-next-line: undefined-doc-name
---@param the_role ROLE
---@param parent Panel
---@param header string?
---@return unknown
TTT2SMORE.ExtendMenu = function(the_role, parent, header)
	header = header or "header_roles_smore_all_role_general"

	local base = TTT2SMORE.FindChildByName(parent, "Panel")
	local target = TTT2SMORE.FindChildByName(base, header)

	if not target then
		target = vgui.CreateTTT2Form(parent, header)
	end
	return target
end

TTT2SMORE.ExtendRoleMenu = function(data, parent, header)
	header = header or "header_roles_smore_all_role_general"
	return TTT2SMORE.ExtendMenu(data, parent, header)
end

TTT2SMORE.ExtendEquipmentMenu = function(data, parent, header)
	header = header or "header_equipment_additional"
	return TTT2SMORE.ExtendMenu(data, parent, header)
end

TTT2SMORE.RegisterRoundData = function(name, data)
	TTT2SMORE.RoundDataProto[name] = data
end

TTT2SMORE.AddFeature = function(name, tbl)
	TTT2SMORE.Features[name] = tbl
end

TTT2SMORE.AddMechanic = function(name, tbl)
	TTT2SMORE.Mechanics[name] = tbl
end