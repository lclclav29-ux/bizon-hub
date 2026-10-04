-- BIZON HUB — Auto (с Auto Boss)
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")

local Hub = _G.BizonHub
if not Hub then warn("[Bizon Hub] Загрузи core.lua!") return end
local T = Hub.Theme
local player = game.Players.LocalPlayer

local AutoTab = Hub.createTab("Auto", "")

local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Shared")
if remotes then remotes = remotes:FindFirstChild("Remotes") end

-- Настройки Auto Boss
local BossSettings = {
    AutoJoinRaid = true,
    AutoAttack = true,
    AutoReward = true,
    AttackDelay = 0.1,
    SkipTimer = true,
}

-- Settings Auto
local Settings = {
    Clicker = {enabled = false, delay = 0.1},
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

-- ===== СОЗДАНИЕ CARD (с настройками ПКМ) =====
local function createAutoToggle(name, key, settingsFn)
    local config = Settings[key]
    if not config then return end
    
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 52)
    container.BackgroundColor3 = T.Bg3
    container.BackgroundTransparency = 0.3
    container.BorderSizePixel = 0
    container.Parent = AutoTab
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 10)
    
    local stroke = Instance.new("UIStroke", container)
    stroke.Color = T.Stroke
    stroke.Thickness = 1
    stroke.Transparency = 0.4
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -200, 1, 0)
    label.Position = UDim2.new(0, 16, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = T.Text
    label.Font = Enum.Font.GothamBold
    label.TextSize = 15
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    -- Индикатор ПКМ
    if settingsFn then
        local gear = Instance.new("TextLabel")
        gear.Size = UDim2.new(0, 18, 0, 18)
        gear.Position = UDim2.new(1, -190, 0.5, -9)
        gear.BackgroundTransparency = 1
        gear.Text = "..."
        gear.TextColor3 = T.TextDim
        gear.Font = Enum.Font.GothamBold
        gear.TextSize = 14
        gear.TextTransparency = 0.5
        gear.Parent = container
        
        container.MouseEnter:Connect(function()
            TweenService:Create(gear, TweenInfo.new(0.15), {TextTransparency = 0}):Play()
        end)
        container.MouseLeave:Connect(function()
            TweenService:Create(gear, TweenInfo.new(0.15), {TextTransparency = 0.5}):Play()
        end)
    end
    
    local delayLbl = Instance.new("TextLabel")
    delayLbl.Size = UDim2.new(0, 60, 0, 24)
    delayLbl.Position = UDim2.new(1, -170, 0.5, -12)
    delayLbl.BackgroundColor3 = T.Accent
    delayLbl.BackgroundTransparency = 0.8
    delayLbl.Text = config.delay .. "s"
    delayLbl.TextColor3 = T.Accent
    delayLbl.Font = Enum.Font.GothamBold
    delayLbl.TextSize = 12
    delayLbl.BorderSizePixel = 0
    delayLbl.Parent = container
    Instance.new("UICorner", delayLbl).CornerRadius = UDim.new(1, 0)
    
    local minusBtn = Instance.new("TextButton")
    minusBtn.Size = UDim2.new(0, 24, 0, 24)
    minusBtn.Position = UDim2.new(1, -105, 0.5, -12)
    minusBtn.BackgroundColor3 = T.Bg
    minusBtn.Text = "-"
    minusBtn.TextColor3 = T.Text
    minusBtn.Font = Enum.Font.GothamBold
    minusBtn.TextSize = 15
    minusBtn.BorderSizePixel = 0
    minusBtn.AutoButtonColor = false
    minusBtn.Parent = container
    Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0, 6)
    
    local plusBtn = Instance.new("TextButton")
    plusBtn.Size = UDim2.new(0, 24, 0, 24)
    plusBtn.Position = UDim2.new(1, -77, 0.5, -12)
    plusBtn.BackgroundColor3 = T.Bg
    plusBtn.Text = "+"
    plusBtn.TextColor3 = T.Text
    plusBtn.Font = Enum.Font.GothamBold
    plusBtn.TextSize = 15
    plusBtn.BorderSizePixel = 0
    plusBtn.AutoButtonColor = false
    plusBtn.Parent = container
    Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0, 6)
    
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
            TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = T.Accent}):Play()
            TweenService:Create(toggleStroke, TweenInfo.new(0.2), {Color = T.AccentGlow, Transparency = 0.3}):Play()
            TweenService:Create(knob, TweenInfo.new(0.2), {Position = UDim2.new(1, -21, 0.5, -9), BackgroundColor3 = Color3.new(1,1,1)}):Play()
        else
            TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = T.Bg}):Play()
            TweenService:Create(toggleStroke, TweenInfo.new(0.2), {Color = T.Stroke, Transparency = 0.5}):Play()
            TweenService:Create(knob, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -9), BackgroundColor3 = T.TextDim}):Play()
        end
    end
    updToggle()
    
    -- ЛКМ = toggle
    toggleBtn.MouseButton1Click:Connect(function()
        config.enabled = not config.enabled
        updToggle()
        print("[Bizon Hub] " .. name .. ": " .. (config.enabled and "ON" or "OFF"))
    end)
    
    -- ПКМ = настройки
    container.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            if Hub.openContext then
                Hub.openContext(container, function(menuParent)
                    Hub.addContextLabel(menuParent, name)
                    
                    -- Слайдер задержки
                    Hub.addContextSlider(menuParent, "Задержка (сек)", 0.05, 30, config.delay, function(v)
                        config.delay = v
                        delayLbl.Text = string.format("%.2f", v):gsub("%.?0+$", "") .. "s"
                    end)
                    
                    -- Стандартный settingsFn
                    if settingsFn then
                        settingsFn(menuParent, config.enabled, function(newState)
                            if newState ~= nil then
                                config.enabled = newState
                                updToggle()
                            end
                        end)
                    end
                end)
            end
        end
    end)
    
    minusBtn.MouseButton1Click:Connect(function()
        if config.delay > 1 then
            config.delay = config.delay - 1
        else
            config.delay = math.max(0.05, config.delay - 0.05)
        end
        delayLbl.Text = string.format("%.2f", config.delay):gsub("%.?0+$", "") .. "s"
    end)
    plusBtn.MouseButton1Click:Connect(function()
        if config.delay < 1 then
            config.delay = config.delay + 0.05
        else
            config.delay = config.delay + 1
        end
        delayLbl.Text = string.format("%.2f", config.delay):gsub("%.?0+$", "") .. "s"
    end)
    
    for _, btn in pairs({minusBtn, plusBtn}) do
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = T.Bg4}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = T.Bg}):Play()
        end)
    end
    
    container.MouseEnter:Connect(function()
        TweenService:Create(container, TweenInfo.new(0.15), {BackgroundTransparency = 0.15}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.15), {Color = T.Accent, Transparency = 0.5}):Play()
    end)
    container.MouseLeave:Connect(function()
        TweenService:Create(container, TweenInfo.new(0.15), {BackgroundTransparency = 0.3}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.15), {Color = T.Stroke, Transparency = 0.4}):Play()
    end)
