-- vyronui.lua
-- Vyron UI — loaded by pslams (Library + shared.VyronNew must already exist)
local Library = getgenv().Library
local Config  = shared.VyronNew

local Window = Library:Window({
    Name = "Vyron",
    FadeSpeed = 0.25
})

local Watermark = Library:Watermark("vyron ~ ".. os.date("%b %d %Y") .. " ~ ".. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)
local KeybindList = Library:KeybindList()

Watermark:SetVisibility(false)
KeybindList:SetVisibility(false)

local CombatTab   = Window:Page({Name = "Combat",   Columns = 2, Subtabs = false})
local VisualsTab  = Window:Page({Name = "Visuals",  Columns = 2, Subtabs = false})
local WorldTab    = Window:Page({Name = "World",    Columns = 2, Subtabs = false})
local MiscTab     = Window:Page({Name = "Misc",     Columns = 2, Subtabs = false})
local SettingsTab = Window:Page({Name = "Settings", Columns = 2, Subtabs = false})

do -- Combat Tab

    -- Silent Aim
    local SilentAimSection = CombatTab:Section({Name = "Silent Aim", Side = 1})

    SilentAimSection:Toggle({Name = "Enabled", Flag = "SA Enabled", Default = Config["Silent Aim"]["Enabled"], Callback = function(Value)
        Config["Silent Aim"]["Enabled"] = Value
    end}):Keybind({Name = "Bind", Flag = "SA Bind", Default = Enum.KeyCode[Config["General"]["Binds"]["Silent Aim"]], Mode = "Toggle"})

    SilentAimSection:Dropdown({Name = "Target Mode", Flag = "SA Target Mode", Default = Config["Silent Aim"]["Target Mode"], Items = {"Target", "Closest", "Random"}, Callback = function(Value)
        Config["Silent Aim"]["Target Mode"] = Value
    end})

    SilentAimSection:Dropdown({Name = "Hit Part", Flag = "SA Hit Part", Default = Config["Silent Aim"]["Hit Part"], Items = {"HumanoidRootPart", "Head", "Torso"}, Callback = function(Value)
        Config["Silent Aim"]["Hit Part"] = Value
    end})

    SilentAimSection:Toggle({Name = "Auto Shoot", Flag = "SA Auto Shoot", Default = Config["Silent Aim"]["Auto Shoot"], Callback = function(Value)
        Config["Silent Aim"]["Auto Shoot"] = Value
    end})

    SilentAimSection:Divider()

    SilentAimSection:Toggle({Name = "Distance Check", Flag = "SA Dist Check", Default = Config["Silent Aim"]["Distance Check"]["Enabled"], Callback = function(Value)
        Config["Silent Aim"]["Distance Check"]["Enabled"] = Value
    end})

    SilentAimSection:Slider({Name = "Max Distance", Flag = "SA Max Dist", Min = 50, Max = 2000, Default = Config["Silent Aim"]["Distance Check"]["Max"], Decimals = 1, Suffix = " studs", Callback = function(Value)
        Config["Silent Aim"]["Distance Check"]["Max"] = Value
    end})

    SilentAimSection:Divider()

    SilentAimSection:Toggle({Name = "FOV Enabled", Flag = "SA FOV Enabled", Default = Config["Silent Aim"]["FOV"]["Enabled"], Callback = function(Value)
        Config["Silent Aim"]["FOV"]["Enabled"] = Value
    end}):Colorpicker({Name = "FOV Color", Flag = "SA FOV Color", Default = Config["Silent Aim"]["FOV"]["Color"], Callback = function(Value)
        Config["Silent Aim"]["FOV"]["Color"] = Value
    end})

    SilentAimSection:Toggle({Name = "FOV Visible", Flag = "SA FOV Visible", Default = Config["Silent Aim"]["FOV"]["Visible"], Callback = function(Value)
        Config["Silent Aim"]["FOV"]["Visible"] = Value
    end})

    SilentAimSection:Slider({Name = "FOV Size", Flag = "SA FOV Size", Min = 10, Max = 800, Default = Config["Silent Aim"]["FOV"]["Size"], Decimals = 1, Callback = function(Value)
        Config["Silent Aim"]["FOV"]["Size"] = Value
    end})

    -- Camera Lock
    local CamLockSection = CombatTab:Section({Name = "Camera Lock", Side = 1})

    CamLockSection:Toggle({Name = "Enabled", Flag = "CL Enabled", Default = Config["Camera Lock"]["Enabled"], Callback = function(Value)
        Config["Camera Lock"]["Enabled"] = Value
    end}):Keybind({Name = "Bind", Flag = "CL Bind", Default = Enum.KeyCode[Config["General"]["Binds"]["Camera Lock"]], Mode = "Toggle"})

    CamLockSection:Dropdown({Name = "Target Mode", Flag = "CL Target Mode", Default = Config["Camera Lock"]["Target Mode"], Items = {"Target", "Closest", "Random"}, Callback = function(Value)
        Config["Camera Lock"]["Target Mode"] = Value
    end})

    CamLockSection:Dropdown({Name = "Hit Part", Flag = "CL Hit Part", Default = Config["Camera Lock"]["Hit Part"], Items = {"HumanoidRootPart", "Head", "Torso"}, Callback = function(Value)
        Config["Camera Lock"]["Hit Part"] = Value
    end})

    CamLockSection:Slider({Name = "Smoothness", Flag = "CL Smoothness", Min = 0, Max = 1, Default = Config["Camera Lock"]["Smoothness"], Decimals = 0.01, Callback = function(Value)
        Config["Camera Lock"]["Smoothness"] = Value
    end})

    CamLockSection:Slider({Name = "Prediction", Flag = "CL Prediction", Min = 0, Max = 1, Default = Config["Camera Lock"]["Prediction"], Decimals = 0.01, Callback = function(Value)
        Config["Camera Lock"]["Prediction"] = Value
    end})

    CamLockSection:Divider()

    CamLockSection:Toggle({Name = "FOV Enabled", Flag = "CL FOV Enabled", Default = Config["Camera Lock"]["FOV"]["Enabled"], Callback = function(Value)
        Config["Camera Lock"]["FOV"]["Enabled"] = Value
    end}):Colorpicker({Name = "FOV Color", Flag = "CL FOV Color", Default = Config["Camera Lock"]["FOV"]["Color"], Callback = function(Value)
        Config["Camera Lock"]["FOV"]["Color"] = Value
    end})

    CamLockSection:Toggle({Name = "FOV Visible", Flag = "CL FOV Visible", Default = Config["Camera Lock"]["FOV"]["Visible"], Callback = function(Value)
        Config["Camera Lock"]["FOV"]["Visible"] = Value
    end})

    CamLockSection:Slider({Name = "FOV Size", Flag = "CL FOV Size", Min = 10, Max = 800, Default = Config["Camera Lock"]["FOV"]["Size"], Decimals = 1, Callback = function(Value)
        Config["Camera Lock"]["FOV"]["Size"] = Value
    end})

    -- Trigger Bot
    local TriggerSection = CombatTab:Section({Name = "Trigger Bot", Side = 2})

    TriggerSection:Toggle({Name = "Enabled", Flag = "TB Enabled", Default = Config["Trigger Bot"]["Enabled"], Callback = function(Value)
        Config["Trigger Bot"]["Enabled"] = Value
    end}):Keybind({Name = "Bind", Flag = "TB Bind", Default = Enum.KeyCode[Config["General"]["Binds"]["Trigger Bot"]], Mode = "Toggle"})

    TriggerSection:Dropdown({Name = "Target Mode", Flag = "TB Target Mode", Default = Config["Trigger Bot"]["Target Mode"], Items = {"Target", "Closest", "Random"}, Callback = function(Value)
        Config["Trigger Bot"]["Target Mode"] = Value
    end})

    TriggerSection:Slider({Name = "Cooldown", Flag = "TB Cooldown", Min = 0, Max = 1, Default = Config["Trigger Bot"]["Cooldown"], Decimals = 0.01, Suffix = "s", Callback = function(Value)
        Config["Trigger Bot"]["Cooldown"] = Value
    end})

    TriggerSection:Divider()

    TriggerSection:Toggle({Name = "FOV Enabled", Flag = "TB FOV Enabled", Default = Config["Trigger Bot"]["FOV"]["Enabled"], Callback = function(Value)
        Config["Trigger Bot"]["FOV"]["Enabled"] = Value
    end}):Colorpicker({Name = "FOV Color", Flag = "TB FOV Color", Default = Config["Trigger Bot"]["FOV"]["Color"], Callback = function(Value)
        Config["Trigger Bot"]["FOV"]["Color"] = Value
    end})

    TriggerSection:Toggle({Name = "FOV Visible", Flag = "TB FOV Visible", Default = Config["Trigger Bot"]["FOV"]["Visible"], Callback = function(Value)
        Config["Trigger Bot"]["FOV"]["Visible"] = Value
    end})

    TriggerSection:Slider({Name = "FOV Size", Flag = "TB FOV Size", Min = 5, Max = 200, Default = Config["Trigger Bot"]["FOV"]["Size"], Decimals = 1, Callback = function(Value)
        Config["Trigger Bot"]["FOV"]["Size"] = Value
    end})

    -- Weapon
    local WeaponSection = CombatTab:Section({Name = "Weapon", Side = 2})

    WeaponSection:Toggle({Name = "Rapid Fire", Flag = "RF Enabled", Default = Config["Rapid Fire"]["Enabled"], Callback = function(Value)
        Config["Rapid Fire"]["Enabled"] = Value
    end}):Keybind({Name = "Bind", Flag = "RF Bind", Mode = "Toggle"})

    WeaponSection:Slider({Name = "RF Cooldown", Flag = "RF Cooldown", Min = 0, Max = 1, Default = Config["Rapid Fire"]["Cooldown"], Decimals = 0.001, Suffix = "s", Callback = function(Value)
        Config["Rapid Fire"]["Cooldown"] = Value
    end})

    WeaponSection:Divider()

    WeaponSection:Toggle({Name = "Spread Modifier", Flag = "SM Enabled", Default = Config["Spread Modifier"]["Enabled"], Callback = function(Value)
        Config["Spread Modifier"]["Enabled"] = Value
    end})

    WeaponSection:Slider({Name = "Spread Amount", Flag = "SM Amount", Min = 0, Max = 1, Default = Config["Spread Modifier"]["Amount"], Decimals = 0.01, Callback = function(Value)
        Config["Spread Modifier"]["Amount"] = Value
    end})

    WeaponSection:Divider()

    WeaponSection:Toggle({Name = "Infinite Range", Flag = "IR Enabled", Default = Config["Infinite Range"]["Enabled"], Callback = function(Value)
        Config["Infinite Range"]["Enabled"] = Value
    end})

    WeaponSection:Slider({Name = "Range", Flag = "IR Range", Min = 100, Max = 999999999, Default = Config["Infinite Range"]["Range"], Decimals = 1, Callback = function(Value)
        Config["Infinite Range"]["Range"] = Value
    end})

    WeaponSection:Toggle({Name = "Zero Cooldown", Flag = "ZC Enabled", Default = Config["Zero Cooldown"]["Enabled"], Callback = function(Value)
        Config["Zero Cooldown"]["Enabled"] = Value
    end})

    WeaponSection:Divider()

    WeaponSection:Toggle({Name = "Hitbox Expander", Flag = "HB Enabled", Default = Config["Hitbox Expander"]["Enabled"], Callback = function(Value)
        Config["Hitbox Expander"]["Enabled"] = Value
    end})

    WeaponSection:Slider({Name = "Hitbox Size", Flag = "HB Size", Min = 1, Max = 50, Default = Config["Hitbox Expander"]["Size"], Decimals = 0.1, Callback = function(Value)
        Config["Hitbox Expander"]["Size"] = Value
    end})

    WeaponSection:Toggle({Name = "Visualize Hitbox", Flag = "HB Visualize", Default = Config["Hitbox Expander"]["Visualize"], Callback = function(Value)
        Config["Hitbox Expander"]["Visualize"] = Value
    end})
