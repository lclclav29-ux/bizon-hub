-- 🐗 Bizon Hub Core v3.1 (Base)
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
    Bg2 = Color3.fromRGB(20, 16, 32),
    Bg3 = Color3.fromRGB(28, 22, 45),
    Bg4 = Color3.fromRGB(38, 30, 60),
    Accent = Color3.fromRGB(168, 85, 247),
    Accent2 = Color3.fromRGB(126, 34, 206),
    AccentGlow = Color3.fromRGB(200, 130, 255),
    Text = Color3.fromRGB(240, 235, 255),
    TextDim = Color3.fromRGB(140, 130, 165),
    TextDisabled = Color3.fromRGB(80, 75, 100),
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

-- WATERMARK
local WatermarkGui = Instance.new("ScreenGui")
WatermarkGui.Name = "BizonWatermark"
WatermarkGui.ResetOnSpawn = false
WatermarkGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
WatermarkGui.IgnoreGuiInset = true
WatermarkGui.Parent = player:WaitForChild("PlayerGui")

local WMFrame = Instance.new("Frame")
WMFrame.Size = UDim2.new(0, 360, 0, 44)
WMFrame.Position = UDim2.new(1, -380, 0, 20)
WMFrame.BackgroundColor3 = T.Bg
WMFrame.BackgroundTransparency = 0.15
WMFrame.BorderSizePixel = 0
WMFrame.Parent = WatermarkGui
Instance.new("UICorner", WMFrame).CornerRadius = UDim.new(0, 12)

local WMstroke = Instance.new("UIStroke", WMFrame)
WMstroke.Color = T.Accent
WMstroke.Thickness = 1.5
WMstroke.Transparency = 0.3

local WMglow = Instance.new("UIStroke", WMFrame)
WMglow.Color = T.AccentGlow
WMglow.Thickness = 6
WMglow.Transparency = 0.85

local WMicon = Instance.new("TextLabel")
WMicon.Size = UDim2.new(0, 40, 1, 0)
WMicon.Position = UDim2.new(0, 8, 0, 0)
WMicon.BackgroundTransparency = 1
WMicon.Text = "🐗"
WMicon.TextColor3 = T.Accent
WMicon.Font = Enum.Font.GothamBold
WMicon.TextSize = 22
WMicon.Parent = WMFrame

local WMtitle = Instance.new("TextLabel")
WMtitle.Size = UDim2.new(0, 140, 1, 0)
WMtitle.Position = UDim2.new(0, 46, 0, 0)
WMtitle.BackgroundTransparency = 1
WMtitle.Text = "BIZON HUB"
WMtitle.TextColor3 = T.Accent
WMtitle.Font = Enum.Font.GothamBlack
WMtitle.TextSize = 15
WMtitle.TextXAlignment = Enum.TextXAlignment.Left
WMtitle.Parent = WMFrame

local WMsep1 = Instance.new("Frame")
WMsep1.Size = UDim2.new(0, 1, 0, 24)
WMsep1.Position = UDim2.new(0, 188, 0.5, -12)
WMsep1.BackgroundColor3 = T.Stroke
WMsep1.BorderSizePixel = 0
WMsep1.Parent = WMFrame

local WMfps = Instance.new("TextLabel")
WMfps.Size = UDim2.new(0, 65, 1, 0)
WMfps.Position = UDim2.new(0, 196, 0, 0)
WMfps.BackgroundTransparency = 1
WMfps.Text = "FPS: --"
WMfps.TextColor3 = T.Text
WMfps.Font = Enum.Font.GothamBold
WMfps.TextSize = 12
WMfps.TextXAlignment = Enum.TextXAlignment.Left
WMfps.Parent = WMFrame

local WMping = Instance.new("TextLabel")
WMping.Size = UDim2.new(0, 65, 1, 0)
WMping.Position = UDim2.new(0, 270, 0, 0)
WMping.BackgroundTransparency = 1
WMping.Text = "PING: --"
WMping.TextColor3 = T.Text
WMping.Font = Enum.Font.GothamBold
WMping.TextSize = 12
WMping.TextXAlignment = Enum.TextXAlignment.Left
WMping.Parent = WMFrame

