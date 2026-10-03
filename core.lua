-- 🐗 Bizon Hub Core v3.2 (Compact)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local player = Players.LocalPlayer
_G.BizonHub = _G.BizonHub or {}
local Hub = _G.BizonHub
Hub.Connections = Hub.Connections or {}
Hub.IsPanicked = false

function Hub.addConnection(conn)
    table.insert(Hub.Connections, conn)
    return conn
end

Hub.Theme = {
    Bg = Color3.fromRGB(15, 12, 25),
    Bg3 = Color3.fromRGB(28, 22, 45),
    Accent = Color3.fromRGB(168, 85, 247),
    AccentGlow = Color3.fromRGB(200, 130, 255),
    Text = Color3.fromRGB(240, 235, 255),
    TextDim = Color3.fromRGB(140, 130, 165),
    Success = Color3.fromRGB(80, 240, 160),
    Danger = Color3.fromRGB(240, 70, 100),
    Warning = Color3.fromRGB(255, 200, 50),
    Stroke = Color3.fromRGB(60, 50, 90),
}

Hub.Settings = {
    SpeedEnabled=false, SpeedValue=50, SmoothSpeed=false,
    UseKeybind=false, SpeedKey=Enum.KeyCode.LeftShift,
    SpeedInAir=false, AutoRun=false,
    JumpEnabled=false, JumpValue=100, InfiniteJump=false,
    FlyEnabled=false, FlySpeed=50,
    Noclip=false, Fullbright=false,
    AutoFarmEnabled=false, FarmTargetName="Hitbox",
    FarmRange=20, FarmHitCooldown=0.1, FarmUseTool=true,
}

local T = Hub.Theme
local S = Hub.Settings

-- Удаляем старые GUI
local old = player.PlayerGui:FindFirstChild("BizonHub")
if old then old:Destroy() end
local oldWM = player.PlayerGui:FindFirstChild("BizonWatermark")
if oldWM then oldWM:Destroy() end

-- ROOT
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BizonHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = player:WaitForChild("PlayerGui")
Hub.ScreenGui = ScreenGui

-- FLOAT BUTTON
local FloatBtn = Instance.new("TextButton")
FloatBtn.Size = UDim2.new(0, 56, 0, 56)
FloatBtn.Position = UDim2.new(0, 20, 0.5, -28)
FloatBtn.BackgroundColor3 = T.Bg
FloatBtn.BackgroundTransparency = 0.1
FloatBtn.Text = "🐗"
FloatBtn.TextColor3 = T.Accent
FloatBtn.Font = Enum.Font.GothamBold
FloatBtn.TextSize = 28
FloatBtn.BorderSizePixel = 0
FloatBtn.AutoButtonColor = false
FloatBtn.Parent = ScreenGui
Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(1, 0)
local FBstroke = Instance.new("UIStroke", FloatBtn)
FBstroke.Color = T.Accent
FBstroke.Thickness = 1.5

Hub.FloatBtn = FloatBtn

-- MAIN FRAME
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 720, 0, 500)
MainFrame.Position = UDim2.new(0.5, -360, 0.5, -250)
MainFrame.BackgroundColor3 = T.Bg
MainFrame.BackgroundTransparency = 0.08
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 22)
local MFstroke = Instance.new("UIStroke", MainFrame)
MFstroke.Color = T.Stroke
MFstroke.Thickness = 1.5
Hub.MainFrame = MainFrame

-- HEADER
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 70)
Header.BackgroundTransparency = 1
Header.Parent = MainFrame

local LogoIcon = Instance.new("TextLabel")
LogoIcon.Size = UDim2.new(0, 32, 0, 40)
LogoIcon.Position = UDim2.new(0, 26, 0, 18)
LogoIcon.BackgroundTransparency = 1
LogoIcon.Text = "🐗"
LogoIcon.TextColor3 = T.Accent
LogoIcon.Font = Enum.Font.GothamBold
LogoIcon.TextSize = 24
LogoIcon.Parent = Header

local LogoText = Instance.new("TextLabel")
LogoText.Size = UDim2.new(0, 200, 0, 40)
LogoText.Position = UDim2.new(0, 60, 0, 18)
LogoText.BackgroundTransparency = 1
LogoText.Text = "Bizon Hub"
LogoText.TextColor3 = T.Text
LogoText.Font = Enum.Font.GothamBlack
LogoText.TextSize = 20
LogoText.TextXAlignment = Enum.TextXAlignment.Left
LogoText.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -46, 0, 20)
CloseBtn.BackgroundColor3 = T.Bg3
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = T.TextDim
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.BorderSizePixel = 0
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = Header
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)
CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