end

do -- Visuals Tab

    local ESPSection = VisualsTab:Section({Name = "ESP", Side = 1})

    ESPSection:Toggle({Name = "Enabled", Flag = "ESP Enabled", Default = Config["ESP"]["Enabled"], Callback = function(Value)
        Config["ESP"]["Enabled"] = Value
    end}):Keybind({Name = "Bind", Flag = "ESP Bind", Default = Enum.KeyCode[Config["General"]["Binds"]["ESP"]], Mode = "Toggle"})

    ESPSection:Colorpicker({Name = "ESP Color", Flag = "ESP Color", Default = Config["ESP"]["Color"], Callback = function(Value)
        Config["ESP"]["Color"] = Value
    end})

    ESPSection:Colorpicker({Name = "Target Color", Flag = "ESP Target Color", Default = Config["ESP"]["Target Color"], Callback = function(Value)
        Config["ESP"]["Target Color"] = Value
    end})

    ESPSection:Divider()

    ESPSection:Toggle({Name = "Nametag", Flag = "ESP Nametag", Default = Config["ESP"]["Nametag"]["Enabled"], Callback = function(Value)
        Config["ESP"]["Nametag"]["Enabled"] = Value
    end})

    ESPSection:Dropdown({Name = "Nametag Mode", Flag = "ESP Nametag Mode", Default = Config["ESP"]["Nametag"]["Mode"], Items = {"Username", "DisplayName"}, Callback = function(Value)
        Config["ESP"]["Nametag"]["Mode"] = Value
    end})

    ESPSection:Dropdown({Name = "Nametag Position", Flag = "ESP Nametag Pos", Default = Config["ESP"]["Nametag"]["Position"], Items = {"Feet", "Head"}, Callback = function(Value)
        Config["ESP"]["Nametag"]["Position"] = Value
    end})

    ESPSection:Slider({Name = "Nametag Size", Flag = "ESP Nametag Size", Min = 6, Max = 24, Default = Config["ESP"]["Nametag"]["Size"], Decimals = 1, Callback = function(Value)
        Config["ESP"]["Nametag"]["Size"] = Value
    end})

    ESPSection:Divider()

    ESPSection:Toggle({Name = "Box", Flag = "ESP Box", Default = Config["ESP"]["Box"]["Enabled"], Callback = function(Value)
        Config["ESP"]["Box"]["Enabled"] = Value
    end}):Colorpicker({Name = "Box Color", Flag = "ESP Box Color", Default = Config["ESP"]["Box"]["Color"], Callback = function(Value)
        Config["ESP"]["Box"]["Color"] = Value
    end})

    ESPSection:Toggle({Name = "Health Bar", Flag = "ESP HealthBar", Default = Config["ESP"]["HealthBar"]["Enabled"], Callback = function(Value)
        Config["ESP"]["HealthBar"]["Enabled"] = Value
    end})

    ESPSection:Toggle({Name = "Skeleton", Flag = "ESP Skeleton", Default = Config["ESP"]["Skeleton"]["Enabled"], Callback = function(Value)
        Config["ESP"]["Skeleton"]["Enabled"] = Value
    end}):Colorpicker({Name = "Skeleton Color", Flag = "ESP Skeleton Color", Default = Config["ESP"]["Skeleton"]["Color"], Callback = function(Value)
        Config["ESP"]["Skeleton"]["Color"] = Value
    end})

    local TracerSection = VisualsTab:Section({Name = "Tracer", Side = 1})

    TracerSection:Toggle({Name = "Enabled", Flag = "Tracer Enabled", Default = Config["Tracer"]["Enabled"], Callback = function(Value)
        Config["Tracer"]["Enabled"] = Value
    end}):Colorpicker({Name = "Color", Flag = "Tracer Color", Default = Config["Tracer"]["Color"], Callback = function(Value)
        Config["Tracer"]["Color"] = Value
    end})

    TracerSection:Slider({Name = "Thickness", Flag = "Tracer Thickness", Min = 1, Max = 10, Default = Config["Tracer"]["Thickness"], Decimals = 0.5, Callback = function(Value)
        Config["Tracer"]["Thickness"] = Value
    end})

    TracerSection:Slider({Name = "Transparency", Flag = "Tracer Transparency", Min = 0, Max = 1, Default = Config["Tracer"]["Transparency"], Decimals = 0.01, Callback = function(Value)
        Config["Tracer"]["Transparency"] = Value
    end})

    local HUDSection = VisualsTab:Section({Name = "HUD", Side = 2})

    HUDSection:Toggle({Name = "Enabled", Flag = "HUD Enabled", Default = Config["General"]["HUD"]["Enabled"], Callback = function(Value)
        Config["General"]["HUD"]["Enabled"] = Value
    end})

    HUDSection:Label({Name = "Title Color", Alignment = "Left"}):Colorpicker({Name = "Title Color", Flag = "HUD Title Color", Default = Config["General"]["HUD"]["Title Color"], Callback = function(Value)
        Config["General"]["HUD"]["Title Color"] = Value
    end})

    HUDSection:Label({Name = "Accent Color", Alignment = "Left"}):Colorpicker({Name = "Accent Color", Flag = "HUD Accent Color", Default = Config["General"]["HUD"]["Accent Color"], Callback = function(Value)
        Config["General"]["HUD"]["Accent Color"] = Value
    end})

    HUDSection:Label({Name = "Active Color", Alignment = "Left"}):Colorpicker({Name = "Active Color", Flag = "HUD Active Color", Default = Config["General"]["HUD"]["Active Color"], Callback = function(Value)
        Config["General"]["HUD"]["Active Color"] = Value
    end})

    HUDSection:Label({Name = "Inactive Color", Alignment = "Left"}):Colorpicker({Name = "Inactive Color", Flag = "HUD Inactive Color", Default = Config["General"]["HUD"]["Inactive Color"], Callback = function(Value)
        Config["General"]["HUD"]["Inactive Color"] = Value
    end})

    local DmgSection = VisualsTab:Section({Name = "Damage Indicator", Side = 2})

    DmgSection:Toggle({Name = "Enabled", Flag = "DI Enabled", Default = Config["Misc"]["Damage Indicator"]["Enabled"], Callback = function(Value)
        Config["Misc"]["Damage Indicator"]["Enabled"] = Value
    end})
