-- 🐗 Bizon Hub Farm — Clean Auto Clicker
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

S.FarmHitCooldown = 0.1
S.FarmTargetName = "Hitbox"
S.FarmRange = 20

-- === UI HELPERS ===
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

local function createSlider(parent, name, minVal, maxVal, default, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 60)
    container.BackgroundColor3 = T.Tertiary
    container.BorderSizePixel = 0
    container.Parent = parent
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 8)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -100, 0, 22)
    label.Position = UDim2.new(0, 14, 0, 8)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = T.Text
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 70, 0, 22)
    valueLabel.Position = UDim2.new(1, -84, 0, 8)
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
    sliderBg.Size = UDim2.new(1, -28, 0, 8)
    sliderBg.Position = UDim2.new(0, 14, 0, 40)
    sliderBg.BackgroundColor3 = T.Background
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
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.new((default - minVal) / (maxVal - minVal), -8, 0.5, -8)
    knob.BackgroundColor3 = Color3.new(1,1,1)
    knob.BorderSizePixel = 0
    knob.Parent = sliderBg
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    local sliding = false
    local function updateSlider(input)
        local relX = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        local value = math.floor(minVal + (maxVal - minVal) * relX)
        fill.Size = UDim2.new(relX, 0, 1, 0)
        knob.Position = UDim2.new(relX, -8, 0.5, -8)
        valueLabel.Text = tostring(value)
        callback(value)
    end
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true; updateSlider(input) end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then updateSlider(input) end
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

local function createTextInput(parent, name, default, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 44)
    container.BackgroundColor3 = T.Tertiary
    container.BorderSizePixel = 0
    container.Parent = parent
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 8)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.45, 0, 1, 0)
    label.Position = UDim2.new(0, 14, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = T.Text
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0, 130, 0, 30)
    box.Position = UDim2.new(1, -144, 0.5, -15)
    box.BackgroundColor3 = T.Background
    box.Text = default
    box.TextColor3 = T.Accent
    box.Font = Enum.Font.GothamBold
    box.TextSize = 12
    box.BorderSizePixel = 0
    box.ClearTextOnFocus = false
    box.Parent = container
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
    box.FocusLost:Connect(function() callback(box.Text) end)
    return container
end

-- === FARM TAB ===
local FarmTab = Hub.createTab("Farm", "🌾")

createLabel(FarmTab, "АВТО КЛИКЕР ГРУШ")

createToggle(FarmTab, "👊 Auto Clicker", S.AutoFarmEnabled, function(state)
    S.AutoFarmEnabled = state
    print("🐗 Auto Clicker: " .. (state and "ВКЛ" or "ВЫКЛ"))
end)

createTextInput(FarmTab, "Имя цели", S.FarmTargetName, function(text)
    S.FarmTargetName = text
    print("🐗 Поиск: " .. text)
end)

createLabel(FarmTab, "НАСТРОЙКИ")

createSlider(FarmTab, "Радиус поиска", 5, 100, S.FarmRange, function(val) S.FarmRange = val end)
createSlider(FarmTab, "Задержка (x100)", 1, 30, 10, function(val) S.FarmHitCooldown = val / 100 end)
createToggle(FarmTab, "Использовать инструмент", S.FarmUseTool, function(state) S.FarmUseTool = state end)

-- === ПОИСК ЦЕЛИ РЯДОМ ===
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
                    isPlayerPart = true; break
                end
            end
            if not isPlayerPart then
                local d = (obj.Position - rp.Position).Magnitude
                if d <= S.FarmRange then return true end
            end
        end
    end
    return false
end

local clickerThread = nil

local function startClicker()
    if clickerThread then return end
    clickerThread = task.spawn(function()
        while S.AutoFarmEnabled and not Hub.IsPanicked do
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
                    task.wait(S.FarmHitCooldown)
                else
                    task.wait(0.5)
                end
            else
                task.wait(0.2)
            end
        end
        clickerThread = nil
        print("🐗 Auto Clicker остановлен")
    end)
end

local lastState = false
Hub.addConnection(RunService.Heartbeat:Connect(function()
    if Hub.IsPanicked then return end
    if S.AutoFarmEnabled and not lastState then
        lastState = true
        startClicker()
    elseif not S.AutoFarmEnabled and lastState then
        lastState = false
    end
end))

print("🐗 Farm модуль загружен (Auto Clicker)")
