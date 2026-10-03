-- 🐗 Bizon Hub Farm Tab v4 (оптимизированный + правильное отключение)
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

S.FarmTeleport = true
S.FarmHitCooldown = 0.08

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
createLabel(FarmTab, "АВТО ФАРМ ГРУШ")

createToggle(FarmTab, "🌾 Auto Farm", S.AutoFarmEnabled, function(state)
    S.AutoFarmEnabled = state
    print("🐗 Auto Farm: " .. (state and "ВКЛ" or "ВЫКЛ"))
    if not state then
        -- Возвращаем скорость игроку
        local ch = player.Character
        if ch and ch:FindFirstChild("Humanoid") then
            ch.Humanoid.WalkSpeed = 16
        end
    end
end)

local targetInputFrame = createTextInput(FarmTab, "Имя объекта", S.FarmTargetName, function(text)
    S.FarmTargetName = text
    print("🐗 Поиск: " .. text)
end)

-- Кнопка сканера
local scanBtn = Instance.new("TextButton")
scanBtn.Size = UDim2.new(1, 0, 0, 40)
scanBtn.BackgroundColor3 = T.Accent
scanBtn.Text = "🔍 Сканировать объекты рядом"
scanBtn.TextColor3 = T.Background
scanBtn.Font = Enum.Font.GothamBold
scanBtn.TextSize = 14
scanBtn.BorderSizePixel = 0
scanBtn.AutoButtonColor = false
scanBtn.Parent = FarmTab
Instance.new("UICorner", scanBtn).CornerRadius = UDim.new(0, 8)

scanBtn.MouseEnter:Connect(function()
    TweenService:Create(scanBtn, TweenInfo.new(0.15), {BackgroundColor3 = T.Accent:Lerp(Color3.new(1,1,1), 0.2)}):Play()
end)
scanBtn.MouseLeave:Connect(function()
    TweenService:Create(scanBtn, TweenInfo.new(0.15), {BackgroundColor3 = T.Accent}):Play()
end)

-- === ПАНЕЛЬ СКАНИРОВАНИЯ ===
local ScanPanel = Instance.new("Frame")
ScanPanel.Size = UDim2.new(0, 320, 0, 400)
ScanPanel.Position = UDim2.new(0.5, -160, 0.5, -200)
ScanPanel.BackgroundColor3 = T.Background
ScanPanel.BorderSizePixel = 0
ScanPanel.Visible = false
ScanPanel.ZIndex = 10
ScanPanel.Parent = Hub.ScreenGui
Instance.new("UICorner", ScanPanel).CornerRadius = UDim.new(0, 12)
local SPstroke = Instance.new("UIStroke", ScanPanel)
SPstroke.Color = T.Accent
SPstroke.Thickness = 1.5

local SPHeader = Instance.new("Frame")
SPHeader.Size = UDim2.new(1, 0, 0, 42)
SPHeader.BackgroundColor3 = T.Secondary
SPHeader.BorderSizePixel = 0
SPHeader.ZIndex = 10
SPHeader.Parent = ScanPanel
Instance.new("UICorner", SPHeader).CornerRadius = UDim.new(0, 12)
local SPHfix = Instance.new("Frame")
SPHfix.Size = UDim2.new(1, 0, 0, 12)
SPHfix.Position = UDim2.new(0, 0, 1, -12)
SPHfix.BackgroundColor3 = T.Secondary
SPHfix.BorderSizePixel = 0
SPHfix.ZIndex = 10
SPHfix.Parent = SPHeader

local SPTitle = Instance.new("TextLabel")
SPTitle.Size = UDim2.new(1, -50, 1, 0)
SPTitle.Position = UDim2.new(0, 16, 0, 0)
SPTitle.BackgroundTransparency = 1
SPTitle.Text = "🔍 ОБЪЕКТЫ РЯДОМ"
SPTitle.TextColor3 = T.Accent
SPTitle.Font = Enum.Font.GothamBold
SPTitle.TextSize = 14
SPTitle.TextXAlignment = Enum.TextXAlignment.Left
SPTitle.ZIndex = 10
SPTitle.Parent = SPHeader

local SPClose = Instance.new("TextButton")
SPClose.Size = UDim2.new(0, 28, 0, 28)
SPClose.Position = UDim2.new(1, -38, 0.5, -14)
SPClose.BackgroundColor3 = T.Tertiary
SPClose.Text = "✕"
SPClose.TextColor3 = T.Danger
SPClose.Font = Enum.Font.GothamBold
SPClose.TextSize = 14
SPClose.BorderSizePixel = 0
SPClose.AutoButtonColor = false
SPClose.ZIndex = 10
SPClose.Parent = SPHeader
Instance.new("UICorner", SPClose).CornerRadius = UDim.new(0, 8)
SPClose.MouseButton1Click:Connect(function() ScanPanel.Visible = false end)

