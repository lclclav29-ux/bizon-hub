-- ============================================
-- BIZON HUB — Recode 1.0 — CORE
-- ============================================
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
    Bg = Color3.fromRGB(10, 10, 18),
    Bg2 = Color3.fromRGB(18, 18, 30),
    Bg3 = Color3.fromRGB(26, 26, 42),
    Bg4 = Color3.fromRGB(36, 36, 56),
    Accent = Color3.fromRGB(168, 85, 247),
    AccentGlow = Color3.fromRGB(200, 130, 255),
    Text = Color3.fromRGB(240, 240, 245),
    TextDim = Color3.fromRGB(140, 140, 160),
    TextDim2 = Color3.fromRGB(90, 90, 110),
    Success = Color3.fromRGB(80, 240, 160),
    Danger = Color3.fromRGB(240, 70, 100),
    Warning = Color3.fromRGB(255, 200, 50),
    Stroke = Color3.fromRGB(50, 45, 70),
    StrokeLight = Color3.fromRGB(80, 70, 110),
}

Hub.Settings = {
    SpeedEnabled=false, SpeedValue=50, SmoothSpeed=false,
    SpeedInAir=false,
    JumpEnabled=false, JumpValue=100, InfiniteJump=false,
    FlyEnabled=false, FlySpeed=50,
    Noclip=false, Fullbright=false,
}

local T = Hub.Theme

for _, name in ipairs({"BizonHub", "BizonWatermark", "BizonTooltip"}) do
    local old = player.PlayerGui:FindFirstChild(name)
    if old then old:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BizonHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = player:WaitForChild("PlayerGui")
Hub.ScreenGui = ScreenGui

-- ============================================
-- WATERMARK
-- ============================================
local WatermarkGui = Instance.new("ScreenGui")
WatermarkGui.Name = "BizonWatermark"
WatermarkGui.ResetOnSpawn = false
WatermarkGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
WatermarkGui.IgnoreGuiInset = true
WatermarkGui.Parent = player:WaitForChild("PlayerGui")

local WMFrame = Instance.new("Frame")
WMFrame.Size = UDim2.new(0, 320, 0, 42)
WMFrame.Position = UDim2.new(1, -340, 0, 20)
WMFrame.BackgroundColor3 = T.Bg2
WMFrame.BackgroundTransparency = 0.1
WMFrame.BorderSizePixel = 0
WMFrame.Parent = WatermarkGui
Instance.new("UICorner", WMFrame).CornerRadius = UDim.new(0, 10)

local WMstroke = Instance.new("UIStroke", WMFrame)
WMstroke.Color = T.Accent
WMstroke.Thickness = 1
WMstroke.Transparency = 0.4

local WMicon = Instance.new("Frame")
WMicon.Size = UDim2.new(0, 30, 0, 30)
WMicon.Position = UDim2.new(0, 6, 0.5, -15)
WMicon.BackgroundColor3 = T.Bg
WMicon.BorderSizePixel = 0
WMicon.Parent = WMFrame
Instance.new("UICorner", WMicon).CornerRadius = UDim.new(1, 0)

local WMiconStroke = Instance.new("UIStroke", WMicon)
WMiconStroke.Color = T.Accent
WMiconStroke.Thickness = 1

local WMiconLetter = Instance.new("TextLabel")
WMiconLetter.Size = UDim2.new(1, 0, 1, 0)
WMiconLetter.BackgroundTransparency = 1
WMiconLetter.Text = "B"
WMiconLetter.TextColor3 = T.Accent
WMiconLetter.Font = Enum.Font.GothamBlack
WMiconLetter.TextSize = 18
WMiconLetter.Parent = WMicon

local WMtitle = Instance.new("TextLabel")
WMtitle.Size = UDim2.new(0, 120, 0, 20)
WMtitle.Position = UDim2.new(0, 42, 0, 6)
WMtitle.BackgroundTransparency = 1
WMtitle.Text = "BIZON HUB"
WMtitle.TextColor3 = T.Text
WMtitle.Font = Enum.Font.GothamBold
WMtitle.TextSize = 12
WMtitle.TextXAlignment = Enum.TextXAlignment.Left
WMtitle.Parent = WMFrame

local WMver = Instance.new("TextLabel")
WMver.Size = UDim2.new(0, 120, 0, 14)
WMver.Position = UDim2.new(0, 42, 0, 22)
WMver.BackgroundTransparency = 1
WMver.Text = "Recode 1.0"
WMver.TextColor3 = T.TextDim2
WMver.Font = Enum.Font.GothamMedium
WMver.TextSize = 9
WMver.TextXAlignment = Enum.TextXAlignment.Left
WMver.Parent = WMFrame

