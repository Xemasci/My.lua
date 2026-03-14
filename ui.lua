local ToruhubLib = {}
ToruhubLib.__index = ToruhubLib

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- ============================================
-- THEME
-- ============================================
local Theme = {
    Background     = Color3.fromRGB(18, 18, 28),
    Sidebar        = Color3.fromRGB(14, 14, 22),
    TitleBar       = Color3.fromRGB(12, 12, 20),
    ItemBg         = Color3.fromRGB(25, 27, 42),
    Accent         = Color3.fromRGB(0, 220, 255),
    AccentDim      = Color3.fromRGB(0, 180, 220),
    ToggleOn       = Color3.fromRGB(0, 210, 120),
    ToggleOff      = Color3.fromRGB(50, 55, 75),
    TextMain       = Color3.fromRGB(210, 215, 235),
    TextSub        = Color3.fromRGB(120, 130, 160),
    TextMuted      = Color3.fromRGB(100, 110, 140),
    TabActive      = Color3.fromRGB(255, 255, 255),
    TabInactive    = Color3.fromRGB(160, 170, 200),
    TabBgActive    = Color3.fromRGB(0, 180, 220),
    TabBgInactive  = Color3.fromRGB(22, 22, 34),
    Border         = Color3.fromRGB(0, 220, 255),
    StatusBg       = Color3.fromRGB(20, 22, 35),
    ButtonBg       = Color3.fromRGB(0, 200, 255),
    ButtonText     = Color3.fromRGB(10, 10, 20),
    SectionText    = Color3.fromRGB(100, 110, 140),
}

-- ============================================
-- INTERNAL HELPERS
-- ============================================
local function applyCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 6)
    c.Parent = parent
    return c
end

local function applyStroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or Theme.Border
    s.Thickness = thickness or 1.5
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

local function tween(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.15), props):Play()
end

