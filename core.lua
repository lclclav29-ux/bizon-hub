-- 🐗 Bizon Hub Core
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

Hub.Theme = {
    Background = Color3.fromRGB(18, 18, 24),
    Secondary = Color3.fromRGB(28, 28, 38),
    Tertiary = Color3.fromRGB(38, 38, 52),
    Accent = Color3.fromRGB(255, 165, 0),
    Text = Color3.fromRGB(240, 240, 245),
    TextDim = Color3.fromRGB(140, 140, 160),
    Success = Color3.fromRGB(0, 220, 120),
    Danger = Color3.fromRGB(255, 70, 70),
}

Hub.Settings = {
    SpeedEnabled=false, SpeedValue=50, SmoothSpeed=false,
    UseKeybind=false, SpeedKey=Enum.KeyCode.LeftShift,
    SpeedInAir=false, AutoRun=false,
    JumpEnabled=false, JumpValue=100, InfiniteJump=false,
    Noclip=false, Fullbright=false,
    AutoFarmEnabled=false, FarmRange=30, FarmSpeed=30,
    FarmAttackDelay=0.1, FarmTargetName="Pear", FarmUseTool=true,
}

local T = Hub.Theme

-- Уничтожаем старый GUI при перезагрузке
local old = player.PlayerGui:FindFirstChild("BizonHub")
if old then old:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BizonHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = player:WaitForChild("PlayerGui")
Hub.ScreenGui = ScreenGui

-- Float Button
local FloatBtn = Instance.new("TextButton")
FloatBtn.Size = UDim2.new(0, 120, 0, 44)
FloatBtn.Position = UDim2.new(0, 20, 0, 100)
FloatBtn.BackgroundColor3 = T.Background
FloatBtn.Text = "🐗 BIZON HUB"
FloatBtn.TextColor3 = T.Accent
FloatBtn.Font = Enum.Font.GothamBold
FloatBtn.TextSize = 14
FloatBtn.BorderSizePixel = 0
FloatBtn.AutoButtonColor = false
FloatBtn.Parent = ScreenGui
Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(0, 10)

local FBstroke = Instance.new("UIStroke", FloatBtn)
FBstroke.Color = T.Accent
FBstroke.Thickness = 1.5

local fbDrag, fbStart, fbStartPos
Hub.addConnection(FloatBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        fbDrag = true
        fbStart = input.Position
        fbStartPos = FloatBtn.Position
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

task.spawn(function()
    while FloatBtn.Parent and not Hub.IsPanicked do
        TweenService:Create(FBstroke, TweenInfo.new(1.5), {Transparency = 0.6}):Play()
        task.wait(1.5)
        if Hub.IsPanicked then break end
        TweenService:Create(FBstroke, TweenInfo.new(1.5), {Transparency = 0}):Play()
        task.wait(1.5)
    end
end)

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 360)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -180)
MainFrame.BackgroundColor3 = T.Background
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)
local MFstroke = Instance.new("UIStroke", MainFrame)
MFstroke.Color = T.Accent
MFstroke.Thickness = 1.5
Hub.MainFrame = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = T.Secondary
Header.BorderSizePixel = 0
Header.Parent = MainFrame
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 14)

local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 15)
HeaderFix.Position = UDim2.new(0, 0, 1, -15)
HeaderFix.BackgroundColor3 = T.Secondary
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = Header

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0.7, 0, 1, 0)
TitleLabel.Position = UDim2.new(0, 20, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🐗  BIZON HUB"
TitleLabel.TextColor3 = T.Accent
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextSize = 20
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = Header

local Version = Instance.new("TextLabel")
Version.Size = UDim2.new(0, 60, 0, 20)
Version.Position = UDim2.new(0, 200, 0.5, -10)
Version.BackgroundColor3 = T.Accent
Version.BackgroundTransparency = 0.85
Version.Text = "v1.4"
Version.TextColor3 = T.Accent
Version.Font = Enum.Font.GothamBold
Version.TextSize = 11
Version.BorderSizePixel = 0
Version.Parent = Header
Instance.new("UICorner", Version).CornerRadius = UDim.new(1, 0)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -44, 0.5, -16)
CloseBtn.BackgroundColor3 = T.Tertiary
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = T.Danger
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.BorderSizePixel = 0
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = Header
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)
CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