end

do -- World Tab

    local FogSection = WorldTab:Section({Name = "Fog", Side = 1})

    FogSection:Toggle({Name = "Enabled", Flag = "Fog Enabled", Default = Config["World"]["Fog"]["Enabled"], Callback = function(Value)
        Config["World"]["Fog"]["Enabled"] = Value
    end}):Colorpicker({Name = "Fog Color", Flag = "Fog Color", Default = Config["World"]["Fog"]["FogColor"], Callback = function(Value)
        Config["World"]["Fog"]["FogColor"] = Value
    end})

    FogSection:Slider({Name = "Fog End", Flag = "Fog End", Min = 0, Max = 100000, Default = Config["World"]["Fog"]["FogEnd"], Decimals = 1, Callback = function(Value)
        Config["World"]["Fog"]["FogEnd"] = Value
    end})

    FogSection:Slider({Name = "Fog Start", Flag = "Fog Start", Min = 0, Max = 100000, Default = Config["World"]["Fog"]["FogStart"], Decimals = 1, Callback = function(Value)
        Config["World"]["Fog"]["FogStart"] = Value
    end})

    local LightingSection = WorldTab:Section({Name = "Lighting", Side = 1})

    LightingSection:Toggle({Name = "Enabled", Flag = "Lighting Enabled", Default = Config["World"]["Lighting"]["Enabled"], Callback = function(Value)
        Config["World"]["Lighting"]["Enabled"] = Value
    end})

    LightingSection:Slider({Name = "Clock Time", Flag = "Lighting ClockTime", Min = 0, Max = 24, Default = Config["World"]["Lighting"]["ClockTime"], Decimals = 0.1, Callback = function(Value)
        Config["World"]["Lighting"]["ClockTime"] = Value
    end})

    LightingSection:Slider({Name = "Brightness", Flag = "Lighting Brightness", Min = 0, Max = 10, Default = Config["World"]["Lighting"]["Brightness"], Decimals = 0.1, Callback = function(Value)
        Config["World"]["Lighting"]["Brightness"] = Value
    end})

    LightingSection:Toggle({Name = "Global Shadows", Flag = "Lighting Shadows", Default = Config["World"]["Lighting"]["GlobalShadows"], Callback = function(Value)
        Config["World"]["Lighting"]["GlobalShadows"] = Value
    end})

    LightingSection:Label({Name = "Ambient", Alignment = "Left"}):Colorpicker({Name = "Ambient", Flag = "Lighting Ambient", Default = Config["World"]["Lighting"]["Ambient"], Callback = function(Value)
        Config["World"]["Lighting"]["Ambient"] = Value
    end})

    LightingSection:Label({Name = "Outdoor Ambient", Alignment = "Left"}):Colorpicker({Name = "Outdoor Ambient", Flag = "Lighting OutdoorAmbient", Default = Config["World"]["Lighting"]["OutdoorAmbient"], Callback = function(Value)
        Config["World"]["Lighting"]["OutdoorAmbient"] = Value
    end})

    local CCSection = WorldTab:Section({Name = "Color Correction", Side = 2})

    CCSection:Toggle({Name = "Enabled", Flag = "CC Enabled", Default = Config["World"]["Color Correction"]["Enabled"], Callback = function(Value)
        Config["World"]["Color Correction"]["Enabled"] = Value
    end})

    CCSection:Toggle({Name = "Saturation", Flag = "CC Sat Enabled", Default = Config["World"]["Color Correction"]["Saturation"]["Enabled"], Callback = function(Value)
        Config["World"]["Color Correction"]["Saturation"]["Enabled"] = Value
    end})

    CCSection:Slider({Name = "Saturation Value", Flag = "CC Sat Value", Min = -1, Max = 1, Default = Config["World"]["Color Correction"]["Saturation"]["Value"], Decimals = 0.01, Callback = function(Value)
        Config["World"]["Color Correction"]["Saturation"]["Value"] = Value
    end})

    CCSection:Toggle({Name = "Contrast", Flag = "CC Con Enabled", Default = Config["World"]["Color Correction"]["Contrast"]["Enabled"], Callback = function(Value)
        Config["World"]["Color Correction"]["Contrast"]["Enabled"] = Value
    end})

    CCSection:Slider({Name = "Contrast Value", Flag = "CC Con Value", Min = -1, Max = 1, Default = Config["World"]["Color Correction"]["Contrast"]["Value"], Decimals = 0.01, Callback = function(Value)
        Config["World"]["Color Correction"]["Contrast"]["Value"] = Value
    end})

    CCSection:Toggle({Name = "Brightness", Flag = "CC Bri Enabled", Default = Config["World"]["Color Correction"]["Brightness"]["Enabled"], Callback = function(Value)
        Config["World"]["Color Correction"]["Brightness"]["Enabled"] = Value
    end})

    CCSection:Slider({Name = "Brightness Value", Flag = "CC Bri Value", Min = -1, Max = 1, Default = Config["World"]["Color Correction"]["Brightness"]["Value"], Decimals = 0.01, Callback = function(Value)
        Config["World"]["Color Correction"]["Brightness"]["Value"] = Value
    end})

    CCSection:Toggle({Name = "Tint Color", Flag = "CC Tint Enabled", Default = Config["World"]["Color Correction"]["TintColor"]["Enabled"], Callback = function(Value)
        Config["World"]["Color Correction"]["TintColor"]["Enabled"] = Value
    end}):Colorpicker({Name = "Tint", Flag = "CC Tint Color", Default = Config["World"]["Color Correction"]["TintColor"]["Value"], Callback = function(Value)
        Config["World"]["Color Correction"]["TintColor"]["Value"] = Value
    end})
