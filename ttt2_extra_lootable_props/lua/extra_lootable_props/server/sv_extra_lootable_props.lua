-- remake of https://steamcommunity.com/sharedfiles/filedetails/?id=654149429
ExtraLootableProps = ExtraLootableProps or {}

ExtraLootableProps.CVARS = ExtraLootableProps.CVARS or {
	enabled = CreateConVar(
		"sv_elp_enabled",
		"1",
		{FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}
	),
	only_appropriate_props = CreateConVar(
		"sv_elp_only_appropriate_props",
		"1",
		{FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}
	),
	prop_name_matches = CreateConVar(
		"sv_elp_prop_name_matches",
		"drum|crate|box|cardboard|drawer|closet",
		{FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}
	),
	max_items_per_prop = CreateConVar(
		"sv_elp_max_items_per_prop",
		"1",
		{FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}
	),
	drop_chance = CreateConVar(
		"sv_elp_drop_chance",
		"33",
		{FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}
	),
	weapon_drop_chance = CreateConVar(
		"sv_elp_weapon_drop_chance",
		"0",
		{FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}
	),
	-- debug_print = CreateConVar(
	--     "sv_elp_debug_print",
	--     "0",
	--     {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}
	-- ),
}

ExtraLootableProps.SpawnItem = function(pos, broken_prop)
	if not (util.PointContents(pos) == CONTENTS_SOLID) and
		(not IsValid(broken_prop) or IsValid(broken_prop:GetPhysicsObject()) and
		broken_prop:GetPhysicsObject():IsMotionEnabled()) then
		if math.random(1, 100) <= ExtraLootableProps.CVARS.weapon_drop_chance:GetInt() then
			entspawn.SpawnRandomWeapon(broken_prop)
		else
			entspawn.SpawnRandomAmmo(broken_prop)
		end
	end
end

ExtraLootableProps.CheckModelName = function(in_str)
	local strings = string.Split(ExtraLootableProps.CVARS.prop_name_matches:GetString(),"|")
	for _, check in ipairs(strings) do
		local did_find = not not string.find(in_str, check)
		if did_find then return true end
	end
	return false
end

ExtraLootableProps.PropBreak = function(attacker, prop)
	if not ExtraLootableProps.CVARS.enabled:GetBool() then return end
	local check_pass = math.random(1, 100) <= ExtraLootableProps.CVARS.drop_chance:GetInt()
	local name_pass = (ExtraLootableProps.CVARS.only_appropriate_props:GetBool() and ExtraLootableProps.CheckModelName(string.lower(prop:GetModel())) or true)
	local iterations = math.max(1, math.random(1, ExtraLootableProps.CVARS.max_items_per_prop:GetInt()))
	if check_pass and name_pass then
		for _ = 1, iterations do
			ExtraLootableProps.SpawnItem(prop:LocalToWorld(prop:OBBCenter()), prop)
		end
	end
end

ExtraLootableProps.Init = function()
	hook.Add(
		"PropBreak",
		"ExtraLootableProps_PropBreak",
		ExtraLootableProps.PropBreak
	)
end

hook.Add(
	"PostInitPostEntity",
	"ExtraLootableProps_Init",
	ExtraLootableProps.Init
)