local WMver = Instance.new("TextLabel")
WMver.Size = UDim2.new(0, 30, 1, 0)
WMver.Position = UDim2.new(1, -36, 0, 0)
WMver.BackgroundTransparency = 1
WMver.Text = "3.1"
WMver.TextColor3 = T.TextDim
WMver.Font = Enum.Font.GothamBold
WMver.TextSize = 10
WMver.Parent = WMFrame

-- Drag watermark
local wmDrag, wmStart, wmStartPos
Hub.addConnection(WMFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        wmDrag = true; wmStart = input.Position; wmStartPos = WMFrame.Position
    end
end))
Hub.addConnection(UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then wmDrag = false end
end))
Hub.addConnection(UserInputService.InputChanged:Connect(function(input)
    if wmDrag and input.UserInputType == Enum.UserInputType.MouseMovement then
        local d = input.Position - wmStart
        WMFrame.Position = UDim2.new(wmStartPos.X.Scale, wmStartPos.X.Offset + d.X, wmStartPos.Y.Scale, wmStartPos.Y.Offset + d.Y)
    end
end))

-- Пульсация
task.spawn(function()
    while WMFrame.Parent and not Hub.IsPanicked do
        TweenService:Create(WMglow, TweenInfo.new(2, Enum.EasingStyle.Sine), {Transparency = 0.95, Thickness = 10}):Play()
        task.wait(2)
        if Hub.IsPanicked then break end
        TweenService:Create(WMglow, TweenInfo.new(2, Enum.EasingStyle.Sine), {Transparency = 0.75, Thickness = 6}):Play()
        task.wait(2)
    end
end)

-- FPS
local fpsHistory = {}
task.spawn(function()
    local lastUpdate = tick()
    local frames = 0
    while WMFrame.Parent and not Hub.IsPanicked do
        RunService.RenderStepped:Wait()
        frames = frames + 1
        local now = tick()
        if now - lastUpdate >= 0.5 then
            local rawFps = frames / (now - lastUpdate)
            frames = 0; lastUpdate = now
            table.insert(fpsHistory, rawFps)
            if #fpsHistory > 30 then table.remove(fpsHistory, 1) end
            local sum = 0
            for _, v in pairs(fpsHistory) do sum = sum + v end
            local avgFps = math.floor(sum / #fpsHistory)
            local color = T.Success
            if avgFps < 30 then color = T.Danger
            elseif avgFps < 60 then color = T.Warning end
            WMfps.Text = "FPS: " .. tostring(avgFps)
            WMfps.TextColor3 = color
        end
    end
end)

-- Ping
local pingHistory = {}
task.spawn(function()
    while WMFrame.Parent and not Hub.IsPanicked do
        local ok, ping = pcall(function()
            return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
        end)
        if ok and ping then
            table.insert(pingHistory, ping)
            if #pingHistory > 10 then table.remove(pingHistory, 1) end
            local sum = 0
            for _, v in pairs(pingHistory) do sum = sum + v end
            local avgPing = math.floor(sum / #pingHistory)
            local color = T.Success
            if avgPing > 200 then color = T.Danger
            elseif avgPing > 100 then color = T.Warning end
            WMping.Text = "PING: " .. tostring(avgPing)
            WMping.TextColor3 = color
        end
        task.wait(1)
    end
end)

Hub.Watermark = WMFrame
function Hub.setEdition(edition)
    if edition == "PREMIUM" then
        WMtitle.TextColor3 = Color3.fromRGB(255, 200, 50)
        WMicon.TextColor3 = Color3.fromRGB(255, 200, 50)
        WMstroke.Color = Color3.fromRGB(255, 200, 50)
    end
end

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

local FBglow = Instance.new("UIStroke", FloatBtn)
FBglow.Color = T.AccentGlow
FBglow.Thickness = 6
FBglow.Transparency = 0.8

task.spawn(function()
    while FloatBtn.Parent and not Hub.IsPanicked do
        TweenService:Create(FBglow, TweenInfo.new(1.5), {Transparency = 0.95, Thickness = 12}):Play()
        task.wait(1.5)
        if Hub.IsPanicked then break end
        TweenService:Create(FBglow, TweenInfo.new(1.5), {Transparency = 0.7, Thickness = 6}):Play()
        task.wait(1.5)
    end
end)

local fbDrag, fbStart, fbStartPos
Hub.addConnection(FloatBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        fbDrag = true; fbStart = input.Position; fbStartPos = FloatBtn.Position
    end
end))
Hub.addConnection(UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then fbDrag = false end
end))
Hub.addConnection(UserInputService.InputChanged:Connect(function(input)
    if fbDrag and input.UserInputType == Enum.UserInputType.MouseMovement then
        local d = input.Position - fbStart
        FloatBtn.Position = UDim2.new(fbStartPos.X.Scale, fbStartPos.X.Offset + d.X, fbStartPos.Y.Scale, fbStartPos.Y.Offset + d.Y)
    end
end))

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
MFstroke.Transparency = 0.3