local WMsep = Instance.new("Frame")
WMsep.Size = UDim2.new(0, 1, 0, 22)
WMsep.Position = UDim2.new(0, 172, 0.5, -11)
WMsep.BackgroundColor3 = T.Stroke
WMsep.BorderSizePixel = 0
WMsep.Parent = WMFrame

local WMfps = Instance.new("TextLabel")
WMfps.Size = UDim2.new(0, 55, 1, 0)
WMfps.Position = UDim2.new(0, 180, 0, 0)
WMfps.BackgroundTransparency = 1
WMfps.Text = "FPS: --"
WMfps.TextColor3 = T.Text
WMfps.Font = Enum.Font.GothamBold
WMfps.TextSize = 10
WMfps.TextXAlignment = Enum.TextXAlignment.Left
WMfps.Parent = WMFrame

local WMping = Instance.new("TextLabel")
WMping.Size = UDim2.new(0, 55, 1, 0)
WMping.Position = UDim2.new(0, 240, 0, 0)
WMping.BackgroundTransparency = 1
WMping.Text = "PING: --"
WMping.TextColor3 = T.Text
WMping.Font = Enum.Font.GothamBold
WMping.TextSize = 10
WMping.TextXAlignment = Enum.TextXAlignment.Left
WMping.Parent = WMFrame

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

-- ============================================
-- TOOLTIP
-- ============================================
local TooltipGui = Instance.new("ScreenGui")
TooltipGui.Name = "BizonTooltip"
TooltipGui.ResetOnSpawn = false
TooltipGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
TooltipGui.IgnoreGuiInset = true
TooltipGui.DisplayOrder = 9999
TooltipGui.Parent = player:WaitForChild("PlayerGui")

local Tooltip = Instance.new("Frame")
Tooltip.Size = UDim2.new(0, 260, 0, 60)
Tooltip.BackgroundColor3 = T.Bg2
Tooltip.BackgroundTransparency = 0.05
Tooltip.BorderSizePixel = 0
Tooltip.Visible = false
Tooltip.ZIndex = 100
Tooltip.Parent = TooltipGui
Instance.new("UICorner", Tooltip).CornerRadius = UDim.new(0, 8)

local TTstroke = Instance.new("UIStroke", Tooltip)
TTstroke.Color = T.Accent
TTstroke.Thickness = 1.5
TTstroke.Transparency = 0.3

local TTpadding = Instance.new("UIPadding", Tooltip)
TTpadding.PaddingTop = UDim.new(0, 10)
TTpadding.PaddingBottom = UDim.new(0, 10)
TTpadding.PaddingLeft = UDim.new(0, 14)
TTpadding.PaddingRight = UDim.new(0, 14)

local TTTitle = Instance.new("TextLabel")
TTTitle.Size = UDim2.new(1, 0, 0, 18)
TTTitle.BackgroundTransparency = 1
TTTitle.Text = ""
TTTitle.TextColor3 = T.Accent
TTTitle.Font = Enum.Font.GothamBold
TTTitle.TextSize = 12
TTTitle.TextXAlignment = Enum.TextXAlignment.Left
TTTitle.Parent = Tooltip

local TTDesc = Instance.new("TextLabel")
TTDesc.Size = UDim2.new(1, 0, 0, 30)
TTDesc.Position = UDim2.new(0, 0, 0, 22)
TTDesc.BackgroundTransparency = 1
TTDesc.Text = ""
TTDesc.TextColor3 = T.Text
TTDesc.Font = Enum.Font.Gotham
TTDesc.TextSize = 10
TTDesc.TextXAlignment = Enum.TextXAlignment.Left
TTDesc.TextYAlignment = Enum.TextYAlignment.Top
TTDesc.TextWrapped = true
TTDesc.Parent = Tooltip

