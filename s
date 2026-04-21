-- UI Library
-- Standalone Roblox Lua UI Framework
-- Dark theme, smooth animations, tab system, toggles, sliders, buttons

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Library = {}
Library.__index = Library

-- Theme
local Theme = {
    Background      = Color3.fromRGB(13, 17, 28),
    BackgroundAlt   = Color3.fromRGB(18, 23, 36),
    Surface         = Color3.fromRGB(22, 28, 44),
    SurfaceAlt      = Color3.fromRGB(28, 35, 54),
    Border          = Color3.fromRGB(40, 50, 75),
    Accent          = Color3.fromRGB(99, 130, 255),
    AccentDark      = Color3.fromRGB(70, 95, 200),
    AccentGlow      = Color3.fromRGB(120, 150, 255),
    Text            = Color3.fromRGB(220, 225, 240),
    TextMuted       = Color3.fromRGB(130, 140, 170),
    TextDim         = Color3.fromRGB(80, 90, 120),
    ToggleOn        = Color3.fromRGB(99, 130, 255),
    ToggleOff       = Color3.fromRGB(45, 55, 80),
    SliderFill      = Color3.fromRGB(99, 130, 255),
    SliderTrack     = Color3.fromRGB(35, 44, 68),
    ButtonBase      = Color3.fromRGB(30, 38, 60),
    ButtonHover     = Color3.fromRGB(40, 52, 85),
    ButtonPress     = Color3.fromRGB(22, 28, 50),
    Divider         = Color3.fromRGB(35, 44, 68),
    Shadow          = Color3.fromRGB(5, 7, 12),
}

-- Tween helpers
local function tween(obj, props, duration, style, direction)
    style = style or Enum.EasingStyle.Quart
    direction = direction or Enum.EasingDirection.Out
    local info = TweenInfo.new(duration or 0.25, style, direction)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local function tweenSpring(obj, props, duration)
    return tween(obj, props, duration or 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

-- Utility: create instance with properties
local function make(class, props, parent)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        inst[k] = v
    end
    if parent then inst.Parent = parent end
    return inst
end

-- Utility: hover color effect
local function addHover(btn, normalColor, hoverColor, prop)
    prop = prop or "BackgroundColor3"
    btn.MouseEnter:Connect(function()
        tween(btn, {[prop] = hoverColor}, 0.15)
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, {[prop] = normalColor}, 0.2)
    end)
end

-- Utility: corner radius
local function corner(parent, radius)
    return make("UICorner", {CornerRadius = UDim.new(0, radius or 6)}, parent)
end

