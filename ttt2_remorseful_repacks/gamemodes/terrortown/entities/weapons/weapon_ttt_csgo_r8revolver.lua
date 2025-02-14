SWEP.PrintName = "R8 Revolver"
-- my edits
SWEP.Base = "weapon_tttbase"
SWEP.Kind = WEAPON_PISTOL
SWEP.Primary.Ammo = "AlyxGun"
SWEP.AutoSpawnable = true
SWEP.InLoadoutFor = nil
SWEP.Icon = "vgui/ttt/icon_weapon_ttt_csgo_r8revolver"
SWEP.AmmoEnt = "item_ammo_revolver_ttt"
SWEP.AllowDrop = true
SWEP.IsSilent = false
SWEP.NoSights = true
SWEP.Primary.ClipMax = 8
-- end of my edits
SWEP.ViewModelFOV = 80
SWEP.ViewModel = "models/weapons/v_models/csgo/v_pist_revolver.mdl"
SWEP.WorldModel = "models/weapons/w_models/csgo/w_pist_revolver.mdl"
SWEP.ViewModelFlip = false
SWEP.BobScale = 0.4
SWEP.SwayScale = 0.75
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Weight = 7
SWEP.Slot = 1
SWEP.SlotPos = 0
SWEP.UseHands = true
SWEP.HoldType = "revolver"
SWEP.FiresUnderwater = true
SWEP.DrawCrosshair = false
SWEP.DrawAmmo = true
SWEP.CSMuzzleFlashes = 1
SWEP.Hammer = 0
SWEP.HammerTimer = CurTime()
SWEP.InspectTimer = CurTime()
SWEP.ShotTimer = CurTime()
SWEP.Reloading = 0
SWEP.ReloadingTimer = CurTime()
SWEP.ReloadingTime = 1.97
SWEP.FireDelay = 0.2
SWEP.ReloadingStage = 0
SWEP.ReloadingStageTimer = CurTime()
SWEP.Idle = 0
SWEP.IdleTimer = CurTime()
--SWEP.Speed = 176
SWEP.CrosshairDistance = 24
SWEP.Primary.Sound = Sound("Weapon_Revolver_CSGO.Single")
SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 8
SWEP.Primary.Automatic = false
SWEP.Primary.Damage = 50
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.Spread = 0.002
SWEP.Primary.SpreadMin = 0.002
SWEP.Primary.SpreadMax = 0.065
SWEP.Primary.SpreadKick = 0.05
SWEP.Primary.SpreadMove = 0.065
SWEP.Primary.SpreadAir = 0.065
SWEP.Primary.SpreadTimer = CurTime()
SWEP.Primary.SpreadTime = 0.9
SWEP.Primary.NumberOfShots = 1
SWEP.Primary.Delay = 0.5
SWEP.Primary.Force = 3
SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 0.4
SWEP.Secondary.Spread = 0.08
---------sounds-----------------------------------------------------------
sound.Add({
    name = "Weapon.WeaponMove2",
    channel = CHAN_ITEM,
    level = SNDLVL_65dB,
    volume = 0.15,
    sound = Sound("weapons/csgo/movement2.wav"),
})

sound.Add({
    name = "Weapon.WeaponMove3",
    channel = CHAN_ITEM,
    level = SNDLVL_65dB,
    volume = 0.15,
    sound = Sound("weapons/csgo/movement3.wav"),
})

sound.Add({
    name = "Weapon_Revolver_CSGO.Single",
    channel = CHAN_WEAPON, --CHAN_STATIC
    level = SNDLVL_GUNFIRE, --75
    sound = Sound("weapons/csgo/revolver/revolver-1_01.wav"),
})

sound.Add({
    name = "Weapon_Revolver_CSGO.Prepare",
    channel = CHAN_ITEM,
    level = SNDLVL_GUNFIRE,
    volume = { 0.9, 1.0 },
    sound = Sound("weapons/csgo/revolver/revolver_prepare.wav"),
})

sound.Add({
    name = "Weapon_Revolver_CSGO.Draw",
    channel = CHAN_ITEM,
    level = SNDLVL_65dB,
    --volume = 0.3,
    volume = { 0.5, 1 },
    pitch = { 97, 105 },
    sound = Sound("weapons/csgo/revolver/revolver_draw.wav"),
})

sound.Add({
    name = "Weapon_Revolver_CSGO.Clipout",
    channel = CHAN_ITEM,
    level = SNDLVL_70dB,
    pitch = { 97, 105 },
    volume = { 0.5, 1.0 },
    sound = Sound("weapons/csgo/revolver/revolver_clipout.wav"),
})

