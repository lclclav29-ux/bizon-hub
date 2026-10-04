-- 🐗 Bizon Hub Auto
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local Hub = _G.BizonHub
if not Hub then warn("🐗 Загрузи core.lua!") return end
local T = Hub.Theme
local player = game.Players.LocalPlayer

local AutoTab = Hub.createTab("Auto", "⚙️")

-- Получаем remotes
local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Shared")
if remotes then remotes = remotes:FindFirstChild("Remotes") end
if not remotes then warn("🐗 Remotes не найдены!") return end

-- Настройки
local Settings = {
    Rebirth = {enabled = false, delay = 3},
    EquipBestPets = {enabled = false, delay = 30},
    EquipBestArtifacts = {enabled = false, delay = 30},
    OpenCrate = {enabled = false, delay = 5},
    ClaimOffline = {enabled = false, delay = 60},
    ClaimDaily = {enabled = false, delay = 60},
    ClaimGroup = {enabled = false, delay = 60},
    ClaimPlaytime = {enabled = false, delay = 60},
    HeroTiles = {enabled = false, delay = 0.5},
    RequestTrain = {enabled = false, delay = 1},
    AutoSummon = {enabled = false, delay = 10},
    UseBoost = {enabled = false, delay = 30},
    AutoHatch = {enabled = false, delay = 5},
}

-- === СОЗДАНИЕ ПЕРЕКЛЮЧАТЕЛЯ С DELAY ===
local function createAutoToggle(name, key, callback)
    local config = Settings[key]
    if not config then return end
    
    -- Карточка с настройками (1 строка)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 52)
    container.BackgroundColor3 = T.Bg3
    container.BackgroundTransparency = 0.35
    container.BorderSizePixel = 0
    container.Parent = AutoTab
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 12)
    
    local grad = Instance.new("UIGradient", container)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, T.Bg4),
        ColorSequenceKeypoint.new(1, T.Bg3),
    })
    grad.Rotation = 45
    
    local stroke = Instance.new("UIStroke", container)
    stroke.Color = T.Stroke
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    
    -- Имя
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -200, 1, 0)
    label.Position = UDim2.new(0, 14, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = T.Text
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    -- Слайдер задержки
    local delayLbl = Instance.new("TextLabel")
    delayLbl.Size = UDim2.new(0, 60, 0, 22)
    delayLbl.Position = UDim2.new(1, -170, 0.5, -11)
    delayLbl.BackgroundColor3 = T.Accent
    delayLbl.BackgroundTransparency = 0.8
    delayLbl.Text = config.delay .. "с"
    delayLbl.TextColor3 = T.Accent
    delayLbl.Font = Enum.Font.GothamBold
    delayLbl.TextSize = 10
    delayLbl.BorderSizePixel = 0
    delayLbl.Parent = container
    Instance.new("UICorner", delayLbl).CornerRadius = UDim.new(1, 0)
    
    -- Минус
    local minusBtn = Instance.new("TextButton")
    minusBtn.Size = UDim2.new(0, 24, 0, 24)
    minusBtn.Position = UDim2.new(1, -104, 0.5, -12)
    minusBtn.BackgroundColor3 = T.Bg
    minusBtn.Text = "−"
    minusBtn.TextColor3 = T.Text
    minusBtn.Font = Enum.Font.GothamBold
    minusBtn.TextSize = 14
    minusBtn.BorderSizePixel = 0
    minusBtn.AutoButtonColor = false
    minusBtn.Parent = container
    Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0, 6)
    
    -- Плюс
    local plusBtn = Instance.new("TextButton")
    plusBtn.Size = UDim2.new(0, 24, 0, 24)
    plusBtn.Position = UDim2.new(1, -76, 0.5, -12)
    plusBtn.BackgroundColor3 = T.Bg
    plusBtn.Text = "+"
    plusBtn.TextColor3 = T.Text
    plusBtn.Font = Enum.Font.GothamBold
    plusBtn.TextSize = 14
    plusBtn.BorderSizePixel = 0
    plusBtn.AutoButtonColor = false
    plusBtn.Parent = container
    Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0, 6)
    
    -- Toggle
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 44, 0, 24)
    toggleBtn.Position = UDim2.new(1, -48, 0.5, -12)
    toggleBtn.BackgroundColor3 = T.Bg
    toggleBtn.Text = ""
    toggleBtn.BorderSizePixel = 0
    toggleBtn.AutoButtonColor = false
    toggleBtn.Parent = container
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)
    
    local toggleStroke = Instance.new("UIStroke", toggleBtn)
    toggleStroke.Color = T.Stroke
    toggleStroke.Thickness = 1
    toggleStroke.Transparency = 0.5
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = UDim2.new(0, 3, 0.5, -9)
    knob.BackgroundColor3 = T.TextDim
    knob.BorderSizePixel = 0
    knob.Parent = toggleBtn
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    
    local function updToggle()
        if config.enabled then
            TweenService:Create(toggleBtn, TweenInfo.new(0.25), {BackgroundColor3 = T.Accent}):Play()
            TweenService:Create(toggleStroke, TweenInfo.new(0.25), {Color = T.AccentGlow, Transparency = 0.3}):Play()
            TweenService:Create(knob, TweenInfo.new(0.25), {
                Position = UDim2.new(1, -21, 0.5, -9),
                BackgroundColor3 = Color3.new(1,1,1),
            }):Play()
        else
            TweenService:Create(toggleBtn, TweenInfo.new(0.25), {BackgroundColor3 = T.Bg}):Play()
            TweenService:Create(toggleStroke, TweenInfo.new(0.25), {Color = T.Stroke, Transparency = 0.5}):Play()
            TweenService:Create(knob, TweenInfo.new(0.25), {
                Position = UDim2.new(0, 3, 0.5, -9),
                BackgroundColor3 = T.TextDim,
            }):Play()
        end
    end
    updToggle()
    
    toggleBtn.MouseButton1Click:Connect(function()
        config.enabled = not config.enabled
        updToggle()
        print("🐗 " .. name .. ": " .. (config.enabled and "ВКЛ" or "ВЫКЛ"))
    end)
    
    -- Кнопки изменения задержки
    minusBtn.MouseButton1Click:Connect(function()
        config.delay = math.max(0.1, config.delay - 1)
        delayLbl.Text = config.delay .. "с"
    end)
    plusBtn.MouseButton1Click:Connect(function()
        config.delay = config.delay + 1
        delayLbl.Text = config.delay .. "с"
    end)
    
    container.MouseEnter:Connect(function()
        TweenService:Create(container, TweenInfo.new(0.2), {BackgroundTransparency = 0.15}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Color = T.Accent, Transparency = 0.55}):Play()
    end)
    container.MouseLeave:Connect(function()
        TweenService:Create(container, TweenInfo.new(0.2), {BackgroundTransparency = 0.35}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Color = T.Stroke, Transparency = 0.5}):Play()
    end)
