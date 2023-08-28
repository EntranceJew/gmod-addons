---@diagnostic disable: missing-parameter, param-type-mismatch
TTT2ServerMetaOptions = TTT2ServerMetaOptions or {}

TTT2ServerMetaOptions.CVARS = TTT2ServerMetaOptions.CVARS or {
	enabled = CreateConVar(
		"sv_smo_enabled",
		"1",
		{FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}
	),
	only_appropriate_props = CreateConVar(
		"sv_smo_only_appropriate_props",
		"1",
		{FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}
	),
	prop_name_matches = CreateConVar(
		"sv_smo_prop_name_matches",
		"drum|crate|box|cardboard|drawer|closet",
		{FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}
	),
	max_items_per_prop = CreateConVar(
		"sv_smo_max_items_per_prop",
		"1",
		{FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}
	),
	drop_chance = CreateConVar(
		"sv_smo_drop_chance",
		"33",
		{FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}
	),
	weapon_drop_chance = CreateConVar(
		"sv_smo_weapon_drop_chance",
		"0",
		{FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}
	),
	-- debug_print = CreateConVar(
	--     "sv_smo_debug_print",
	--     "0",
	--     {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}
	-- ),
}

TTT2ServerMetaOptions.Init = function()
	-- hook.Add(
	-- 	"PropBreak",
	-- 	"ExtraLootableProps_PropBreak",
	-- 	TTT2ServerMetaOptions.PropBreak
	-- )
end

hook.Add(
	"PostInitPostEntity",
	"TTT2ServerMetaOptions_Init",
	TTT2ServerMetaOptions.Init
)