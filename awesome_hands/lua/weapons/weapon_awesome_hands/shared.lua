AddCSLuaFile()

CreateConVar("sv_ah_enable_feature_dragging", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Enable Feature: Dragging", 0, 1)
CreateConVar("sv_ah_enable_feature_shoving", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Enable Feature: Shoving", 0, 1)
CreateConVar("sv_ah_enable_feature_darkrp_pocket", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Enable Feature: DarkRP Pocket", 0, 1)
CreateConVar("sv_ah_enable_feature_darkrp_keys", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Enable Feature: DarkRP Keys", 0, 1)
CreateConVar("sv_ah_enable_mode_fists", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Enable Mode: Fists", 0, 1)
CreateConVar("sv_ah_drag_range", 150, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Drag Range", 0, nil)
CreateConVar("sv_ah_drag_force", 500, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Drag Force", 0, nil)
CreateConVar("sv_ah_shove_range", 100, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Shove Range", 0, nil)
CreateConVar("sv_ah_shove_force", 800, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Shove Force", 0, nil)
CreateConVar("sv_ah_fist_range", 48, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Fist Range", 0, nil)
CreateConVar("sv_ah_fist_punch_damage_min", 8, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Fist Punch Damage Min", 0, nil)
CreateConVar("sv_ah_fist_punch_damage_max", 12, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Fist Punch Damage Max", 0, nil)
CreateConVar("sv_ah_fist_uppercut_damage_min", 12, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Fist Uppercut Damage Min", 0, nil)
CreateConVar("sv_ah_fist_uppercut_damage_max", 24, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Fist Uppercut Damage Max", 0, nil)

concommand.Add( "ah_switchhandmode", function( ply, cmd, args )
  local wep = ply:GetWeapon("weapon_awesome_hands")
  if IsValid(wep) then
    if wep == ply:GetActiveWeapon() then
      wep:SwitchHandMode(args[1])
    else
      if SERVER then
        ply:SelectWeapon( wep )
      end
      if CLIENT then
        input.SelectWeapon( wep )
      end
      wep:SwitchHandMode(args[1])
    end
  end
end, nil, "set the hand mode used by Awesome Hands")

-- @TODO: these includes / CS files are verbatim from pocket; require them 
/*
  * localization files
  * console binds to switch to certain modes
  * Make It Rain
    * add ShouldSkip() method when advancing hand mode
  * vehicle flip
  * gestures
    * sond / crack fists / flipoff
  * magic?
    * vort fists, enchanted hand, physgun
  * others
    * spiderman
*/
if SERVER then
    AddCSLuaFile("cl_menu.lua")
    include("sv_init.lua")
end
if CLIENT then
    include("cl_menu.lua")
end

-- don't do debugging in release mode
/*
  local AHDebugPrint = print
  if SERVER then
      util.AddNetworkString("AwesomeHandDebug3")

      AHDebugPrint = function(plr, msg)
          net.Start("AwesomeHandDebug3")
          net.WriteString(msg)
          net.Send(plr)
      end
  else
      -- Netmsg is coming from the server so no need for sanity checks as the server *should* be as expected unlike clients
      net.Receive("AwesomeHandDebug3", function()
          chat.AddText(net.ReadString())
      end)
  end
*/

SWEP.PrintName = "Awesome Hands"
SWEP.Author = "EntranceJew"
SWEP.Purpose = "Pocket, keys, dragging, and optional violence."
SWEP.ViewModelFlip = false
SWEP.AnimPrefix = "rpg"
-- @TODO: weigh the following values from DarkRP's pocket; the lattermost is not ever referenced anymore...
-- SWEP.Base = weapon_cs_base2
-- SWEP.AnimPrefix = "rpg"
if DarkRP then
  SWEP.IsDarkRPPocket = true
end
SWEP.Slot = 0
SWEP.SlotPos = 1
SWEP.Weight = 5

SWEP.Spawnable = true
if DarkRP then
  SWEP.AdminOnly = true
end
SWEP.Category = "Other"
local defaultViewModel = "models/weapons/c_awesomehands.mdl"
local defaultFOV = 54
SWEP.ViewModel = Model(defaultViewModel)
SWEP.WorldModel = ""
SWEP.ViewModelFOV = defaultFOV
SWEP.UseHands = true

if (CLIENT) then
    SWEP.WepSelectIcon = surface.GetTextureID("weapons/weapon_awesome_hands")
end

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.DrawAmmo = false
SWEP.FistsOut = false
SWEP.HitDistance = 48
SWEP.ModeNames = {}
local SwingSound = Sound("WeaponFrag.Throw")
local HitSound = Sound("Flesh.ImpactHard")
local lockSpeed = 8
SWEP.DragTime = 0
SWEP.AnimSeq = 0
SWEP.PrimaryContextTime = 0
SWEP.SecondaryContextTime = 0

local function isThatAFuckingDoor(pl)
    local trace = pl:GetEyeTrace()

    if not IsValid(trace.Entity) or ((not trace.Entity:isDoor() and not trace.Entity:IsVehicle()) or pl:EyePos():DistToSqr(trace.HitPos) > 40000) then
        return false
    else
        return true
    end
end

function SWEP:JankShove()
    self:SetNextPrimaryFire(CurTime() + 1)

    if self:GetOwner().LagCompensation then
        self:GetOwner():LagCompensation(true)
    end

    local tr = self:GetOwner():GetEyeTrace(MASK_SHOT)
    local vm = self:GetOwner():GetViewModel()
    vm:SendViewModelMatchingSequence(vm:LookupSequence("fists_draw"))

    if tr.Hit and IsValid(tr.Entity) and (self:GetOwner():EyePos() - tr.HitPos):Length() < GetConVar("sv_ah_shove_range"):GetFloat() then
        local ply = tr.Entity

        if SERVER then
            local pushvel = tr.Normal * GetConVar("sv_ah_shove_force"):GetFloat()
            pushvel.z = math.Clamp(pushvel.z, 100, 100)
            ply:SetVelocity(ply:GetVelocity() + pushvel)
            self:GetOwner():SetAnimation(PLAYER_ATTACK1)

            --, infl=self}
            ply.was_pushed = {
                att = self:GetOwner(),
                t = CurTime(),
                wep = self:GetClass()
            }
        end
    end

    vm:SendViewModelMatchingSequence(vm:LookupSequence("fists_holster"))

    timer.Simple(0.2, function()
      vm:SendViewModelMatchingSequence(vm:LookupSequence("elevator_idle"))
    end)

    if self:GetOwner().LagCompensation then
        self:GetOwner():LagCompensation(false)
    end
end

local function lockAnimation(wep, snd)
    --AHDebugPrint(wep.Owner, "locking...")
    wep:GetOwner():EmitSound("npc/metropolice/gear" .. math.random(1, 6) .. ".wav")

    timer.Simple(0.9, function()
        if IsValid(wep:GetOwner()) then
            wep:GetOwner():EmitSound(snd)
            wep:PlayAnimation("keys_idle01")
        end
    end)

    net.Start("ah_anim_keys")
    net.WriteEntity(wep)
    net.WriteString("keyslock")
    net.Send(wep:GetOwner())
    wep:GetOwner():AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_ITEM_PLACE, true)
end

local function unlockAnimation(wep, snd)
    --AHDebugPrint(wep:GetOwner(), "unlocking...")
    wep:GetOwner():EmitSound("npc/metropolice/gear" .. math.random(1, 6) .. ".wav")

    timer.Simple(0.9, function()
        if IsValid(wep:GetOwner()) then
          wep:GetOwner():EmitSound(snd)
            wep:PlayAnimation("keys_idle01")
        end
    end)

    net.Start("ah_anim_keys")
    net.WriteEntity(wep)
    net.WriteString("keysunlock")
    net.Send(wep:GetOwner())
    wep:GetOwner():AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_ITEM_PLACE, true)
end

local function doKnock(wep, sound)
    wep:GetOwner():EmitSound(sound, 100, math.random(90, 110))
    net.Start("ah_anim_keys")
    net.WriteEntity(wep)
    net.WriteString("knocking")
    net.Send(wep:GetOwner())
    wep:GetOwner():AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST, true)
end

local function canShoveThis(ent)
    return (ent:IsPlayer() or ent:IsNPC() or ent:IsNextBot()) and GetConVar("sv_ah_enable_feature_shoving"):GetBool()
end

local function canDragThis(ent)
    return not IsValid(ent) or ent:GetMoveType() ~= MOVETYPE_VPHYSICS or ent:IsVehicle() or ent:GetNWBool("NoDrag", false) or ent.BlockDrag or IsValid(ent:GetParent())
end

function SWEP:PlayAnimation(seq, extime)
    -- print(seq)
    extime = extime or 0
    if self:GetOwner().GetViewModel then
      local vm = self:GetOwner():GetViewModel()
      if IsValid(vm) then
        vm:SendViewModelMatchingSequence(vm:LookupSequence(seq))
        self:UpdateNextIdle(extime)
      end
    end
end

function SWEP:SetupDataTables()
    -- META
    self:NetworkVar("Int", 0, "CurrentMode")
    self:NetworkVar("String", 0, "PrimaryContextText")
    self:NetworkVar("String", 1, "SecondaryContextText")
    -- TOGGLEABLE FISTS
    self:NetworkVar("Float", 0, "NextMeleeAttack")
    self:NetworkVar("Float", 1, "NextIdle")
    self:NetworkVar("Int", 2, "Combo")

    if SERVER then
        self:SetPrimaryContextText("None")
        self:SetSecondaryContextText("None")
    end
end

--if SERVER then
function SWEP:SetPrimaryContext(ctx)
    self:SetPrimaryContextText(ctx)
    self.PrimaryContextTime = 0
end

function SWEP:SetSecondaryContext(ctx)
    self:SetSecondaryContextText(ctx)
    self.SecondaryContextTime = 0
end

--end
function SWEP:Initialize()
    -- local nop = function() return end
    self.ModeData = {
      /*
        gallery = {
            name = "gallery",
            holdType = "normal",
            fov = 62,
            invisible = false,
            crosshair = true,
            PrimaryAttack = function()
                self:SetNextPrimaryFire(CurTime() + 0.2)
                local Owner = self:GetOwner()
                local vm = Owner:GetViewModel()
                local items = vm:GetSequenceList()
                self.AnimSeq = self.AnimSeq + 1

                if self.AnimSeq > #items then
                    self.AnimSeq = 1
                end

                self:PlayAnimation(items[self.AnimSeq])

                if CLIENT then
                    chat.AddText(Color(100, 100, 255), "VMAnimSeq: ", Color(100, 255, 100), items[self.AnimSeq], Color(255, 100, 255), " " .. self.AnimSeq)
                end
            end,
            SecondaryAttack = function()
                self:SetNextSecondaryFire(CurTime() + 0.2)
                local Owner = self:GetOwner()
                local vm = Owner:GetViewModel()
                local items = vm:GetSequenceList()
                self.AnimSeq = self.AnimSeq - 1

                if self.AnimSeq < 0 then
                    self.AnimSeq = #items
                end

                self:PlayAnimation(items[self.AnimSeq])

                if CLIENT then
                    chat.AddText(Color(100, 100, 255), "VMAnimSeq: ", Color(100, 255, 100), items[self.AnimSeq], Color(255, 100, 255), " " .. self.AnimSeq)
                end
            end,
        },
      */
        fists = {
            name = "fists",
            holdType = "fist",
            viewModel = defaultViewModel,
            fov = 54,
            invisible = false,
            crosshair = true,
            CanSwitch = function()
              return GetConVar("sv_ah_enable_mode_fists"):GetBool()
            end,
            PrimaryAttack = function()
                self:GetOwner():SetAnimation(PLAYER_ATTACK1)
                local anim = "fists_left"

                if (self:GetCombo() >= 2) then
                    anim = "fists_uppercut"
                end

                local vm = self:GetOwner():GetViewModel()
                vm:SendViewModelMatchingSequence(vm:LookupSequence(anim))
                self:EmitSound(SwingSound)
                self:UpdateNextIdle()
                self:SetNextMeleeAttack(CurTime() + 0.2)
                self:SetNextPrimaryFire(CurTime() + 0.9)
                self:SetNextSecondaryFire(CurTime() + 0.9)
            end,
            SecondaryAttack = function()
                self:GetOwner():SetAnimation(PLAYER_ATTACK1)
                local anim = "fists_right"

                if (self:GetCombo() >= 2) then
                    anim = "fists_uppercut"
                end

                local vm = self:GetOwner():GetViewModel()
                vm:SendViewModelMatchingSequence(vm:LookupSequence(anim))
                self:EmitSound(SwingSound)
                self:UpdateNextIdle()
                self:SetNextMeleeAttack(CurTime() + 0.2)
                self:SetNextPrimaryFire(CurTime() + 0.9)
                self:SetNextSecondaryFire(CurTime() + 0.9)
            end,
            Deploy = function()
                --AHDebugPrint(self:GetOwner(), "fist deployed")
                local speed = GetConVar("sv_defaultdeployspeed"):GetFloat()
                local vm = self:GetOwner():GetViewModel()
                -- was originally "fists_draw", but now it is "fists_down" because we put them away immediately
                vm:SendViewModelMatchingSequence(vm:LookupSequence("fists_draw"))
                vm:SetPlaybackRate(speed)
                self:SetNextPrimaryFire(CurTime() + vm:SequenceDuration() / speed)
                self:SetNextSecondaryFire(CurTime() + vm:SequenceDuration() / speed)
                self:UpdateNextIdle()

                if (SERVER) then
                    self:SetCombo(0)
                end

                return true
            end,
            Think = function()
                -- local vm = self:GetOwner():GetViewModel()
                -- local curtime = CurTime()
                local idletime = self:GetNextIdle()

                if (idletime > 0 and CurTime() > idletime and self.FistsOut) then
                    self:PlayAnimation("fists_idle_0" .. math.random(1, 2))
                end

                local meleetime = self:GetNextMeleeAttack()

                if (meleetime > 0 and CurTime() > meleetime) then
                    self:DealDamage()
                    self:SetNextMeleeAttack(0)
                end

                if (SERVER and CurTime() > self:GetNextPrimaryFire() + 0.1) then
                    self:SetCombo(0)
                end
            end,
            SwitchTo = function()
                local vm = self:GetOwner():GetViewModel()
                vm:SendViewModelMatchingSequence(vm:LookupSequence("fists_draw"))
                self:SetHoldType("fist")
                local AnimationTime = self:GetOwner():GetViewModel():SequenceDuration()
                self.ReloadingTime = CurTime() + AnimationTime
                self:SetNextPrimaryFire(CurTime() + AnimationTime)
                self:SetNextSecondaryFire(CurTime() + AnimationTime)
                -- self:UpdateNextIdle()
                self.FistsOut = not self.FistsOut
                -- self:FistsDown()
                self:SetPrimaryContextText("")
                self:SetSecondaryContextText("")
            end,
            SwitchAway = function()
                local vm = self:GetOwner():GetViewModel()
                vm:SendViewModelMatchingSequence(vm:LookupSequence("fists_holster"))

                timer.Simple(vm:SequenceDuration() / 1.5, function()
                    self:SetHoldType("normal")
                end)

                local AnimationTime = self:GetOwner():GetViewModel():SequenceDuration()
                self.ReloadingTime = CurTime() + AnimationTime
                self:SetNextPrimaryFire(CurTime() + AnimationTime)
                self:SetNextSecondaryFire(CurTime() + AnimationTime)
                -- self:UpdateNextIdle()
                self.FistsOut = not self.FistsOut
                -- self:FistsDown()
            end,
        },
        hands = {
            name = "draglookerpocketkeys",
            holdType = "normal",
            -- viewModel = "models/weapons/c_awesomehands.mdl",
            fov = 90,
            invisible = false,
            crosshair = true,
            PrimaryAttack = function()
                local Owner = self:GetOwner()
                if not IsValid(Owner) then return end

                if DarkRP and isThatAFuckingDoor(Owner) and not self.Drag and GetConVar("sv_ah_enable_feature_darkrp_keys"):GetBool() then
                    local trace = Owner:GetEyeTrace()

                    if (trace.Entity.GetIsVehicleLocked and trace.Entity:GetIsVehicleLocked()) or (trace.Entity.isLocked and trace.Entity:isLocked()) then
                        --AHDebugPrint(Owner, "attempting unlock...")
                        if Owner:canKeysUnlock(trace.Entity) then
                            --AHDebugPrint(Owner, "attempting unlock doing it...")
                            if SERVER then
                                trace.Entity:keysUnLock() -- Unlock the door immediately so it won't annoy people
                                unlockAnimation(self, "doors/door_latch3.wav")
                            end

                            local vm = Owner:GetViewModel()
                            self:PlayAnimation("keys_unlock")
                            self:SetNextPrimaryFire(CurTime() + vm:SequenceDuration())
                            self:SetNextSecondaryFire(CurTime() + vm:SequenceDuration())
                        elseif trace.Entity:IsVehicle() then
                            if SERVER then
                                DarkRP.notify(Owner, 1, 3, DarkRP.getPhrase("do_not_own_ent"))
                            end
                        else
                            if SERVER then
                                doKnock(self, "physics/wood/wood_crate_impact_hard3.wav")
                            end
                        end

                        self:SetNextPrimaryFire(CurTime() + 0.2)

                        return
                    else
                        --AHDebugPrint(Owner, "attempting lock...")
                        if Owner:canKeysLock(trace.Entity) then
                            if SERVER then
                                trace.Entity:keysLock() -- Lock the door immediately so it won't annoy people
                                lockAnimation(self, "doors/door_latch2.wav")
                            end

                            local vm = Owner:GetViewModel()
                            self:PlayAnimation("keys_lock")
                            self:SetNextPrimaryFire(CurTime() + vm:SequenceDuration())
                            self:SetNextSecondaryFire(CurTime() + vm:SequenceDuration())
                        elseif trace.Entity:IsVehicle() then
                            if SERVER then
                                DarkRP.notify(Owner, 1, 3, DarkRP.getPhrase("do_not_own_ent"))
                            end
                        else
                            if SERVER then
                                doKnock(self, "physics/wood/wood_crate_impact_hard2.wav")
                            end
                        end

                        self:SetNextPrimaryFire(CurTime() + 0.2)

                        return
                    end
                end

                local Pos = self:GetOwner():GetShootPos()
                local Aim = self:GetOwner():GetAimVector()

                local Tr = util.TraceLine{
                    start = Pos,
                    endpos = Pos + Aim * GetConVar("sv_ah_drag_range"):GetFloat(),
                    filter = self:GetOwner(),
                }

                local HitEnt = Tr.Entity

                if not self.Drag then
                    if canDragThis(HitEnt) then
                        if (canShoveThis(HitEnt)) then
                            -- AHDebugPrint(self:GetOwner(), "jankshove condition time 1")
                            self:JankShove(HitEnt)

                            return
                        else
                            if math.random(0, 1) == 0 then
                                self:PlayAnimation("bms_admire_old")
                            else
                                self:PlayAnimation("seq_admire")
                            end
                        end
                    else
                        if GetConVar("sv_ah_enable_feature_dragging"):GetBool() then
                          self.Drag = {
                              OffPos = HitEnt:WorldToLocal(Tr.HitPos),
                              Entity = HitEnt,
                              Fraction = Tr.Fraction,
                          }
                        end
                    end
                else
                    HitEnt = self.Drag.Entity
                end

                if CLIENT or not IsValid(HitEnt) then return end
                local Phys = HitEnt:GetPhysicsObject()

                if IsValid(Phys) and self.Drag and GetConVar("sv_ah_enable_feature_dragging"):GetBool() then
                    local Pos2 = Pos + Aim * GetConVar("sv_ah_drag_range"):GetFloat() * self.Drag.Fraction
                    local OffPos = HitEnt:LocalToWorld(self.Drag.OffPos)
                    local Dif = Pos2 - OffPos
                    local Nom = (Dif:GetNormal() * math.min(1, Dif:Length() / 100) * GetConVar("sv_ah_drag_force"):GetFloat() - Phys:GetVelocity()) * Phys:GetMass()
                    Phys:ApplyForceOffset(Nom, OffPos)
                    Phys:AddAngleVelocity(-Phys:GetAngleVelocity() / 4)
                end
            end,
            SecondaryAttack = function()
                self:SetNextSecondaryFire(CurTime() + 0.3)
                -- if not SERVER then return end
                if not DarkRP then return end
                local Owner = self:GetOwner()
                if not IsValid(Owner) then return end
                local ent = Owner:GetEyeTrace().Entity
                local canPickup, message = hook.Call("canPocket", GAMEMODE, Owner, ent)

                -- local trace = self:GetOwner():GetEyeTrace()
                if SERVER and DarkRP and isThatAFuckingDoor(Owner) and GetConVar("sv_ah_enable_feature_darkrp_keys"):GetBool() then
                    net.Start("KeysMenuAH")
                    net.Send(Owner)
                    return
                end

                if GetConVar("sv_ah_enable_feature_darkrp_pocket"):GetBool() then
                  if not canPickup then
                      if message then
                          DarkRP.notify(Owner, 1, 4, message)
                      else
                          if SERVER then
                              -- print("telling the server to open the menu")
                              net.Start("PocketMenuAH")
                              net.Send(self:GetOwner())
                          end
                      end

                      return
                  else
                      -- print("put it in my pocket")
                      Owner:addPocketItem(ent)
                      self:PlayAnimation("magic_idle")
                      self:PlayAnimation("magic_altfire")
                  end
                end
            end,
            Think = function()
                if self.Drag and (not self:GetOwner():KeyDown(IN_ATTACK) or not IsValid(self.Drag.Entity)) then
                    self.Drag = nil
                end

                local vm = self:GetOwner():GetViewModel()

                if self:GetNextIdle() ~= 0 and self:GetNextIdle() < CurTime() then
                    vm:SendViewModelMatchingSequence(vm:LookupSequence("reference"))
                    self:SetNextIdle(0)
                end

                if SERVER then
                    self:ThinkHarderPrimary()
                    self:ThinkHarderSecondary()
                end
            end,
            SwitchTo = function()
              if IsValid(self:GetOwner()) and self:GetOwner().GetViewModel then
                local vm = self:GetOwner():GetViewModel()
                vm:SendViewModelMatchingSequence(vm:LookupSequence("elevator_idle"))
              end
              self:SetHoldType("normal")
              self:PlayAnimation("seq_admire", 0.2)
              self:SetNextPrimaryFire(CurTime() + 0.2)
              self:SetNextSecondaryFire(CurTime() + 0.2)
              -- self:UpdateNextIdle()
              self.FistsOut = false
              -- self:FistsDown()
          end,
          SwitchAway = function()
              -- local vm = self:GetOwner():GetViewModel()
              -- vm:SendViewModelMatchingSequence(vm:LookupSequence("seq_admire"))
              self:SetHoldType("normal")
              self:PlayAnimation("elevator_idle", 0.2)
              self:SetNextPrimaryFire(CurTime() + 0.2)
              self:SetNextSecondaryFire(CurTime() + 0.2)
              -- self:UpdateNextIdle()
              self.FistsOut = false
              -- self:FistsDown()
          end,
        },
    }

    local modeNames = {}
    local n = 0

    for k, v in pairs(self.ModeData) do
        if v.CanSwitch and not v:CanSwitch() then continue end
        n = n + 1
        modeNames[n] = k
    end

    self.ModeNames = modeNames
    self:SetCurrentMode(1)

    self:SwitchHandMode("hands")
end

function SWEP:RouteCurrent(call, ...)
    if self.ModeData[self.ModeNames[self:GetCurrentMode()]] and self.ModeData[self.ModeNames[self:GetCurrentMode()]][call] then
        return self.ModeData[self.ModeNames[self:GetCurrentMode()]][call](unpack({...}))
    end
end

function SWEP:RouteCall(handMode, call, ...)
    if self.ModeData[handMode] and self.ModeData[handMode][call] then
        return self.ModeData[handMode][call](unpack({...}))
    end
end

function SWEP:SwitchHandModeSilent(newMode, oldMode)
  local currentIndex = 0

  for k, v in ipairs(self.ModeNames) do
      if v == newMode then
          currentIndex = k
          break
      end
  end

  if CLIENT then
    --AHDebugPrint(self:GetOwner(),"[AH] mode: "..newMode)
    chat.AddText(Color(255, 128, 0), "[AH] mode: ", Color(100, 255, 100), newMode)
  end
  self:SetCurrentMode(currentIndex)
end

function SWEP:SwitchHandMode(newMode, oldMode)
    if oldMode and self.ModeData[oldMode].SwitchAway then
        self.ModeData[oldMode].SwitchAway()
    end

    local handMode = self.ModeData[newMode]

    if handMode.holdType then
        self:SetHoldType(handMode.holdType)
    end

    if handMode.viewModel then
        self.ViewModel = handMode.viewModel
        self:SwitchViewModels(handMode.viewModel)
    end

    -- TODO: else, default
    if handMode.SwitchTo then
        handMode.SwitchTo()
    end

    -- @TODO: all the other stuff
    -- network mode change
    self:SwitchHandModeSilent(newMode, oldMode)

    --AHDebugPrint(self:GetOwner(), "now "..self.ModeNames[self:GetCurrentMode()])
    local newFOV = handMode.fov or defaultFOV
    self.ViewModelFOV = newFOV
    if self:GetOwner().GetActiveWeapon then
      self:GetOwner():GetActiveWeapon().ViewModelFOV = newFOV
      if SERVER then
        self:GetOwner():SendLua([[LocalPlayer():GetActiveWeapon().ViewModelFOV = tonumber(]] .. newFOV .. [[)]])
      end
    end
end

function SWEP:PreDrawViewModel()
    -- AHDebugPrint(self:GetOwner(), "predraw: "..self.ModeNames[self:GetCurrentMode()] )
    if self.ModeData[self.ModeNames[self:GetCurrentMode()]].invisible then return true end
end

function SWEP:DoDrawCrosshair()
    if not self.ModeData[self.ModeNames[self:GetCurrentMode()]].crosshair then return true end
end

function SWEP:OnDrop()
    self:Remove() -- You can't drop fists
end

function SWEP:Holster()
    self:SetNextMeleeAttack(0)

    return true
end

function SWEP:SwitchViewModels(newModel)
    local wep = self:GetOwner():GetActiveWeapon()

    if (not IsValid(wep)) then
        -- AHDebugPrint(self:GetOwner(), "[SVM] illegal weapon")
        return
    end

    local newmod = newModel or wep.ViewModel

    --newmod = newmod..".mdl"
    if not file.Exists(newmod, "GAME") then
        -- AHDebugPrint(self:GetOwner(), "[SVM] illegal file")
        return
    end

    --util.PrecacheModel(newmod)
    wep.ViewModel = newmod
    self:GetOwner():GetViewModel():SetWeaponModel(Model(newmod), wep)
    --AHDebugPrint(self:GetOwner(), "[SVM] setweaponmodel")
    if true then return end
    -- hack / workaround from SWEP construction kit
    /*
      if SERVER then
        self:GetOwner():SendLua([[LocalPlayer():GetActiveWeapon().ViewModel = "]]..newmod..[["]])
        self:GetOwner():SendLua([[LocalPlayer():GetViewModel():SetWeaponModel(Model("]]..newmod..[["), Entity(]]..wep:EntIndex()..[[))]])
      end
      
      local quickswitch = nil
      for k, v in pairs( self:GetOwner():GetWeapons() ) do
        if (v:GetClass() != wep:GetClass()) then 
          quickswitch = v:GetClass()
          break
        end
      end
      
      if (quickswitch) then
        --AHDebugPrint(self:GetOwner(), "[SVM] quickswitch")
        if SERVER then
          --CUserCmd:SelectWeapon( quickswitch )
          --CUserCmd:SelectWeapon( wep )
          self:GetOwner():SelectWeapon( quickswitch )
          self:GetOwner():SelectWeapon( wep:GetClass() )
        end
      else
        AHDebugPrint(self:GetOwner(), "[SVM] could not quick switch :(")
        self:GetOwner():ChatPrint("Switch weapons to make the new viewmodel show up")
      end
    */
end

function SWEP:Reload()
    if self.ReloadingTime and CurTime() <= self.ReloadingTime then return end
    self.ReloadingTime = CurTime() + 0.3
    -- local vm = self:GetOwner():GetViewModel()
    local currentIndex = self:GetCurrentMode() + 1

    if currentIndex > #self.ModeNames then
        currentIndex = 1
    end

    self:SwitchHandMode(self.ModeNames[currentIndex], self.ModeNames[self:GetCurrentMode()])
    -- fist specific logic we migrated already
    /*
      if (self.FistsOut) then 
        vm:SendViewModelMatchingSequence( vm:LookupSequence( "fists_holster" ) )
        timer.Simple( vm:SequenceDuration() / 1.5, function() 
          self:SetHoldType("normal")
        end )
      else 		
        vm:SendViewModelMatchingSequence( vm:LookupSequence( "fists_draw" ) )
        self:SetHoldType("fist")
      end
      local AnimationTime = self:GetOwner():GetViewModel():SequenceDuration()
      self.ReloadingTime = CurTime() + AnimationTime
      self:SetNextPrimaryFire(CurTime() + AnimationTime)
      self:SetNextSecondaryFire(CurTime() + AnimationTime)
      self:UpdateNextIdle()

      self.FistsOut = !self.FistsOut
      self:FistsDown()
    */
end

/* reroutes */
function SWEP:Deploy()
    --AHDebugPrint(self:GetOwner(),"routed Deploy with "..self.ModeNames[self:GetCurrentMode()])
    if CLIENT then
      chat.AddText(Color(255, 128, 0), "[AH] mode: ", Color(100, 255, 100), self.ModeNames[self:GetCurrentMode()])
    end
    self.ReloadingTime = CurTime() + 0.3
    self:PlayAnimation("elevator_idle")
    self:SetNextPrimaryFire(CurTime() + 0.3)
    self:SetNextSecondaryFire(CurTime() + 0.3)
    self:RouteCurrent("Deploy")
end

function SWEP:PrimaryAttack()
    -- AHDebugPrint(self:GetOwner(),"routed PrimaryAttack with "..self.ModeNames[self:GetCurrentMode()])
    self:RouteCurrent("PrimaryAttack")
end

function SWEP:SecondaryAttack()
    -- AHDebugPrint(self:GetOwner(),"routed SecondaryAttack with "..self.ModeNames[self:GetCurrentMode()])
    self:RouteCurrent("SecondaryAttack")
end

function SWEP:Think()
    self:RouteCurrent("Think")
end

/* custom */
function SWEP:UpdateNextIdle(extime)
    extime = extime or 0
    local vm = self:GetOwner():GetViewModel()
    self:SetNextIdle(CurTime() + vm:SequenceDuration() / vm:GetPlaybackRate() + extime)
end

function SWEP:DealDamage()
    local anim = self:GetSequenceName(self:GetOwner():GetViewModel():GetSequence())
    self:GetOwner():LagCompensation(true)

    local tr = util.TraceLine({
        start = self:GetOwner():GetShootPos(),
        endpos = self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * self.HitDistance,
        filter = self:GetOwner(),
        mask = MASK_SHOT_HULL
    })

    if (not IsValid(tr.Entity)) then
        tr = util.TraceHull({
            start = self:GetOwner():GetShootPos(),
            endpos = self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * self.HitDistance,
            filter = self:GetOwner(),
            mins = Vector(-10, -10, -8),
            maxs = Vector(10, 10, 8),
            mask = MASK_SHOT_HULL
        })
    end

    -- We need the second part for single player because SWEP:Think is ran shared in SP
    if (tr.Hit and not (game.SinglePlayer() and CLIENT)) then
        self:EmitSound(HitSound)
    end

    local hit = false
    local phys_pushscale = GetConVar("phys_pushscale")
    local scale = phys_pushscale:GetFloat()

    if (SERVER and IsValid(tr.Entity) and (tr.Entity:IsNPC() or tr.Entity:IsPlayer() or tr.Entity:Health() > 0)) then
        local dmginfo = DamageInfo()
        local attacker = self:GetOwner()

        if (not IsValid(attacker)) then
            attacker = self
        end

        dmginfo:SetAttacker(attacker)
        dmginfo:SetInflictor(self)
        dmginfo:SetDamage(math.random(GetConVar("sv_ah_fist_punch_damage_min"):GetFloat(), GetConVar("sv_ah_fist_punch_damage_max"):GetFloat()))

        if (anim == "fists_left") then
            dmginfo:SetDamageForce(self:GetOwner():GetRight() * 4912 * scale + self:GetOwner():GetForward() * 9998 * scale) -- Yes we need those specific numbers
        elseif (anim == "fists_right") then
            dmginfo:SetDamageForce(self:GetOwner():GetRight() * -4912 * scale + self:GetOwner():GetForward() * 9989 * scale)
        elseif (anim == "fists_uppercut") then
            dmginfo:SetDamageForce(self:GetOwner():GetUp() * 5158 * scale + self:GetOwner():GetForward() * 10012 * scale)
            dmginfo:SetDamage(math.random(GetConVar("sv_ah_fist_uppercut_damage_min"):GetFloat(), GetConVar("sv_ah_fist_uppercut_damage_max"):GetFloat()))
        end

        SuppressHostEvents(NULL) -- Let the breakable gibs spawn in multiplayer on client
        tr.Entity:TakeDamageInfo(dmginfo)
        SuppressHostEvents(self:GetOwner())
        hit = true
    end

    -- this `SERVER &&` wasn't here on the official git
    -- removed in https://github.com/Facepunch/garrysmod/commit/608f3361c7b7f19ca62df70dce2e56d163db4fd2
    if (IsValid(tr.Entity)) then
        local phys = tr.Entity:GetPhysicsObject()

        if (IsValid(phys)) then
            phys:ApplyForceOffset(self:GetOwner():GetAimVector() * 80 * phys:GetMass() * scale, tr.HitPos)
        end
    end

    if (SERVER) then
        if (hit and anim ~= "fists_uppercut") then
            self:SetCombo(self:GetCombo() + 1)
        else
            self:SetCombo(0)
        end
    end

    self:GetOwner():LagCompensation(false)
end

-- function SWEP:FistsDown()
  -- if self:GetOwner().GetViewModel then
    -- local vm = self:GetOwner():GetViewModel()

    -- timer.Simple(vm:SequenceDuration(), function()
        -- vm:SendViewModelMatchingSequence(vm:LookupSequence("fists_down"))
    -- end)
  -- end
-- end

-- FOR: coolkeys
function SWEP:Idle(instant)
    local vm = self:GetOwner():GetViewModel()

    if instant then
        vm:SendViewModelMatchingSequence(vm:LookupSequence("keys_idle01"))
    else
        timer.Simple(vm:SequenceDuration() - 0.2, function()
            vm:SendViewModelMatchingSequence(vm:LookupSequence("keys_idle01"))
        end)
    end
    --timer.Simple( 0, function()
    --    vm:SendViewModelMatchingSequence( vm:LookupSequence( "idle01" ) )
    --end )
end

function SWEP:ThinkHarderPrimary()
    local Owner = self:GetOwner()
    if not IsValid(Owner) then return end

    if DarkRP and isThatAFuckingDoor(Owner) and not self.Drag and GetConVar("sv_ah_enable_feature_darkrp_keys"):GetBool() then
        local trace = Owner:GetEyeTrace()

        if (trace.Entity.GetIsVehicleLocked and trace.Entity:GetIsVehicleLocked()) or (trace.Entity.isLocked and trace.Entity:isLocked()) then
            if Owner:canKeysUnlock(trace.Entity) then
                self:SetPrimaryContext("Unlock")
            elseif trace.Entity:IsVehicle() then
                self:SetPrimaryContext("Can't Unlock, Not Your Vehicle")
            else
                self:SetPrimaryContext("Knock (Locked)")
            end

            return
        else
            --AHDebugPrint(Owner, "attempting lock...")
            if Owner:canKeysLock(trace.Entity) then
                self:SetPrimaryContext("Lock")
            elseif trace.Entity:IsVehicle() then
                self:SetPrimaryContext("Can't Lock, Not Your Vehicle")
            else
                self:SetPrimaryContext("Knock (Unlocked)")
            end

            return
        end
    end

    local Pos = self:GetOwner():GetShootPos()
    local Aim = self:GetOwner():GetAimVector()

    local Tr = util.TraceLine{
        start = Pos,
        endpos = Pos + Aim * GetConVar("sv_ah_drag_range"):GetFloat(),
        filter = player.GetAll(),
    }

    local HitEnt = Tr.Entity

    if self.Drag then
        HitEnt = self.Drag.Entity
        self:SetPrimaryContext("Continue Drag")

        return
    else
        if not (not IsValid(HitEnt) or HitEnt:GetMoveType() ~= MOVETYPE_VPHYSICS or HitEnt:IsVehicle() or HitEnt:GetNWBool("NoDrag", false) or HitEnt.BlockDrag or IsValid(HitEnt:GetParent())) and not self.Drag and GetConVar("sv_ah_enable_feature_dragging"):GetBool() then
            self:SetPrimaryContext("Begin Drag")

            return
        end
    end

    Tr = util.TraceLine{
        start = Pos,
        endpos = Pos + Aim * GetConVar("sv_ah_drag_range"):GetFloat(),
        filter = self:GetOwner(),
    }

    HitEnt = Tr.Entity

    if (HitEnt:IsPlayer() or HitEnt:IsNPC() or HitEnt:IsNextBot()) and GetConVar("sv_ah_enable_feature_shoving"):GetBool() then
        self:SetPrimaryContext("Shove")

        return
    end

    self:SetPrimaryContext("")
    -- we can't continue b/c we didn't decide to define self.Drag here
    /*
      if CLIENT or not IsValid( HitEnt ) then return end

      local Phys = HitEnt:GetPhysicsObject()

      if IsValid( Phys ) then
        local Pos2 = Pos +Aim *self.DragRange *self.Drag.Fraction
        local OffPos = HitEnt:LocalToWorld( self.Drag.OffPos )
        local Dif = Pos2 -OffPos
        local Nom = (Dif:GetNormal() *math.min(1, Dif:Length() /100) *500 -Phys:GetVelocity()) *Phys:GetMass()

        self:SetPrimaryContext("Dragging")
      end
    */
end

function SWEP:ThinkHarderSecondary()
  if not DarkRP then self:SetSecondaryContext("") return end
  local Owner = self:GetOwner()
  if not IsValid(Owner) then return end
  local ent = Owner:GetEyeTrace().Entity
  local canPickup, message = hook.Call("canPocket", GAMEMODE, Owner, ent)

  -- local trace = self:GetOwner():GetEyeTrace()
  if SERVER and DarkRP and isThatAFuckingDoor(Owner) and GetConVar("sv_ah_enable_feature_darkrp_keys"):GetBool() then
      self:SetSecondaryContext("Door Menu")

      return
  end

  if GetConVar("sv_ah_enable_feature_darkrp_pocket"):GetBool() then
    if not canPickup then
        -- print("can't pick up")
        if message then
            self:SetSecondaryContext("Can't Pocket")
        else
            self:SetSecondaryContext("Open Pocket")
        end

        return
    else
        self:SetSecondaryContext("Pocket Item")
        return
    end
  end

  self:SetSecondaryContext("")
end

if CLIENT then
    local x, y = ScrW() / 2, ScrH() / 2 + ScrH() / 14
    local x2, y2 = ScrW() / 2, ScrH() / 2 + ScrH() / 8
    local Col = Color(255, 255, 255, 255)

    function SWEP:DrawHUD()
        draw.SimpleText(self:GetPrimaryContextText(), "DermaLarge", x, y, Col, TEXT_ALIGN_CENTER)
        draw.SimpleText(self:GetSecondaryContextText(), "DermaLarge", x2, y2, Col, TEXT_ALIGN_CENTER)
        --if true then return end
        /*
          if IsValid( self:GetOwner():GetVehicle() ) then return end
          local Pos = self:GetOwner():GetShootPos()
          local Aim = self:GetOwner():GetAimVector()

          local Tr = util.TraceLine{
            start = Pos,
            endpos = Pos +Aim *self.DragRange,
            filter = player.GetAll(),
          }

          local HitEnt = Tr.Entity
          if IsValid( HitEnt ) and HitEnt:GetMoveType() == MOVETYPE_VPHYSICS and
            not self.Drag and
            not HitEnt:IsVehicle() and
            not IsValid( HitEnt:GetParent() ) and
            not HitEnt:GetNWBool( "NoDrag", false ) then

            if self.ContextText ~= "Drag" then
              self.ContextText = "Drag"
              self.ContextTime = SysTime()
            end
            
            self.DragTime = math.min( 1, self.DragTime +2 *FrameTime() )
          else
            self.DragTime = math.max( 0, self.DragTime -2 *FrameTime() )
          end

          if self.DragTime > 0 then
            Col.a = MainCol.a *self.DragTime

            draw.SimpleText(
              self.ContextText,
              "DermaLarge",
              x,
              y,
              Col,
              TEXT_ALIGN_CENTER
            )
          end

          if self.Drag and IsValid( self.Drag.Entity ) then
            local Pos2 = Pos +Aim *100 *self.Drag.Fraction
            local OffPos = self.Drag.Entity:LocalToWorld( self.Drag.OffPos )
            local Dif = Pos2 -OffPos

            local A = OffPos:ToScreen()
            local B = Pos2:ToScreen()

            surface.DrawRect( A.x -2, A.y -2, 4, 4, MainCol )
            surface.DrawRect( B.x -2, B.y -2, 4, 4, MainCol )
            surface.DrawLine( A.x, A.y, B.x, B.y, MainCol )
          end
        */
    end
end


/* darkrp shit */
if not DarkRP then return end
local meta = FindMetaTable("Player")

DarkRP.stub{
    name = "getPocketItems",
    description = "Get a player's pocket items.",
    parameters = {},
    returns = {
        {
            name = "items",
            description = "A table containing crucial information about the items in the pocket.",
            type = "table"
        }
    },
    metatable = meta,
    realm = "Shared"
}

local function KeysAnims(len, ply)
    local wep = net.ReadEntity()
    local act = net.ReadString()
    if ((not IsValid(wep)) or (not IsValid(wep.Owner))) then return end --AHDebugPrint(wep.Owner, "that owner didn't exist")
    local vm = wep.Owner:GetViewModel()
    vm:SendViewModelMatchingSequence(vm:LookupSequence("keys_idle01"))
    vm:SetLayerPlaybackRate(0, lockSpeed)
    vm:SetPlaybackRate(lockSpeed)

    if act == "keyslock" then
        --AHDebugPrint(wep.Owner, "finally locked, probably")
        wep:PlayAnimation("keys_lock")
        wep:SetNextPrimaryFire(CurTime() + vm:SequenceDuration())
        wep:SetNextSecondaryFire(CurTime() + vm:SequenceDuration())
        --wep:Idle(false)
        wep.Owner:AnimRestartGesture(GESTURE_SLOT_CUSTOM, true and ACT_GMOD_GESTURE_ITEM_PLACE or ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST, true)
    elseif act == "keysunlock" then
        --AHDebugPrint(wep.Owner, "finally unlocked, probably")
        --vm:SendViewModelMatchingSequence( vm:LookupSequence( "keys_idle01" ) )
        wep:PlayAnimation("keys_unlock")
        wep:SetNextPrimaryFire(CurTime() + vm:SequenceDuration())
        --wep:SetNextSecondaryFire( CurTime() + vm:SequenceDuration( ) )
        wep:Idle(false)
        wep.Owner:AnimRestartGesture(GESTURE_SLOT_CUSTOM, true and ACT_GMOD_GESTURE_ITEM_PLACE or ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST, true)
    elseif act == "knocking" then
        -- vm:SendViewModelMatchingSequence( vm:LookupSequence( "unlock" ) )
        wep.Owner:AnimRestartGesture(GESTURE_SLOT_CUSTOM, true and ACT_GMOD_GESTURE_ITEM_PLACE or ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST, true)
    end

    wep:SetNextPrimaryFire(CurTime() + vm:SequenceDuration())
    wep:SetNextSecondaryFire(CurTime() + vm:SequenceDuration())
    wep:UpdateNextIdle()
    wep:Idle(false)
end

net.Receive("ah_anim_keys", function()
  KeysAnims()
end)