end

-- === ЗАГОЛОВОК ===
Hub.createLabel(AutoTab, "Основное")
AutoTab.currentRow = nil
AutoTab.colCount = 0

-- Функции в 1 колонку (с задержкой)
createAutoToggle("🔄 Auto Rebirth", "Rebirth")
createAutoToggle("🐾 Auto Equip Best Pets", "EquipBestPets")
createAutoToggle("🏺 Auto Equip Best Artifacts", "EquipBestArtifacts")

Hub.createLabel(AutoTab, "Клейм награды")
AutoTab.currentRow = nil
AutoTab.colCount = 0

createAutoToggle("💰 Claim Offline Earnings", "ClaimOffline")
createAutoToggle("📅 Claim Daily Reward", "ClaimDaily")
createAutoToggle("👥 Claim Group Reward", "ClaimGroup")
createAutoToggle("⏰ Claim Playtime Reward", "ClaimPlaytime")

Hub.createLabel(AutoTab, "События")
AutoTab.currentRow = nil
AutoTab.colCount = 0

createAutoToggle("💪 Hero Tiles Evolve", "HeroTiles")
createAutoToggle("🏋 Request Train", "RequestTrain")
createAutoToggle("📦 Auto Open Crate", "OpenCrate")
createAutoToggle("🎁 Auto Summon", "AutoSummon")
createAutoToggle("⚡ Use Boost", "UseBoost")
createAutoToggle("🐣 Auto Hatch", "AutoHatch")

-- === АВТО-ЦИКЛ ===
local lastRun = {}
for key, _ in pairs(Settings) do
    lastRun[key] = 0
end

local function fire(name, ...)
    local ev = remotes:FindFirstChild(name)
    if not ev then return false end
    local args = {...}
    local ok = pcall(function()
        if #args == 0 then
            if ev:IsA("RemoteFunction") then
                ev:InvokeServer()
            else
                ev:FireServer()
            end
        else
            if ev:IsA("RemoteFunction") then
                ev:InvokeServer(unpack(args))
            else
                ev:FireServer(unpack(args))
            end
        end
    end)
    return ok
end

task.spawn(function()
    while not Hub.IsPanicked do
        task.wait(0.2)
        local now = tick()
        
        for key, config in pairs(Settings) do
            if config.enabled and (now - lastRun[key] >= config.delay) then
                lastRun[key] = now
                
                if key == "Rebirth" then fire("RequestRebirth")
                elseif key == "EquipBestPets" then fire("EquipBestPets")
                elseif key == "EquipBestArtifacts" then fire("EquipBestArtifacts")
                elseif key == "ClaimOffline" then fire("ClaimOfflineEarnings")
                elseif key == "ClaimDaily" then fire("ClaimDailyReward")
                elseif key == "ClaimGroup" then fire("ClaimGroupReward")
                elseif key == "ClaimPlaytime" then fire("ClaimPlaytimeReward")
                elseif key == "HeroTiles" then fire("HeroTilesAction", "evolve")
                elseif key == "RequestTrain" then fire("RequestTrain")
                elseif key == "OpenCrate" then fire("AutoOpenCrate", true)
                elseif key == "AutoSummon" then fire("AutoSummon", true)
                elseif key == "UseBoost" then fire("UseBoost")
                elseif key == "AutoHatch" then fire("AutoHatch")
                end
            end
        end
    end
end)

print("🐗 Auto модуль загружен (13 функций)")
