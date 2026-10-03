-- 🐗 Bizon Hub Core v4.2 (Base + Watermark + 2col Tabs)
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
WMFrame.Size = UDim2.new(0, 320, 0, 40)
WMFrame.Position = UDim2.new(1, -340, 0, 20)
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
WMicon.Size = UDim2.new(0, 36, 1, 0)
WMicon.Position = UDim2.new(0, 8, 0, 0)
WMicon.BackgroundTransparency = 1
WMicon.Text = "🐗"
WMicon.TextColor3 = T.Accent
WMicon.Font = Enum.Font.GothamBold
WMicon.TextSize = 20
WMicon.Parent = WMFrame

local WMtitle = Instance.new("TextLabel")
WMtitle.Size = UDim2.new(0, 120, 1, 0)
WMtitle.Position = UDim2.new(0, 42, 0, 0)
WMtitle.BackgroundTransparency = 1
WMtitle.Text = "BIZON HUB"
WMtitle.TextColor3 = T.Accent
WMtitle.Font = Enum.Font.GothamBlack
WMtitle.TextSize = 13
WMtitle.TextXAlignment = Enum.TextXAlignment.Left
WMtitle.Parent = WMFrame

local WMsep1 = Instance.new("Frame")
WMsep1.Size = UDim2.new(0, 1, 0, 20)
WMsep1.Position = UDim2.new(0, 168, 0.5, -10)
WMsep1.BackgroundColor3 = T.Stroke
WMsep1.BorderSizePixel = 0
WMsep1.Parent = WMFrame

local WMfps = Instance.new("TextLabel")
WMfps.Size = UDim2.new(0, 58, 1, 0)
WMfps.Position = UDim2.new(0, 176, 0, 0)
WMfps.BackgroundTransparency = 1
WMfps.Text = "FPS: --"
WMfps.TextColor3 = T.Text
WMfps.Font = Enum.Font.GothamBold
WMfps.TextSize = 11
WMfps.TextXAlignment = Enum.TextXAlignment.Left
WMfps.Parent = WMFrame

local WMping = Instance.new("TextLabel")
WMping.Size = UDim2.new(0, 58, 1, 0)
WMping.Position = UDim2.new(0, 240, 0, 0)
WMping.BackgroundTransparency = 1
WMping.Text = "PING: --"
WMping.TextColor3 = T.Text
WMping.Font = Enum.Font.GothamBold
WMping.TextSize = 11
WMping.TextXAlignment = Enum.TextXAlignment.Left
WMping.Parent = WMFrame

local WMver = Instance.new("TextLabel")
WMver.Size = UDim2.new(0, 30, 1, 0)
WMver.Position = UDim2.new(1, -34, 0, 0)
WMver.BackgroundTransparency = 1
WMver.Text = "4.2"
WMver.TextColor3 = T.TextDim
WMver.Font = Enum.Font.GothamBold
WMver.TextSize = 10
WMver.Parent = WMFrame

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

task.spawn(function()
    while WMFrame.Parent and not Hub.IsPanicked do
        TweenService:Create(WMglow, TweenInfo.new(2, Enum.EasingStyle.Sine), {Transparency = 0.95, Thickness = 10}):Play()
        task.wait(2)
        if Hub.IsPanicked then break end
        TweenService:Create(WMglow, TweenInfo.new(2, Enum.EasingStyle.Sine), {Transparency = 0.75, Thickness = 6}):Play()
        task.wait(2)
    end
end)

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

-- FLOAT BTN
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

Hub.Tabs = {}
Hub.CurrentTab = nil

function Hub.switchTab(name)
    if Hub.CurrentTab == name then return end
    if Hub.CurrentTab and Hub.Tabs[Hub.CurrentTab] then
        Hub.Tabs[Hub.CurrentTab].container.Visible = false
        TweenService:Create(Hub.Tabs[Hub.CurrentTab].button, TweenInfo.new(0.2), {TextColor3 = T.TextDim, BackgroundTransparency = 1}):Play()
    end
    Hub.CurrentTab = name
    if Hub.Tabs[name] then
        Hub.Tabs[name].container.Visible = true
        TweenService:Create(Hub.Tabs[name].button, TweenInfo.new(0.2), {TextColor3 = T.Accent, BackgroundTransparency = 0}):Play()
    end
