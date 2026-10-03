-- 🐗 Bizon Hub Core v2.0 — новый дизайн
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
_G.BizonHub = _G.BizonHub or {}

local Hub = _G.BizonHub
Hub.Connections = Hub.Connections or {}
Hub.IsPanicked = false

function Hub.addConnection(conn)
    table.insert(Hub.Connections, conn)
    return conn
end

-- Цвета темы (современная тёмная + оранжевый акцент)
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

-- Удаляем старый GUI
local old = player.PlayerGui:FindFirstChild("BizonHub")
if old then old:Destroy() end

-- === ROOT ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BizonHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = player:WaitForChild("PlayerGui")
Hub.ScreenGui = ScreenGui

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

local FBgrad = Instance.new("UIGradient", FloatBtn)
FBgrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, T.Bg2),
    ColorSequenceKeypoint.new(1, T.Bg),
})
FBgrad.Rotation = 45

-- Drag
local fbDrag, fbStart, fbStartPos
Hub.addConnection(FloatBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        fbDrag = true; fbStart = input.Position; fbStartPos = FloatBtn.Position
    end
end))
Hub.addConnection(UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        fbDrag = false
    end
end))
Hub.addConnection(UserInputService.InputChanged:Connect(function(input)
    if fbDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - fbStart
        FloatBtn.Position = UDim2.new(fbStartPos.X.Scale, fbStartPos.X.Offset + d.X, fbStartPos.Y.Scale, fbStartPos.Y.Offset + d.Y)
    end
end))

-- Pulse animation
task.spawn(function()
    while FloatBtn.Parent and not Hub.IsPanicked do
        TweenService:Create(FBstroke, TweenInfo.new(1.8, Enum.EasingStyle.Sine), {Transparency = 0.7}):Play()
        task.wait(1.8)
        if Hub.IsPanicked then break end
        TweenService:Create(FBstroke, TweenInfo.new(1.8, Enum.EasingStyle.Sine), {Transparency = 0.3}):Play()
        task.wait(1.8)
    end
end)

-- === MAIN FRAME ===
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 540, 0, 380)
MainFrame.Position = UDim2.new(0.5, -270, 0.5, -190)
MainFrame.BackgroundColor3 = T.Bg
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 22)

local MFstroke = Instance.new("UIStroke", MainFrame)
MFstroke.Color = T.Stroke
MFstroke.Thickness = 1.5

local MFgrad = Instance.new("UIGradient", MainFrame)
MFgrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, T.Bg),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 26)),
})
MFgrad.Rotation = 90

Hub.MainFrame = MainFrame

-- === HEADER ===
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

local HBgrad = Instance.new("UIGradient", Header)
HBgrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, T.Bg3),
    ColorSequenceKeypoint.new(1, T.Bg2),
})
HBgrad.Rotation = 0

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0.6, 0, 1, 0)
TitleLabel.Position = UDim2.new(0, 22, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🐗  BIZON HUB"
TitleLabel.TextColor3 = T.Accent
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextSize = 20
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = Header

local Version = Instance.new("TextLabel")
Version.Size = UDim2.new(0, 65, 0, 22)
Version.Position = UDim2.new(0, 210, 0.5, -11)
Version.BackgroundColor3 = T.Accent
Version.BackgroundTransparency = 0.82
Version.Text = "v2.0"
Version.TextColor3 = T.Accent
Version.Font = Enum.Font.GothamBold
Version.TextSize = 11
Version.BorderSizePixel = 0
Version.Parent = Header
Instance.new("UICorner", Version).CornerRadius = UDim.new(1, 0)

-- Close button
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

CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = T.Danger, TextColor3 = Color3.new(1,1,1)}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = T.Bg3, TextColor3 = T.TextDim}):Play()
end)
CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

-- Window drag
local winDrag, winStart, winStartPos
Hub.addConnection(Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        winDrag = true; winStart = input.Position; winStartPos = MainFrame.Position
    end
end))
Hub.addConnection(UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        winDrag = false
    end
end))
Hub.addConnection(UserInputService.InputChanged:Connect(function(input)
    if winDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - winStart
        MainFrame.Position = UDim2.new(winStartPos.X.Scale, winStartPos.X.Offset + d.X, winStartPos.Y.Scale, winStartPos.Y.Offset + d.Y)
    end
end))

-- === TAB BAR (вертикальные табы) ===
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(0, 145, 1, -80)
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

-- Content
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -175, 1, -80)
Content.Position = UDim2.new(0, 163, 0, 68)
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
        TweenService:Create(Tabs[Hub.CurrentTab].button, TweenInfo.new(0.2), {
            BackgroundColor3 = T.Bg2, TextColor3 = T.TextDim
        }):Play()
        Tabs[Hub.CurrentTab].container.Visible = false
    end
    Hub.CurrentTab = name
    TweenService:Create(Tabs[name].button, TweenInfo.new(0.2), {
        BackgroundColor3 = T.Accent, TextColor3 = T.Bg
    }):Play()
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

-- Menu toggle
local menuOpen = false
function Hub.toggleMenu()
    menuOpen = not menuOpen
    MainFrame.Visible = menuOpen
    if menuOpen then
        MainFrame.Size = UDim2.new(0, 540, 0, 0)
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 540, 0, 380)
        }):Play()
        if not Hub.CurrentTab and Tabs["Utilities"] then
            Hub.switchTab("Utilities")
        end
    end
end

FloatBtn.MouseButton1Click:Connect(Hub.toggleMenu)

Hub.addConnection(UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        Hub.toggleMenu()
    end
    if input.KeyCode == Enum.KeyCode.End then
        if Hub.Panic then Hub.Panic() end
    end
end))

print("🐗 Core загружен (v2.0)")
