
local replacementTexture = "cs_havana/mouth.vtf"

local function replaceAnimatedMaterials()
    local worldEntity = game.GetWorld()
    local materials = worldEntity:GetMaterials()
    for _, materialPath in ipairs(materials) do
        local material = Material(materialPath)
        if material:GetInt("$frame") and material:GetInt("$frame") > 0 then
            material:SetTexture("$basetexture", replacementTexture)
            print("Replaced animated material:", materialPath)
        end
    end
end

hook.Add("PostRender", "ReplaceAnimatedMaterials", function()
    if game.GetMap() == "ttt_dn_hollywoodholocaust_v2" then
    	replaceAnimatedMaterials()
    end
end)

