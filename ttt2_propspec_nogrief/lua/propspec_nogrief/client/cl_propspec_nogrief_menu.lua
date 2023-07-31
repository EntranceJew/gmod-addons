local go_go_gadget_extendo_dick = vgui.GetControlTable("DFormTTT2")

-- And here we go:
-- go_go_gadget_extendo_dick = FindMetaTable( "DFormTTT2" )

local GetEnumKeys = function(prefix, target)
    target = target or _G
    local result = {}
    for enum_name, value in pairs(_G) do
        if enum_name:sub(1, #prefix) == prefix then
            table.insert(result, {
                name  = enum_name,
                value = value
            })
        end
    end

    table.sort(result, function(a,b)
        return a.value < b.value
    end)

    return result
end

-- local IntegerToFlags = function(int, enum_def)
--     local out_flags = {}
--     for i = #enum_def, 1, -1 do
--         if int > enum_def.value then
--             int = int - enum_def.value
--             table.insert(out_flags, enum_def.name)
--         end
--     end
--     if int > 0 then

--     end
-- end

if not go_go_gadget_extendo_dick then return end

function go_go_gadget_extendo_dick:MakeFlagEnum(config)
    --[[
        config.label
        config.serverConvar
        config.help_label
    ]]
    if config.help_label then
        self:MakeHelp({
            label = config.help_label
        })
    end


    local keys = GetEnumKeys("CONTENTS_")
    for _, enum in ipairs(keys) do
        self:MakeCheckBox({
            label = enum.name,
            OnChange = function(_, value)
                enum_value_honk = 0
                if util.StringToType(value, "bool") then
                    enum_value_honk = enum_value_honk + enum.value
                else
                    enum_value_honk = enum_value_honk - enum.value
                end
                print("value is currently:" .. tostring(enum_value_honk))
            end
        })
    end
end