end

-- ===== СОЗДАНИЕ ФУНКЦИЙ =====
-- Auto Boss первым
createAutoToggle("Auto Boss Farm", "AutoBoss", function(menuParent, currentState, stateSetter)
    Hub.addContextLabel(menuParent, "Настройки боя")
    
    Hub.addContextButton(menuParent, (BossSettings.AutoJoinRaid and "[V] " or "[ ] ") .. "Авто-вход в рейд", function()
        BossSettings.AutoJoinRaid = not BossSettings.AutoJoinRaid
    end)
    
    Hub.addContextButton(menuParent, (BossSettings.AutoAttack and "[V] " or "[ ] ") .. "Авто-атака", function()
        BossSettings.AutoAttack = not BossSettings.AutoAttack
    end)
    
    Hub.addContextButton(menuParent, (BossSettings.AutoReward and "[V] " or "[ ] ") .. "Забирать награду", function()
        BossSettings.AutoReward = not BossSettings.AutoReward
    end)
    
    Hub.addContextButton(menuParent, (BossSettings.SkipTimer and "[V] " or "[ ] ") .. "Пропускать таймер", function()
        BossSettings.SkipTimer = not BossSettings.SkipTimer
    end)
    
    Hub.addContextSlider(menuParent, "Задержка атаки", 0.05, 2, BossSettings.AttackDelay, function(v)
        BossSettings.AttackDelay = v
    end)
end)