local SPContent = Instance.new("ScrollingFrame")
SPContent.Size = UDim2.new(1, -20, 1, -52)
SPContent.Position = UDim2.new(0, 10, 0, 48)
SPContent.BackgroundTransparency = 1
SPContent.BorderSizePixel = 0
SPContent.ScrollBarThickness = 4
SPContent.ScrollBarImageColor3 = T.Accent
SPContent.CanvasSize = UDim2.new(0, 0, 0, 0)
SPContent.ZIndex = 10
SPContent.Parent = ScanPanel
local SPLayout = Instance.new("UIListLayout", SPContent)
SPLayout.Padding = UDim.new(0, 4)
SPLayout.SortOrder = Enum.SortOrder.LayoutOrder
SPLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    SPContent.CanvasSize = UDim2.new(0, 0, 0, SPLayout.AbsoluteContentSize.Y + 10)
end)

-- === ОПТИМИЗИРОВАННЫЙ ПОИСК ЦЕЛЕЙ ===
-- Кэш: перестраивается редко, а не каждый тик
local targetsCache = {}
local lastScanTime = 0
local SCAN_INTERVAL = 0.5  -- сканируем раз в 0.5 секунды вместо каждый тик

local function refreshTargetsCache()
    local now = tick()
    if now - lastScanTime < SCAN_INTERVAL then return targetsCache end
    lastScanTime = now

    local ch = player.Character
    if not ch then return {} end
    local rp = ch:FindFirstChild("HumanoidRootPart")
    if not rp then return {} end

    local targets = {}
    local targetName = S.FarmTargetName:lower()

    -- Оптимизация: ищем в Workspace.Map (обычно там все игровые объекты)
    -- Если Map нет — сканируем Workspace напрямую
    local searchRoots = {}
    local map = Workspace:FindFirstChild("Map")
    if map then
        table.insert(searchRoots, map)
    else
        table.insert(searchRoots, Workspace)
    end

    for _, root in pairs(searchRoots) do
        for _, obj in pairs(root:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name:lower():find(targetName) then
                local d = (obj.Position - rp.Position).Magnitude
                if d <= S.FarmRange then
                    table.insert(targets, {part = obj, dist = d})
                end
            end
        end
    end

    table.sort(targets, function(a, b) return a.dist < b.dist end)
    targetsCache = targets
    return targets
end

-- === СКАНЕР (для GUI) ===
local function scanObjects()
    for _, child in pairs(SPContent:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end

    local ch = player.Character
    if not ch then return end
    local rp = ch:FindFirstChild("HumanoidRootPart")
    if not rp then return end

    local found = {}
    local seen = {}

    -- Ищем в Workspace.Map или Workspace
    local searchRoot = Workspace:FindFirstChild("Map") or Workspace

    for _, obj in pairs(searchRoot:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local isPlayer = false
            for _, plr in pairs(game.Players:GetPlayers()) do
                if plr.Character and (obj == plr.Character or obj:IsDescendantOf(plr.Character)) then
                    isPlayer = true; break
                end
            end
            if not isPlayer then
                local part = obj
                if obj:IsA("Model") then
                    part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                end
                if part and part:IsA("BasePart") then
                    local d = (part.Position - rp.Position).Magnitude
                    if d <= 150 and not seen[obj.Name] then
                        seen[obj.Name] = true
                        table.insert(found, {name = obj.Name, dist = d, class = obj.ClassName})
                    end
                end
            end
        end
    end

    table.sort(found, function(a, b) return a.dist < b.dist end)

    for i = 1, math.min(#found, 50) do
        local info = found[i]
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 50)
        btn.BackgroundColor3 = T.Tertiary
        btn.Text = ""
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.ZIndex = 10
        btn.Parent = SPContent
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

        local nameLbl = Instance.new("TextLabel")
        nameLbl.Size = UDim2.new(1, -14, 0, 22)
        nameLbl.Position = UDim2.new(0, 8, 0, 4)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = info.name
        nameLbl.TextColor3 = T.Text
        nameLbl.Font = Enum.Font.GothamBold
        nameLbl.TextSize = 13
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left
        nameLbl.ZIndex = 10
        nameLbl.Parent = btn

        local infoLbl = Instance.new("TextLabel")
        infoLbl.Size = UDim2.new(1, -14, 0, 18)
        infoLbl.Position = UDim2.new(0, 8, 0, 26)
        infoLbl.BackgroundTransparency = 1
        infoLbl.Text = string.format("%s • %.0f studs", info.class, info.dist)
        infoLbl.TextColor3 = T.TextDim
        infoLbl.Font = Enum.Font.Gotham
        infoLbl.TextSize = 11
        infoLbl.TextXAlignment = Enum.TextXAlignment.Left
        infoLbl.ZIndex = 10
        infoLbl.Parent = btn

        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = T.Accent:Lerp(T.Tertiary, 0.7)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = T.Tertiary}):Play()
        end)
        btn.MouseButton1Click:Connect(function()
            S.FarmTargetName = info.name
            for _, desc in pairs(targetInputFrame:GetDescendants()) do
                if desc:IsA("TextBox") then desc.Text = info.name; break end
            end
            print("🐗 Цель: " .. info.name)
            btn.BackgroundColor3 = T.Success
            task.wait(0.3)
            TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = T.Tertiary}):Play()
        end)
    end

    print(string.format("🐗 Найдено уникальных: %d", #found))
end

scanBtn.MouseButton1Click:Connect(function()
    scanBtn.Text = "⏳ Сканирую..."
    task.wait(0.1)
    pcall(scanObjects)
    scanBtn.Text = "🔍 Сканировать объекты рядом"
    ScanPanel.Visible = true
end)

createLabel(FarmTab, "НАСТРОЙКИ")
createToggle(FarmTab, "⚡ Телепорт к цели", S.FarmTeleport, function(state) S.FarmTeleport = state end)
createSlider(FarmTab, "Радиус поиска", 10, 300, S.FarmRange, function(val) S.FarmRange = val end)
createSlider(FarmTab, "Задержка удара (x100)", 1, 30, 8, function(val) S.FarmHitCooldown = val / 100 end)
createToggle(FarmTab, "Использовать инструмент", S.FarmUseTool, function(state) S.FarmUseTool = state end)

-- === УМНЫЙ ЦИКЛ ФАРМА ===
local farmThread = nil

local function startFarmLoop()
    if farmThread then return end
    farmThread = task.spawn(function()
        local currentTarget = nil
        local attackBusy = false

        while S.AutoFarmEnabled and not Hub.IsPanicked do
            task.wait(0.1)

            local ch = player.Character
            if not ch then task.wait(0.5); continue end
            local hum = ch:FindFirstChild("Humanoid")
            local rp = ch:FindFirstChild("HumanoidRootPart")
            if not hum or not rp then task.wait(0.5); continue end

            -- Проверяем текущую цель
            if currentTarget and not currentTarget.Parent then
                currentTarget = nil
                print("🐗 Груша сломана — ищу новую")
            end

            -- Ищем новую если нет
            if not currentTarget then
                local targets = refreshTargetsCache()
                if #targets > 0 then
                    currentTarget = targets[1].part
                    print(string.format("🐗 Цель: %s (%.0f studs) | Всего: %d", currentTarget.Name, targets[1].dist, #targets))
                end
            end

            -- Действия с целью
            if currentTarget and currentTarget.Parent then
                local d = (currentTarget.Position - rp.Position).Magnitude

                -- Телепорт / подход
                if S.FarmTeleport and d > 5 then
                    local dir = (rp.Position - currentTarget.Position).Unit
                    local newPos = currentTarget.Position + dir * 3 + Vector3.new(0, 3, 0)
                    rp.CFrame = CFrame.new(newPos, currentTarget.Position)
                elseif not S.FarmTeleport and d > 8 then
                    hum:MoveTo(currentTarget.Position)
                end

                -- Атака
                if not attackBusy then
                    attackBusy = true
                    task.spawn(function()
                        while S.AutoFarmEnabled and not Hub.IsPanicked and currentTarget and currentTarget.Parent do
                            local ch2 = player.Character
                            if not ch2 then break end
                            local tool = ch2:FindFirstChildWhichIsA("Tool")
                            if tool and S.FarmUseTool then
                                pcall(function() tool:Activate() end)
                            end
                            pcall(function()
                                VirtualUser:Button1Down(Vector2.new(0, 0))
                                task.wait(S.FarmHitCooldown)
                                VirtualUser:Button1Up(Vector2.new(0, 0))
                            end)
                            task.wait(S.FarmHitCooldown)
                        end
                        attackBusy = false
                    end)
                end
            end
        end

        -- При выходе из цикла — сброс
        farmThread = nil
        print("🐗 Цикл фарма остановлен")
    end)
end

-- Подписываемся на изменение AutoFarmEnabled
-- Используем Heartbeat чтобы отслеживать переключение
local lastFarmState = false
Hub.addConnection(RunService.Heartbeat:Connect(function()
    if Hub.IsPanicked then return end
    if S.AutoFarmEnabled and not lastFarmState then
        -- Только что включили
        lastFarmState = true
        startFarmLoop()
    elseif not S.AutoFarmEnabled and lastFarmState then
        -- Только что выключили
        lastFarmState = false
        -- farmThread сам завершится по проверке S.AutoFarmEnabled
        -- Плюс сбрасываем скорость
        local ch = player.Character
        if ch and ch:FindFirstChild("Humanoid") then
            ch.Humanoid.WalkSpeed = 16
        end
        targetsCache = {}
    end
end))

print("🐗 Farm модуль загружен (v4 — оптимизированный)")
