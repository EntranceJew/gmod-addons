local PatchRole = function(role, pre_func, post_func)
    local the_role = roles.GetByIndex(role)

    local grl = the_role.GiveRoleLoadout
    the_role.GiveRoleLoadout = function(self, ply, ...)
        pre_func(self, ply, ...)
        grl(self, ply, ...)
    end
    local rrl = the_role.RemoveRoleLoadout
    the_role.RemoveRoleLoadout = function(self, ply, ...)
        post_func(self, ply, ...)
        rrl(self, ply, ...)
    end
end

if SERVER then
    hook.Add("PostInitPostEntity", "HOUSERULES_PostInitPostEntity_InfectedClimb", function()
        PatchRole(ROLE_INFECTED,
            function(self, ply, ...)
                if INFECTEDS[ply] then return end
                ply:GiveEquipmentItem("item_ttt_climb")
            end,
            function(self, ply, ...)
                if INFECTEDS[ply] then return end
                ply:RemoveEquipmentItem("item_ttt_climb")
            end
        )

        --[[
        PatchRole(ROLE_DETECTIVE,
            function(self, ply, ...)
                ply:GiveEquipmentWeapon("weapon_ttt_handcuffs")
                ply:GiveEquipmentWeapon("weapon_ttt2_lens")
                ply:GiveEquipmentWeapon("weapon_ttt2_deputydeagle")
                ply:GiveEquipmentItem("item_ttt_hunchvision")
            end,
            function(self, ply, ...)
                ply:RemoveEquipmentWeapon("weapon_ttt_handcuffs")
                ply:RemoveEquipmentWeapon("weapon_ttt2_lens")
                ply:RemoveEquipmentWeapon("weapon_ttt2_deputydeagle")
                ply:RemoveEquipmentItem("item_ttt_hunchvision")
            end
        )
        ]]
    end)
end