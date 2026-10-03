-- 🐗 Bizon Hub Teleport v6 (Clean)
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

local function resetRow()
    local tab = getTabInfo()
    if tab then
        tab.tpRow = nil
        tab.tpCol = 0
    end
end

-- Телепорт
local function teleportTo(pos)
    local ch = player.Character
    if not ch then return false end
    local hrp = ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
    return true
end

-- Кнопка-карточка
local function createCard(parent, label, callback)
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
    end)
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
end)

createCard(getRow(), "📍 Вернуться", function(lbl)
    if not savedPos then
        lbl.Text = "❌ Сначала сохрани"
        task.wait(1.2)
        lbl.Text = "📍 Вернуться"
        return
    end
    teleportTo(savedPos)
end)

print("🐗 Teleport v6 загружен (Clean)")
