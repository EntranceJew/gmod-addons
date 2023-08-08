local EPSILON = 0.000000001

-- local function nearly_equal(a, b)
--   -- float epsilon = 128 * FLT_EPSILON, float abs_th = FLT_MIN)
--   -- those defaults are arbitrary and could be removed
--   if a == b then return true end

--   local diff = math.abs(a-b)
--   local norm = math.min((math.abs(a) + math.abs(b)), math.huge)

--   return diff < math.max(EPSILON, EPSILON * norm)
-- end

-- function nearly_equal(lhs, rhs)
--       epsilon  = epsilon or 1E-12
--       return math.abs(lhs - rhs) <= EPSILON * (math.abs(lhs) + math.abs(rhs))
-- end

function nearly_equal(lhs,rhs)
	if lhs == rhs then return true end
	return math.abs(lhs - rhs) <= EPSILON * (math.abs(lhs) + math.abs(rhs)) / 2
end

hook.Add("Initialize", "ShopEditorExpand", function()
	print("hmm")
	ShopEditor.savingKeys.AllowDrop = {
		group = 2,
		order = 100,
		typ = "bool",
		default = true,
		name = "allow_drop",
		inverted = false,
		b_desc = true,
		showForItem = true,
		master = nil,
	}
	ShopEditor.savingKeys.DoNotDropOnDeath = {
		group = 2,
		order = 110,
		typ = "bool",
		default = false,
		name = "do_not_drop_on_death",
		inverted = true,
		b_desc = true,
		showForItem = true,
		master = nil,
	}
	ShopEditor.savingKeys.DamageScaling = {
		group = 3,
		order = 120,
		typ = "number",
		bits = 32,
		default = 1,
		min = 0,
		max = 5,
		decimal = 2,
		name = "damage_scaling",
		b_desc = true,
		showForItem = true,
		master = nil,
	}
	ShopEditor.savingKeysCount = table.Count(ShopEditor.savingKeys)
	ShopEditor.savingKeysBitCount = math.ceil(math.log(ShopEditor.savingKeysCount + 1, 2))
	

	if CLIENT then
		L = LANG.GetLanguageTableReference("en")
		L["equipmenteditor_name_allow_drop"] = "Allow Drop"
		L["equipmenteditor_desc_allow_drop"] = "Whether an item can be dropped by players."
		L["equipmenteditor_name_do_not_drop_on_death"] = "Do Not Drop On Death"
		L["equipmenteditor_desc_do_not_drop_on_death"] = "Whether an item will be dropped on death."
		L["equipmenteditor_name_damage_scaling"] = "Damage Scaling"
		L["equipmenteditor_desc_damage_scaling"] = "Whether an item will be dropped on death."
	end
end)

hook.Add("LoadedFallbackShops", "ShopEditorExpand", function()
	local sweps = weapons.GetList()

	for i = 1, #sweps do
		local eq = sweps[i]

		if eq.DamageScaling == 2 then
			print("gadzooks")
			PrintTable(eq)
		end

		if eq.DamageScaling ~= nil and (eq.DamageScaling > 1 or eq.DamageScaling < 1) then
			PrintTable(eq)
			local b = eq.ShootBullet
			if not b then
				print("we went to al of bam bam")
				local base = baseclass.Get(eq.Base)
				b = base.ShootBullet
			end

			eq.ShootBullet = function(self, dmg, recoil, numbul, cone)
				b(self, dmg * self.DamageScaling, recoil, numbul, cone)
			end
		end
	end
end)


hook.Add("TTT2RegisterWeaponID", "ShopEditorExpand", function(equipment)
	local b = equipment.PreDrop
	equipment.PreDrop = function(self, deathDrop)
		print("EJEW: hello, we are predrop", deathDrop, self.DoNotDropOnDeath)
		if self.DoNotDropOnDeath and deathDrop then
			self:Remove()
		else
			if b then
				b(self)
			end
		end
	end

	-- if equipment.DamageScaling and not nearly_equal(equipment.DamageScaling, 1) then
		
	-- else
	--     print("we didn't do it reddit")
	-- end
end)
-- hook.Run("Initialize")