-- Drag window
local winDrag, winStart, winStartPos
Hub.addConnection(Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        winDrag = true; winStart = input.Position; winStartPos = MainFrame.Position
    end
end))
Hub.addConnection(UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then winDrag = false end
end))
Hub.addConnection(UserInputService.InputChanged:Connect(function(input)
    if winDrag and input.UserInputType == Enum.UserInputType.MouseMovement then
        local d = input.Position - winStart
        MainFrame.Position = UDim2.new(winStartPos.X.Scale, winStartPos.X.Offset + d.X, winStartPos.Y.Scale, winStartPos.Y.Offset + d.Y)
    end
end))

-- TAB BAR
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -52, 0, 40)
TabBar.Position = UDim2.new(0, 26, 0, 82)
TabBar.BackgroundTransparency = 1
TabBar.Parent = MainFrame

local TabList = Instance.new("UIListLayout", TabBar)
TabList.FillDirection = Enum.FillDirection.Horizontal
TabList.Padding = UDim.new(0, 4)
TabList.SortOrder = Enum.SortOrder.LayoutOrder

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -52, 1, -180)
Content.Position = UDim2.new(0, 26, 0, 130)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

local Tabs = {}
Hub.Tabs = Tabs
Hub.CurrentTab = nil

function Hub.switchTab(name)
    if Hub.CurrentTab == name then return end
    if Hub.CurrentTab and Tabs[Hub.CurrentTab] then
        Tabs[Hub.CurrentTab].container.Visible = false
        TweenService:Create(Tabs[Hub.CurrentTab].button, TweenInfo.new(0.2), {TextColor3 = T.TextDim, BackgroundTransparency = 1}):Play()
    end
    Hub.CurrentTab = name
    Tabs[name].container.Visible = true
    TweenService:Create(Tabs[name].button, TweenInfo.new(0.2), {TextColor3 = T.Accent, BackgroundTransparency = 0}):Play()
end

function Hub.createTab(name, icon)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0, 110, 1, 0)
    tabBtn.BackgroundColor3 = T.Bg3
    tabBtn.BackgroundTransparency = 1
    tabBtn.Text = (icon or "") .. "  " .. name
    tabBtn.TextColor3 = T.TextDim
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextSize = 12
    tabBtn.BorderSizePixel = 0
    tabBtn.AutoButtonColor = false
    tabBtn.Parent = TabBar
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 8)

    local container = Instance.new("ScrollingFrame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.ScrollBarThickness = 3
    container.ScrollBarImageColor3 = T.Accent
    container.CanvasSize = UDim2.new(0, 0, 0, 0)
    container.Visible = false
    container.Parent = Content

    local layout = Instance.new("UIGridLayout", container)
    layout.CellSize = UDim2.new(0.5, -4, 0, 56)
    layout.CellPadding = UDim2.new(0, 8, 0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
    end)

    Tabs[name] = {button = tabBtn, container = container}
    tabBtn.MouseButton1Click:Connect(function() Hub.switchTab(name) end)
    return container
end

-- === UI HELPERS (в том же файле, после объявления) ===
function Hub.createToggle(parent, name, default, callback)
    local state = default or false
    local container = Instance.new("Frame")
    container.BackgroundColor3 = T.Bg3
    container.BackgroundTransparency = 0.3
    container.BorderSizePixel = 0
    container.Parent = parent
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 12)

    local stroke = Instance.new("UIStroke", container)
    stroke.Color = T.Stroke
    stroke.Thickness = 1
    stroke.Transparency = 0.5

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -90, 1, 0)
    label.Position = UDim2.new(0, 16, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = T.Text
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 46, 0, 24)
    toggleBtn.Position = UDim2.new(1, -58, 0.5, -12)
    toggleBtn.BackgroundColor3 = T.Bg
    toggleBtn.Text = ""
    toggleBtn.BorderSizePixel = 0
    toggleBtn.AutoButtonColor = false
    toggleBtn.Parent = container
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

    local toggleStroke = Instance.new("UIStroke", toggleBtn)
    toggleStroke.Color = T.Stroke
    toggleStroke.Thickness = 1

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = UDim2.new(0, 3, 0.5, -9)
    knob.BackgroundColor3 = T.TextDim
    knob.BorderSizePixel = 0
    knob.Parent = toggleBtn
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local function upd()
        if state then
            TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = T.Accent}):Play()
            TweenService:Create(toggleStroke, TweenInfo.new(0.2), {Color = T.AccentGlow}):Play()
            TweenService:Create(knob, TweenInfo.new(0.2), {Position = UDim2.new(1, -21, 0.5, -9), BackgroundColor3 = Color3.new(1,1,1)}):Play()
        else
            TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = T.Bg}):Play()
            TweenService:Create(toggleStroke, TweenInfo.new(0.2), {Color = T.Stroke}):Play()
            TweenService:Create(knob, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -9), BackgroundColor3 = T.TextDim}):Play()
        end
    end
    upd()

    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        upd()
        if callback then callback(state) end
    end)
    return container
