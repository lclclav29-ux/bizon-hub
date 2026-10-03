-- 🐗 Bizon Hub Core v2.2 (Large Watermark Right Top)
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
    Bg = Color3.fromRGB(22, 22, 30),
    Bg2 = Color3.fromRGB(30, 30, 42),
    Bg3 = Color3.fromRGB(42, 42, 58),
    Bg4 = Color3.fromRGB(55, 55, 75),
    Accent = Color3.fromRGB(255, 145, 30),
    Accent2 = Color3.fromRGB(255, 90, 20),
    Text = Color3.fromRGB(235, 235, 245),
    TextDim = Color3.fromRGB(140, 140, 165),
    Success = Color3.fromRGB(50, 220, 130),
    Danger = Color3.fromRGB(240, 65, 75),
    Stroke = Color3.fromRGB(60, 60, 85),
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

Hub.WatermarkEdition = "FREE"

-- Удаляем старые GUI
local old = player.PlayerGui:FindFirstChild("BizonHub")
if old then old:Destroy() end
local oldWM = player.PlayerGui:FindFirstChild("BizonWatermark")
if oldWM then oldWM:Destroy() end

-- === ROOT ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BizonHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = player:WaitForChild("PlayerGui")
Hub.ScreenGui = ScreenGui

-- ============================================
-- WATERMARK (Large, Right Top)
-- ============================================
local WatermarkGui = Instance.new("ScreenGui")
WatermarkGui.Name = "BizonWatermark"
WatermarkGui.ResetOnSpawn = false
WatermarkGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
WatermarkGui.IgnoreGuiInset = true
WatermarkGui.Parent = player:WaitForChild("PlayerGui")

local WMFrame = Instance.new("Frame")
WMFrame.Size = UDim2.new(0, 460, 0, 58)
WMFrame.Position = UDim2.new(1, -480, 0, 20)
WMFrame.BackgroundColor3 = T.Bg
WMFrame.BackgroundTransparency = 0.1
WMFrame.BorderSizePixel = 0
WMFrame.Parent = WatermarkGui
Instance.new("UICorner", WMFrame).CornerRadius = UDim.new(0, 14)

local WMstroke = Instance.new("UIStroke", WMFrame)
WMstroke.Color = T.Accent
WMstroke.Thickness = 2

local WMgrad = Instance.new("UIGradient", WMFrame)
WMgrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, T.Bg2),
    ColorSequenceKeypoint.new(1, T.Bg),
})
WMgrad.Rotation = 45

-- Иконка 🐗
local WMicon = Instance.new("TextLabel")
WMicon.Size = UDim2.new(0, 50, 1, 0)
WMicon.Position = UDim2.new(0, 12, 0, 0)
WMicon.BackgroundTransparency = 1
WMicon.Text = "🐗"
WMicon.TextColor3 = T.Accent
WMicon.Font = Enum.Font.GothamBold
WMicon.TextSize = 30
WMicon.Parent = WMFrame

-- Название BIZON HUB
local WMtitle = Instance.new("TextLabel")
WMtitle.Size = UDim2.new(0, 180, 0, 32)
WMtitle.Position = UDim2.new(0, 62, 0, 6)
WMtitle.BackgroundTransparency = 1
WMtitle.Text = "BIZON HUB"
WMtitle.TextColor3 = T.Accent
WMtitle.Font = Enum.Font.GothamBlack
WMtitle.TextSize = 24
WMtitle.TextXAlignment = Enum.TextXAlignment.Left
WMtitle.Parent = WMFrame

-- Версия под названием
local WMversion = Instance.new("TextLabel")
WMversion.Size = UDim2.new(0, 180, 0, 18)
WMversion.Position = UDim2.new(0, 62, 0, 36)
WMversion.BackgroundTransparency = 1
WMversion.Text = "version v2.2"
WMversion.TextColor3 = T.TextDim
WMversion.Font = Enum.Font.GothamMedium
WMversion.TextSize = 12
WMversion.TextXAlignment = Enum.TextXAlignment.Left
WMversion.Parent = WMFrame

-- Разделитель 1
local WMsep1 = Instance.new("Frame")
WMsep1.Size = UDim2.new(0, 2, 0, 32)
WMsep1.Position = UDim2.new(0, 250, 0.5, -16)
WMsep1.BackgroundColor3 = T.Stroke
WMsep1.BorderSizePixel = 0
WMsep1.Parent = WMFrame