function Hub.showTooltip(title, description)
    TTTitle.Text = title
    TTDesc.Text = description or ""
    local descHeight = math.max(14, math.ceil(#(description or "") / 34) * 15)
    TTDesc.Size = UDim2.new(1, 0, 0, descHeight)
    Tooltip.Size = UDim2.new(0, 260, 0, 20 + descHeight + 10)
end

local tooltipActive = false

Hub.addConnection(UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and tooltipActive then
        local mousePos = UserInputService:GetMouseLocation()
        local vp = workspace.CurrentCamera.ViewportSize
        local x = mousePos.X + 15
        local y = mousePos.Y + 15
        local w = 260
        local h = Tooltip.AbsoluteSize.Y
        if x + w > vp.X then x = mousePos.X - w - 15 end
        if y + h > vp.Y then y = mousePos.Y - h - 15 end
        Tooltip.Position = UDim2.new(0, x, 0, y)
    end
end))

function Hub.attachTooltip(element, title, description)
    if not title then return end
    element.MouseEnter:Connect(function()
        tooltipActive = true
        Hub.showTooltip(title, description or "")
        Tooltip.Visible = true
        TweenService:Create(Tooltip, TweenInfo.new(0.15), {BackgroundTransparency = 0.05}):Play()
    end)
    element.MouseLeave:Connect(function()
        tooltipActive = false
        TweenService:Create(Tooltip, TweenInfo.new(0.15), {BackgroundTransparency = 0.5}):Play()
        task.wait(0.15)
        if not tooltipActive then Tooltip.Visible = false end
    end)
end

-- ============================================
-- FLOAT BUTTON
-- ============================================
local FloatBtn = Instance.new("TextButton")
FloatBtn.Size = UDim2.new(0, 56, 0, 56)
FloatBtn.Position = UDim2.new(0, 20, 0.5, -28)
FloatBtn.BackgroundColor3 = T.Bg2
FloatBtn.BackgroundTransparency = 0.1
FloatBtn.Text = ""
FloatBtn.BorderSizePixel = 0
FloatBtn.AutoButtonColor = false
FloatBtn.Parent = ScreenGui
Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(1, 0)

local FBletter = Instance.new("TextLabel")
FBletter.Size = UDim2.new(1, 0, 1, 0)
FBletter.BackgroundTransparency = 1
FBletter.Text = "B"
FBletter.TextColor3 = T.Accent
FBletter.Font = Enum.Font.GothamBlack
FBletter.TextSize = 30
FBletter.Parent = FloatBtn

local FBstroke = Instance.new("UIStroke", FloatBtn)
FBstroke.Color = T.Accent
FBstroke.Thickness = 1.5

local FBglow = Instance.new("UIStroke", FloatBtn)
FBglow.Color = T.AccentGlow
FBglow.Thickness = 6
FBglow.Transparency = 0.7

task.spawn(function()
    while FloatBtn.Parent and not Hub.IsPanicked do
        TweenService:Create(FBglow, TweenInfo.new(1.8, Enum.EasingStyle.Sine), {Transparency = 0.9, Thickness = 10}):Play()
        task.wait(1.8)
        if Hub.IsPanicked then break end
        TweenService:Create(FBglow, TweenInfo.new(1.8, Enum.EasingStyle.Sine), {Transparency = 0.7, Thickness = 6}):Play()
        task.wait(1.8)
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

-- ============================================
-- MAIN FRAME
-- ============================================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 860, 0, 580)
MainFrame.Position = UDim2.new(0.5, -430, 0.5, -290)
MainFrame.BackgroundColor3 = T.Bg
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 18)

local MFstroke = Instance.new("UIStroke", MainFrame)
MFstroke.Color = T.StrokeLight
MFstroke.Thickness = 1
MFstroke.Transparency = 0.5

Hub.MainFrame = MainFrame

-- HEADER
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 56)
Header.BackgroundColor3 = T.Bg2
Header.BackgroundTransparency = 0.3
Header.BorderSizePixel = 0
Header.Parent = MainFrame
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 18)

local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 18)
HeaderFix.Position = UDim2.new(0, 0, 1, -18)
HeaderFix.BackgroundColor3 = T.Bg2
HeaderFix.BackgroundTransparency = 0.3
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = Header

local HeaderLogo = Instance.new("Frame")
HeaderLogo.Size = UDim2.new(0, 30, 0, 30)
HeaderLogo.Position = UDim2.new(0, 20, 0.5, -15)
HeaderLogo.BackgroundColor3 = T.Bg
HeaderLogo.BorderSizePixel = 0
HeaderLogo.Parent = Header
Instance.new("UICorner", HeaderLogo).CornerRadius = UDim.new(1, 0)

local HeaderLogoStroke = Instance.new("UIStroke", HeaderLogo)
HeaderLogoStroke.Color = T.Accent
HeaderLogoStroke.Thickness = 1

local HeaderLogoLetter = Instance.new("TextLabel")
HeaderLogoLetter.Size = UDim2.new(1, 0, 1, 0)
HeaderLogoLetter.BackgroundTransparency = 1
HeaderLogoLetter.Text = "B"
HeaderLogoLetter.TextColor3 = T.Accent
HeaderLogoLetter.Font = Enum.Font.GothamBlack
HeaderLogoLetter.TextSize = 16
HeaderLogoLetter.Parent = HeaderLogo