local function stroke(parent, color, thickness)
    return make("UIStroke", {
        Color = color or Theme.Border,
        Thickness = thickness or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, parent)
end


-- ScreenGui setup
local function createGui()
    local existing = LocalPlayer.PlayerGui:FindFirstChild("UILibrary")
    if existing then existing:Destroy() end

    local gui = make("ScreenGui", {
        Name = "UILibrary",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 999,
    }, LocalPlayer.PlayerGui)

    return gui
end

-- Dragging logic
local function makeDraggable(handle, frame)
    local dragging = false
    local dragStart, startPos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end


-- Window constructor
function Library:CreateWindow(config)
    config = config or {}
    local title   = config.Title or "Interface"
    local width   = config.Width or 520
    local height  = config.Height or 400
    local keybind = config.Keybind or Enum.KeyCode.RightShift

    local gui = createGui()
    local visible = true

    -- Root frame (used for scale animation)
    local root = make("Frame", {
        Name = "Root",
        Size = UDim2.new(0, width, 0, height),
        Position = UDim2.new(0.5, -width / 2, 0.5, -height / 2),
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
    }, gui)

    -- Main window frame
    local win = make("Frame", {
        Name = "Window",
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
    }, root)
    corner(win, 10)
    stroke(win, Theme.Border, 1)

    -- Drop shadow
    local shadow = make("ImageLabel", {
        Name = "Shadow",
        Size = UDim2.new(1, 30, 1, 30),
        Position = UDim2.new(0, -15, 0, -10),
        BackgroundTransparency = 1,
        Image = "rbxassetid://6014261993",
        ImageColor3 = Theme.Shadow,
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
        ZIndex = -1,
    }, root)

    -- Accent top bar
    local accentBar = make("Frame", {
        Name = "AccentBar",
        Size = UDim2.new(1, 0, 0, 3),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        ZIndex = 5,
    }, win)
    make("UICorner", {CornerRadius = UDim.new(0, 10)}, accentBar)

    -- Title bar
    local titleBar = make("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 44),
        Position = UDim2.new(0, 0, 0, 3),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        ZIndex = 4,
    }, win)

    local titleLabel = make("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 16, 0, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Theme.Text,
        TextSize = 15,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 5,
    }, titleBar)

    -- Close button
    local closeBtn = make("TextButton", {
        Name = "Close",
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(1, -38, 0.5, -14),
        BackgroundColor3 = Theme.SurfaceAlt,
        Text = "x",
        TextColor3 = Theme.TextMuted,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        ZIndex = 6,
    }, titleBar)
    corner(closeBtn, 6)
    addHover(closeBtn, Theme.SurfaceAlt, Color3.fromRGB(180, 60, 60))

    -- Divider under title
    make("Frame", {
        Size = UDim2.new(1, -32, 0, 1),
        Position = UDim2.new(0, 16, 1, -1),
        BackgroundColor3 = Theme.Divider,
        BorderSizePixel = 0,
        ZIndex = 4,
    }, titleBar)

    makeDraggable(titleBar, root)

    -- Tab bar
    local tabBar = make("Frame", {
        Name = "TabBar",
        Size = UDim2.new(0, 140, 1, -47),
        Position = UDim2.new(0, 0, 0, 47),
        BackgroundColor3 = Theme.BackgroundAlt,
        BorderSizePixel = 0,
        ZIndex = 3,
        ClipsDescendants = true,
    }, win)

    make("UIStroke", {
        Color = Theme.Border,
        Thickness = 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, tabBar)

    local tabList = make("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2),
    }, tabBar)

    make("UIPadding", {
        PaddingTop = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
    }, tabBar)

    -- Content area
    local contentArea = make("Frame", {
        Name = "ContentArea",
        Size = UDim2.new(1, -148, 1, -55),
        Position = UDim2.new(0, 148, 0, 55),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 3,
        ClipsDescendants = true,
    }, win)

    -- Window object
    local Window = {}
    Window._gui = gui
    Window._root = root
    Window._win = win
    Window._tabs = {}
    Window._activeTab = nil
    Window._visible = true

    -- Open/close animation
    local function setVisible(state)
        visible = state
        if state then
            root.Visible = true
            tween(win, {BackgroundTransparency = 0}, 0.2)
            tweenSpring(root, {Size = UDim2.new(0, width, 0, height)}, 0.35)
        else
            tween(win, {BackgroundTransparency = 1}, 0.2)
            tween(root, {Size = UDim2.new(0, width * 0.92, 0, height * 0.92)}, 0.25)
            task.delay(0.25, function()
                root.Visible = false
                root.Size = UDim2.new(0, width, 0, height)
            end)
        end
    end

    closeBtn.MouseButton1Click:Connect(function()
        setVisible(false)
    end)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == keybind then
            setVisible(not visible)
        end
    end)

    -- Tab creation
    function Window:AddTab(tabConfig)
        tabConfig = tabConfig or {}
        local tabName = tabConfig.Name or ("Tab " .. #self._tabs + 1)

        -- Tab button
        local tabBtn = make("TextButton", {
            Name = "Tab_" .. tabName,
            Size = UDim2.new(1, 0, 0, 34),
            BackgroundColor3 = Theme.Surface,
            Text = "",
            BorderSizePixel = 0,
            ZIndex = 4,
            LayoutOrder = #self._tabs + 1,
        }, tabBar)
        corner(tabBtn, 6)

        local tabLabel = make("TextLabel", {
            Size = UDim2.new(1, -12, 1, 0),
            Position = UDim2.new(0, 12, 0, 0),
            BackgroundTransparency = 1,
            Text = tabName,
            TextColor3 = Theme.TextMuted,
            TextSize = 13,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 5,
        }, tabBtn)

        -- Active indicator bar
        local indicator = make("Frame", {
            Size = UDim2.new(0, 3, 0.6, 0),
            Position = UDim2.new(0, 0, 0.2, 0),
            BackgroundColor3 = Theme.Accent,
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            ZIndex = 6,
        }, tabBtn)
        corner(indicator, 3)

        -- Scroll frame for tab content
        local scrollFrame = make("ScrollingFrame", {
            Name = "Content_" .. tabName,
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.Accent,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            ZIndex = 3,
        }, contentArea)

        local contentList = make("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 6),
        }, scrollFrame)

        make("UIPadding", {
            PaddingTop = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 14),
            PaddingBottom = UDim.new(0, 10),
        }, scrollFrame)

        local Tab = {}
        Tab._btn = tabBtn
        Tab._label = tabLabel
        Tab._indicator = indicator
        Tab._scroll = scrollFrame
        Tab._window = self
        Tab._order = 0

        -- Activate this tab
        local function activate()
            -- Deactivate previous
            if self._activeTab and self._activeTab ~= Tab then
                local prev = self._activeTab
                tween(prev._btn, {BackgroundColor3 = Theme.Surface}, 0.2)
                tween(prev._label, {TextColor3 = Theme.TextMuted}, 0.2)
                tween(prev._indicator, {BackgroundTransparency = 1}, 0.2)
                prev._scroll.Visible = false
            end
            self._activeTab = Tab
            tween(tabBtn, {BackgroundColor3 = Theme.SurfaceAlt}, 0.2)
            tween(tabLabel, {TextColor3 = Theme.Text}, 0.2)
            tween(indicator, {BackgroundTransparency = 0}, 0.2)
            scrollFrame.Visible = true
        end

        tabBtn.MouseButton1Click:Connect(activate)
        addHover(tabBtn, Theme.Surface, Theme.SurfaceAlt)

        table.insert(self._tabs, Tab)

        if #self._tabs == 1 then
            activate()
        end

        -- Section
        function Tab:AddSection(sectionConfig)
            sectionConfig = sectionConfig or {}
            local sectionName = sectionConfig.Name or "Section"

            local sectionFrame = make("Frame", {
                Name = "Section_" .. sectionName,
                Size = UDim2.new(1, 0, 0, 28),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ZIndex = 4,
                LayoutOrder = self._order,
                AutomaticSize = Enum.AutomaticSize.Y,
            }, scrollFrame)
            self._order = self._order + 1

            local sectionLabel = make("TextLabel", {
                Size = UDim2.new(1, -8, 0, 18),
                Position = UDim2.new(0, 0, 0, 4),
                BackgroundTransparency = 1,
                Text = string.upper(sectionName),
                TextColor3 = Theme.Accent,
                TextSize = 10,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                LetterSpacing = 2,
                ZIndex = 5,
            }, sectionFrame)

            local divLine = make("Frame", {
                Size = UDim2.new(1, 0, 0, 1),
                Position = UDim2.new(0, 0, 0, 24),
                BackgroundColor3 = Theme.Divider,
                BorderSizePixel = 0,
                ZIndex = 4,
            }, sectionFrame)

            return sectionFrame
        end

        -- Button
        function Tab:AddButton(btnConfig)
            btnConfig = btnConfig or {}
            local label   = btnConfig.Name or "Button"
            local desc    = btnConfig.Description or ""
            local callback = btnConfig.Callback or function() end

            local frame = make("Frame", {
                Name = "Button_" .. label,
                Size = UDim2.new(1, 0, 0, 44),
                BackgroundColor3 = Theme.ButtonBase,
                BorderSizePixel = 0,
                ZIndex = 4,
                LayoutOrder = self._order,
            }, scrollFrame)
            self._order = self._order + 1
            corner(frame, 7)
            stroke(frame, Theme.Border, 1)

            local btn = make("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                ZIndex = 5,
            }, frame)

            make("TextLabel", {
                Size = UDim2.new(1, -16, 0, 20),
                Position = UDim2.new(0, 14, 0, 6),
                BackgroundTransparency = 1,
                Text = label,
                TextColor3 = Theme.Text,
                TextSize = 13,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 6,
            }, frame)

            if desc ~= "" then
                make("TextLabel", {
                    Size = UDim2.new(1, -16, 0, 14),
                    Position = UDim2.new(0, 14, 0, 26),
                    BackgroundTransparency = 1,
                    Text = desc,
                    TextColor3 = Theme.TextMuted,
                    TextSize = 11,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 6,
                }, frame)
            end

            addHover(frame, Theme.ButtonBase, Theme.ButtonHover)

            btn.MouseButton1Down:Connect(function()
                tween(frame, {BackgroundColor3 = Theme.ButtonPress}, 0.08)
            end)
            btn.MouseButton1Up:Connect(function()
                tween(frame, {BackgroundColor3 = Theme.ButtonHover}, 0.15)
                task.spawn(callback)
            end)

            return frame
        end

        -- Toggle
        function Tab:AddToggle(toggleConfig)
            toggleConfig = toggleConfig or {}
            local label    = toggleConfig.Name or "Toggle"
            local desc     = toggleConfig.Description or ""
            local default  = toggleConfig.Default or false
            local callback = toggleConfig.Callback or function() end

            local state = default

            local frame = make("Frame", {
                Name = "Toggle_" .. label,
                Size = UDim2.new(1, 0, 0, 44),
                BackgroundColor3 = Theme.Surface,
                BorderSizePixel = 0,
                ZIndex = 4,
                LayoutOrder = self._order,
            }, scrollFrame)
            self._order = self._order + 1
            corner(frame, 7)
            stroke(frame, Theme.Border, 1)

            make("TextLabel", {
                Size = UDim2.new(1, -70, 0, 20),
                Position = UDim2.new(0, 14, 0, 6),
                BackgroundTransparency = 1,
                Text = label,
                TextColor3 = Theme.Text,
                TextSize = 13,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 5,
            }, frame)

            if desc ~= "" then
                make("TextLabel", {
                    Size = UDim2.new(1, -70, 0, 14),
                    Position = UDim2.new(0, 14, 0, 26),
                    BackgroundTransparency = 1,
                    Text = desc,
                    TextColor3 = Theme.TextMuted,
                    TextSize = 11,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 5,
                }, frame)
            end

            -- Toggle track
            local track = make("Frame", {
                Size = UDim2.new(0, 42, 0, 22),
                Position = UDim2.new(1, -56, 0.5, -11),
                BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff,
                BorderSizePixel = 0,
                ZIndex = 5,
            }, frame)
            corner(track, 11)

            -- Toggle knob
            local knob = make("Frame", {
                Size = UDim2.new(0, 16, 0, 16),
                Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0,
                ZIndex = 6,
            }, track)
            corner(knob, 8)

            local btn = make("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                ZIndex = 7,
            }, frame)

            addHover(frame, Theme.Surface, Theme.SurfaceAlt)

            local function updateToggle(newState)
                state = newState
                tween(track, {BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff}, 0.2)
                tween(knob, {
                    Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
                }, 0.2, Enum.EasingStyle.Quart)
                task.spawn(callback, state)
            end

            btn.MouseButton1Click:Connect(function()
                updateToggle(not state)
            end)

            local Toggle = {}
            function Toggle:Set(val)
                updateToggle(val)
            end
            function Toggle:Get()
                return state
            end

            return Toggle
        end

        -- Slider
        function Tab:AddSlider(sliderConfig)
            sliderConfig = sliderConfig or {}
            local label    = sliderConfig.Name or "Slider"
            local desc     = sliderConfig.Description or ""
            local min      = sliderConfig.Min or 0
            local max      = sliderConfig.Max or 100
            local default  = sliderConfig.Default or min
            local suffix   = sliderConfig.Suffix or ""
            local callback = sliderConfig.Callback or function() end

            local value = math.clamp(default, min, max)

            local frame = make("Frame", {
                Name = "Slider_" .. label,
                Size = UDim2.new(1, 0, 0, 56),
                BackgroundColor3 = Theme.Surface,
                BorderSizePixel = 0,
                ZIndex = 4,
                LayoutOrder = self._order,
            }, scrollFrame)
            self._order = self._order + 1
            corner(frame, 7)
            stroke(frame, Theme.Border, 1)

            local topRow = make("Frame", {
                Size = UDim2.new(1, 0, 0, 28),
                BackgroundTransparency = 1,
                ZIndex = 5,
            }, frame)

            make("TextLabel", {
                Size = UDim2.new(1, -80, 1, 0),
                Position = UDim2.new(0, 14, 0, 0),
                BackgroundTransparency = 1,
                Text = label,
                TextColor3 = Theme.Text,
                TextSize = 13,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 6,
            }, topRow)

            local valueLabel = make("TextLabel", {
                Size = UDim2.new(0, 70, 1, 0),
                Position = UDim2.new(1, -80, 0, 0),
                BackgroundTransparency = 1,
                Text = tostring(value) .. suffix,
                TextColor3 = Theme.Accent,
                TextSize = 13,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Right,
                ZIndex = 6,
            }, topRow)

            -- Track
            local track = make("Frame", {
                Size = UDim2.new(1, -28, 0, 6),
                Position = UDim2.new(0, 14, 0, 38),
                BackgroundColor3 = Theme.SliderTrack,
                BorderSizePixel = 0,
                ZIndex = 5,
                ClipsDescendants = true,
            }, frame)
            corner(track, 3)

            -- Fill
            local fill = make("Frame", {
                Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
                BackgroundColor3 = Theme.SliderFill,
                BorderSizePixel = 0,
                ZIndex = 6,
            }, track)
            corner(fill, 3)

            -- Knob
            local knob = make("Frame", {
                Size = UDim2.new(0, 14, 0, 14),
                Position = UDim2.new((value - min) / (max - min), -7, 0.5, -7),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0,
                ZIndex = 7,
            }, track)
            corner(knob, 7)
            make("UIStroke", {Color = Theme.Accent, Thickness = 2}, knob)

            local dragging = false

            local function updateSlider(inputX)
                local trackPos = track.AbsolutePosition.X
                local trackSize = track.AbsoluteSize.X
                local rel = math.clamp((inputX - trackPos) / trackSize, 0, 1)
                local newVal = math.floor(min + rel * (max - min) + 0.5)
                value = newVal
                local pct = (value - min) / (max - min)
                tween(fill, {Size = UDim2.new(pct, 0, 1, 0)}, 0.08)
                tween(knob, {Position = UDim2.new(pct, -7, 0.5, -7)}, 0.08)
                valueLabel.Text = tostring(value) .. suffix
                task.spawn(callback, value)
            end

            local sliderBtn = make("TextButton", {
                Size = UDim2.new(1, 0, 0, 24),
                Position = UDim2.new(0, 0, 0, 28),
                BackgroundTransparency = 1,
                Text = "",
                ZIndex = 8,
            }, frame)

            sliderBtn.MouseButton1Down:Connect(function()
                dragging = true
                updateSlider(Mouse.X)
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(Mouse.X)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            addHover(frame, Theme.Surface, Theme.SurfaceAlt)

            local Slider = {}
            function Slider:Set(val)
                value = math.clamp(val, min, max)
                local pct = (value - min) / (max - min)
                tween(fill, {Size = UDim2.new(pct, 0, 1, 0)}, 0.15)
                tween(knob, {Position = UDim2.new(pct, -7, 0.5, -7)}, 0.15)
                valueLabel.Text = tostring(value) .. suffix
            end
            function Slider:Get()
                return value
            end

            return Slider
        end

        -- Label
        function Tab:AddLabel(labelConfig)
            labelConfig = labelConfig or {}
            local text = labelConfig.Text or ""

            local frame = make("Frame", {
                Name = "Label",
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ZIndex = 4,
                LayoutOrder = self._order,
            }, scrollFrame)
            self._order = self._order + 1

            local lbl = make("TextLabel", {
                Size = UDim2.new(1, -14, 1, 0),
                Position = UDim2.new(0, 14, 0, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Theme.TextMuted,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 5,
            }, frame)

            local Label = {}
            function Label:Set(t)
                lbl.Text = t
            end
            return Label
        end

        return Tab
    end

    -- Notify
    function Window:Notify(notifConfig)
        notifConfig = notifConfig or {}
        local title   = notifConfig.Title or "Notice"
        local message = notifConfig.Message or ""
        local duration = notifConfig.Duration or 3

        local notifHolder = gui:FindFirstChild("NotifHolder")
        if not notifHolder then
            notifHolder = make("Frame", {
                Name = "NotifHolder",
                Size = UDim2.new(0, 280, 1, 0),
                Position = UDim2.new(1, -296, 0, 0),
                BackgroundTransparency = 1,
                ZIndex = 100,
            }, gui)
            make("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Bottom,
                Padding = UDim.new(0, 8),
            }, notifHolder)
            make("UIPadding", {PaddingBottom = UDim.new(0, 16)}, notifHolder)
        end

        local card = make("Frame", {
            Name = "Notif",
            Size = UDim2.new(1, 0, 0, 0),
            BackgroundColor3 = Theme.Surface,
            BorderSizePixel = 0,
            ZIndex = 101,
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
        }, notifHolder)
        corner(card, 8)
        stroke(card, Theme.Border, 1)

        make("Frame", {
            Size = UDim2.new(0, 3, 1, 0),
            BackgroundColor3 = Theme.Accent,
            BorderSizePixel = 0,
            ZIndex = 102,
        }, card)

        local inner = make("Frame", {
            Size = UDim2.new(1, -12, 0, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            AutomaticSize = Enum.AutomaticSize.Y,
            ZIndex = 102,
        }, card)

        make("UIPadding", {
            PaddingTop = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10),
        }, inner)

        make("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 3),
        }, inner)

        make("TextLabel", {
            Size = UDim2.new(1, 0, 0, 16),
            BackgroundTransparency = 1,
            Text = title,
            TextColor3 = Theme.Text,
            TextSize = 13,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 103,
            LayoutOrder = 1,
        }, inner)

        make("TextLabel", {
            Size = UDim2.new(1, 0, 0, 14),
            BackgroundTransparency = 1,
            Text = message,
            TextColor3 = Theme.TextMuted,
            TextSize = 11,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 103,
            LayoutOrder = 2,
            TextWrapped = true,
        }, inner)

        tween(card, {BackgroundTransparency = 0}, 0.2)

        task.delay(duration, function()
            tween(card, {BackgroundTransparency = 1}, 0.3)
            task.delay(0.35, function()
                card:Destroy()
            end)
        end)
    end

    return Window
end

return Library