sound.Add({
    name = "Weapon_Revolver_CSGO.Clipin",
    channel = CHAN_ITEM,
    level = SNDLVL_70dB,
    pitch = { 97, 105 },
    volume = { 0.5, 1.0 },
    sound = Sound("weapons/csgo/revolver/revolver_clipin.wav"),
})

sound.Add({
    name = "Weapon_Revolver_CSGO.Sideback",
    channel = CHAN_ITEM,
    level = SNDLVL_70dB,
    pitch = { 97, 105 },
    volume = { 0.5, 1.0 },
    sound = Sound("weapons/csgo/revolver/revolver_sideback.wav"),
})

sound.Add({
    name = "Weapon_Revolver_CSGO.Siderelease",
    channel = CHAN_ITEM,
    level = SNDLVL_70dB,
    pitch = { 97, 105 },
    volume = { 0.5, 1.0 },
    sound = Sound("weapons/csgo/revolver/revolver_siderelease.wav"),
})

sound.Add({
    name = "Weapon_Revolver_CSGO.BarrelRoll",
    channel = CHAN_ITEM,
    level = SNDLVL_70dB,
    pitch = 120,
    volume = 0.2,
    sound = Sound("weapons/csgo/revolver/revolver_prepare.wav"),
})

-------------------------------------------------------------------------------
function SWEP:Initialize()
    self:SetWeaponHoldType(self.HoldType)
    self.Idle = 0
    self.IdleTimer = CurTime() + 0.5
end

function SWEP:Deploy()
    self:SetWeaponHoldType(self.HoldType)
    self:SendWeaponAnim(ACT_VM_DRAW)
    self:SetNextPrimaryFire(CurTime() + self:GetOwner():GetViewModel():SequenceDuration())
    self:SetNextSecondaryFire(CurTime() + self:GetOwner():GetViewModel():SequenceDuration())
    self.Hammer = 0
    self.HammerTimer = CurTime()
    self.InspectTimer = CurTime() + self:GetOwner():GetViewModel():SequenceDuration()
    self.ShotTimer = CurTime()
    self.Reloading = 0
    self.ReloadingTimer = CurTime() + self:GetOwner():GetViewModel():SequenceDuration()
    self.ReloadingStage = 0
    self.ReloadingStageTimer = CurTime()
    self.Idle = 0
    self.IdleTimer = CurTime() + self:GetOwner():GetViewModel():SequenceDuration()
    return true
end

function SWEP:Holster()
    self.Hammer = 0
    self.HammerTimer = CurTime()
    self.InspectTimer = CurTime()
    self.ShotTimer = CurTime()
    self.Reloading = 0
    self.ReloadingTimer = CurTime()
    self.ReloadingStage = 0
    self.ReloadingStageTimer = CurTime()
    self.Idle = 0
    self.IdleTimer = CurTime()
    return true
end

function SWEP:PrimaryAttack()
    if self.Reloading == 1 then
        return
    end
    if
        (self:Clip1() <= 0 and self:Ammo1() <= 0)
        or (self.FiresUnderwater == false and self:GetOwner():WaterLevel() == 3)
    then
        if SERVER then
            self:GetOwner():EmitSound("Default.ClipEmpty_Pistol")
        end
        self:SetNextPrimaryFire(CurTime() + self.FireDelay)
    end

    if self:Clip1() <= 0 and self:Ammo1() > 0 then
        self:Reload()
    end
    if
        self:Clip1() <= 0 or (self.FiresUnderwater == false and self:GetOwner():WaterLevel() == 3)
    then
        return
    end
    if SERVER then
        local aud = RecipientFilter(true)
        aud:AddPAS(self:GetPos())
        aud:RemovePlayer(self:GetOwner())
        self:GetOwner():EmitSound(
            "Weapon_Revolver_CSGO.Prepare",
            SNDLVL_GUNFIRE,
            100,
            1,
            CHAN_STATIC,
            SND_NOFLAGS,
            0,
            aud
        )
    end
    self:SendWeaponAnim(ACT_VM_HAULBACK)
    self:SetNextPrimaryFire(CurTime() + self.FireDelay)
    self:SetNextSecondaryFire(CurTime() + self.FireDelay)
    self.Hammer = 1
    self.HammerTimer = CurTime() + self.FireDelay
    self.Idle = 0
    self.IdleTimer = CurTime() + self:GetOwner():GetViewModel():SequenceDuration()
end

function SWEP:ShootEffects()
    self:GetOwner():SetAnimation(PLAYER_ATTACK1)
    self:GetOwner():MuzzleFlash()
end