-- ============================================
-- CREATE WINDOW
-- ============================================
function ToruhubLib:CreateWindow(config)
    config = config or {}
    local title   = config.Title   or "ToruhubLib"
    local version = config.Version or "v1.0"
    local size    = config.Size    or UDim2.new(0, 340, 0, 280)
    local pos     = config.Position or UDim2.new(0.5, -170, 0.5, -140)

    -- Destroy old GUI if exists
    pcall(function()
        game.CoreGui:FindFirstChild("ToruhubLib"):Destroy()
    end)

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ToruhubLib"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game.CoreGui

    -- Main Frame
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = size
    Main.Position = pos
    Main.BackgroundColor3 = Theme.Background
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui
    applyCorner(Main, 10)
    applyStroke(Main, Theme.Border, 1.5)
    makeDraggable(Main)

    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 36)
    TitleBar.BackgroundColor3 = Theme.TitleBar
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = Main
    applyCorner(TitleBar, 10)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = title
    TitleLabel.Size = UDim2.new(0.6, 0, 0, 20)
    TitleLabel.Position = UDim2.new(0, 12, 0, 4)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextColor3 = Theme.Accent
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar

    local VerLabel = Instance.new("TextLabel")
    VerLabel.Text = version
    VerLabel.Size = UDim2.new(0.6, 0, 0, 12)
    VerLabel.Position = UDim2.new(0, 12, 0, 22)
    VerLabel.BackgroundTransparency = 1
    VerLabel.TextColor3 = Theme.TextSub
    VerLabel.Font = Enum.Font.Gotham
    VerLabel.TextSize = 10
    VerLabel.TextXAlignment = Enum.TextXAlignment.Left
    VerLabel.Parent = TitleBar

    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 24, 0, 24)
    CloseBtn.Position = UDim2.new(1, -30, 0.5, -12)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 11
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Parent = TitleBar
    applyCorner(CloseBtn, 5)
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    -- Minimize Button
    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 24, 0, 24)
    MinBtn.Position = UDim2.new(1, -58, 0.5, -12)
    MinBtn.BackgroundColor3 = Color3.fromRGB(200, 160, 0)
    MinBtn.Text = "—"
    MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextSize = 11
    MinBtn.BorderSizePixel = 0
    MinBtn.Parent = TitleBar
    applyCorner(MinBtn, 5)

    local minimized = false
    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        tween(Main, {Size = minimized and UDim2.new(0, 340, 0, 36) or size}, 0.2)
    end)

    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 82, 1, -36)
    Sidebar.Position = UDim2.new(0, 0, 0, 36)
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = Main

    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarLayout.Padding = UDim.new(0, 4)
    SidebarLayout.Parent = Sidebar

    local SidebarPad = Instance.new("UIPadding")
    SidebarPad.PaddingTop = UDim.new(0, 8)
    SidebarPad.PaddingLeft = UDim.new(0, 4)
    SidebarPad.PaddingRight = UDim.new(0, 4)
    SidebarPad.Parent = Sidebar

    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -90, 1, -44)
    ContentContainer.Position = UDim2.new(0, 88, 0, 40)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.ClipsDescendants = true
    ContentContainer.Parent = Main

    -- Status Bar
    local StatusFrame = Instance.new("Frame")
    StatusFrame.Name = "StatusBar"
    StatusFrame.Size = UDim2.new(1, -90, 0, 22)
    StatusFrame.Position = UDim2.new(0, 88, 1, -28)
    StatusFrame.BackgroundColor3 = Theme.StatusBg
    StatusFrame.BorderSizePixel = 0
    StatusFrame.Parent = Main
    applyCorner(StatusFrame, 5)

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Name = "StatusLabel"
    StatusLabel.Text = "STATUS: IDLE"
    StatusLabel.Size = UDim2.new(1, 0, 1, 0)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.TextColor3 = Theme.AccentDim
    StatusLabel.Font = Enum.Font.GothamBold
    StatusLabel.TextSize = 11
    StatusLabel.Parent = StatusFrame

    -- Window Object
    local Window = {}
    Window._tabs = {}
    Window._tabButtons = {}
    Window._activeTab = nil
    Window._sidebar = Sidebar
    Window._container = ContentContainer
    Window._statusLabel = StatusLabel
    Window._tabCount = 0

    -- ==========================================
    -- SET STATUS
    -- ==========================================
    function Window:SetStatus(text, color)
        StatusLabel.Text = "STATUS: " .. (text or "IDLE")
        StatusLabel.TextColor3 = color or Theme.AccentDim
    end

    -- ==========================================
    -- CREATE TAB
    -- ==========================================
    function Window:CreateTab(tabName)
        self._tabCount = self._tabCount + 1
        local order = self._tabCount

        -- Tab Button
        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = tabName
        TabBtn.Size = UDim2.new(1, 0, 0, 34)
        TabBtn.BackgroundColor3 = Theme.TabBgInactive
        TabBtn.BorderSizePixel = 0
        TabBtn.Text = tabName
        TabBtn.TextColor3 = Theme.TabInactive
        TabBtn.Font = Enum.Font.GothamSemibold
        TabBtn.TextSize = 13
        TabBtn.LayoutOrder = order
        TabBtn.Parent = Sidebar
        applyCorner(TabBtn, 6)

        -- Tab Content Frame
        local TabFrame = Instance.new("ScrollingFrame")
        TabFrame.Name = tabName .. "_Content"
        TabFrame.Size = UDim2.new(1, 0, 1, -30)
        TabFrame.Position = UDim2.new(0, 0, 0, 0)
        TabFrame.BackgroundTransparency = 1
        TabFrame.BorderSizePixel = 0
        TabFrame.ScrollBarThickness = 2
        TabFrame.ScrollBarImageColor3 = Theme.Accent
        TabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabFrame.Visible = false
        TabFrame.Parent = ContentContainer

        local TabLayout = Instance.new("UIListLayout")
        TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabLayout.Padding = UDim.new(0, 6)
        TabLayout.Parent = TabFrame

        local TabPad = Instance.new("UIPadding")
        TabPad.PaddingTop = UDim.new(0, 4)
        TabPad.PaddingBottom = UDim.new(0, 4)
        TabPad.Parent = TabFrame

        self._tabs[tabName] = TabFrame
        self._tabButtons[tabName] = TabBtn

        -- Activate first tab by default
        if self._tabCount == 1 then
            self._activeTab = tabName
            TabFrame.Visible = true
            TabBtn.BackgroundColor3 = Theme.TabBgActive
            TabBtn.TextColor3 = Theme.TabActive
        end

        local win = self
        TabBtn.MouseButton1Click:Connect(function()
            if win._activeTab == tabName then return end
            -- Hide old
            if win._tabs[win._activeTab] then
                win._tabs[win._activeTab].Visible = false
            end
            if win._tabButtons[win._activeTab] then
                tween(win._tabButtons[win._activeTab], {BackgroundColor3 = Theme.TabBgInactive})
                win._tabButtons[win._activeTab].TextColor3 = Theme.TabInactive
            end
            -- Show new
            win._activeTab = tabName
            TabFrame.Visible = true
            tween(TabBtn, {BackgroundColor3 = Theme.TabBgActive})
            TabBtn.TextColor3 = Theme.TabActive
        end)

        -- Tab API
        local Tab = {}
        Tab._frame = TabFrame
        Tab._itemCount = 0

        local function nextOrder()
            Tab._itemCount = Tab._itemCount + 1
            return Tab._itemCount
        end

        -- ======================================
        -- SECTION LABEL
        -- ======================================
        function Tab:AddSection(text)
            local lbl = Instance.new("TextLabel")
            lbl.Text = string.upper(text)
            lbl.Size = UDim2.new(1, 0, 0, 18)
            lbl.BackgroundTransparency = 1
            lbl.TextColor3 = Theme.SectionText
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 10
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.LayoutOrder = nextOrder()
            lbl.Parent = TabFrame
        end

        -- ======================================
        -- TOGGLE
        -- ======================================
        function Tab:AddToggle(config)
            config = config or {}
            local label   = config.Name    or "Toggle"
            local default = config.Default or false
            local callback = config.Callback or function() end

            local state = default

            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, 30)
            row.BackgroundTransparency = 1
            row.LayoutOrder = nextOrder()
            row.Parent = TabFrame

            local lbl = Instance.new("TextLabel")
            lbl.Text = label
            lbl.Size = UDim2.new(1, -50, 1, 0)
            lbl.BackgroundTransparency = 1
            lbl.TextColor3 = Theme.TextMain
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 13
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = row

            local bg = Instance.new("Frame")
            bg.Size = UDim2.new(0, 38, 0, 20)
            bg.Position = UDim2.new(1, -40, 0.5, -10)
            bg.BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff
            bg.BorderSizePixel = 0
            bg.Parent = row
            applyCorner(bg, 20)

            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 14, 0, 14)
            knob.Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
            knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            knob.BorderSizePixel = 0
            knob.Parent = bg
            applyCorner(knob, 20)

            local clickBtn = Instance.new("TextButton")
            clickBtn.Size = UDim2.new(1, 0, 1, 0)
            clickBtn.BackgroundTransparency = 1
            clickBtn.Text = ""
            clickBtn.Parent = row

            local Toggle = {}

            function Toggle:Set(val)
                state = val
                tween(bg, {BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff})
                tween(knob, {Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)})
                callback(state)
            end

            function Toggle:Get() return state end

            clickBtn.MouseButton1Click:Connect(function()
                Toggle:Set(not state)
            end)

            return Toggle
        end

        -- ======================================
        -- BUTTON
        -- ======================================
        function Tab:AddButton(config)
            config = config or {}
            local label    = config.Name     or "Button"
            local callback = config.Callback or function() end

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.BackgroundColor3 = Theme.AccentDim
            btn.BorderSizePixel = 0
            btn.Text = label
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.GothamSemibold
            btn.TextSize = 13
            btn.LayoutOrder = nextOrder()
            btn.Parent = TabFrame
            applyCorner(btn, 6)

            btn.MouseButton1Click:Connect(function()
                tween(btn, {BackgroundColor3 = Theme.Accent})
                callback()
                task.delay(0.15, function()
                    tween(btn, {BackgroundColor3 = Theme.AccentDim})
                end)
            end)
        end

        -- ======================================
        -- TEXTBOX (INPUT + ADD)
        -- ======================================
        function Tab:AddInput(config)
            config = config or {}
            local label       = config.Name        or "Input"
            local placeholder = config.Placeholder or ""
            local btnText     = config.ButtonText  or "ADD"
            local callback    = config.Callback    or function() end

            local wrapper = Instance.new("Frame")
            wrapper.Size = UDim2.new(1, 0, 0, 50)
            wrapper.BackgroundTransparency = 1
            wrapper.LayoutOrder = nextOrder()
            wrapper.Parent = TabFrame

            local lbl = Instance.new("TextLabel")
            lbl.Text = string.upper(label)
            lbl.Size = UDim2.new(1, 0, 0, 16)
            lbl.BackgroundTransparency = 1
            lbl.TextColor3 = Theme.SectionText
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 10
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = wrapper

            local box = Instance.new("TextBox")
            box.Size = UDim2.new(1, -50, 0, 26)
            box.Position = UDim2.new(0, 0, 0, 20)
            box.BackgroundColor3 = Theme.ItemBg
            box.BorderSizePixel = 0
            box.TextColor3 = Theme.TextMain
            box.PlaceholderText = placeholder
            box.PlaceholderColor3 = Theme.TextSub
            box.Font = Enum.Font.Gotham
            box.TextSize = 12
            box.ClearTextOnFocus = false
            box.Parent = wrapper
            applyCorner(box, 5)
            applyStroke(box, Color3.fromRGB(50, 55, 80), 1)

            local addBtn = Instance.new("TextButton")
            addBtn.Size = UDim2.new(0, 44, 0, 26)
            addBtn.Position = UDim2.new(1, -44, 0, 20)
            addBtn.BackgroundColor3 = Theme.ButtonBg
            addBtn.BorderSizePixel = 0
            addBtn.Text = btnText
            addBtn.TextColor3 = Theme.ButtonText
            addBtn.Font = Enum.Font.GothamBold
            addBtn.TextSize = 12
            addBtn.Parent = wrapper
            applyCorner(addBtn, 5)

            addBtn.MouseButton1Click:Connect(function()
                callback(box.Text)
                box.Text = ""
            end)

            local Input = {}
            function Input:GetText() return box.Text end
            function Input:SetText(t) box.Text = t end
            return Input
        end

        -- ======================================
        -- SLIDER
        -- ======================================
        function Tab:AddSlider(config)
            config = config or {}
            local label    = config.Name     or "Slider"
            local min      = config.Min      or 0
            local max      = config.Max      or 100
            local default  = config.Default  or min
            local callback = config.Callback or function() end

            local value = math.clamp(default, min, max)

            local wrapper = Instance.new("Frame")
            wrapper.Size = UDim2.new(1, 0, 0, 42)
            wrapper.BackgroundTransparency = 1
            wrapper.LayoutOrder = nextOrder()
            wrapper.Parent = TabFrame

            local topRow = Instance.new("Frame")
            topRow.Size = UDim2.new(1, 0, 0, 16)
            topRow.BackgroundTransparency = 1
            topRow.Parent = wrapper

            local nameLbl = Instance.new("TextLabel")
            nameLbl.Text = label
            nameLbl.Size = UDim2.new(0.7, 0, 1, 0)
            nameLbl.BackgroundTransparency = 1
            nameLbl.TextColor3 = Theme.TextMain
            nameLbl.Font = Enum.Font.Gotham
            nameLbl.TextSize = 13
            nameLbl.TextXAlignment = Enum.TextXAlignment.Left
            nameLbl.Parent = topRow

            local valLbl = Instance.new("TextLabel")
            valLbl.Text = tostring(value)
            valLbl.Size = UDim2.new(0.3, 0, 1, 0)
            valLbl.Position = UDim2.new(0.7, 0, 0, 0)
            valLbl.BackgroundTransparency = 1
            valLbl.TextColor3 = Theme.Accent
            valLbl.Font = Enum.Font.GothamBold
            valLbl.TextSize = 13
            valLbl.TextXAlignment = Enum.TextXAlignment.Right
            valLbl.Parent = topRow

            local track = Instance.new("Frame")
            track.Size = UDim2.new(1, 0, 0, 6)
            track.Position = UDim2.new(0, 0, 0, 26)
            track.BackgroundColor3 = Theme.ToggleOff
            track.BorderSizePixel = 0
            track.Parent = wrapper
            applyCorner(track, 4)

            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            fill.BackgroundColor3 = Theme.Accent
            fill.BorderSizePixel = 0
            fill.Parent = track
            applyCorner(fill, 4)

            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 12, 0, 12)
            knob.Position = UDim2.new((value - min) / (max - min), -6, 0.5, -6)
            knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            knob.BorderSizePixel = 0
            knob.Parent = track
            applyCorner(knob, 8)

            local sliding = false
            local clickArea = Instance.new("TextButton")
            clickArea.Size = UDim2.new(1, 0, 0, 16)
            clickArea.Position = UDim2.new(0, 0, 0, 20)
            clickArea.BackgroundTransparency = 1
            clickArea.Text = ""
            clickArea.Parent = wrapper

            local function updateSlider(inputPos)
                local abs = track.AbsolutePosition
                local sizeX = track.AbsoluteSize.X
                local relX = math.clamp((inputPos.X - abs.X) / sizeX, 0, 1)
                value = math.floor(min + relX * (max - min))
                valLbl.Text = tostring(value)
                tween(fill, {Size = UDim2.new(relX, 0, 1, 0)})
                tween(knob, {Position = UDim2.new(relX, -6, 0.5, -6)})
                callback(value)
            end

            clickArea.MouseButton1Down:Connect(function(x, y)
                sliding = true
                updateSlider(Vector2.new(x, y))
            end)
            UserInputService.InputChanged:Connect(function(input)
                if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input.Position)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = false
                end
            end)

            local Slider = {}
            function Slider:Set(v)
                value = math.clamp(v, min, max)
                local rel = (value - min) / (max - min)
                valLbl.Text = tostring(value)
                tween(fill, {Size = UDim2.new(rel, 0, 1, 0)})
                tween(knob, {Position = UDim2.new(rel, -6, 0.5, -6)})
                callback(value)
            end
            function Slider:Get() return value end
            return Slider
        end

        -- ======================================
        -- LABEL
        -- ======================================
        function Tab:AddLabel(text)
            local lbl = Instance.new("TextLabel")
            lbl.Text = text or ""
            lbl.Size = UDim2.new(1, 0, 0, 20)
            lbl.BackgroundTransparency = 1
            lbl.TextColor3 = Theme.TextSub
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextWrapped = true
            lbl.LayoutOrder = nextOrder()
            lbl.Parent = TabFrame
        end

        return Tab
    end

    return Window
end

return ToruhubLib        function Tab:AddLabel(text)
            local lbl = Instance.new("TextLabel")
            lbl.Text = text or ""
            lbl.Size = UDim2.new(1, 0, 0, 20)
            lbl.BackgroundTransparency = 1
            lbl.TextColor3 = Theme.TextSub
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextWrapped = true
            lbl.LayoutOrder = nextOrder()
            lbl.Parent = TabFrame
        end

        return Tab
    end

    return Window
end

return ToruhubLib
