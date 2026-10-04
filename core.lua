-- 🐗 Bizon Hub Core v5.4 (Fixed)
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
    Bg = Color3.fromRGB(12, 10, 20),
    Bg2 = Color3.fromRGB(22, 18, 38),
    Bg3 = Color3.fromRGB(32, 26, 52),
    Bg4 = Color3.fromRGB(42, 34, 68),
    Bg5 = Color3.fromRGB(52, 42, 84),
    Accent = Color3.fromRGB(168, 85, 247),
    Accent2 = Color3.fromRGB(126, 34, 206),
    AccentGlow = Color3.fromRGB(200, 130, 255),
    Text = Color3.fromRGB(245, 240, 255),
    TextDim = Color3.fromRGB(150, 140, 175),
    TextDim2 = Color3.fromRGB(100, 92, 125),
    Success = Color3.fromRGB(80, 240, 160),
    Danger = Color3.fromRGB(240, 70, 100),
    Warning = Color3.fromRGB(255, 200, 50),
    Stroke = Color3.fromRGB(65, 55, 95),
    StrokeLight = Color3.fromRGB(95, 80, 140),
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
local oldTT = player.PlayerGui:FindFirstChild("BizonTooltip")
if oldTT then oldTT:Destroy() end

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
WMFrame.Size = UDim2.new(0, 340, 0, 44)
WMFrame.Position = UDim2.new(1, -360, 0, 20)
WMFrame.BackgroundColor3 = T.Bg2
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

local WMiconFrame = Instance.new("Frame")
WMiconFrame.Size = UDim2.new(0, 32, 0, 32)
WMiconFrame.Position = UDim2.new(0, 6, 0.5, -16)
WMiconFrame.BackgroundColor3 = T.Bg
WMiconFrame.BorderSizePixel = 0
WMiconFrame.Parent = WMFrame
Instance.new("UICorner", WMiconFrame).CornerRadius = UDim.new(1, 0)

local WMiconStroke = Instance.new("UIStroke", WMiconFrame)
WMiconStroke.Color = T.Accent
WMiconStroke.Thickness = 1.5

local WMiconLetter = Instance.new("TextLabel")
WMiconLetter.Size = UDim2.new(1, 0, 1, 0)
WMiconLetter.BackgroundTransparency = 1
WMiconLetter.Text = "B"
WMiconLetter.TextColor3 = Color3.fromRGB(255, 255, 255)
WMiconLetter.Font = Enum.Font.GothamBlack
WMiconLetter.TextSize = 20
WMiconLetter.Parent = WMiconFrame

local WMiconGrad = Instance.new("UIGradient", WMiconLetter)
WMiconGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 130, 255)),
})
WMiconGrad.Rotation = 90

local WMtitle = Instance.new("TextLabel")
WMtitle.Size = UDim2.new(0, 130, 1, 0)
WMtitle.Position = UDim2.new(0, 44, 0, 0)
WMtitle.BackgroundTransparency = 1
WMtitle.Text = "BIZON HUB"
WMtitle.TextColor3 = T.Accent
WMtitle.Font = Enum.Font.GothamBlack
WMtitle.TextSize = 14
WMtitle.TextXAlignment = Enum.TextXAlignment.Left
WMtitle.Parent = WMFrame

local WMsep1 = Instance.new("Frame")
WMsep1.Size = UDim2.new(0, 1, 0, 22)
WMsep1.Position = UDim2.new(0, 178, 0.5, -11)
WMsep1.BackgroundColor3 = T.Stroke
WMsep1.BorderSizePixel = 0
WMsep1.Parent = WMFrame

local WMfps = Instance.new("TextLabel")
WMfps.Size = UDim2.new(0, 60, 1, 0)
WMfps.Position = UDim2.new(0, 186, 0, 0)
WMfps.BackgroundTransparency = 1
WMfps.Text = "FPS: --"
WMfps.TextColor3 = T.Text
WMfps.Font = Enum.Font.GothamBold
WMfps.TextSize = 11
WMfps.TextXAlignment = Enum.TextXAlignment.Left
WMfps.Parent = WMFrame