--- does everything to do with firing a bullet
--- @param is_secondary boolean
function SWEP:FireCylinder(is_secondary)
    if
        (self:Clip1() <= 0 and self:Ammo1() <= 0)
        or (self.FiresUnderwater == false and self:GetOwner():WaterLevel() == 3)
    then
        if SERVER then
            self:GetOwner():EmitSound("Default.ClipEmpty_Pistol")
        end
        self:SetNextPrimaryFire(CurTime() + self.FireDelay)
    end

    if is_secondary and self:Clip1() <= 0 and self:Ammo1() > 0 then
        self:Reload()
    end
    if
        self:Clip1() <= 0 or (self.FiresUnderwater == false and self:GetOwner():WaterLevel() == 3)
    then
        return
    end
    local bullet = {}
    bullet.Num = self.Primary.NumberOfShots
    bullet.Src = self:GetOwner():GetShootPos()
    bullet.Dir = self:GetOwner():GetAimVector()
        - self:GetOwner():EyeAngles():Right() * self:GetOwner():GetViewPunchAngles().y * 0.03
        - self:GetOwner():EyeAngles():Up() * self:GetOwner():GetViewPunchAngles().x * 0.03
    local props = is_secondary and self.Secondary or self.Primary
    bullet.Spread = Vector(props.Spread, props.Spread, 0)
    bullet.Tracer = 1
    bullet.Force = self.Primary.Force
    bullet.Distance = 4096
    bullet.Damage = self.Primary.Damage
    bullet.AmmoType = self.Primary.Ammo
    self:EmitSound(self.Primary.Sound)
    self:GetOwner():FireBullets(bullet)
    self:SendWeaponAnim(is_secondary and ACT_VM_SECONDARYATTACK or ACT_VM_PRIMARYATTACK)
    self:ShootEffects()
    self:GetOwner():ViewPunch(Angle(-0.5, -0.5, 0))
    self:TakePrimaryAmmo(self.Primary.TakeAmmo)
    self:SetNextPrimaryFire(CurTime() + props.Delay)
    self:SetNextSecondaryFire(CurTime() + props.Delay)
    if self.Primary.Spread < self.Primary.SpreadMax then
        self.Primary.Spread = self.Primary.Spread
            + (is_secondary and props.Spread or self.Primary.SpreadKick)
    end
    self.Primary.SpreadTimer = CurTime() + self.Primary.SpreadTime
    self.InspectTimer = CurTime() + self.Primary.Delay
    self.ShotTimer = CurTime() + self.Primary.Delay + (not is_secondary and self.FireDelay or 0)
    self.ReloadingTimer = CurTime() + self.Primary.Delay
    -- if not is_secondary then
    self.Hammer = 0
    self.HammerTimer = CurTime()
    -- end
    self.Idle = 0
    self.IdleTimer = CurTime() + self:GetOwner():GetViewModel():SequenceDuration()
end

function SWEP:SecondaryAttack()
    if
        self.InspectTimer <= CurTime()
        and self.ReloadingTimer <= CurTime()
        and (self:GetOwner():KeyDown(IN_USE) or self:GetOwner():IsBot())
    then
        self:SendWeaponAnim(ACT_VM_IDLE_DEPLOYED)
        self.InspectTimer = CurTime() + self:GetOwner():GetViewModel():SequenceDuration()
        self.Idle = 0
        self.IdleTimer = CurTime() + self:GetOwner():GetViewModel():SequenceDuration()
    end

    if (not self:GetOwner():KeyDown(IN_USE)) or self:GetOwner():IsBot() then
        if self.Reloading == 1 then
            return
        end
        self:FireCylinder(true)
    end
end

function SWEP:Reload()
    if
        self.Reloading == 0
        and self.ReloadingTimer <= CurTime()
        and self:Clip1() < self.Primary.ClipSize
        and self:Ammo1() > 0
    then
        self:SendWeaponAnim(ACT_VM_RELOAD)
        self:GetOwner():SetAnimation(PLAYER_RELOAD)
        self:SetNextPrimaryFire(CurTime() + self:GetOwner():GetViewModel():SequenceDuration())
        self:SetNextSecondaryFire(CurTime() + self:GetOwner():GetViewModel():SequenceDuration())
        self.Hammer = 0
        self.HammerTimer = CurTime()
        self.InspectTimer = CurTime() + self:GetOwner():GetViewModel():SequenceDuration()
        self.Reloading = 1
        self.ReloadingTimer = CurTime() + self.ReloadingTime
        self.ReloadingStage = 1
        self.ReloadingStageTimer = CurTime() + 1.033333
        self.Idle = 0
        self.IdleTimer = CurTime() + self:GetOwner():GetViewModel():SequenceDuration()
    end
end

function SWEP:ReloadEnd()
    if self:Ammo1() > (self.Primary.ClipSize - self:Clip1()) then
        self:GetOwner()
            :SetAmmo(self:Ammo1() - self.Primary.ClipSize + self:Clip1(), self.Primary.Ammo)
        self:SetClip1(self.Primary.ClipSize)
    end

    if
        (self:Ammo1() - self.Primary.ClipSize + self:Clip1()) + self:Clip1() < self.Primary.ClipSize
    then
        self:SetClip1(self:Clip1() + self:Ammo1())
        self:GetOwner():SetAmmo(0, self.Primary.Ammo)
    end

    self.Reloading = 0
