concommand.Remove("revert_cvars")
concommand.Add(
    "revert_cvars",
    function (_, _, args, argStr)
        for _, cvar_name in ipairs(args) do
            print("reverting: ", cvar_name)
            local fail = function(...)
                print("revert_cvars: cannot revert '" .. cvar_name .. "' because " .. string.Implode(" ", {...}))
            end

            if not ConVarExists(cvar_name) then fail("it does not exist") continue end
            if IsConCommandBlocked(cvar_name) then print("it is blocked (probably)") continue end
            local cvar = GetConVar(cvar_name)
            if not cvar then fail("it is a flagrant liar") continue end

            local succ, err = pcall(function() cvar:Revert() end)
            if not succ then
                -- probably "not created in lua"
                local succ, err = pcall(function()
                    RunConsoleCommand(cvar_name, cvar:GetDefault())
                end)
                if not succ then fail(err) continue end
            end
        end
    end,
    nil, -- @TODO: cannot get a list of all existant cvars easily
    "Revert one or more ConVars to their respective default values."
)