local WMping = Instance.new("TextLabel")
WMping.Size = UDim2.new(0, 60, 1, 0)
WMping.Position = UDim2.new(0, 250, 0, 0)
WMping.BackgroundTransparency = 1
WMping.Text = "PING: --"
WMping.TextColor3 = T.Text
WMping.Font = Enum.Font.GothamBold
WMping.TextSize = 11
WMping.TextXAlignment = Enum.TextXAlignment.Left
WMping.Parent = WMFrame

local WMver = Instance.new("TextLabel")
WMver.Size = UDim2.new(0, 40, 1, 0)
WMver.Position = UDim2.new(1, -44, 0, 0)
WMver.BackgroundTransparency = 1
WMver.Text = "v5.4"
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

-- ============================================
-- TOOLTIP SYSTEM
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
Instance.new("UICorner", Tooltip).CornerRadius = UDim.new(0, 10)

local TTstroke = Instance.new("UIStroke", Tooltip)
TTstroke.Color = T.Accent
TTstroke.Thickness = 1.5
TTstroke.Transparency = 0.3

local TTglow = Instance.new("UIStroke", Tooltip)
TTglow.Color = T.AccentGlow
TTglow.Thickness = 4
TTglow.Transparency = 0.8

local TTpadding = Instance.new("UIPadding", Tooltip)
TTpadding.PaddingTop = UDim.new(0, 10)
TTpadding.PaddingBottom = UDim.new(0, 10)
TTpadding.PaddingLeft = UDim.new(0, 14)
TTpadding.PaddingRight = UDim.new(0, 14)

local TTTitle = Instance.new("TextLabel")
TTTitle.Size = UDim2.new(1, 0, 0, 18)
TTTitle.BackgroundTransparency = 1
TTTitle.Text = "Заголовок"
TTTitle.TextColor3 = T.Accent
TTTitle.Font = Enum.Font.GothamBold
TTTitle.TextSize = 13
TTTitle.TextXAlignment = Enum.TextXAlignment.Left
TTTitle.Parent = Tooltip

local TTDesc = Instance.new("TextLabel")
TTDesc.Size = UDim2.new(1, 0, 0, 30)
TTDesc.Position = UDim2.new(0, 0, 0, 22)
TTDesc.BackgroundTransparency = 1
TTDesc.Text = "Описание"
TTDesc.TextColor3 = T.Text
TTDesc.Font = Enum.Font.Gotham
TTDesc.TextSize = 11
TTDesc.TextXAlignment = Enum.TextXAlignment.Left
TTDesc.TextYAlignment = Enum.TextYAlignment.Top
TTDesc.TextWrapped = true
TTDesc.Parent = Tooltip

function Hub.showTooltip(title, description)
    TTTitle.Text = title
    TTDesc.Text = description or ""
    local descHeight = math.max(16, math.ceil(#(description or "") / 32) * 16)
    TTDesc.Size = UDim2.new(1, 0, 0, descHeight)
    Tooltip.Size = UDim2.new(0, 260, 0, 22 + descHeight + 10)
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
        Tooltip.BackgroundTransparency = 0.3
        TweenService:Create(Tooltip, TweenInfo.new(0.2), {BackgroundTransparency = 0.05}):Play()
    end)
    element.MouseLeave:Connect(function()
        tooltipActive = false
        TweenService:Create(Tooltip, TweenInfo.new(0.15), {BackgroundTransparency = 0.5}):Play()
        task.wait(0.15)
        if not tooltipActive then Tooltip.Visible = false end
    end)
end

Hub.Tooltip = Tooltip

-- ============================================
-- FLOAT BUTTON
-- ============================================
local FloatBtn = Instance.new("TextButton")
FloatBtn.Size = UDim2.new(0, 60, 0, 60)
FloatBtn.Position = UDim2.new(0, 20, 0.5, -30)
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
FBletter.TextColor3 = Color3.fromRGB(255, 255, 255)
FBletter.Font = Enum.Font.GothamBlack
FBletter.TextSize = 34
FBletter.Parent = FloatBtn

local FBgrad = Instance.new("UIGradient", FBletter)
FBgrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 130, 255)),
})
FBgrad.Rotation = 90

