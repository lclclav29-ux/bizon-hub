-- 🐗 Bizon Hub Teleport v5
local TweenService = game:GetService("TweenService")
local Hub = _G.BizonHub
if not Hub then warn("🐗 Загрузи core.lua!") return end
local T = Hub.Theme
local player = game.Players.LocalPlayer

local WORLDS = {
    {name = "🏠 Спавн",          pos = Vector3.new(0, 10, 0)},
    {name = "🌀 Мир 1",          pos = Vector3.new(10, 10, 78)},
    {name = "🌀 Мир 2",          pos = Vector3.new(763, 10, 92)},
}

local savedPos = nil
local TpTab = Hub.createTab("Teleport", "🌀")

-- ============ УТИЛИТЫ ============

-- Получить инфо вкладки
local function getTabInfo()
    return Hub.Tabs["Teleport"]
end

-- Получить/создать строку 2 колонки
local function getRow()
    local tab = getTabInfo()
    if not tab then return TpTab end
    
    if not tab.tpRow or tab.tpCol >= 2 then
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 52)
        row.BackgroundTransparency = 1
        row.Parent = TpTab
        
        local layout = Instance.new("UIListLayout", row)
        layout.FillDirection = Enum.FillDirection.Horizontal
        layout.Padding = UDim.new(0, 6)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        
        tab.tpRow = row
        tab.tpCol = 0
    end
    tab.tpCol = tab.tpCol + 1
    return tab.tpRow
end

-- Сбросить строку
local function resetRow()
    local tab = getTabInfo()
    if tab then
        tab.tpRow = nil
        tab.tpCol = 0
    end
end

-- УНИВЕРСАЛЬНАЯ функция телепорта
local function teleportTo(pos)
    local ch = player.Character
    if not ch then return false end
    local hrp = ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
    return true
end

-- УНИВЕРСАЛЬНАЯ функция поиска позиции игрока
local function getPlayerPosition(plr)
    if not plr or not plr.Character then return nil end
    local char = plr.Character
    
    -- Пробуем разные части по очереди
    local targetPart = char:FindFirstChild("HumanoidRootPart")
        or char:FindFirstChild("UpperTorso")
        or char:FindFirstChild("Torso")
        or char:FindFirstChild("Head")
    
    -- Если не нашли — берём ЛЮБУЮ BasePart
    if not targetPart then
        for _, obj in pairs(char:GetDescendants()) do
            if obj:IsA("BasePart") then
                targetPart = obj
                break
            end
        end
    end
    
    if targetPart then
        return targetPart.Position
    end
    return nil
end

-- ============ СОЗДАНИЕ КАРТОЧКИ ============
local function createCard(parent, label, callback, half)
    local btn = Instance.new("TextButton")
    btn.Size = half and UDim2.new(0.5, -3, 0, 52) or UDim2.new(1, 0, 0, 52)
    btn.BackgroundColor3 = T.Bg3
    btn.BackgroundTransparency = 0.35
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)

    local grad = Instance.new("UIGradient", btn)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, T.Bg4),
        ColorSequenceKeypoint.new(1, T.Bg3),
    })
    grad.Rotation = 45

    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = T.Stroke
    stroke.Thickness = 1
    stroke.Transparency = 0.5

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -16, 1, 0)
    lbl.Position = UDim2.new(0, 14, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = T.Text
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.15}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Color = T.Accent, Transparency = 0.55}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.35}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Color = T.Stroke, Transparency = 0.5}):Play()
    end)

    btn.MouseButton1Click:Connect(function()
        callback(lbl)
    end)
    return btn
end

-- ============ БЫСТРЫЙ ТЕЛЕПОРТ ============
Hub.createLabel(TpTab, "Быстрый телепорт")
resetRow()

for _, world in pairs(WORLDS) do
    local row = getRow()
    createCard(row, world.name, function(lbl)
        teleportTo(world.pos)
        lbl.Text = "✅ " .. world.name
        task.wait(0.6)
        lbl.Text = world.name
    end, true)
end

-- ============ СОХРАНЁННЫЕ ТОЧКИ ============
Hub.createLabel(TpTab, "Сохранённые точки")
resetRow()

createCard(getRow(), "💾 Сохранить позицию", function(lbl)
    local ch = player.Character
    if not ch then return end
    local hrp = ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    savedPos = hrp.Position
    lbl.Text = "✅ Сохранено"
    task.wait(1.2)
    lbl.Text = "💾 Сохранить позицию"
end, true)

createCard(getRow(), "📍 Вернуться", function(lbl)
    if not savedPos then
        lbl.Text = "❌ Сначала сохрани"
        task.wait(1.2)
        lbl.Text = "📍 Вернуться"
        return
    end
    teleportTo(savedPos)
end, true)

-- ============ ИГРОКИ ОНЛАЙН ============
Hub.createLabel(TpTab, "Игроки онлайн")
resetRow()