-- FREE / PREMIUM
local WMedition = Instance.new("TextLabel")
WMedition.Size = UDim2.new(0, 100, 0, 22)
WMedition.Position = UDim2.new(0, 262, 0, 10)
WMedition.BackgroundTransparency = 1
WMedition.Text = "FREE"
WMedition.TextColor3 = T.TextDim
WMedition.Font = Enum.Font.GothamBlack
WMedition.TextSize = 16
WMedition.TextXAlignment = Enum.TextXAlignment.Left
WMedition.Parent = WMFrame

local WMeditionLabel = Instance.new("TextLabel")
WMeditionLabel.Size = UDim2.new(0, 100, 0, 16)
WMeditionLabel.Position = UDim2.new(0, 262, 0, 32)
WMeditionLabel.BackgroundTransparency = 1
WMeditionLabel.Text = "edition"
WMeditionLabel.TextColor3 = T.TextDim
WMeditionLabel.Font = Enum.Font.Gotham
WMeditionLabel.TextSize = 10
WMeditionLabel.TextXAlignment = Enum.TextXAlignment.Left
WMeditionLabel.Parent = WMFrame

-- Разделитель 2
local WMsep2 = Instance.new("Frame")
WMsep2.Size = UDim2.new(0, 2, 0, 32)
WMsep2.Position = UDim2.new(0, 366, 0.5, -16)
WMsep2.BackgroundColor3 = T.Stroke
WMsep2.BorderSizePixel = 0
WMsep2.Parent = WMFrame

-- FPS
local WMfps = Instance.new("TextLabel")
WMfps.Size = UDim2.new(0, 90, 0, 22)
WMfps.Position = UDim2.new(0, 376, 0, 10)
WMfps.BackgroundTransparency = 1
WMfps.Text = "FPS: --"
WMfps.TextColor3 = T.Text
WMfps.Font = Enum.Font.GothamBlack
WMfps.TextSize = 15
WMfps.TextXAlignment = Enum.TextXAlignment.Left
WMfps.Parent = WMFrame

-- PING под FPS
local WMping = Instance.new("TextLabel")
WMping.Size = UDim2.new(0, 90, 0, 18)
WMping.Position = UDim2.new(0, 376, 0, 32)
WMping.BackgroundTransparency = 1
WMping.Text = "PING: --"
WMping.TextColor3 = T.Text
WMping.Font = Enum.Font.GothamBold
WMping.TextSize = 12
WMping.TextXAlignment = Enum.TextXAlignment.Left
WMping.Parent = WMFrame

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

-- Сглаженный FPS
local fpsHistory = {}
local FPS_SAMPLES = 30