local FBstroke = Instance.new("UIStroke", FloatBtn)
FBstroke.Color = T.Accent
FBstroke.Thickness = 2

local FBglow = Instance.new("UIStroke", FloatBtn)
FBglow.Color = T.AccentGlow
FBglow.Thickness = 8
FBglow.Transparency = 0.75

task.spawn(function()
    while FloatBtn.Parent and not Hub.IsPanicked do
        TweenService:Create(FBglow, TweenInfo.new(1.5), {Transparency = 0.95, Thickness = 14}):Play()
        task.wait(1.5)
        if Hub.IsPanicked then break end
        TweenService:Create(FBglow, TweenInfo.new(1.5), {Transparency = 0.6, Thickness = 8}):Play()
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

-- ============================================
-- MAIN FRAME
-- ============================================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 900, 0, 600)
MainFrame.Position = UDim2.new(0.5, -450, 0.5, -300)
MainFrame.BackgroundColor3 = T.Bg
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 24)

local MFstroke = Instance.new("UIStroke", MainFrame)
MFstroke.Color = T.StrokeLight
MFstroke.Thickness = 1.5
MFstroke.Transparency = 0.4

local MFglow = Instance.new("UIStroke", MainFrame)
MFglow.Color = T.AccentGlow
MFglow.Thickness = 10
MFglow.Transparency = 0.9

Hub.MainFrame = MainFrame

-- SIDEBAR
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 200, 1, 0)
Sidebar.BackgroundColor3 = T.Bg2
Sidebar.BackgroundTransparency = 0.3
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 24)

local SidebarFix = Instance.new("Frame")
SidebarFix.Size = UDim2.new(0, 20, 1, -48)
SidebarFix.Position = UDim2.new(1, -20, 0, 24)
SidebarFix.BackgroundColor3 = T.Bg2
SidebarFix.BackgroundTransparency = 0.3
SidebarFix.BorderSizePixel = 0
SidebarFix.Parent = Sidebar

local LogoBox = Instance.new("Frame")
LogoBox.Size = UDim2.new(1, -24, 0, 60)
LogoBox.Position = UDim2.new(0, 12, 0, 16)
LogoBox.BackgroundTransparency = 1
LogoBox.Parent = Sidebar

local LogoIcon = Instance.new("Frame")
LogoIcon.Size = UDim2.new(0, 44, 1, 0)
LogoIcon.Position = UDim2.new(0, 4, 0, 0)
LogoIcon.BackgroundColor3 = T.Bg
LogoIcon.BorderSizePixel = 0
LogoIcon.Parent = LogoBox
Instance.new("UICorner", LogoIcon).CornerRadius = UDim.new(1, 0)

local LogoStroke = Instance.new("UIStroke", LogoIcon)
LogoStroke.Color = T.Accent
LogoStroke.Thickness = 1.5

local LogoLetter = Instance.new("TextLabel")
LogoLetter.Size = UDim2.new(1, 0, 1, 0)
LogoLetter.BackgroundTransparency = 1
LogoLetter.Text = "B"
LogoLetter.TextColor3 = Color3.fromRGB(255, 255, 255)
LogoLetter.Font = Enum.Font.GothamBlack
LogoLetter.TextSize = 28
LogoLetter.Parent = LogoIcon

local LogoGrad = Instance.new("UIGradient", LogoLetter)
LogoGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 130, 255)),
})
LogoGrad.Rotation = 90

local LogoText = Instance.new("TextLabel")
LogoText.Size = UDim2.new(1, -60, 0, 24)
LogoText.Position = UDim2.new(0, 56, 0, 6)
LogoText.BackgroundTransparency = 1
LogoText.Text = "Bizon Hub"
LogoText.TextColor3 = T.Text
LogoText.Font = Enum.Font.GothamBlack
LogoText.TextSize = 18
LogoText.TextXAlignment = Enum.TextXAlignment.Left
LogoText.Parent = LogoBox

