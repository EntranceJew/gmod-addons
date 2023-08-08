local function GiveExtraAmmo()
    for _, ply in ipairs(player.GetAll()) do

        if ply:GetActiveWeapon() ~= NULL then
            local wep = ply:GetActiveWeapon()
            local ammoType = wep:GetPrimaryAmmoType()
            local clipSize = wep:GetMaxClip1()
            local extraAmmo = clipSize

            ply:GiveAmmo(extraAmmo, ammoType, true)
        end
    end
end

hook.Add("TTTBeginRound", "GiveExtraAmmo", GiveExtraAmmo)