task.spawn(function()
    local lastUpdate = tick()
    local frames = 0
    while WMFrame.Parent and not Hub.IsPanicked do
        RunService.RenderStepped:Wait()
        frames = frames + 1
        local now = tick()
        if now - lastUpdate >= 0.5 then
            local rawFps = frames / (now - lastUpdate)
            frames = 0
            lastUpdate = now

            table.insert(fpsHistory, rawFps)
            if #fpsHistory > FPS_SAMPLES then
                table.remove(fpsHistory, 1)
            end

            local sum = 0
            for _, v in pairs(fpsHistory) do sum = sum + v end
            local avgFps = math.floor(sum / #fpsHistory)

            local color = T.Success
            if avgFps < 30 then color = T.Danger
            elseif avgFps < 60 then color = Color3.fromRGB(255, 200, 0) end

            WMfps.Text = "FPS: " .. tostring(avgFps)
            WMfps.TextColor3 = color
        end
    end
end)

-- Сглаженный PING
local pingHistory = {}
local PING_SAMPLES = 10

task.spawn(function()
    while WMFrame.Parent and not Hub.IsPanicked do
        local ok, ping = pcall(function()
            return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
        end)
        if ok and ping then
            table.insert(pingHistory, ping)
            if #pingHistory > PING_SAMPLES then
                table.remove(pingHistory, 1)
            end

            local sum = 0
            for _, v in pairs(pingHistory) do sum = sum + v end
            local avgPing = math.floor(sum / #pingHistory)

            local color = T.Success
            if avgPing > 200 then color = T.Danger
            elseif avgPing > 100 then color = Color3.fromRGB(255, 200, 0) end

            WMping.Text = "PING: " .. tostring(avgPing)
            WMping.TextColor3 = color
        end
        task.wait(1)
    end
end)

-- API смены версии
Hub.Watermark = WMFrame
function Hub.setEdition(edition)
    Hub.WatermarkEdition = edition
    WMedition.Text = edition
    if edition == "PREMIUM" then
        WMedition.TextColor3 = Color3.fromRGB(255, 200, 50)
        WMstroke.Color = Color3.fromRGB(255, 200, 50)
        WMtitle.TextColor3 = Color3.fromRGB(255, 200, 50)
        WMicon.TextColor3 = Color3.fromRGB(255, 200, 50)
    else
        WMedition.TextColor3 = T.TextDim
        WMstroke.Color = T.Accent
        WMtitle.TextColor3 = T.Accent
        WMicon.TextColor3 = T.Accent
    end
end

-- === FLOAT BUTTON ===
local FloatBtn = Instance.new("TextButton")
FloatBtn.Size = UDim2.new(0, 130, 0, 46)
FloatBtn.Position = UDim2.new(0, 20, 0, 100)
FloatBtn.BackgroundColor3 = T.Bg
FloatBtn.Text = "🐗  BIZON HUB"
FloatBtn.TextColor3 = T.Accent
FloatBtn.Font = Enum.Font.GothamBold
FloatBtn.TextSize = 14
FloatBtn.BorderSizePixel = 0
FloatBtn.AutoButtonColor = false
FloatBtn.Parent = ScreenGui
Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(0, 14)

local FBstroke = Instance.new("UIStroke", FloatBtn)
FBstroke.Color = T.Accent
FBstroke.Thickness = 1.5
FBstroke.Transparency = 0.3

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

task.spawn(function()
    while FloatBtn.Parent and not Hub.IsPanicked do
        TweenService:Create(FBstroke, TweenInfo.new(2.5), {Transparency = 0.7}):Play()
        task.wait(2.5)
        if Hub.IsPanicked then break end
        TweenService:Create(FBstroke, TweenInfo.new(2.5), {Transparency = 0.3}):Play()
        task.wait(2.5)
    end
end)

-- === MAIN FRAME ===
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 560, 0, 400)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -200)
MainFrame.BackgroundColor3 = T.Bg
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 22)

local MFstroke = Instance.new("UIStroke", MainFrame)
MFstroke.Color = T.Stroke
MFstroke.Thickness = 1.5
Hub.MainFrame = MainFrame

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 58)
Header.BackgroundColor3 = T.Bg2
Header.BorderSizePixel = 0
Header.Parent = MainFrame
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 22)

local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 20)
HeaderFix.Position = UDim2.new(0, 0, 1, -20)
HeaderFix.BackgroundColor3 = T.Bg2
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = Header

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0.6, 0, 1, 0)
TitleLabel.Position = UDim2.new(0, 24, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🐗  BIZON HUB"
TitleLabel.TextColor3 = T.Accent
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextSize = 20
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = Header

local Version = Instance.new("TextLabel")
Version.Size = UDim2.new(0, 65, 0, 22)
Version.Position = UDim2.new(0, 230, 0.5, -11)
Version.BackgroundColor3 = T.Accent
Version.BackgroundTransparency = 0.82
Version.Text = "v2.2"
Version.TextColor3 = T.Accent
Version.Font = Enum.Font.GothamBold
Version.TextSize = 11
Version.BorderSizePixel = 0
Version.Parent = Header
Instance.new("UICorner", Version).CornerRadius = UDim.new(1, 0)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 36, 0, 36)
CloseBtn.Position = UDim2.new(1, -48, 0.5, -18)
CloseBtn.BackgroundColor3 = T.Bg3
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = T.TextDim
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
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

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(0, 150, 1, -80)
TabBar.Position = UDim2.new(0, 12, 0, 68)
TabBar.BackgroundColor3 = T.Bg2
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame
Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 16)

