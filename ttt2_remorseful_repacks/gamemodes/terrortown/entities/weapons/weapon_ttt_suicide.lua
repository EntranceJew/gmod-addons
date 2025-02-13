AddCSLuaFile()

if CLIENT then
    SWEP.PrintName = "Suicide Bomb"
    SWEP.Slot = 6
    SWEP.Icon = "vgui/ttt/icon_weapon_ttt_suicidebomb"
    SWEP.IconLetter = "I"
end

SWEP.Base = "weapon_tttbase"
SWEP.HoldType = "slam"

SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 5
SWEP.Primary.ClipSize = -1
SWEP.Primary.ClipMax = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false

SWEP.UseHands = true
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 54
SWEP.ViewModel = Model("models/weapons/cstrike/c_c4.mdl")
SWEP.WorldModel = Model("models/weapons/w_c4.mdl")
SWEP.idleResetFix = true

SWEP.Kind = WEAPON_EQUIP1
SWEP.AutoSpawnable = false
SWEP.AmmoEnt = "none"
SWEP.CanBuy = { ROLE_TRAITOR }
SWEP.InLoadoutFor = { nil }
SWEP.LimitedStock = true
SWEP.AllowDrop = true
SWEP.IsSilent = false
SWEP.NoSights = true
SWEP.FlukeChance = 0.03

function SWEP:SetupDataTables()
    self:NetworkVar("Bool", 0, "Fluke")
end


function SWEP:Precache()
    util.PrecacheSound("weapons/weapon_ttt_suicide/boom.wav")
    util.PrecacheSound("weapons/weapon_ttt_suicide/bouta_blow.wav")
end

function SWEP:Reload() end

function SWEP:Initialize()
    if SERVER then
        self:SetFluke(false)
    end
end

function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire(CurTime() + 1.72)

    local effectdata = EffectData()
    effectdata:SetOrigin(self:GetOwner():GetPos())
    effectdata:SetNormal(self:GetOwner():GetPos())
    effectdata:SetMagnitude(8)
    effectdata:SetScale(1)
    effectdata:SetRadius(78)
    util.Effect("Sparks", effectdata)
    self.BaseClass.ShootEffects(self)
    if SERVER then
        self:SetFluke(math.random() < self.FlukeChance)
    end

    if SERVER then
        timer.Simple(1.72, function()
            self:Explode()
        end)
        self:GetOwner():EmitSound("weapons/weapon_ttt_suicide/bouta_blow" .. (self:GetFluke() and "2" or "") .. ".wav")
    end
end

function SWEP:Explode()
    if not IsValid(self:GetOwner()) then
        self:Remove()
        return
    end
    local ent = ents.Create("env_explosion")
    ent:SetPos(self:GetOwner():GetPos())
    ent:SetOwner(self:GetOwner())
    ent:SetKeyValue("iMagnitude", "200")
    ent:Spawn()
    ent:Fire("Explode", 0, 0)
    ent:EmitSound("weapons/weapon_ttt_suicide/boom" .. (self:GetFluke() and "2" or "") .. ".wav")
    self:Remove()
end

if CLIENT then
    SWEP.EquipMenuData = {
        type = "Weapon",
        desc = "Blow away all your friends!\n\nBlows the user and surrounding terrorists.",
    }
end