end

function SWEP:IdleAnimation()
    if self.Idle == 0 then
        self.Idle = 1
    end
    if SERVER and self.Idle == 1 then
        self:SendWeaponAnim(ACT_VM_IDLE)
    end
    self.IdleTimer = CurTime() + self:GetOwner():GetViewModel():SequenceDuration()
end

function SWEP:Think()
    if self.Hammer == 1 then
        if not self:GetOwner():KeyDown(IN_ATTACK) then
            self.Hammer = 0
            self.HammerTimer = CurTime()
            self.Idle = 0
            self.IdleTimer = CurTime()
        end

        if self.HammerTimer <= CurTime() and self:GetOwner():KeyDown(IN_ATTACK) then
            self:FireCylinder(false)
        end
    end

    if self.Reloading == 1 then
        if
            self.ReloadingTimer <= CurTime() + self.ReloadingTime
            and self.ReloadingTimer > CurTime() + 1.75
        then
            self:GetOwner():ViewPunch(Angle(-0.025, 0, 0))
        end
        if self.ReloadingTimer <= CurTime() + 1.75 and self.ReloadingTimer > CurTime() + 1.5 then
            self:GetOwner():ViewPunch(Angle(-0.05, -0.025, 0))
        end
        if self.ReloadingTimer <= CurTime() + 1.5 and self.ReloadingTimer > CurTime() + 1.25 then
            self:GetOwner():ViewPunch(Angle(0.05, -0.05, 0))
        end
        if self.ReloadingTimer <= CurTime() + 1.25 and self.ReloadingTimer > CurTime() + 1 then
            self:GetOwner():ViewPunch(Angle(0.1, -0.075, 0))
        end
        if self.ReloadingTimer <= CurTime() + 1 and self.ReloadingTimer > CurTime() + 0.75 then
            self:GetOwner():ViewPunch(Angle(0.075, -0.1, 0))
        end
        if self.ReloadingTimer <= CurTime() + 0.75 and self.ReloadingTimer > CurTime() + 0.5 then
            self:GetOwner():ViewPunch(Angle(0.05, -0.1, 0))
        end
        if self.ReloadingTimer <= CurTime() + 0.5 and self.ReloadingTimer > CurTime() + 0.25 then
            self:GetOwner():ViewPunch(Angle(-0.05, -0.075, 0))
        end
        if self.ReloadingTimer <= CurTime() + 0.25 and self.ReloadingTimer > CurTime() then
            self:GetOwner():ViewPunch(Angle(-0.025, 0.025, 0))
        end
    end

    if self.ShotTimer > CurTime() then
        self.Primary.SpreadTimer = CurTime() + self.Primary.SpreadTime
    end
    if self:GetOwner():IsOnGround() then
        if self:GetOwner():GetVelocity():Length() <= 100 then
            if self.Primary.SpreadTimer <= CurTime() then
                self.Primary.Spread = self.Primary.SpreadMin
            end
            if self.Primary.Spread > self.Primary.SpreadMin then
                self.Primary.Spread = (
                    (self.Primary.SpreadTimer - CurTime()) / self.Primary.SpreadTime
                ) * self.Primary.Spread
            end
        end

        if
            self:GetOwner():GetVelocity():Length() <= 100
            and self.Primary.Spread > self.Primary.SpreadMax
        then
            self.Primary.Spread = self.Primary.SpreadMax
        end
        if self:GetOwner():GetVelocity():Length() > 100 then
            self.Primary.Spread = self.Primary.SpreadMove
            self.Primary.SpreadTimer = CurTime() + self.Primary.SpreadTime
            if self.Primary.Spread > self.Primary.SpreadMin then
                self.Primary.Spread = (
                    (self.Primary.SpreadTimer - CurTime()) / self.Primary.SpreadTime
                ) * self.Primary.SpreadMove
            end
        end
    end

    if not self:GetOwner():IsOnGround() then
        self.Primary.Spread = self.Primary.SpreadAir
        self.Primary.SpreadTimer = CurTime() + self.Primary.SpreadTime
        if self.Primary.Spread > self.Primary.SpreadMin then
            self.Primary.Spread = ((self.Primary.SpreadTimer - CurTime()) / self.Primary.SpreadTime)
                * self.Primary.SpreadAir
        end
    end

    if self.Reloading == 1 and self.ReloadingTimer <= CurTime() then
        self:ReloadEnd()
    end
    if self.IdleTimer <= CurTime() then
        self:IdleAnimation()
    end
end
