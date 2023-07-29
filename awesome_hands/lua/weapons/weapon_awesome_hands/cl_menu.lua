

hook.Add("PopulateToolMenu", "AddAwesomeHandsOptions", function()
  spawnmenu.AddToolMenuOption("Utilities", "Admin", "AwesomeHandsOptions", "Awesome Hands", "", "", function(pnl)
      pnl:CheckBox("Enable Feature: Dragging", "sv_ah_enable_feature_dragging") -- default 1
      pnl:CheckBox("Enable Feature: Shoving", "sv_ah_enable_feature_shoving") -- default 1
      pnl:CheckBox("Enable Feature: DarkRP Pocket", "sv_ah_enable_feature_darkrp_pocket") -- default 1
      pnl:CheckBox("Enable Feature: DarkRP Keys", "sv_ah_enable_feature_darkrp_keys") -- default 1
      pnl:CheckBox("Enable Mode: Fists", "sv_ah_enable_mode_fists") -- default 1
      pnl:NumSlider("Drag Range", "sv_ah_drag_range", 0, 600 ) -- default 150
      pnl:NumSlider("Drag Force", "sv_ah_drag_force", 0, 1200 ) -- default 500
      pnl:NumSlider("Shove Range", "sv_ah_shove_range", 0, 600 ) -- default 100; MAY EXPERIENCE PROBLEMS IF SMALLER THAN ah_drag_range shared:471
      pnl:NumSlider("Shove Force", "sv_ah_shove_force", 0, 1200 ) -- default 800
      pnl:NumSlider("Fist Range", "sv_ah_fist_range", 0, 600 ) -- default 48
      pnl:NumSlider("Fist Punch Damage Min", "sv_ah_fist_punch_damage_min", 0, 100 ) -- default 8
      pnl:NumSlider("Fist Punch Damage Max", "sv_ah_fist_punch_damage_max", 0, 100 ) -- default 12
      pnl:NumSlider("Fist Uppercut Damage Min", "sv_ah_fist_uppercut_damage_min", 0, 100 ) -- default 12
      pnl:NumSlider("Fist Uppercut Damage Max", "sv_ah_fist_uppercut_damage_max", 0, 100 ) -- default 24
      -- DForm:TextEntry("Holstering weapon", "holsterweapon_weapon")
      -- DForm:Help("Weapon classname to have as the ''the holster'', or leave blank for default. Requires map restart.")
      -- DForm:ControlHelp("Right click a weapon and click ''copy to clipboard'' to get its classname.")
  end)
end)

if not DarkRP then return end

-- FROM: POCKET
local pocket = {}
local frame
local reload

local function openPocketMenu()
    if IsValid(frame) and frame:IsVisible() then return end
    local wep = LocalPlayer():GetActiveWeapon()
    -- allow AH to open the pocket despite not being the pocket
    if not wep:IsValid() /* or wep:GetClass() ~= "pocket" */ then return end

    if not pocket then
        pocket = {}

        -- allow creating and viewing an empty pocket
        /* return */
    end

    -- allow opening the pocket all the time
    /* if table.IsEmpty(pocket) then return end */
    frame = vgui.Create("DFrame")

    local count = GAMEMODE.Config.pocketitems or GM.Config.pocketitems
    frame:SetSize(345, 32 + 64 * math.ceil(count / 5) + 3 * math.ceil(count / 5))
    frame:SetTitle(DarkRP.getPhrase("drop_item"))
    frame.btnMaxim:SetVisible(false)
    frame.btnMinim:SetVisible(false)
    frame:SetDraggable(false)
    frame:MakePopup()
    frame:Center()

    local Scroll = vgui.Create("DScrollPanel", frame)
    Scroll:Dock(FILL)

    local sbar = Scroll:GetVBar()
    sbar:SetWide(3)
    frame.List = vgui.Create("DIconLayout", Scroll)
    frame.List:Dock(FILL)
    frame.List:SetSpaceY(3)
    frame.List:SetSpaceX(3)
    reload()
    frame:SetSkin(GAMEMODE.Config.DarkRPSkin)
end
net.Receive("PocketMenuAH", openPocketMenu)

function reload()
    if not IsValid(frame) or not frame:IsVisible() then return end
    if not pocket then pocket = {} end
    /* if next(pocket) == nil then frame:Close() return end */

    local itemCount = table.Count(pocket)

    frame.List:Clear()
    local i = 0
    local items = {}

    for k, v in pairs(pocket) do
        local ListItem = frame.List:Add( "DPanel" )
        ListItem:SetSize( 64, 64 )

        local icon = vgui.Create("SpawnIcon", ListItem)
        icon:SetModel(v.model)
        icon:SetSize(64, 64)
        icon:SetTooltip()
        icon.DoClick = function(self)
            icon:SetTooltip()

            net.Start("DarkRP_spawnPocket")
                net.WriteFloat(k)
            net.SendToServer()
            pocket[k] = nil

            itemCount = itemCount - 1

            /*
              if itemCount == 0 then
                  frame:Close()
                  return
              end
            */

            fn.Map(self.Remove, items)
            items = {}

            local wep = LocalPlayer():GetActiveWeapon()

            wep:SetHoldType("pistol")
            wep:PlayAnimation("magic_idle")
            wep:PlayAnimation("magic_altfire_reverse", 9)
            /*
              timer.Simple(0.8, function()
                  if wep:IsValid() then
                      wep:SetHoldType("normal")
                  end
              end)
            */
        end

        table.insert(items, icon)
        i = i + 1
    end
    if itemCount < GAMEMODE.Config.pocketitems then
        for _ = 1, GAMEMODE.Config.pocketitems - itemCount do
            local ListItem = frame.List:Add("DPanel")
            ListItem:SetSize(64, 64)
        end
    end
end

local function retrievePocket()
    pocket = net.ReadTable()
    reload()
end
net.Receive("DarkRP_Pocket", retrievePocket)
net.Receive("KeysMenuAH", DarkRP.openKeysMenu)