local TabList = Instance.new("UIListLayout", TabBar)
TabList.Padding = UDim.new(0, 6)
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local TabPad = Instance.new("UIPadding", TabBar)
TabPad.PaddingTop = UDim.new(0, 10)
TabPad.PaddingLeft = UDim.new(0, 8)
TabPad.PaddingRight = UDim.new(0, 8)

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -180, 1, -80)
Content.Position = UDim2.new(0, 168, 0, 68)
Content.BackgroundColor3 = T.Bg2
Content.BorderSizePixel = 0
Content.Parent = MainFrame
Instance.new("UICorner", Content).CornerRadius = UDim.new(0, 16)

local Tabs = {}
Hub.Tabs = Tabs
Hub.CurrentTab = nil

function Hub.switchTab(name)
    if Hub.CurrentTab == name then return end
    if Hub.CurrentTab and Tabs[Hub.CurrentTab] then
        TweenService:Create(Tabs[Hub.CurrentTab].button, TweenInfo.new(0.2), {BackgroundColor3 = T.Bg2, TextColor3 = T.TextDim}):Play()
        Tabs[Hub.CurrentTab].container.Visible = false
    end
    Hub.CurrentTab = name
    TweenService:Create(Tabs[name].button, TweenInfo.new(0.2), {BackgroundColor3 = T.Accent, TextColor3 = T.Bg}):Play()
    Tabs[name].container.Visible = true
end

function Hub.createTab(name, icon)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, -8, 0, 38)
    tabBtn.BackgroundColor3 = T.Bg2
    tabBtn.Text = (icon or "") .. "  " .. name
    tabBtn.TextColor3 = T.TextDim
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextSize = 13
    tabBtn.TextXAlignment = Enum.TextXAlignment.Left
    tabBtn.BorderSizePixel = 0
    tabBtn.AutoButtonColor = false
    tabBtn.Parent = TabBar
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 12)
    local Tpad = Instance.new("UIPadding", tabBtn)
    Tpad.PaddingLeft = UDim.new(0, 12)

    local container = Instance.new("ScrollingFrame")
    container.Size = UDim2.new(1, -16, 1, -16)
    container.Position = UDim2.new(0, 8, 0, 8)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.ScrollBarThickness = 4
    container.ScrollBarImageColor3 = T.Accent
    container.CanvasSize = UDim2.new(0, 0, 0, 0)
    container.Visible = false
    container.Parent = Content

    local layout = Instance.new("UIListLayout", container)
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    local pad = Instance.new("UIPadding", container)
    pad.PaddingTop = UDim.new(0, 8)
    pad.PaddingBottom = UDim.new(0, 8)
    pad.PaddingLeft = UDim.new(0, 8)
    pad.PaddingRight = UDim.new(0, 8)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 16)
    end)

    Tabs[name] = {button = tabBtn, container = container}
    tabBtn.MouseButton1Click:Connect(function() Hub.switchTab(name) end)
    return container
end

function Hub.createToggle(parent, name, default, callback, onRight)
    local state = default or false
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 48)
    container.BackgroundColor3 = T.Bg3
    container.BorderSizePixel = 0
    container.Parent = parent
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 12)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -90, 1, 0)
    label.Position = UDim2.new(0, 16, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = T.Text
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 52, 0, 26)
    toggleBtn.Position = UDim2.new(1, -64, 0.5, -13)
    toggleBtn.BackgroundColor3 = T.Bg
    toggleBtn.Text = ""
    toggleBtn.BorderSizePixel = 0
    toggleBtn.AutoButtonColor = false
    toggleBtn.Parent = container
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 20, 0, 20)
    knob.Position = UDim2.new(0, 3, 0.5, -10)
    knob.BackgroundColor3 = T.TextDim
    knob.BorderSizePixel = 0
    knob.Parent = toggleBtn
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local function upd()
        if state then
            TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = T.Accent}):Play()
            TweenService:Create(knob, TweenInfo.new(0.2), {Position = UDim2.new(1, -23, 0.5, -10), BackgroundColor3 = Color3.new(1,1,1)}):Play()
        else
            TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = T.Bg}):Play()
            TweenService:Create(knob, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -10), BackgroundColor3 = T.TextDim}):Play()
        end
    end
    upd()

    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        upd()
        if callback then callback(state) end
    end)
    container.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            state = not state
            upd()
            if callback then callback(state) end
        elseif input.UserInputType == Enum.UserInputType.MouseButton2 and onRight then
            onRight()
        end
    end)
    return container
end