local LogoSub = Instance.new("TextLabel")
LogoSub.Size = UDim2.new(1, -60, 0, 16)
LogoSub.Position = UDim2.new(0, 56, 0, 28)
LogoSub.BackgroundTransparency = 1
LogoSub.Text = "v5.4 • Premium"
LogoSub.TextColor3 = T.TextDim2
LogoSub.Font = Enum.Font.GothamMedium
LogoSub.TextSize = 10
LogoSub.TextXAlignment = Enum.TextXAlignment.Left
LogoSub.Parent = LogoBox

local LogoLine = Instance.new("Frame")
LogoLine.Size = UDim2.new(1, -24, 0, 1)
LogoLine.Position = UDim2.new(0, 12, 0, 88)
LogoLine.BackgroundColor3 = T.Stroke
LogoLine.BackgroundTransparency = 0.5
LogoLine.BorderSizePixel = 0
LogoLine.Parent = Sidebar

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -24, 1, -140)
TabBar.Position = UDim2.new(0, 12, 0, 104)
TabBar.BackgroundTransparency = 1
TabBar.Parent = Sidebar

local TabLayout = Instance.new("UIListLayout", TabBar)
TabLayout.Padding = UDim.new(0, 6)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -232, 1, -100)
Content.Position = UDim2.new(0, 216, 0, 24)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

local ContentHeader = Instance.new("Frame")
ContentHeader.Size = UDim2.new(1, 0, 0, 56)
ContentHeader.BackgroundTransparency = 1
ContentHeader.Parent = Content

local ContentTitle = Instance.new("TextLabel")
ContentTitle.Size = UDim2.new(1, -120, 0, 32)
ContentTitle.Position = UDim2.new(0, 0, 0, 6)
ContentTitle.BackgroundTransparency = 1
ContentTitle.Text = "Speed"
ContentTitle.TextColor3 = T.Text
ContentTitle.Font = Enum.Font.GothamBlack
ContentTitle.TextSize = 22
ContentTitle.TextXAlignment = Enum.TextXAlignment.Left
ContentTitle.Parent = ContentHeader

local ContentSub = Instance.new("TextLabel")
ContentSub.Size = UDim2.new(1, -120, 0, 18)
ContentSub.Position = UDim2.new(0, 0, 0, 34)
ContentSub.BackgroundTransparency = 1
ContentSub.Text = "Настройки скорости персонажа"
ContentSub.TextColor3 = T.TextDim
ContentSub.Font = Enum.Font.GothamMedium
ContentSub.TextSize = 11
ContentSub.TextXAlignment = Enum.TextXAlignment.Left
ContentSub.Parent = ContentHeader

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 36, 0, 36)
CloseBtn.Position = UDim2.new(1, -36, 0, 10)
CloseBtn.BackgroundColor3 = T.Bg3
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = T.TextDim
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 15
CloseBtn.BorderSizePixel = 0
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = ContentHeader
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = T.Danger, TextColor3 = Color3.new(1,1,1)}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = T.Bg3, TextColor3 = T.TextDim}):Play()
end)
CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