local winDrag, winStart, winStartPos
Hub.addConnection(Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        winDrag = true
        winStart = input.Position
        winStartPos = MainFrame.Position
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

-- Tab Bar
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(0, 130, 1, -70)
TabBar.Position = UDim2.new(0, 10, 0, 60)
TabBar.BackgroundColor3 = T.Secondary
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame
Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 10)
local TabList = Instance.new("UIListLayout", TabBar)
TabList.Padding = UDim.new(0, 6)
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
local TabPadding = Instance.new("UIPadding", TabBar)
TabPadding.PaddingTop = UDim.new(0, 10)
TabPadding.PaddingLeft = UDim.new(0, 6)
TabPadding.PaddingRight = UDim.new(0, 6)

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -160, 1, -70)
Content.Position = UDim2.new(0, 150, 0, 60)
Content.BackgroundColor3 = T.Secondary
Content.BorderSizePixel = 0
Content.Parent = MainFrame
Instance.new("UICorner", Content).CornerRadius = UDim.new(0, 10)

Hub.Tabs = {}
Hub.CurrentTab = nil

function Hub.switchTab(name)
    if Hub.CurrentTab == name then return end
    if Hub.CurrentTab and Hub.Tabs[Hub.CurrentTab] then
        TweenService:Create(Hub.Tabs[Hub.CurrentTab].button, TweenInfo.new(0.2), {BackgroundColor3 = T.Tertiary, TextColor3 = T.TextDim}):Play()
        Hub.Tabs[Hub.CurrentTab].container.Visible = false
    end
    Hub.CurrentTab = name
    TweenService:Create(Hub.Tabs[name].button, TweenInfo.new(0.2), {BackgroundColor3 = T.Accent, TextColor3 = T.Background}):Play()
    Hub.Tabs[name].container.Visible = true
end

function Hub.createTab(name, icon)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, -12, 0, 36)
    tabBtn.BackgroundColor3 = T.Tertiary
    tabBtn.Text = (icon or "") .. "  " .. name
    tabBtn.TextColor3 = T.TextDim
    tabBtn.Font = Enum.Font.GothamMedium
    tabBtn.TextSize = 13
    tabBtn.TextXAlignment = Enum.TextXAlignment.Left
    tabBtn.BorderSizePixel = 0
    tabBtn.AutoButtonColor = false
    tabBtn.Parent = TabBar
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 8)
    local Tpad = Instance.new("UIPadding", tabBtn)
    Tpad.PaddingLeft = UDim.new(0, 10)

    local container = Instance.new("ScrollingFrame")
    container.Size = UDim2.new(1, -12, 1, -12)
    container.Position = UDim2.new(0, 6, 0, 6)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.ScrollBarThickness = 4
    container.ScrollBarImageColor3 = T.Accent
    container.CanvasSize = UDim2.new(0, 0, 0, 0)
    container.Visible = false
    container.Parent = Content

    local layout = Instance.new("UIListLayout", container)
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    local pad = Instance.new("UIPadding", container)
    pad.PaddingTop = UDim.new(0, 6)
    pad.PaddingBottom = UDim.new(0, 6)
    pad.PaddingLeft = UDim.new(0, 6)
    pad.PaddingRight = UDim.new(0, 6)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 12)
    end)

    Hub.Tabs[name] = {button = tabBtn, container = container}
    tabBtn.MouseButton1Click:Connect(function() Hub.switchTab(name) end)
    return container
end

-- Menu toggle
local menuOpen = false
local function toggleMenu()
    menuOpen = not menuOpen
    MainFrame.Visible = menuOpen
    if menuOpen and not Hub.CurrentTab and Hub.Tabs["Speed"] then
        Hub.switchTab("Speed")
    end
end

FloatBtn.MouseButton1Click:Connect(toggleMenu)
Hub.toggleMenu = toggleMenu

print("🐗 Core загружен")