local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Size = UDim2.new(0, 200, 0, 20)
HeaderTitle.Position = UDim2.new(0, 58, 0, 12)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Text = "BIZON HUB"
HeaderTitle.TextColor3 = T.Text
HeaderTitle.Font = Enum.Font.GothamBlack
HeaderTitle.TextSize = 15
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
HeaderTitle.Parent = Header

local HeaderSub = Instance.new("TextLabel")
HeaderSub.Size = UDim2.new(0, 200, 0, 14)
HeaderSub.Position = UDim2.new(0, 58, 0, 30)
HeaderSub.BackgroundTransparency = 1
HeaderSub.Text = "Recode 1.0"
HeaderSub.TextColor3 = T.TextDim2
HeaderSub.Font = Enum.Font.GothamMedium
HeaderSub.TextSize = 9
HeaderSub.TextXAlignment = Enum.TextXAlignment.Left
HeaderSub.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -44, 0.5, -16)
CloseBtn.BackgroundColor3 = T.Bg3
CloseBtn.Text = "X"
CloseBtn.TextColor3 = T.TextDim
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.BorderSizePixel = 0
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = Header
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)

CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = T.Danger, TextColor3 = Color3.new(1,1,1)}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = T.Bg3, TextColor3 = T.TextDim}):Play()
end)
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

-- SIDEBAR
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 180, 1, -80)
Sidebar.Position = UDim2.new(0, 12, 0, 68)
Sidebar.BackgroundColor3 = T.Bg2
Sidebar.BackgroundTransparency = 0.4
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 14)

local TabList = Instance.new("UIListLayout", Sidebar)
TabList.Padding = UDim.new(0, 4)
TabList.SortOrder = Enum.SortOrder.LayoutOrder

local TabPad = Instance.new("UIPadding", Sidebar)
TabPad.PaddingTop = UDim.new(0, 10)
TabPad.PaddingLeft = UDim.new(0, 8)
TabPad.PaddingRight = UDim.new(0, 8)

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -212, 1, -80)
Content.Position = UDim2.new(0, 200, 0, 68)
Content.BackgroundColor3 = T.Bg2
Content.BackgroundTransparency = 0.4
Content.BorderSizePixel = 0
Content.Parent = MainFrame
Instance.new("UICorner", Content).CornerRadius = UDim.new(0, 14)

local ContentHeader = Instance.new("Frame")
ContentHeader.Size = UDim2.new(1, 0, 0, 50)
ContentHeader.BackgroundTransparency = 1
ContentHeader.Parent = Content

local ContentTitle = Instance.new("TextLabel")
ContentTitle.Size = UDim2.new(1, -40, 0, 24)
ContentTitle.Position = UDim2.new(0, 20, 0, 14)
ContentTitle.BackgroundTransparency = 1
ContentTitle.Text = "Speed"
ContentTitle.TextColor3 = T.Text
ContentTitle.Font = Enum.Font.GothamBlack
ContentTitle.TextSize = 18
ContentTitle.TextXAlignment = Enum.TextXAlignment.Left
ContentTitle.Parent = ContentHeader

local ContentSub = Instance.new("TextLabel")
ContentSub.Size = UDim2.new(1, -40, 0, 14)
ContentSub.Position = UDim2.new(0, 20, 0, 34)
ContentSub.BackgroundTransparency = 1
ContentSub.Text = ""
ContentSub.TextColor3 = T.TextDim
ContentSub.Font = Enum.Font.GothamMedium
ContentSub.TextSize = 10
ContentSub.TextXAlignment = Enum.TextXAlignment.Left
ContentSub.Parent = ContentHeader

-- TABS
Hub.Tabs = {}
Hub.CurrentTab = nil
Hub.TabInfo = {
    Speed = "Настройки скорости и движения",
    Teleport = "Телепорт в миры и точки",
    Auto = "Автоматизация действий",
    Misc = "Прочие функции",
}

function Hub.switchTab(name)
    if Hub.CurrentTab == name then return end
    if Hub.CurrentTab and Hub.Tabs[Hub.CurrentTab] then
        Hub.Tabs[Hub.CurrentTab].container.Visible = false
        local oldBtn = Hub.Tabs[Hub.CurrentTab].button
        oldBtn.BackgroundColor3 = T.Bg3
        oldBtn.TextColor3 = T.TextDim
        local oldIndicator = oldBtn:FindFirstChild("Indicator")
        if oldIndicator then oldIndicator.BackgroundTransparency = 1 end
    end
    Hub.CurrentTab = name
    if Hub.Tabs[name] then
        Hub.Tabs[name].container.Visible = true
        local newBtn = Hub.Tabs[name].button
        newBtn.BackgroundColor3 = T.Bg4
        newBtn.TextColor3 = T.Accent
        local newIndicator = newBtn:FindFirstChild("Indicator")
        if newIndicator then newIndicator.BackgroundTransparency = 0 end
    end
    ContentTitle.Text = name
    ContentSub.Text = Hub.TabInfo[name] or ""
