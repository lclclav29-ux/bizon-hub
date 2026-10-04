-- 🐗 Bizon Hub Teleport v8 (with Offset)
local TweenService = game:GetService("TweenService")

local Hub = _G.BizonHub
if not Hub then warn("🐗 Загрузи core.lua!") return end
local T = Hub.Theme
local player = game.Players.LocalPlayer

local TpTab = Hub.createTab("Teleport", "🌀")

-- ========== ХЕЛПЕРЫ ==========
local function getTabInfo()
    return Hub.Tabs["Teleport"]
end

local function getRow()
    local tab = getTabInfo()
    if not tab then return TpTab end
    if not tab.tpRow or (tab.tpCol or 0) >= 2 then
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 56)
        row.BackgroundTransparency = 1
        row.Parent = TpTab
        local layout = Instance.new("UIListLayout", row)
        layout.FillDirection = Enum.FillDirection.Horizontal
        layout.Padding = UDim.new(0, 8)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        tab.tpRow = row
        tab.tpCol = 0
    end
    tab.tpCol = (tab.tpCol or 0) + 1
    return tab.tpRow
end

local function resetRow()
    local tab = getTabInfo()
    if tab then
        tab.tpRow = nil
        tab.tpCol = 0
    end
end

-- ⭐ ТП С ОТСТУПОМ
local function teleportTo(pos, offsetX, offsetZ)
    local ch = player.Character
    if not ch then return false end
    local hrp = ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    offsetX = offsetX or 50    -- отступ вправо от центра
    offsetZ = offsetZ or 50    -- отступ вперёд от центра
    local offsetY = 5          -- отступ вверх (чтобы не застрять в полу)
    
    local newPos = Vector3.new(pos.X + offsetX, pos.Y + offsetY, pos.Z + offsetZ)
    hrp.CFrame = CFrame.new(newPos)
    return true
end

-- ⭐ Ищем Spawn внутри карты (а не Leaderboard!)
local function getSpawnOrCenter(mapName)
    local ok, result = pcall(function()
        local map = workspace:FindFirstChild(mapName)
        if not map then return nil end
        
        -- 1. Ищем Spawn / SpawnLocation
        local spawn = map:FindFirstChild("Spawn") or map:FindFirstChild("SpawnLocation")
        if spawn and spawn:IsA("BasePart") then
            return {part = spawn, offset = false}
        end
        
        -- 2. Ищем Floor (пол - обычно центр карты)
        local floor = map:FindFirstChild("Floor")
        if floor and floor:IsA("BasePart") then
            return {part = floor, offset = true}
        end
        
        -- 3. Ищем все части, КРОМЕ Leaderboard
        for _, obj in ipairs(map:GetChildren()) do
            if obj:IsA("BasePart") and not obj.Name:lower():find("leaderboard") then
                return {part = obj, offset = true}
            end
        end
        
        -- 4. Ищем внутри вложенных объектов
        for _, obj in ipairs(map:GetChildren()) do
            if obj:IsA("Model") or obj:IsA("Folder") then
                if not obj.Name:lower():find("leaderboard") then
                    local p = obj:FindFirstChildWhichIsA("BasePart", true)
                    if p then
                        return {part = p, offset = true}
                    end
                end
            end
        end
        
        return nil
    end)
    
    if not ok or not result then return nil, false end
    return result.part and result.part.Position, result.offset
end

local function createCard(parent, label, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.5, -4, 1, 0)
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
    lbl.Size = UDim2.new(1, -12, 1, 0)
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

-- ========== БЫСТРЫЙ ТЕЛЕПОРТ ==========
Hub.createLabel(TpTab, "Быстрый телепорт")
resetRow()

createCard(getRow(), "🏠 Спавн", function(lbl)
    if teleportTo(Vector3.new(0, 10, 0), 0, 0) then
        lbl.Text = "✅ Спавн"
        task.wait(0.6)
        lbl.Text = "🏠 Спавн"
    end
end)

createCard(getRow(), "🌀 Мир 1 (Портал)", function(lbl)
    if teleportTo(Vector3.new(2333, 15, 49), 0, 0) then
        lbl.Text = "✅ Мир 1"
        task.wait(0.6)
        lbl.Text = "🌀 Мир 1 (Портал)"
    end
end)

-- ========== ВСЕ МИРЫ ==========
Hub.createLabel(TpTab, "Все миры")
resetRow()

local WORLDS = {
    {name = "🌍 World 1", mapName = "Map4"},
    {name = "🌍 World 2", mapName = "Map5"},
    {name = "🌍 World 3", mapName = "Map6"},
    {name = "🌍 World 4", mapName = "Map7"},
    {name = "🌍 World 5", mapName = "Map8"},
    {name = "🌍 World 6", mapName = "Map9"},
    {name = "🌍 World 7", mapName = "Map10"},
}

for _, world in ipairs(WORLDS) do
    createCard(getRow(), world.name, function(lbl)
        local pos, needOffset = getSpawnOrCenter(world.mapName)
        if not pos then
            lbl.Text = "❌ Не найдено"
            task.wait(1)
            lbl.Text = world.name
            return
        end
        
        -- Если нашли Spawn — ТП прямо, если центр — со смещением
        if needOffset then
            teleportTo(pos, 50, 50)
        else
            teleportTo(pos, 0, 0)
        end
        
        lbl.Text = "✅ Телепорт"
        task.wait(0.6)
        lbl.Text = world.name
    end)
end

-- ========== СПЕЦИАЛЬНЫЕ ЗОНЫ ==========
Hub.createLabel(TpTab, "Специальные зоны")
resetRow()

local ZONES = {
    {name = "⚔️ Raid",        mapName = "Raid"},
    {name = "💰 BlackMarket", mapName = "BlackMarket"},
    {name = "🏋 Training",    mapName = "TrainingZone"},
    {name = "👹 BossFight",   mapName = "BossFightStage"},
    {name = "🏟 Hero Arena",  mapName = "HeroTilesArena"},
    {name = "💀 Survival",    mapName = "SurvivalArena"},
    {name = "🔥 Meteor",      mapName = "MeteorShower"},
}

for _, zone in ipairs(ZONES) do
    createCard(getRow(), zone.name, function(lbl)
        local pos, needOffset = getSpawnOrCenter(zone.mapName)
        if not pos then
            lbl.Text = "❌ Не найдено"
            task.wait(1)
            lbl.Text = zone.name
            return
        end
        
        if needOffset then
            teleportTo(pos, 30, 30)
        else
            teleportTo(pos, 0, 0)
        end
        
        lbl.Text = "✅ Телепорт"
        task.wait(0.6)
        lbl.Text = zone.name
    end)
end

-- ========== СОХРАНЁННЫЕ ТОЧКИ ==========
Hub.createLabel(TpTab, "Сохранённые точки")
resetRow()

local savedPos = nil

createCard(getRow(), "💾 Сохранить", function(lbl)
    local ch = player.Character
    if not ch then return end
    local hrp = ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    savedPos = hrp.Position
    lbl.Text = "✅ Сохранено"
    task.wait(1.2)
    lbl.Text = "💾 Сохранить"
end)

createCard(getRow(), "📍 Вернуться", function(lbl)
    if not savedPos then
        lbl.Text = "❌ Сначала сохрани"
        task.wait(1.2)
        lbl.Text = "📍 Вернуться"
        return
    end
    teleportTo(savedPos, 0, 0)
end)

print("🐗 Teleport v8 загружен (с отступом от Leaderboard)")
