if SERVER then
    hook.Add("TTTInitPostEntity", "HOUSERULES_ShopEditorListener", function()
        local linked_roles = {
            [ROLE_DETECTIVE] = {ROLE_DEFECTIVE},
            [ROLE_TRAITOR] = {ROLE_DEFECTIVE},
        }

        local old_add = ShopEditor.AddToShopEditor
        local old_remove = ShopEditor.RemoveFromShopEditor

        local function scoop(ply, rd, equip, cb)
            -- print("scooping", rd.name)
            cb(ply, rd, equip)
            if linked_roles[rd.index] then
                for _, role_id in ipairs(linked_roles[rd.index]) do
                    local nrole = roles.GetByIndex(role_id)
                    -- print("scooping", rd.name, "to", nrole.name)
                    cb(ply, nrole, equip)
                end
            end
        end

        ShopEditor.AddToShopEditor = function(ply, rd, equip)
            scoop(ply, rd, equip, old_add)
        end

        ShopEditor.RemoveFromShopEditor = function(ply, rd, equip)
            scoop(ply, rd, equip, old_remove)
        end
    end)
end
-- ShopEditor.AddToShopEditor(ply, rd, equip)
-- ShopEditor.RemoveFromShopEditor(ply, rd, equip)