end

function Hub.createTab(name, icon)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, 0, 0, 40)
    tabBtn.BackgroundColor3 = T.Bg3
    tabBtn.BackgroundTransparency = 0.3
    tabBtn.Text = name
    tabBtn.TextColor3 = T.TextDim
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextSize = 14
    tabBtn.TextXAlignment = Enum.TextXAlignment.Left
    tabBtn.BorderSizePixel = 0
    tabBtn.AutoButtonColor = false
    tabBtn.Parent = Sidebar
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 10)
    
    local Tpad = Instance.new("UIPadding", tabBtn)
    Tpad.PaddingLeft = UDim.new(0, 16)
    
    local Indicator = Instance.new("Frame")
    Indicator.Name = "Indicator"
    Indicator.Size = UDim2.new(0, 3, 0, 20)
    Indicator.Position = UDim2.new(0, 0, 0.5, -10)
    Indicator.BackgroundColor3 = T.Accent
    Indicator.BackgroundTransparency = 1
    Indicator.BorderSizePixel = 0
    Indicator.Parent = tabBtn
    Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)
    
    local container = Instance.new("ScrollingFrame")
    container.Size = UDim2.new(1, -16, 1, -70)
    container.Position = UDim2.new(0, 8, 0, 56)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.ScrollBarThickness = 3
    container.ScrollBarImageColor3 = T.Accent
    container.ScrollBarImageTransparency = 0.4
    container.CanvasSize = UDim2.new(0, 0, 0, 0)
    container.Visible = false
    container.Parent = Content
    
    local layout = Instance.new("UIListLayout", container)
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local pad = Instance.new("UIPadding", container)
    pad.PaddingTop = UDim.new(0, 6)
    pad.PaddingBottom = UDim.new(0, 10)
    pad.PaddingLeft = UDim.new(0, 6)
    pad.PaddingRight = UDim.new(0, 10)
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
    end)
    
    Hub.Tabs[name] = {button = tabBtn, container = container}
    tabBtn.MouseButton1Click:Connect(function() Hub.switchTab(name) end)
    
    tabBtn.MouseEnter:Connect(function()
        if Hub.CurrentTab ~= name then
            tabBtn.BackgroundColor3 = T.Bg4
            tabBtn.TextColor3 = T.Text
        end
    end)
    tabBtn.MouseLeave:Connect(function()
        if Hub.CurrentTab ~= name then
            tabBtn.BackgroundColor3 = T.Bg3
            tabBtn.TextColor3 = T.TextDim
        end
    end)
    
    return container
end

-- SETTINGS PANEL
local SettingsPanel = Instance.new("Frame")
SettingsPanel.Size = UDim2.new(0, 300, 0, 0)
SettingsPanel.BackgroundColor3 = T.Bg2
SettingsPanel.BackgroundTransparency = 0.05
SettingsPanel.BorderSizePixel = 0
SettingsPanel.Visible = false
SettingsPanel.ZIndex = 50
SettingsPanel.Parent = ScreenGui
Instance.new("UICorner", SettingsPanel).CornerRadius = UDim.new(0, 12)

local SPstroke = Instance.new("UIStroke", SettingsPanel)
SPstroke.Color = T.Accent
SPstroke.Thickness = 1
SPstroke.Transparency = 0.4

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
    SettingsPanel.Size = UDim2.new(0, 300, 0, math.clamp(SPLayout.AbsoluteContentSize.Y + 20, 60, 500))
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
    SettingsPanel.Position = UDim2.new(0, pos.X + size.X + 12, 0, pos.Y)
    SettingsPanel.Size = UDim2.new(0, 300, 0, 0)
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
    if menuOpen then
        MainFrame.Size = UDim2.new(0, 860, 0, 0)
        MainFrame.BackgroundTransparency = 1
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
            Size = UDim2.new(0, 860, 0, 580),
            BackgroundTransparency = 0.05,
        }):Play()
        if not Hub.CurrentTab and Hub.Tabs["Speed"] then
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

print("[Bizon Hub] Core — Recode 1.0 загружен")
