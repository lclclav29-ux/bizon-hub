-- 🐗 Bizon Hub Teleport v3
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Hub = _G.BizonHub
if not Hub then warn("🐗 Загрузи core.lua!") return end
local T = Hub.Theme
local player = game.Players.LocalPlayer

local WORLDS = {
    {name = "🏠 Спавн",          pos = Vector3.new(0, 10, 0)},
    {name = "🌀 Мир 1 (Портал)", pos = Vector3.new(10, 10, 78)},
    {name = "🌀 Мир 2",          pos = Vector3.new(763, 10, 92)},
}

local savedPos = nil
local TpTab = Hub.createTab("Teleport", "🌀")

-- Функция телепорта
local function teleportTo(pos)
    local ch = player.Character
    if not ch then return end
    local hrp = ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
    print("🌀 Телепорт в " .. tostring(pos))
end

-- Кнопка-карточка для телепорта
local function createTeleportCard(parent, name, position)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.5, -3, 0, 52)
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
    lbl.Text = name
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
        teleportTo(position)
        lbl.Text = "✅ " .. name
        task.wait(0.5)
        lbl.Text = name
    end)
    return btn
end

-- Получаем/создаём строку на 2 колонки
local function getTpRow()
    if not TpTab.currentRow or TpTab.colCount >= 2 then
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 52)
        row.BackgroundTransparency = 1
        row.Parent = TpTab
        
        local layout = Instance.new("UIListLayout", row)
        layout.FillDirection = Enum.FillDirection.Horizontal
        layout.Padding = UDim.new(0, 6)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        
        TpTab.currentRow = row
        TpTab.colCount = 0
    end
    TpTab.colCount = TpTab.colCount + 1
    return TpTab.currentRow
end

-- Заголовок
Hub.createLabel(TpTab, "Быстрый телепорт")
TpTab.currentRow = nil
TpTab.colCount = 0

-- Кнопки миров
for _, world in pairs(WORLDS) do
    createTeleportCard(getTpRow(), world.name, world.pos)
end

-- Заголовок
Hub.createLabel(TpTab, "Сохранённые точки")
TpTab.currentRow = nil
TpTab.colCount = 0

-- Save
local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(0.5, -3, 0, 52)
saveBtn.BackgroundColor3 = T.Bg3
saveBtn.BackgroundTransparency = 0.35
saveBtn.Text = ""
saveBtn.BorderSizePixel = 0
saveBtn.AutoButtonColor = false
saveBtn.Parent = getTpRow()
Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 12)

local saveStroke = Instance.new("UIStroke", saveBtn)
saveStroke.Color = T.Stroke
saveStroke.Thickness = 1
saveStroke.Transparency = 0.5

local saveLbl = Instance.new("TextLabel")
saveLbl.Size = UDim2.new(1, -16, 1, 0)
saveLbl.Position = UDim2.new(0, 14, 0, 0)
saveLbl.BackgroundTransparency = 1
saveLbl.Text = "💾 Сохранить"
saveLbl.TextColor3 = T.Text
saveLbl.Font = Enum.Font.GothamMedium
saveLbl.TextSize = 12
saveLbl.TextXAlignment = Enum.TextXAlignment.Left
saveLbl.Parent = saveBtn

saveBtn.MouseButton1Click:Connect(function()
    local ch = player.Character
    if not ch then return end
    local hrp = ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    savedPos = hrp.Position
    saveLbl.Text = "✅ Сохранено"
    task.wait(1.2)
    saveLbl.Text = "💾 Сохранить"
end)

-- Load
local loadBtn = Instance.new("TextButton")
loadBtn.Size = UDim2.new(0.5, -3, 0, 52)
loadBtn.BackgroundColor3 = T.Bg3
loadBtn.BackgroundTransparency = 0.35
loadBtn.Text = ""
loadBtn.BorderSizePixel = 0
loadBtn.AutoButtonColor = false
loadBtn.Parent = getTpRow()
Instance.new("UICorner", loadBtn).CornerRadius = UDim.new(0, 12)

local loadStroke = Instance.new("UIStroke", loadBtn)
loadStroke.Color = T.Stroke
loadStroke.Thickness = 1
loadStroke.Transparency = 0.5

local loadLbl = Instance.new("TextLabel")
loadLbl.Size = UDim2.new(1, -16, 1, 0)
loadLbl.Position = UDim2.new(0, 14, 0, 0)
loadLbl.BackgroundTransparency = 1
loadLbl.Text = "📍 Вернуться"
loadLbl.TextColor3 = T.Text
loadLbl.Font = Enum.Font.GothamMedium
loadLbl.TextSize = 12
loadLbl.TextXAlignment = Enum.TextXAlignment.Left
loadLbl.Parent = loadBtn

loadBtn.MouseButton1Click:Connect(function()
    if not savedPos then
        loadLbl.Text = "❌ Сначала сохрани"
        task.wait(1.2)
        loadLbl.Text = "📍 Вернуться"
        return
    end
    teleportTo(savedPos)
end)

-- Заголовок
Hub.createLabel(TpTab, "Игроки онлайн")
TpTab.currentRow = nil
TpTab.colCount = 0

-- Список игроков на всю ширину
local playersList = Instance.new("ScrollingFrame")
playersList.Size = UDim2.new(1, 0, 0, 180)
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

listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    playersList.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 12)
end)

local function updatePlayersList()
    for _, child in pairs(playersList:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("TextLabel") then
            child:Destroy()
        end
    end

    local players = {}
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player then table.insert(players, plr) end
    end
    table.sort(players, function(a, b) return a.Name:lower() < b.Name:lower() end)

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
        btn.Size = UDim2.new(1, 0, 0, 32)
        btn.BackgroundColor3 = T.Bg3
        btn.BackgroundTransparency = 0.35
        btn.Text = ""
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Parent = playersList
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, 8, 0, 8)
        dot.Position = UDim2.new(0, 10, 0.5, -4)
        dot.BackgroundColor3 = T.Success
        dot.BorderSizePixel = 0
        dot.Parent = btn
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

        local nameLbl = Instance.new("TextLabel")
        nameLbl.Size = UDim2.new(1, -60, 1, 0)
        nameLbl.Position = UDim2.new(0, 26, 0, 0)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = plr.Name
        nameLbl.TextColor3 = T.Text
        nameLbl.Font = Enum.Font.GothamMedium
        nameLbl.TextSize = 12
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left
        nameLbl.Parent = btn

        local tpLbl = Instance.new("TextLabel")
        tpLbl.Size = UDim2.new(0, 40, 1, 0)
        tpLbl.Position = UDim2.new(1, -44, 0, 0)
        tpLbl.BackgroundTransparency = 1
        tpLbl.Text = "TP →"
        tpLbl.TextColor3 = T.Accent
        tpLbl.Font = Enum.Font.GothamBold
        tpLbl.TextSize = 11
        tpLbl.Parent = btn

        btn.MouseButton1Click:Connect(function()
            if plr.Character then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if hrp then teleportTo(hrp.Position) end
            end
        end)
    end
end

updatePlayersList()
task.spawn(function()
    while TpTab.Parent and not Hub.IsPanicked do
        task.wait(2)
        if TpTab.Parent then updatePlayersList() end
    end
end)

print("🐗 Teleport загружен")
