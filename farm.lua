-- 🐗 Bizon Hub Farm — Simple Auto Clicker (FINAL v2)
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Hub = _G.BizonHub
if not Hub then warn("🐗 Загрузи core.lua!") return end

local T = Hub.Theme
local S = Hub.Settings
local player = game.Players.LocalPlayer

-- Жёсткие настройки
S.FarmTargetName = "Hitbox"
S.FarmRange = 20
S.FarmHitCooldown = 0.1
S.FarmUseTool = true

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

-- === FARM TAB ===
local FarmTab = Hub.createTab("Farm", "🌾")

createLabel(FarmTab, "АВТО КЛИКЕР ГРУШ")

createToggle(FarmTab, "👊 Auto Clicker", false, function(state)
    S.AutoFarmEnabled = state
    print("🐗 Auto Clicker: " .. (state and "ВКЛ" or "ВЫКЛ"))
end)

createLabel(FarmTab, "Цель: Hitbox | Радиус: 20 studs")

-- === ПОИСК ЦЕЛИ ===
local function hasTargetNearby()
    local ch = player.Character
    if not ch then return false end
    local rp = ch:FindFirstChild("HumanoidRootPart")
    if not rp then return false end
    local searchRoot = Workspace:FindFirstChild("Map") or Workspace
    local targetName = S.FarmTargetName:lower()
    for _, obj in pairs(searchRoot:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find(targetName) then
            local isPlayerPart = false
            for _, plr in pairs(game.Players:GetPlayers()) do
                if plr.Character and obj:IsDescendantOf(plr.Character) then
                    isPlayerPart = true
                    break
                end
            end
            if not isPlayerPart then
                local d = (obj.Position - rp.Position).Magnitude
                if d <= S.FarmRange then
                    return true
                end
            end
        end
    end
    return false
end

-- === ПРОСТОЙ ЦИКЛ ===
task.spawn(function()
    while not Hub.IsPanicked do
        task.wait(S.FarmHitCooldown)
        if not S.AutoFarmEnabled then
            continue
        end
        if hasTargetNearby() then
            local ch = player.Character
            if ch then
                local tool = ch:FindFirstChildWhichIsA("Tool")
                if tool and S.FarmUseTool then
                    pcall(function() tool:Activate() end)
                end
                pcall(function()
                    VirtualUser:Button1Down(Vector2.new(0, 0))
                    task.wait(S.FarmHitCooldown)
                    VirtualUser:Button1Up(Vector2.new(0, 0))
                end)
            end
        end
    end
end)

print("🐗 Farm модуль загружен (FINAL v2 — Simple Auto Clicker)")
