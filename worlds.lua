-- 🐗 Bizon Hub Worlds
local TweenService = game:GetService("TweenService")

local Hub = _G.BizonHub
if not Hub then warn("🐗 Загрузи core.lua!") return end
local T = Hub.Theme
local player = game.Players.LocalPlayer

local WorldsTab = Hub.createTab("Worlds", "🌍")

-- Координаты миров (из точной диагностики)
local WORLDS = {
    {name = "🌍 World 1",  mapName = "Map4"},
    {name = "🌍 World 2",  mapName = "Map5"},
    {name = "🌍 World 3",  mapName = "Map6"},
    {name = "🌍 World 4",  mapName = "Map7"},
    {name = "🌍 World 5",  mapName = "Map8"},
    {name = "🌍 World 6",  mapName = "Map9"},
    {name = "🌍 World 7",  mapName = "Map10"},
}

local SPECIAL_ZONES = {
    {name = "⚔️ Raid",        mapName = "Raid"},
    {name = "💰 BlackMarket", mapName = "BlackMarket"},
    {name = "🏋 Training",    mapName = "TrainingZone"},
    {name = "👹 BossFight",   mapName = "BossFightStage"},
    {name = "🏟 Hero Arena",  mapName = "HeroTilesArena"},
    {name = "💀 Survival",    mapName = "SurvivalArena"},
    {name = "🔥 Meteor",      mapName = "MeteorShower"},
    {name = "🏠 MapTest",     mapName = "MapTest"},
}

-- Живые координаты из Workspace
local function getLiveCoord(mapName)
    local ok, result = pcall(function()
        local map = workspace:FindFirstChild(mapName)
        if map then
            local p = map:FindFirstChildWhichIsA("BasePart", true)
            if p then return p.Position end
        end
        return nil
    end)
    return ok and result or nil
end

-- ТП
local function teleportTo(pos)
    local ch = player.Character
    if not ch then return false end
    local hrp = ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    hrp.CFrame = CFrame.new(pos + Vector3.new(0, 5, 0))
    return true
end

-- Row
local function getRow()
    local tab = Hub.Tabs["Worlds"]
    if not tab then return WorldsTab end
    if not tab.wRow or (tab.wCol or 0) >= 2 then
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 56)
        row.BackgroundTransparency = 1
        row.Parent = WorldsTab
        local layout = Instance.new("UIListLayout", row)
        layout.FillDirection = Enum.FillDirection.Horizontal
        layout.Padding = UDim.new(0, 8)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        tab.wRow = row
        tab.wCol = 0
    end
    tab.wCol = (tab.wCol or 0) + 1
    return tab.wRow
end

-- Карточка
local function createWorldCard(name, mapName)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0.5, -4, 1, 0)
    container.BackgroundColor3 = T.Bg3
    container.BackgroundTransparency = 0.35
    container.BorderSizePixel = 0
    container.Parent = getRow()
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

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -80, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = T.Text
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local tpBtn = Instance.new("TextButton")
    tpBtn.Size = UDim2.new(0, 60, 0, 32)
    tpBtn.Position = UDim2.new(1, -70, 0.5, -16)
    tpBtn.BackgroundColor3 = T.Accent
    tpBtn.BackgroundTransparency = 0.15
    tpBtn.Text = "TP"
    tpBtn.TextColor3 = T.Text
    tpBtn.Font = Enum.Font.GothamBold
    tpBtn.TextSize = 12
    tpBtn.BorderSizePixel = 0
    tpBtn.AutoButtonColor = false
    tpBtn.Parent = container
    Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 8)

    tpBtn.MouseButton1Click:Connect(function()
        local pos = getLiveCoord(mapName)
        if not pos then
            tpBtn.Text = "❌"
            task.wait(1)
            tpBtn.Text = "TP"
            return
        end
        if teleportTo(pos) then
            tpBtn.Text = "✓"
            tpBtn.BackgroundColor3 = T.Success
            task.wait(0.8)
            tpBtn.Text = "TP"
            tpBtn.BackgroundColor3 = T.Accent
        end
    end)

    tpBtn.MouseEnter:Connect(function()
        TweenService:Create(tpBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
    end)
    tpBtn.MouseLeave:Connect(function()
        TweenService:Create(tpBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.15}):Play()
    end)

    container.MouseEnter:Connect(function()
        TweenService:Create(container, TweenInfo.new(0.2), {BackgroundTransparency = 0.15}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Color = T.Accent, Transparency = 0.55}):Play()
    end)
    container.MouseLeave:Connect(function()
        TweenService:Create(container, TweenInfo.new(0.2), {BackgroundTransparency = 0.35}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Color = T.Stroke, Transparency = 0.5}):Play()
    end)

    if Hub.attachTooltip then
        Hub.attachTooltip(container, name, "Телепорт в " .. name .. " (" .. mapName .. ")")
    end
end

-- Миры
Hub.createLabel(WorldsTab, "Кампания (World 1-7)")
WorldsTab.wRow = nil
WorldsTab.wCol = 0

for _, world in ipairs(WORLDS) do
    createWorldCard(world.name, world.mapName)
end

-- Зоны
Hub.createLabel(WorldsTab, "Специальные зоны")
WorldsTab.wRow = nil
WorldsTab.wCol = 0

for _, zone in ipairs(SPECIAL_ZONES) do
    createWorldCard(zone.name, zone.mapName)
end

print("🐗 Worlds модуль загружен (7 миров + 8 зон)")