-- Контейнер со списком игроков (на всю ширину)
local playersList = Instance.new("ScrollingFrame")
playersList.Size = UDim2.new(1, 0, 0, 220)
playersList.BackgroundColor3 = T.Bg
playersList.BackgroundTransparency = 0.5
playersList.BorderSizePixel = 0
playersList.ScrollBarThickness = 3
playersList.ScrollBarImageColor3 = T.Accent
playersList.CanvasSize = UDim2.new(0, 0, 0, 0)
playersList.Parent = TpTab
Instance.new("UICorner", playersList).CornerRadius = UDim.new(0, 12)

local listLayout = Instance.new("UIListLayout", playersList)
listLayout.Padding = UDim.new(0, 4)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

local listPad = Instance.new("UIPadding", playersList)
listPad.PaddingTop = UDim.new(0, 6)
listPad.PaddingBottom = UDim.new(0, 6)
listPad.PaddingLeft = UDim.new(0, 6)
listPad.PaddingRight = UDim.new(0, 6)

listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    playersList.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 12)
end)

-- Обновление списка игроков
local function updatePlayersList()
    for _, child in pairs(playersList:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("TextLabel") then
            child:Destroy()
        end
    end

    local players = {}
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player then 
            table.insert(players, plr) 
        end
    end
    table.sort(players, function(a, b) 
        return a.Name:lower() < b.Name:lower() 
    end)

    if #players == 0 then
        local empty = Instance.new("TextLabel")
        empty.Size = UDim2.new(1, 0, 0, 40)
        empty.BackgroundTransparency = 1
        empty.Text = "😴 Кроме тебя никого нет"
        empty.TextColor3 = T.TextDim
        empty.Font = Enum.Font.Gotham
        empty.TextSize = 12
        empty.Parent = playersList
        return
    end

    for _, plr in pairs(players) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 34)
        btn.BackgroundColor3 = T.Bg3
        btn.BackgroundTransparency = 0.35
        btn.Text = ""
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Parent = playersList
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

        -- Индикатор (зелёный/красный)
        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, 8, 0, 8)
        dot.Position = UDim2.new(0, 10, 0.5, -4)
        dot.BackgroundColor3 = plr.Character and T.Success or T.Danger
        dot.BorderSizePixel = 0
        dot.Parent = btn
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

        -- Имя
        local nameLbl = Instance.new("TextLabel")
        nameLbl.Size = UDim2.new(1, -70, 1, 0)
        nameLbl.Position = UDim2.new(0, 26, 0, 0)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = plr.Name
        nameLbl.TextColor3 = T.Text
        nameLbl.Font = Enum.Font.GothamMedium
        nameLbl.TextSize = 12
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left
        nameLbl.Parent = btn

        -- Кнопка TP
        local tpLbl = Instance.new("TextLabel")
        tpLbl.Size = UDim2.new(0, 50, 1, 0)
        tpLbl.Position = UDim2.new(1, -55, 0, 0)
        tpLbl.BackgroundTransparency = 1
        tpLbl.Text = "TP →"
        tpLbl.TextColor3 = T.Accent
        tpLbl.Font = Enum.Font.GothamBold
        tpLbl.TextSize = 11
        tpLbl.Parent = btn

        -- Hover
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.15}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.35}):Play()
        end)

        -- Клик = телепорт
        btn.MouseButton1Click:Connect(function()
            -- Проверяем персонажа
            if not plr.Character then
                nameLbl.Text = "❌ " .. plr.Name .. " (нет персонажа)"
                nameLbl.TextColor3 = T.Danger
                task.wait(1.5)
                nameLbl.Text = plr.Name
                nameLbl.TextColor3 = T.Text
                return
            end
            
            -- Универсальный поиск позиции
            local pos = getPlayerPosition(plr)
            
            if not pos then
                nameLbl.Text = "❌ Не могу найти позицию"
                nameLbl.TextColor3 = T.Danger
                task.wait(1.5)
                nameLbl.Text = plr.Name
                nameLbl.TextColor3 = T.Text
                return
            end
            
            -- Телепорт
            local ok = teleportTo(pos)
            
            if ok then
                nameLbl.Text = "✅ Телепорт к " .. plr.Name
                nameLbl.TextColor3 = T.Success
                task.wait(0.6)
                nameLbl.Text = plr.Name
                nameLbl.TextColor3 = T.Text
            else
                nameLbl.Text = "❌ Ошибка телепорта"
                nameLbl.TextColor3 = T.Danger
                task.wait(1.5)
                nameLbl.Text = plr.Name
                nameLbl.TextColor3 = T.Text
            end
        end)
    end
end

-- Первое обновление
updatePlayersList()

-- Авто-обновление каждые 3 секунды
task.spawn(function()
    while TpTab.Parent and not Hub.IsPanicked do
        task.wait(3)
        if TpTab.Parent then 
            pcall(updatePlayersList)
        end
    end
end)

print("🐗 Teleport v5 загружен")
