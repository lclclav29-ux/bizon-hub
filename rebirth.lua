-- 🐗 Bizon Hub Rebirth
local Hub = _G.BizonHub
if not Hub then warn("🐗 Загрузи core.lua!") return end
local T = Hub.Theme
local player = game.Players.LocalPlayer

local RebirthTab = Hub.createTab("Rebirth", "🔄")

-- Находим RemoteFunction
local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Shared")
if remotes then remotes = remotes:FindFirstChild("Remotes") end

local RequestRebirth = nil
if remotes then
    RequestRebirth = remotes:FindFirstChild("RequestRebirth")
end

-- Статистика
local stats = {
    total = 0,
    lastTime = 0,
    autoOn = false,
    delay = 1,
    attempts = 0,
    errors = 0,
}

Hub.createLabel(RebirthTab, "Авто ребёрс")

-- Toggle Auto Rebirth
local autoToggle = Hub.createToggle(RebirthTab, "🔄 Auto Rebirth", false, function(state)
    stats.autoOn = state
    print("🔄 Auto Rebirth: " .. (state and "ВКЛ" or "ВЫКЛ"))
end)

-- Slider задержки
Hub.createSlider(RebirthTab, "Задержка (сек)", 1, 10, 1, function(v)
    stats.delay = v
end)

Hub.createLabel(RebirthTab, "Информация")

-- Счётчик
local infoFrame = Instance.new("Frame")
infoFrame.Size = UDim2.new(1, 0, 0, 90)
infoFrame.BackgroundColor3 = T.Bg3
infoFrame.BackgroundTransparency = 0.35
infoFrame.BorderSizePixel = 0
infoFrame.Parent = RebirthTab
Instance.new("UICorner", infoFrame).CornerRadius = UDim.new(0, 12)

local infoGrad = Instance.new("UIGradient", infoFrame)
infoGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, T.Bg4),
    ColorSequenceKeypoint.new(1, T.Bg3),
})
infoGrad.Rotation = 45

local infoStroke = Instance.new("UIStroke", infoFrame)
infoStroke.Color = T.Stroke
infoStroke.Thickness = 1
infoStroke.Transparency = 0.5

local totalLbl = Instance.new("TextLabel")
totalLbl.Size = UDim2.new(1, -20, 0, 30)
totalLbl.Position = UDim2.new(0, 14, 0, 10)
totalLbl.BackgroundTransparency = 1
totalLbl.Text = "✅ Ребёрсов: 0"
totalLbl.TextColor3 = T.Success
totalLbl.Font = Enum.Font.GothamBold
totalLbl.TextSize = 14
totalLbl.TextXAlignment = Enum.TextXAlignment.Left
totalLbl.Parent = infoFrame

local statusLbl = Instance.new("TextLabel")
statusLbl.Size = UDim2.new(1, -20, 0, 20)
statusLbl.Position = UDim2.new(0, 14, 0, 42)
statusLbl.BackgroundTransparency = 1
statusLbl.Text = "Статус: ожидание"
statusLbl.TextColor3 = T.TextDim
statusLbl.Font = Enum.Font.Gotham
statusLbl.TextSize = 11
statusLbl.TextXAlignment = Enum.TextXAlignment.Left
statusLbl.Parent = infoFrame

local errorLbl = Instance.new("TextLabel")
errorLbl.Size = UDim2.new(1, -20, 0, 20)
errorLbl.Position = UDim2.new(0, 14, 0, 62)
errorLbl.BackgroundTransparency = 1
errorLbl.Text = "Ошибок: 0"
errorLbl.TextColor3 = T.Danger
errorLbl.Font = Enum.Font.Gotham
errorLbl.TextSize = 11
errorLbl.TextXAlignment = Enum.TextXAlignment.Left
errorLbl.Parent = infoFrame

-- Функция ребёрса
local function doRebirth()
    if not RequestRebirth then
        return false, "Remote не найден"
    end
    
    stats.attempts = stats.attempts + 1
    
    local ok, result = pcall(function()
        return RequestRebirth:InvokeServer()
    end)
    
    if not ok then
        stats.errors = stats.errors + 1
        return false, tostring(result)
    end
    
    return true, result
end

-- Auto loop
task.spawn(function()
    while not Hub.IsPanicked do
        task.wait(0.3)
        
        if stats.autoOn and RequestRebirth then
            local now = tick()
            
            if now - stats.lastTime >= stats.delay then
                stats.lastTime = now
                
                local success, result = doRebirth()
                
                if success then
                    stats.total = stats.total + 1
                    totalLbl.Text = "✅ Ребёрсов: " .. stats.total
                    statusLbl.Text = "Статус: последний ребёрс " .. os.date("%H:%M:%S")
                    statusLbl.TextColor3 = T.Success
                    print("🔄 Ребёрс выполнен (#" .. stats.total .. ")")
                else
                    statusLbl.Text = "Статус: ошибка"
                    statusLbl.TextColor3 = T.Danger
                    errorLbl.Text = "Ошибок: " .. stats.errors .. " | " .. tostring(result):sub(1, 40)
                    print("🔄 Ошибка ребёрса: " .. tostring(result))
                end
            end
        end
    end
end)

-- Кнопка "Ребёрс сейчас"
Hub.createLabel(RebirthTab, "Ручной ребёрс")

local manualBtn = Instance.new("TextButton")
manualBtn.Size = UDim2.new(1, 0, 0, 52)
manualBtn.BackgroundColor3 = T.Accent
manualBtn.BackgroundTransparency = 0.15
manualBtn.Text = "🔄 РЕБЁРС СЕЙЧАС"
manualBtn.TextColor3 = T.Bg
manualBtn.Font = Enum.Font.GothamBold
manualBtn.TextSize = 14
manualBtn.BorderSizePixel = 0
manualBtn.AutoButtonColor = false
manualBtn.Parent = RebirthTab
Instance.new("UICorner", manualBtn).CornerRadius = UDim.new(0, 12)

local manualStroke = Instance.new("UIStroke", manualBtn)
manualStroke.Color = T.AccentGlow
manualStroke.Thickness = 1.5
manualStroke.Transparency = 0.3

manualBtn.MouseButton1Click:Connect(function()
    manualBtn.Text = "🔄 ВЫПОЛНЯЮ..."
    
    local ok, result = doRebirth()
    
    if ok then
        stats.total = stats.total + 1
        totalLbl.Text = "✅ Ребёрсов: " .. stats.total
        manualBtn.Text = "✅ ГОТОВО"
        manualBtn.BackgroundColor3 = T.Success
        task.wait(1)
        manualBtn.Text = "🔄 РЕБЁРС СЕЙЧАС"
        manualBtn.BackgroundColor3 = T.Accent
    else
        manualBtn.Text = "❌ ОШИБКА"
        manualBtn.BackgroundColor3 = T.Danger
        errorLbl.Text = "Ошибок: " .. stats.errors .. " | " .. tostring(result):sub(1, 40)
        task.wait(1.5)
        manualBtn.Text = "🔄 РЕБЁРС СЕЙЧАС"
        manualBtn.BackgroundColor3 = T.Accent
    end
end)

manualBtn.MouseEnter:Connect(function()
    TweenService:Create(manualBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
end)
manualBtn.MouseLeave:Connect(function()
    TweenService:Create(manualBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.15}):Play()
end)

print("🐗 Rebirth модуль загружен")