local MFglow = Instance.new("UIStroke", MainFrame)
MFglow.Color = T.AccentGlow
MFglow.Thickness = 8
MFglow.Transparency = 0.9

local MFgrad = Instance.new("UIGradient", MainFrame)
MFgrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 16, 38)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 8, 20)),
})
MFgrad.Rotation = 135
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

local SearchFrame = Instance.new("Frame")
SearchFrame.Size = UDim2.new(0, 220, 0, 36)
SearchFrame.Position = UDim2.new(0.5, -110, 0, 18)
SearchFrame.BackgroundColor3 = T.Bg3
SearchFrame.BackgroundTransparency = 0.3
SearchFrame.BorderSizePixel = 0
SearchFrame.Parent = Header
Instance.new("UICorner", SearchFrame).CornerRadius = UDim.new(0, 8)

local SearchIcon = Instance.new("TextLabel")
SearchIcon.Size = UDim2.new(0, 24, 1, 0)
SearchIcon.Position = UDim2.new(0, 8, 0, 0)
SearchIcon.BackgroundTransparency = 1
SearchIcon.Text = "🔍"
SearchIcon.TextSize = 12
SearchIcon.Parent = SearchFrame

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -38, 1, 0)
SearchBox.Position = UDim2.new(0, 32, 0, 0)
SearchBox.BackgroundTransparency = 1
SearchBox.Text = ""
SearchBox.PlaceholderText = "Search..."
SearchBox.PlaceholderColor3 = T.TextDim
SearchBox.TextColor3 = T.Text
SearchBox.Font = Enum.Font.GothamMedium
SearchBox.TextSize = 12
SearchBox.TextXAlignment = Enum.TextXAlignment.Left
SearchBox.ClearTextOnFocus = false
SearchBox.Parent = SearchFrame

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
        TweenService:Create(Tabs[Hub.CurrentTab].button, TweenInfo.new(0.25), {
            BackgroundTransparency = 1,
            TextColor3 = T.TextDim,
        }):Play()
        Tabs[Hub.CurrentTab].container.Visible = false
    end
    Hub.CurrentTab = name
    TweenService:Create(Tabs[name].button, TweenInfo.new(0.25), {
        BackgroundTransparency = 0,
        TextColor3 = T.Accent,
    }):Play()
    Tabs[name].container.Visible = true
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

-- TOGGLE MENU
local menuOpen = false
function Hub.toggleMenu()
    menuOpen = not menuOpen
    MainFrame.Visible = menuOpen
    if menuOpen then
        if not Hub.CurrentTab and Tabs["Speed"] then
            Hub.switchTab("Speed")
        end
    end
end

FloatBtn.MouseButton1Click:Connect(Hub.toggleMenu)

Hub.addConnection(UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        Hub.toggleMenu()
    end
end))

print("🐗 Core v3.1 (Base) загружен")