end

function Hub.createSlider(parent, name, minVal, maxVal, default, callback)
    local container = Instance.new("Frame")
    container.BackgroundColor3 = T.Bg3
    container.BackgroundTransparency = 0.3
    container.BorderSizePixel = 0
    container.Parent = parent
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 12)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -90, 0, 22)
    label.Position = UDim2.new(0, 16, 0, 8)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = T.Text
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 50, 0, 20)
    valueLabel.Position = UDim2.new(1, -66, 0, 8)
    valueLabel.BackgroundColor3 = T.Accent
    valueLabel.BackgroundTransparency = 0.8
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = T.Accent
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 11
    valueLabel.BorderSizePixel = 0
    valueLabel.Parent = container
    Instance.new("UICorner", valueLabel).CornerRadius = UDim.new(1, 0)

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -32, 0, 6)
    sliderBg.Position = UDim2.new(0, 16, 1, -18)
    sliderBg.BackgroundColor3 = T.Bg
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = container
    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - minVal) / (maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = T.Accent
    fill.BorderSizePixel = 0
    fill.Parent = sliderBg
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new((default - minVal) / (maxVal - minVal), -7, 0.5, -7)
    knob.BackgroundColor3 = Color3.new(1,1,1)
    knob.BorderSizePixel = 0
    knob.Parent = sliderBg
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local sliding = false
    local function upd(input)
        local relX = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        local v = math.floor(minVal + (maxVal - minVal) * relX)
        fill.Size = UDim2.new(relX, 0, 1, 0)
        knob.Position = UDim2.new(relX, -7, 0.5, -7)
        valueLabel.Text = tostring(v)
        callback(v)
    end
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true; upd(input) end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then upd(input) end
    end)
    return container
end

function Hub.createLabel(parent, text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, -4, 0, 24)
    label.BackgroundTransparency = 1
    label.Text = "— " .. text .. " —"
    label.TextColor3 = T.TextDim
    label.Font = Enum.Font.GothamBold
    label.TextSize = 10
    label.Parent = parent
    return label
end

function Hub.createKeybind(parent, name, defaultKey, callback)
    local container = Instance.new("Frame")
    container.BackgroundColor3 = T.Bg3
    container.BackgroundTransparency = 0.3
    container.BorderSizePixel = 0
    container.Parent = parent
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 12)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Position = UDim2.new(0, 16, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = T.Text
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local keyBtn = Instance.new("TextButton")
    keyBtn.Size = UDim2.new(0, 80, 0, 26)
    keyBtn.Position = UDim2.new(1, -92, 0.5, -13)
    keyBtn.BackgroundColor3 = T.Bg
    keyBtn.Text = defaultKey.Name
    keyBtn.TextColor3 = T.Accent
    keyBtn.Font = Enum.Font.GothamBold
    keyBtn.TextSize = 11
    keyBtn.BorderSizePixel = 0
    keyBtn.AutoButtonColor = false
    keyBtn.Parent = container
    Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 6)

    local awaiting = false
    keyBtn.MouseButton1Click:Connect(function()
        awaiting = true
        keyBtn.Text = "Нажми..."
    end)
    UserInputService.InputBegan:Connect(function(input, gp)
        if awaiting and not gp and input.UserInputType == Enum.UserInputType.Keyboard then
            keyBtn.Text = input.KeyCode.Name
            awaiting = false
            callback(input.KeyCode)
        end
    end)
    return container
end

-- TOGGLE MENU (в самом конце!)
local menuOpen = false
function Hub.toggleMenu()
    menuOpen = not menuOpen
    MainFrame.Visible = menuOpen
    if menuOpen and not Hub.CurrentTab then
        Hub.switchTab("Speed")
    end
end

FloatBtn.MouseButton1Click:Connect(Hub.toggleMenu)

Hub.addConnection(UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        Hub.toggleMenu()
    end
end))

print("🐗 Core v3.2 загружен (Compact)")