end

do -- Misc Tab

    local MovementSection = MiscTab:Section({Name = "Movement", Side = 1})

    MovementSection:Toggle({Name = "Speed", Flag = "Speed Enabled", Default = Config["Speed"]["Enabled"], Callback = function(Value)
        Config["Speed"]["Enabled"] = Value
    end}):Keybind({Name = "Bind", Flag = "Speed Bind", Default = Enum.KeyCode[Config["General"]["Binds"]["Speed"]], Mode = "Toggle"})

    MovementSection:Slider({Name = "Speed Value", Flag = "Speed Value", Min = 16, Max = 5000, Default = Config["Speed"]["Speed"], Decimals = 1, Callback = function(Value)
        Config["Speed"]["Speed"] = Value
    end})

    MovementSection:Divider()

    MovementSection:Toggle({Name = "Spiderman", Flag = "Spider Enabled", Default = Config["Spiderman"]["Enabled"], Callback = function(Value)
        Config["Spiderman"]["Enabled"] = Value
    end}):Keybind({Name = "Bind", Flag = "Spider Bind", Default = Enum.KeyCode[Config["General"]["Binds"]["Spiderman"]], Mode = "Toggle"})

    MovementSection:Slider({Name = "Jump Power", Flag = "Spider JumpPower", Min = 10, Max = 500, Default = Config["Spiderman"]["Jump Power"], Decimals = 1, Callback = function(Value)
        Config["Spiderman"]["Jump Power"] = Value
    end})

    local OrbitSection = MiscTab:Section({Name = "Orbit", Side = 1})

    OrbitSection:Toggle({Name = "Enabled", Flag = "Orbit Enabled", Default = Config["Misc"]["Orbit"]["Enabled"], Callback = function(Value)
        Config["Misc"]["Orbit"]["Enabled"] = Value
    end}):Keybind({Name = "Bind", Flag = "Orbit Bind", Default = Enum.KeyCode[Config["General"]["Binds"]["Orbit"]], Mode = "Toggle"})

    OrbitSection:Toggle({Name = "Dead Check", Flag = "Orbit Dead Check", Default = Config["Misc"]["Orbit"]["Dead Check"], Callback = function(Value)
        Config["Misc"]["Orbit"]["Dead Check"] = Value
    end})

    OrbitSection:Slider({Name = "Speed", Flag = "Orbit Speed", Min = 0.1, Max = 10, Default = Config["Misc"]["Orbit"]["Speed"], Decimals = 0.1, Suffix = " rad/s", Callback = function(Value)
        Config["Misc"]["Orbit"]["Speed"] = Value
    end})

    OrbitSection:Slider({Name = "Height", Flag = "Orbit Height", Min = 0, Max = 50, Default = Config["Misc"]["Orbit"]["Height"], Decimals = 0.5, Suffix = " studs", Callback = function(Value)
        Config["Misc"]["Orbit"]["Height"] = Value
    end})

    OrbitSection:Slider({Name = "Radius", Flag = "Orbit Radius", Min = 1, Max = 50, Default = Config["Misc"]["Orbit"]["Radius"], Decimals = 0.5, Suffix = " studs", Callback = function(Value)
        Config["Misc"]["Orbit"]["Radius"] = Value
    end})

    OrbitSection:Dropdown({Name = "Sync With", Flag = "Orbit Sync", Default = Config["Misc"]["Orbit"]["Sync With"], Items = {"None", "Silent Aim", "Camera Lock", "Trigger Bot"}, Callback = function(Value)
        Config["Misc"]["Orbit"]["Sync With"] = Value
    end})

    local UtilSection = MiscTab:Section({Name = "Utility", Side = 2})

    UtilSection:Toggle({Name = "Bullet TP", Flag = "BTP Enabled", Default = Config["Misc"]["Bullet TP"]["Enabled"], Callback = function(Value)
        Config["Misc"]["Bullet TP"]["Enabled"] = Value
    end}):Keybind({Name = "Bind", Flag = "BTP Bind", Default = Enum.KeyCode[Config["General"]["Binds"]["Bullet TP"]], Mode = "Toggle"})

    UtilSection:Toggle({Name = "View Target on TP", Flag = "BTP View Target", Default = Config["Misc"]["Bullet TP"]["View Target"], Callback = function(Value)
        Config["Misc"]["Bullet TP"]["View Target"] = Value
    end})

    UtilSection:Divider()

    UtilSection:Toggle({Name = "Anti Lock", Flag = "AL Enabled", Default = Config["Misc"]["Anti Lock"]["Enabled"], Callback = function(Value)
        Config["Misc"]["Anti Lock"]["Enabled"] = Value
    end}):Keybind({Name = "Bind", Flag = "AL Bind", Default = Enum.KeyCode[Config["General"]["Binds"]["Anti Lock"]], Mode = "Toggle"})

    UtilSection:Dropdown({Name = "Anti Lock Mode", Flag = "AL Mode", Default = Config["Misc"]["Anti Lock"]["Mode"], Items = {"Predbreaker", "Sky", "Ground"}, Callback = function(Value)
        Config["Misc"]["Anti Lock"]["Mode"] = Value
    end})

    UtilSection:Divider()

    UtilSection:Toggle({Name = "Void Hide", Flag = "VH Enabled", Default = Config["Misc"]["Void Hide"]["Enabled"], Callback = function(Value)
        Config["Misc"]["Void Hide"]["Enabled"] = Value
    end}):Keybind({Name = "Bind", Flag = "VH Bind", Default = Enum.KeyCode[Config["General"]["Binds"]["Void Hide"]], Mode = "Toggle"})

    UtilSection:Slider({Name = "Void Depth", Flag = "VH Void Y", Min = -100000, Max = -100, Default = Config["Misc"]["Void Hide"]["Void Y"], Decimals = 100, Callback = function(Value)
        Config["Misc"]["Void Hide"]["Void Y"] = Value
    end})

    UtilSection:Divider()

    UtilSection:Toggle({Name = "Headless", Flag = "HL Enabled", Default = Config["Headless"]["Enabled"], Callback = function(Value)
        Config["Headless"]["Enabled"] = Value
    end})

    UtilSection:Toggle({Name = "Permanent Headless", Flag = "HL Permanent", Default = Config["Headless"]["Permanent"], Callback = function(Value)
        Config["Headless"]["Permanent"] = Value
    end})

    local ChecksSection = MiscTab:Section({Name = "Checks", Side = 2})

    ChecksSection:Toggle({Name = "Visible Only", Flag = "Check Visible", Default = Config["General"]["Checks"]["Visible"], Callback = function(Value)
        Config["General"]["Checks"]["Visible"] = Value
    end})

    ChecksSection:Toggle({Name = "Target Knocked", Flag = "Check Knocked", Default = Config["General"]["Checks"]["Knocked"], Callback = function(Value)
        Config["General"]["Checks"]["Knocked"] = Value
    end})

    ChecksSection:Toggle({Name = "Respawn Check", Flag = "Check Respawn", Default = Config["General"]["Checks"]["Respawn Check"], Callback = function(Value)
        Config["General"]["Checks"]["Respawn Check"] = Value
    end})

    ChecksSection:Toggle({Name = "Crouch Rapid Stop", Flag = "Check Crouch Rapid", Default = Config["General"]["Checks"]["Crouch Rapid"], Callback = function(Value)
        Config["General"]["Checks"]["Crouch Rapid"] = Value
    end})

    ChecksSection:Divider()

    ChecksSection:Toggle({Name = "Bot Targeting", Flag = "BT Enabled", Default = Config["Bot Targeting"]["Enabled"], Callback = function(Value)
        Config["Bot Targeting"]["Enabled"] = Value
    end})

    ChecksSection:Textbox({Name = "Bot Pattern", Flag = "BT Pattern", Default = Config["Bot Targeting"]["Pattern"], Placeholder = "bot", Callback = function(Value)
        Config["Bot Targeting"]["Pattern"] = Value
    end})

    ChecksSection:Divider()

    ChecksSection:Toggle({Name = "Blacklist", Flag = "BL Enabled", Default = Config["Blacklist"]["Enabled"], Callback = function(Value)
        Config["Blacklist"]["Enabled"] = Value
    end})

    ChecksSection:Toggle({Name = "Knife Check", Flag = "KC Enabled", Default = Config["Knife Check"]["Enabled"], Callback = function(Value)
        Config["Knife Check"]["Enabled"] = Value
    end})
