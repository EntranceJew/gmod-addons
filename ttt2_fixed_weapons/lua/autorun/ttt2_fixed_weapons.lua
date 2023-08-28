if SERVER then
    AddCSLuaFile()
    AddCSLuaFile("ttt2_fixed_weapons/shared/sh_binoculars_model.lua")

    include("ttt2_fixed_weapons/shared/sh_binoculars_model.lua")
else
    include("ttt2_fixed_weapons/shared/sh_binoculars_model.lua")
end
