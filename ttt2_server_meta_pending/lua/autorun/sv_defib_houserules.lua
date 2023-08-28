if SERVER then
    hook.Remove("Initialize", "HOUSERULES_Initialize")
    hook.Add("Initialize", "HOUSERULES_Initialize", function()
        hook.Add("TTT2AttemptDefibPlayer", "HOUSERULES_TTT2AttemptDefibPlayer", function(owner, rag, defib)
            local ply = CORPSE.GetPlayer(rag)
            if IsValid(ply) and ply:IsInnocent() then
                LANG.Msg(owner, "defi_error_player_innocent", nil, MSG_MSTACK_WARN)
                return false
            end
        end)

        hook.Add("TTT2DefibError", "HOUSERULES_TTT2DefibError", function(typ, defib, owner, rag)
            if typ ~= 8 then return end
            -- @TODO: make it so that this is a non-inno role
            -- @TODO: possibly also check for roles
            local cost = defib.credits or 1
            rag:Remove()
            defib:Remove()
            owner:AddCredits(cost)
            LANG.Msg(owner, "defi_error_player_disconnect_refund", {cost = cost}, MSG_MSTACK_WARN)
            return false
        end)
    end)
end