end

do -- Settings Tab
    local SettingsSection = SettingsTab:Section({Name = "Settings", Side = 2})
    local ConfigsSection  = SettingsTab:Section({Name = "Profiles",  Side = 1})

    for Index, Value in Library.Theme do
        SettingsSection:Label({Name = Index, Alignment = "Left"}):Colorpicker({Name = Index, Default = Value, Flag = "Theme"..Index, Callback = function(Color)
            Library.Theme[Index] = Color
            Library:ChangeTheme(Index, Color)
        end})
    end

    SettingsSection:Label({Name = "Menu Keybind", Alignment = "Left"}):Keybind({Name = "Menu Keybind", Flag = "Menu Keybind", Default = Enum.KeyCode.RightControl, Mode = "Toggle", Callback = function()
        Library.MenuKeybind = Library.Flags["Menu Keybind"].Key
    end})

    SettingsSection:Toggle({Name = "Watermark", Flag = "Watermark", Default = false, Callback = function(Value)
        Watermark:SetVisibility(Value)
    end})

    SettingsSection:Toggle({Name = "Keybind List", Flag = "Keybind List", Default = false, Callback = function(Value)
        KeybindList:SetVisibility(Value)
    end})

    SettingsSection:Dropdown({Name = "Tweening Style", Flag = "Tweening Style", Default = "Exponential", Items = {"Linear", "Sine", "Quad", "Cubic", "Quart", "Quint", "Exponential", "Circular", "Back", "Elastic", "Bounce"}, Callback = function(Value)
        Library.Tween.Style = Enum.EasingStyle[Value]
    end})

    SettingsSection:Dropdown({Name = "Tweening Direction", Flag = "Tweening Direction", Default = "Out", Items = {"In", "Out", "InOut"}, Callback = function(Value)
        Library.Tween.Direction = Enum.EasingDirection[Value]
    end})

    SettingsSection:Slider({Name = "Tweening Time", Flag = "Tweening Time", Min = 0, Max = 5, Default = 0.25, Decimals = 0.01, Callback = function(Value)
        Library.Tween.Time = Value
    end})

    SettingsSection:Button({Name = "Unload", Callback = function()
        Library:Unload()
    end})

    local ConfigName
    local ConfigSelected

    local ConfigsListbox = ConfigsSection:Listbox({Items = {}, Name = "Configs", Flag = "Configs List", Callback = function(Value)
        ConfigSelected = Value
    end})

    ConfigsSection:Textbox({Name = "Config Name", Placeholder = ". .", Flag = "Config Name", Callback = function(Value)
        ConfigName = Value
    end})

    ConfigsSection:Button({Name = "Create Config", Callback = function()
        if not isfile(Library.Folders.Configs .. "/" .. ConfigName .. ".json") then
            writefile(Library.Folders.Configs .. "/" .. ConfigName .. ".json", Library:GetConfig())
            Library:RefreshConfigsList(ConfigsListbox)
        else
            Library:Notification("Config '" .. ConfigName .. ".json' already exists", 3, Color3.fromRGB(255, 0, 0))
        end
    end})

    ConfigsSection:Button({Name = "Load Config", Callback = function()
        if ConfigSelected then
            Library:LoadConfig(readfile(Library.Folders.Configs .. "/" .. ConfigSelected))
        end
        Library:Thread(function()
            task.wait(0.1)
            for Index, Value in Library.Theme do
                Library.Theme[Index] = Library.Flags["Theme"..Index].Color
                Library:ChangeTheme(Index, Library.Flags["Theme"..Index].Color)
            end
        end)
    end})

    ConfigsSection:Button({Name = "Delete Config", Callback = function()
        if ConfigSelected then
            Library:DeleteConfig(ConfigSelected)
            Library:RefreshConfigsList(ConfigsListbox)
        end
    end})

    ConfigsSection:Button({Name = "Save Config", Callback = function()
        if ConfigSelected then
            Library:SaveConfig(ConfigSelected)
        end
    end})

    ConfigsSection:Button({Name = "Refresh Configs", Callback = function()
        Library:RefreshConfigsList(ConfigsListbox)
    end})

    Library:RefreshConfigsList(ConfigsListbox)
end