local winDrag, winStart, winStartPos
Hub.addConnection(ContentHeader.InputBegan:Connect(function(input)
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

Hub.Tabs = {}
Hub.CurrentTab = nil
Hub.TabInfo = {
    Speed = "Настройки скорости персонажа",
    Jump = "Настройки прыжка",
    Fly = "Полёт в любую сторону",
    Teleport = "Быстрый телепорт и сохранение точек",
    Worlds = "Телепорт в любой мир",
    Auto = "Автоматизация всех действий",
    Misc = "Прочие функции и Skybox",
}

function Hub.switchTab(name)
    if Hub.CurrentTab == name then return end
    if Hub.CurrentTab and Hub.Tabs[Hub.CurrentTab] then
        Hub.Tabs[Hub.CurrentTab].container.Visible = false
        local oldBtn = Hub.Tabs[Hub.CurrentTab].button
        TweenService:Create(oldBtn, TweenInfo.new(0.2), {BackgroundColor3 = T.Bg3, BackgroundTransparency = 1}):Play()
        if oldBtn:FindFirstChild("Indicator") then
            TweenService:Create(oldBtn.Indicator, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        end
        if oldBtn:FindFirstChild("IconLbl") then
            TweenService:Create(oldBtn.IconLbl, TweenInfo.new(0.2), {TextColor3 = T.TextDim}):Play()
        end
        if oldBtn:FindFirstChild("NameLbl") then
            TweenService:Create(oldBtn.NameLbl, TweenInfo.new(0.2), {TextColor3 = T.TextDim}):Play()
        end
    end
    Hub.CurrentTab = name
    if Hub.Tabs[name] then
        Hub.Tabs[name].container.Visible = true
        local newBtn = Hub.Tabs[name].button
        TweenService:Create(newBtn, TweenInfo.new(0.25), {BackgroundColor3 = T.Accent, BackgroundTransparency = 0.85}):Play()
        if newBtn:FindFirstChild("Indicator") then
            TweenService:Create(newBtn.Indicator, TweenInfo.new(0.25), {BackgroundTransparency = 0}):Play()
        end
        if newBtn:FindFirstChild("IconLbl") then
            TweenService:Create(newBtn.IconLbl, TweenInfo.new(0.25), {TextColor3 = T.Text}):Play()
        end
        if newBtn:FindFirstChild("NameLbl") then
            TweenService:Create(newBtn.NameLbl, TweenInfo.new(0.25), {TextColor3 = T.Text}):Play()
        end
    end
    ContentTitle.Text = name
    ContentSub.Text = Hub.TabInfo[name] or ""
end

function Hub.createTab(name, icon)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, 0, 0, 44)
    tabBtn.BackgroundColor3 = T.Bg3
    tabBtn.BackgroundTransparency = 1
    tabBtn.Text = ""
    tabBtn.BorderSizePixel = 0
    tabBtn.AutoButtonColor = false
    tabBtn.Parent = TabBar
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 10)
    
    local Indicator = Instance.new("Frame")
    Indicator.Name = "Indicator"
    Indicator.Size = UDim2.new(0, 3, 0, 20)
    Indicator.Position = UDim2.new(0, 0, 0.5, -10)
    Indicator.BackgroundColor3 = T.Accent
    Indicator.BackgroundTransparency = 1
    Indicator.BorderSizePixel = 0
    Indicator.Parent = tabBtn
    Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)
    
    local IconLbl = Instance.new("TextLabel")
    IconLbl.Name = "IconLbl"
    IconLbl.Size = UDim2.new(0, 30, 1, 0)
    IconLbl.Position = UDim2.new(0, 12, 0, 0)
    IconLbl.BackgroundTransparency = 1
    IconLbl.Text = icon or "•"
    IconLbl.TextColor3 = T.TextDim
    IconLbl.Font = Enum.Font.GothamBold
    IconLbl.TextSize = 16
    IconLbl.Parent = tabBtn
    
    local NameLbl = Instance.new("TextLabel")
    NameLbl.Name = "NameLbl"
    NameLbl.Size = UDim2.new(1, -50, 1, 0)
    NameLbl.Position = UDim2.new(0, 44, 0, 0)
    NameLbl.BackgroundTransparency = 1
    NameLbl.Text = name
    NameLbl.TextColor3 = T.TextDim
    NameLbl.Font = Enum.Font.GothamBold
    NameLbl.TextSize = 13
    NameLbl.TextXAlignment = Enum.TextXAlignment.Left
    NameLbl.Parent = tabBtn
    
    local container = Instance.new("ScrollingFrame")
    container.Size = UDim2.new(1, 0, 1, -72)
    container.Position = UDim2.new(0, 0, 0, 72)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.ScrollBarThickness = 4
    container.ScrollBarImageColor3 = T.Accent
    container.ScrollBarImageTransparency = 0.3
    container.CanvasSize = UDim2.new(0, 0, 0, 0)
    container.Visible = false
    container.Parent = Content
    
    local layout = Instance.new("UIListLayout", container)
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local pad = Instance.new("UIPadding", container)
    pad.PaddingTop = UDim.new(0, 4)
    pad.PaddingBottom = UDim.new(0, 12)
    pad.PaddingLeft = UDim.new(0, 4)
    pad.PaddingRight = UDim.new(0, 12)
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
    end)
    
    Hub.Tabs[name] = {button = tabBtn, container = container}
    tabBtn.MouseButton1Click:Connect(function() Hub.switchTab(name) end)
    
    tabBtn.MouseEnter:Connect(function()
        if Hub.CurrentTab ~= name then
            TweenService:Create(tabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play()
            TweenService:Create(IconLbl, TweenInfo.new(0.2), {TextColor3 = T.Text}):Play()
            TweenService:Create(NameLbl, TweenInfo.new(0.2), {TextColor3 = T.Text}):Play()
        end
    end)
    tabBtn.MouseLeave:Connect(function()
        if Hub.CurrentTab ~= name then
            TweenService:Create(tabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
            TweenService:Create(IconLbl, TweenInfo.new(0.2), {TextColor3 = T.TextDim}):Play()
            TweenService:Create(NameLbl, TweenInfo.new(0.2), {TextColor3 = T.TextDim}):Play()
        end
    end)
    return container
end

-- SETTINGS PANEL
local SettingsPanel = Instance.new("Frame")
SettingsPanel.Size = UDim2.new(0, 320, 0, 0)
SettingsPanel.BackgroundColor3 = T.Bg2
SettingsPanel.BackgroundTransparency = 0.05
SettingsPanel.BorderSizePixel = 0
SettingsPanel.Visible = false
SettingsPanel.ZIndex = 50
SettingsPanel.Parent = ScreenGui
Instance.new("UICorner", SettingsPanel).CornerRadius = UDim.new(0, 16)

local SPstroke = Instance.new("UIStroke", SettingsPanel)
SPstroke.Color = T.Accent
SPstroke.Thickness = 1.5
SPstroke.Transparency = 0.3

local SPContent = Instance.new("ScrollingFrame")
SPContent.Size = UDim2.new(1, -16, 1, -16)
SPContent.Position = UDim2.new(0, 8, 0, 8)
SPContent.BackgroundTransparency = 1
SPContent.BorderSizePixel = 0
SPContent.ScrollBarThickness = 4
SPContent.ScrollBarImageColor3 = T.Accent
SPContent.CanvasSize = UDim2.new(0, 0, 0, 0)
SPContent.Parent = SettingsPanel

local SPLayout = Instance.new("UIListLayout", SPContent)
SPLayout.Padding = UDim.new(0, 8)

SPLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    SPContent.CanvasSize = UDim2.new(0, 0, 0, SPLayout.AbsoluteContentSize.Y + 12)
    SettingsPanel.Size = UDim2.new(0, 320, 0, math.clamp(SPLayout.AbsoluteContentSize.Y + 20, 60, 500))
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
    SettingsPanel.Size = UDim2.new(0, 320, 0, 0)
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
        MainFrame.Size = UDim2.new(0, 900, 0, 0)
        MainFrame.BackgroundTransparency = 1
        TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 900, 0, 600),
            BackgroundTransparency = 0.05,
        }):Play()
        if not Hub.CurrentTab and Hub.Tabs["Speed"] then
            Hub.switchTab("Speed")
        end
    end
end

FloatBtn.MouseButton1Click:Connect(Hub.toggleMenu)

-- ⚠️ ВАЖНО: InputBegan (не InputBegin!)
Hub.addConnection(UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        Hub.toggleMenu()
    end
end))

print("🐗 Core v5.4 загружен")