end

-- НОВАЯ createTab с UIListLayout для 2 колонок
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

    local layout = Instance.new("UIListLayout", container)
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
    end)

    Hub.Tabs[name] = {
        button = tabBtn,
        container = container,
        currentRow = nil,
        colCount = 0
    }
    
    tabBtn.MouseButton1Click:Connect(function() Hub.switchTab(name) end)
    return container
end

-- SETTINGS PANEL
local SettingsPanel = Instance.new("Frame")
SettingsPanel.Size = UDim2.new(0, 260, 0, 0)
SettingsPanel.BackgroundColor3 = T.Bg
SettingsPanel.BackgroundTransparency = 0.05
SettingsPanel.BorderSizePixel = 0
SettingsPanel.Visible = false
SettingsPanel.ZIndex = 50
SettingsPanel.Parent = ScreenGui
Instance.new("UICorner", SettingsPanel).CornerRadius = UDim.new(0, 14)

local SPContent = Instance.new("ScrollingFrame")
SPContent.Size = UDim2.new(1, -12, 1, -12)
SPContent.Position = UDim2.new(0, 6, 0, 6)
SPContent.BackgroundTransparency = 1
SPContent.BorderSizePixel = 0
SPContent.ScrollBarThickness = 3
SPContent.ScrollBarImageColor3 = T.Accent
SPContent.CanvasSize = UDim2.new(0, 0, 0, 0)
SPContent.Parent = SettingsPanel

local SPLayout = Instance.new("UIListLayout", SPContent)
SPLayout.Padding = UDim.new(0, 6)

SPLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    SPContent.CanvasSize = UDim2.new(0, 0, 0, SPLayout.AbsoluteContentSize.Y + 12)
    SettingsPanel.Size = UDim2.new(0, 260, 0, math.clamp(SPLayout.AbsoluteContentSize.Y + 20, 50, 400))
end)

Hub.SettingsPanel = SettingsPanel
Hub.SettingsPanelContent = SPContent

function Hub.openSettings(sourceContainer, settingsFn)
    for _, child in pairs(SPContent:GetChildren()) do
        if not child:IsA("UIListLayout") then child:Destroy() end
    end
    if not sourceContainer then return end
    settingsFn(SPContent)
    task.wait(0.05)
    local ok, pos = pcall(function() return sourceContainer.AbsolutePosition end)
    if not ok or not pos then SettingsPanel.Visible = false; return end
    local size = sourceContainer.AbsoluteSize or Vector2.new(200, 50)
    SettingsPanel.Position = UDim2.new(0, pos.X + size.X + 10, 0, pos.y or pos.Y)
    SettingsPanel.Size = UDim2.new(0, 260, 0, 0)
    SettingsPanel.Visible = true
end

function Hub.closeSettings()
    SettingsPanel.Visible = false
    for _, child in pairs(SPContent:GetChildren()) do
        if not child:IsA("UIListLayout") then child:Destroy() end
    end
end

Hub.addConnection(UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 and SettingsPanel.Visible then
        local mousePos = UserInputService:GetMouseLocation()
        local panelPos = SettingsPanel.AbsolutePosition
        local panelSize = SettingsPanel.AbsoluteSize
        if not (mousePos.X >= panelPos.X and mousePos.X <= panelPos.X + panelSize.X 
                and mousePos.Y >= panelPos.Y and mousePos.Y <= panelPos.Y + panelSize.Y) then
            Hub.closeSettings()
        end
    end
end))

local menuOpen = false
function Hub.toggleMenu()
    menuOpen = not menuOpen
    MainFrame.Visible = menuOpen
    if not menuOpen then Hub.closeSettings() end
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

print("🐗 Core v4.2 загружен")