-- Остальные функции
createAutoToggle("Auto Clicker", "Clicker")
createAutoToggle("Auto Rebirth", "Rebirth")
createAutoToggle("Auto Equip Best Pets", "EquipBestPets")
createAutoToggle("Auto Equip Best Artifacts", "EquipBestArtifacts")
createAutoToggle("Auto Summon", "AutoSummon")
createAutoToggle("Auto Hatch", "AutoHatch")
createAutoToggle("Claim Offline Earnings", "ClaimOffline")
createAutoToggle("Claim Daily Reward", "ClaimDaily")
createAutoToggle("Claim Group Reward", "ClaimGroup")
createAutoToggle("Claim Playtime Reward", "ClaimPlaytime")
createAutoToggle("Hero Tiles Evolve", "HeroTiles")
createAutoToggle("Request Train", "RequestTrain")
createAutoToggle("Auto Open Crate", "OpenCrate")
createAutoToggle("Use Boost", "UseBoost")

-- ===== LOGIC =====
local function hasTargetNearby()
    local ch = player.Character
    if not ch then return false end
    local rp = ch:FindFirstChild("HumanoidRootPart")
    if not rp then return false end
    local map = Workspace:FindFirstChild("Map") or Workspace
    for _, obj in pairs(map:GetChildren()) do
        if obj.Name:lower():find("hitbox") then
            local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
            if part then
                local d = (part.Position - rp.Position).Magnitude
                if d <= 30 then return true end
            end
        end
    end
    return false
end

local lastRun = {}
for key, _ in pairs(Settings) do
    lastRun[key] = 0
end

local function fire(name, ...)
    if not remotes then return false end
    local ev = remotes:FindFirstChild(name)
    if not ev then return false end
    local args = {...}
    local ok = pcall(function()
        if #args == 0 then
            if ev:IsA("RemoteFunction") then ev:InvokeServer() else ev:FireServer() end
        else
            if ev:IsA("RemoteFunction") then ev:InvokeServer(unpack(args)) else ev:FireServer(unpack(args)) end
        end
    end)
    return ok
end

-- ===== AUTO BOSS LOGIC =====
local bossState = "idle"
local lastAttack = 0
local lastCheck = 0

task.spawn(function()
    while not Hub.IsPanicked do
        task.wait(0.1)
        
        if not Settings.AutoBoss.enabled then
            bossState = "idle"
            continue
        end
        
        -- 1. Попытка атаки
        if BossSettings.AutoAttack then
            local now = tick()
            if now - lastAttack >= BossSettings.AttackDelay then
                lastAttack = now
                pcall(function()
                    local attackRemote = remotes:FindFirstChild("RequestAttack")
                    if attackRemote then
                        if attackRemote:IsA("RemoteFunction") then
                            attackRemote:InvokeServer()
                        else
                            attackRemote:FireServer()
                        end
                    end
                end)
            end
        end
        
        -- 2. Проверка рейда раз в 3 секунды
        local now = tick()
        if now - lastCheck >= 3 then
            lastCheck = now
            
            -- Пытаемся зайти в рейд
            if BossSettings.AutoJoinRaid then
                pcall(function()
                    local joinRemote = remotes:FindFirstChild("RaidJoinRequest")
                    if joinRemote then
                        joinRemote:FireServer()
                    end
                end)
            end
            
            -- Забираем награду
            if BossSettings.AutoReward then
                pcall(function()
                    local rewardRemote = remotes:FindFirstChild("BossEventReward")
                    if rewardRemote then
                        rewardRemote:FireServer()
                    end
                end)
            end
            
            -- Пропускаем таймер
            if BossSettings.SkipTimer then
                pcall(function()
                    local skipRemote = remotes:FindFirstChild("TestSkipRaid")
                    if skipRemote then
                        skipRemote:FireServer()
                    end
                end)
            end
        end
    end
end)

-- ===== AUTO FARM LOGIC =====
task.spawn(function()
    while not Hub.IsPanicked do
        task.wait(0.05)
        local now = tick()
        for key, config in pairs(Settings) do
            if key ~= "AutoBoss" and config.enabled and (now - lastRun[key] >= config.delay) then
                lastRun[key] = now
                if key == "Clicker" then
                    if hasTargetNearby() then
                        local ch = player.Character
                        if ch then
                            local tool = ch:FindFirstChildWhichIsA("Tool")
                            if tool then pcall(function() tool:Activate() end) end
                        end
                        pcall(function()
                            VirtualUser:Button1Down(Vector2.new(0, 0))
                            task.wait(0.05)
                            VirtualUser:Button1Up(Vector2.new(0, 0))
                        end)
                    end
                elseif key == "Rebirth" then fire("RequestRebirth")
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

print("[Bizon Hub] Auto модуль загружен (Auto Boss + ПКМ)")
