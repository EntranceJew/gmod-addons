if SERVER then
    resource.AddFile( "models/weapons/v_binoculars.mdl" )
    resource.AddFile( "models/weapons/w_binoculars.mdl" )
    resource.AddFile( "materials/models/weapons/v_binoculars/binocular2.vmt" )
end

hook.Add("TTT2RegisterWeaponID", "TTT2FixedWeapons_TTT2RegisterWeaponID", function(eq)
    if eq.ClassName == "weapon_ttt_binoculars" then
        eq.ViewModel = "models/weapons/v_binoculars.mdl"
        eq.WorldModel = "models/weapons/w_binoculars.mdl"
        eq.HoldType = "pistol"
        eq.GetViewModelPosition = function( self, pos, ang )
            local fwd = ang:Forward()
            local distance = 80
            pos = pos - Vector( -fwd.x * distance, -fwd.y * distance, -fwd.z * distance )
            return pos, ang
        end
        eq.DrawWorldModel = function(self, flags)
            self:DrawModel( flags )
        end
        local szl = eq.SetZoomLevel
        eq.SetZoomLevel = function(self, level)
            szl(self, level)
            local owner = self:GetOwner()
            if level ~= 1 then
                owner:DrawViewModel( false )
            else
                -- Draws the view model again after the FOV has been adjusted to prevent crazy stuff from happening
                timer.Simple(0.2, function()
                    if IsValid( owner ) then
                        owner:DrawViewModel( true )
                    end
                end)
            end
        end
    end
end)