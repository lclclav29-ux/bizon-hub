-- 🐗 Bizon Hub Misc Tab
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local Hub = _G.BizonHub
if not Hub then warn("🐗 Загрузи core.lua!") return end

local T = Hub.Theme
local S = Hub.Settings
local player = game.Players.LocalPlayer

local function createToggle(parent, name, default, callback)
    local state = default or false
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 44)
    container.BackgroundColor3 = T.Tertiary
    container.BorderSizePixel = 0
    container.Parent = parent
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 8)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -90, 1, 0)
    label.Position = UDim2.new(0, 14, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = T.Text
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 54, 0, 26)
    toggleBtn.Position = UDim2.new(1, -64, 0.5, -13)
    toggleBtn.BackgroundColor3 = T.Background
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

    local function updateVisual()
        if state then
            TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = T.Accent}):Play()
            TweenService:Create(knob, TweenInfo.new(0.2), {Position = UDim2.new(1, -23, 0.5, -10), BackgroundColor3 = Color3.new(1,1,1)}):Play()
        else
            TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = T.Background}):Play()
            TweenService:Create(knob, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -10), BackgroundColor3 = T.TextDim}):Play()
        end
    end
    updateVisual()
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        updateVisual()
        if callback then callback(state) end
    end)
    return container
end

local function createLabel(parent, text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 24)
    label.BackgroundTransparency = 1
    label.Text = "— " .. text .. " —"
    label.TextColor3 = T.TextDim
    label.Font = Enum.Font.GothamBold
    label.TextSize = 11
    label.Parent = parent
    return label
end

local function createPanicButton(parent)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 60)
    container.BackgroundColor3 = T.Tertiary
    container.BorderSizePixel = 0
    container.Parent = parent
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke", container)
    stroke.Color = T.Danger
    stroke.Thickness = 1.5
    stroke.Transparency = 0.3

    local panicBtn = Instance.new("TextButton")
    panicBtn.Size = UDim2.new(1, -20, 1, -20)
    panicBtn.Position = UDim2.new(0, 10, 0, 10)
    panicBtn.BackgroundColor3 = T.Danger
    panicBtn.Text = "🚨 PANIC — УДАЛИТЬ СКРИПТ"
    panicBtn.TextColor3 = Color3.new(1,1,1)
    panicBtn.Font = Enum.Font.GothamBold
    panicBtn.TextSize = 14
    panicBtn.BorderSizePixel = 0
    panicBtn.AutoButtonColor = false
    panicBtn.Parent = container
    Instance.new("UICorner", panicBtn).CornerRadius = UDim.new(0, 6)

    panicBtn.MouseButton1Click:Connect(function()
        panicBtn.Text = "✅ УДАЛЕНО"
        panicBtn.BackgroundColor3 = T.Success
        task.wait(0.15)
        Hub.IsPanicked = true
        pcall(function()
            local ch = player.Character
            if ch and ch:FindFirstChild("Humanoid") then
                ch.Humanoid.WalkSpeed = 16
                ch.Humanoid.JumpPower = 50
            end
        end)
        pcall(function()
            Lighting.Ambient = Color3.fromRGB(70,70,70)
            Lighting.Brightness = 1
            Lighting.OutdoorAmbient = Color3.fromRGB(128,128,128)
        end)
        for _, c in pairs(Hub.Connections) do pcall(function() c:Disconnect() end) end
        Hub.Connections = {}
        pcall(function()
            if Hub.ScreenGui and Hub.ScreenGui.Parent then Hub.ScreenGui:Destroy() end
        end)
        print("🐗 Bizon Hub: PANIC активирован")
    end)
    return container
end

-- MISC TAB
local MiscTab = Hub.createTab("Misc", "🎯")
createLabel(MiscTab, "ПРОЧЕЕ")

createToggle(MiscTab, "🚶 Noclip", S.Noclip, function(state) S.Noclip = state end)

createToggle(MiscTab, "💡 Fullbright", S.Fullbright, function(state)
    S.Fullbright = state
    if state then
        Lighting.Ambient = Color3.fromRGB(178,178,178)
        Lighting.Brightness = 3
        Lighting.OutdoorAmbient = Color3.fromRGB(178,178,178)
    else
        Lighting.Ambient = Color3.fromRGB(70,70,70)
        Lighting.Brightness = 1
        Lighting.OutdoorAmbient = Color3.fromRGB(128,128,128)
    end
end)

createLabel(MiscTab, "ОПАСНАЯ ЗОНА")
createPanicButton(MiscTab)

Hub.addConnection(RunService.Heartbeat:Connect(function()
    if Hub.IsPanicked then return end
    if S.Noclip then
        local ch = player.Character
        if ch then
            for _, p in pairs(ch:GetDescendants()) do
                if p:IsA("BasePart") and p.CanCollide then
                    p.CanCollide = false
                end
            end
        end
    end
end))

print("🐗 Misc модуль загружен")
