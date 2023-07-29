if not SERVER then return end

if not ExtraLootableTTT then
	ExtraLootableTTT = {}
else
	ExtraLootableTTT = ExtraLootableTTT
end

ExtraLootableTTT.CVARS = {
	extra_lootable_ttt_enabled = CreateConVar("extra_lootable_ttt_enabled", 1, bit.bor(FCVAR_NOTIFY, FCVAR_ARCHIVE), "If set to 1, enables Extra Lootable TTT."),
	extra_lootable_ttt_only_appropriate_props = CreateConVar("extra_lootable_ttt_only_appropriate_props", 1, bit.bor(FCVAR_NOTIFY, FCVAR_ARCHIVE), "Items can only be dropped from appropiate props like crates, drawers and drums."),
	extra_lootable_ttt_max_items_per_prop = CreateConVar("extra_lootable_ttt_max_items_per_prop", 1, bit.bor(FCVAR_NOTIFY, FCVAR_ARCHIVE), "The maximum number of items that can be dropped per prop."),
	extra_lootable_ttt_drop_chance = CreateConVar("extra_lootable_ttt_drop_chance", 33, bit.bor(FCVAR_NOTIFY, FCVAR_ARCHIVE), "The percentage chance for a prop to drop an item upon breaking it. ( 0 - 100)"),
	extra_lootable_ttt_weapon_drop_chance = CreateConVar("extra_lootable_ttt_weapon_drop_chance", 0, bit.bor(FCVAR_NOTIFY, FCVAR_ARCHIVE), "The percentage chance for the item in the prop to be a weapon. Set to 0 to disable. ( 0 - 100)"),
}

ExtraLootableTTT.CheckStrings = {
	"drum",
	"crate",
	"box",
	"cardboard",
	"drawer",
	"closet",
}

ExtraLootableTTT.SpawnItem = function(pos, broken_prop)
	if not (util.PointContents(pos) == CONTENTS_SOLID) and
		(not IsValid(broken_prop) or IsValid(broken_prop:GetPhysicsObject()) and
		broken_prop:GetPhysicsObject():IsMotionEnabled()) then
		if math.random(1, 100) <= ExtraLootableTTT.CVARS.extra_lootable_ttt_weapon_drop_chance:GetInt() then
			entspawn.SpawnRandomWeapon(broken_prop)
		else
			entspawn.SpawnRandomAmmo(broken_prop)
		end
	end
end

ExtraLootableTTT.CheckModelName = function(in_str)
	for _, check in ipairs(ExtraLootableTTT.CheckStrings) do
		local did_find = not not string.find(in_str, check)
		if did_find then return true end
	end
	return false
end

ExtraLootableTTT.PropBreak = function(attacker, prop)
	if ExtraLootableTTT.CVARS.extra_lootable_ttt_enabled:GetBool() == false then return end
	local check_pass = math.random(1, 100) <= ExtraLootableTTT.CVARS.extra_lootable_ttt_drop_chance:GetInt()
	local name_pass = (ExtraLootableTTT.CVARS.extra_lootable_ttt_only_appropriate_props:GetBool() and ExtraLootableTTT.CheckModelName(string.lower(prop:GetModel())) or true)
	local iterations = math.max(1, math.random(1, ExtraLootableTTT.CVARS.extra_lootable_ttt_max_items_per_prop:GetInt()))
	if check_pass and name_pass then
		for _ = 1, iterations do
			ExtraLootableTTT.SpawnItem(prop:LocalToWorld(prop:OBBCenter()), prop)
		end
	end
end

ExtraLootableTTT.Init = function()
	hook.Add(
		"PropBreak",
		"ExtraLootableTTT_PropBreak",
		ExtraLootableTTT.PropBreak
	)
end

hook.Add(
	"PostInitPostEntity",
	"ExtraLootableTTT_Init",
	ExtraLootableTTT.Init
)