function Hub.createSlider(parent, name, minVal, maxVal, default, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 62)
    container.BackgroundColor3 = T.Bg3
    container.BorderSizePixel = 0
    container.Parent = parent
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 12)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -100, 0, 22)
    label.Position = UDim2.new(0, 16, 0, 8)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = T.Text
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 60, 0, 22)
    valueLabel.Position = UDim2.new(1, -76, 0, 8)
    valueLabel.BackgroundColor3 = T.Accent
    valueLabel.BackgroundTransparency = 0.85
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = T.Accent
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 12
    valueLabel.BorderSizePixel = 0
    valueLabel.Parent = container
    Instance.new("UICorner", valueLabel).CornerRadius = UDim.new(1, 0)

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -32, 0, 8)
    sliderBg.Position = UDim2.new(0, 16, 0, 42)
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
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = UDim2.new((default - minVal) / (maxVal - minVal), -9, 0.5, -9)
    knob.BackgroundColor3 = Color3.new(1,1,1)
    knob.BorderSizePixel = 0
    knob.Parent = sliderBg
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local sliding = false
    local function upd(input)
        local relX = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        local v = math.floor(minVal + (maxVal - minVal) * relX)
        fill.Size = UDim2.new(relX, 0, 1, 0)
        knob.Position = UDim2.new(relX, -9, 0.5, -9)
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
    label.Size = UDim2.new(1, 0, 0, 22)
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
    container.Size = UDim2.new(1, 0, 0, 44)
    container.BackgroundColor3 = T.Bg3
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
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local keyBtn = Instance.new("TextButton")
    keyBtn.Size = UDim2.new(0, 100, 0, 28)
    keyBtn.Position = UDim2.new(1, -116, 0.5, -14)
    keyBtn.BackgroundColor3 = T.Bg
    keyBtn.Text = defaultKey.Name
    keyBtn.TextColor3 = T.Accent
    keyBtn.Font = Enum.Font.GothamBold
    keyBtn.TextSize = 12
    keyBtn.BorderSizePixel = 0
    keyBtn.AutoButtonColor = false
    keyBtn.Parent = container
    Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 8)

    local awaiting = false
    keyBtn.MouseButton1Click:Connect(function()
        awaiting = true
        keyBtn.Text = "Нажми..."
        keyBtn.TextColor3 = Color3.fromRGB(255, 200, 0)
    end)
    UserInputService.InputBegan:Connect(function(input, gp)
        if awaiting and not gp and input.UserInputType == Enum.UserInputType.Keyboard then
            keyBtn.Text = input.KeyCode.Name
            keyBtn.TextColor3 = T.Accent
            awaiting = false
            callback(input.KeyCode)
        end
    end)
    return container
end

local menuOpen = false
function Hub.toggleMenu()
    menuOpen = not menuOpen
    MainFrame.Visible = menuOpen
    if menuOpen then
        MainFrame.Size = UDim2.new(0, 560, 0, 0)
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 560, 0, 400)
        }):Play()
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
function Hub.createLabel(parent, text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 22)
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
    container.Size = UDim2.new(1, 0, 0, 44)
    container.BackgroundColor3 = T.Bg3
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
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local keyBtn = Instance.new("TextButton")
    keyBtn.Size = UDim2.new(0, 100, 0, 28)
    keyBtn.Position = UDim2.new(1, -116, 0.5, -14)
    keyBtn.BackgroundColor3 = T.Bg
    keyBtn.Text = defaultKey.Name
    keyBtn.TextColor3 = T.Accent
    keyBtn.Font = Enum.Font.GothamBold
    keyBtn.TextSize = 12
    keyBtn.BorderSizePixel = 0
    keyBtn.AutoButtonColor = false
    keyBtn.Parent = container
    Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 8)

    local awaiting = false
    keyBtn.MouseButton1Click:Connect(function()
        awaiting = true
        keyBtn.Text = "Нажми..."
        keyBtn.TextColor3 = Color3.fromRGB(255, 200, 0)
    end)
    UserInputService.InputBegan:Connect(function(input, gp)
        if awaiting and not gp and input.UserInputType == Enum.UserInputType.Keyboard then
            keyBtn.Text = input.KeyCode.Name
            keyBtn.TextColor3 = T.Accent
            awaiting = false
            callback(input.KeyCode)
        end
    end)
    return container
end
print("🐗 Core загружен (v2.2 + Large Watermark)")
