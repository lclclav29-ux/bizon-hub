-- 🐗 Bizon Hub Teleport
local UserInputService = game:GetService("UserInputService")

local Hub = _G.BizonHub
if not Hub then warn("🐗 Загрузи core.lua!") return end
local T = Hub.Theme
local S = Hub.Settings
local player = game.Players.LocalPlayer

-- === КООРДИНАТЫ МИРОВ ===
-- Портал в Мир 2 находится около X≈10, Z≈78
-- Мир 2 находится около X≈763, Z≈92
local WORLDS = {
    {name = "🏠 Спавн",       pos = Vector3.new(0, 10, 0)},
    {name = "🌀 Мир 1 (Портал)", pos = Vector3.new(10, 10, 78)},
    {name = "🌀 Мир 2",       pos = Vector3.new(763, 10, 92)},
}

local savedPos = nil  -- для Save/Load

-- === TELEPORT TAB ===
local TpTab = Hub.createTab("Teleport", "🌀")

Hub.createLabel(TpTab, "БЫСТРЫЙ ТЕЛЕПОРТ")

-- Функция телепорта
local function teleportTo(pos)
    local ch = player.Character
    if not ch then
        warn("🐗 Персонаж не найден")
        return
    end
    local hrp = ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
    print("🌀 Телепорт в " .. tostring(pos))
end

-- Кнопки телепорта для каждого мира
for _, world in pairs(WORLDS) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 42)
    btn.BackgroundColor3 = T.Bg3
    btn.Text = world.name
    btn.TextColor3 = T.Text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = TpTab
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = T.Accent
        btn.TextColor3 = T.Bg
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = T.Bg3
        btn.TextColor3 = T.Text
    end)
    btn.MouseButton1Click:Connect(function()
        teleportTo(world.pos)
        btn.Text = "✅ " .. world.name
        task.wait(0.4)
        btn.Text = world.name
    end)
end

Hub.createLabel(TpTab, "СОХРАНЁННЫЕ ТОЧКИ")

-- Кнопка "Сохранить"
local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(1, 0, 0, 42)
saveBtn.BackgroundColor3 = T.Bg3
saveBtn.Text = "💾 Сохранить позицию"
saveBtn.TextColor3 = T.Text
saveBtn.Font = Enum.Font.GothamBold
saveBtn.TextSize = 13
saveBtn.BorderSizePixel = 0
saveBtn.AutoButtonColor = false
saveBtn.Parent = TpTab
Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 12)

saveBtn.MouseButton1Click:Connect(function()
    local ch = player.Character
    if not ch then return end
    local hrp = ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    savedPos = hrp.Position
    saveBtn.Text = "💾 Сохранено (" .. math.floor(savedPos.X) .. ", " .. math.floor(savedPos.Z) .. ")"
    saveBtn.BackgroundColor3 = T.Success
    task.wait(0.5)
    saveBtn.BackgroundColor3 = T.Bg3
end)

-- Кнопка "Вернуться"
local loadBtn = Instance.new("TextButton")
loadBtn.Size = UDim2.new(1, 0, 0, 42)
loadBtn.BackgroundColor3 = T.Bg3
loadBtn.Text = "📍 Вернуться к точке"
loadBtn.TextColor3 = T.Text
loadBtn.Font = Enum.Font.GothamBold
loadBtn.TextSize = 13
loadBtn.BorderSizePixel = 0
loadBtn.AutoButtonColor = false
loadBtn.Parent = TpTab
Instance.new("UICorner", loadBtn).CornerRadius = UDim.new(0, 12)

loadBtn.MouseButton1Click:Connect(function()
    if not savedPos then
        loadBtn.Text = "❌ Сначала сохрани"
        loadBtn.BackgroundColor3 = T.Danger
        task.wait(1)
        loadBtn.Text = "📍 Вернуться к точке"
        loadBtn.BackgroundColor3 = T.Bg3
        return
    end
    teleportTo(savedPos)
    loadBtn.Text = "✅ Телепортирован"
    loadBtn.BackgroundColor3 = T.Success
    task.wait(0.4)
    loadBtn.Text = "📍 Вернуться к точке"
    loadBtn.BackgroundColor3 = T.Bg3
end)

-- Телепорт к игроку
Hub.createLabel(TpTab, "К ИГРОКУ")

local playerInput = Instance.new("TextBox")
playerInput.Size = UDim2.new(1, 0, 0, 40)
playerInput.BackgroundColor3 = T.Bg
playerInput.Text = ""
playerInput.PlaceholderText = "Введи ник игрока..."
playerInput.PlaceholderColor3 = T.TextDim
playerInput.TextColor3 = T.Accent
playerInput.Font = Enum.Font.GothamBold
playerInput.TextSize = 13
playerInput.BorderSizePixel = 0
playerInput.ClearTextOnFocus = false
playerInput.Parent = TpTab
Instance.new("UICorner", playerInput).CornerRadius = UDim.new(0, 12)

local tpPlayerBtn = Instance.new("TextButton")
tpPlayerBtn.Size = UDim2.new(1, 0, 0, 42)
tpPlayerBtn.BackgroundColor3 = T.Accent
tpPlayerBtn.Text = "🎯 Телепорт к игроку"
tpPlayerBtn.TextColor3 = T.Bg
tpPlayerBtn.Font = Enum.Font.GothamBold
tpPlayerBtn.TextSize = 13
tpPlayerBtn.BorderSizePixel = 0
tpPlayerBtn.AutoButtonColor = false
tpPlayerBtn.Parent = TpTab
Instance.new("UICorner", tpPlayerBtn).CornerRadius = UDim.new(0, 12)

tpPlayerBtn.MouseButton1Click:Connect(function()
    local name = playerInput.Text:gsub("%s", "")
    if name == "" then
        tpPlayerBtn.Text = "❌ Введи ник"
        tpPlayerBtn.BackgroundColor3 = T.Danger
        task.wait(1)
        tpPlayerBtn.Text = "🎯 Телепорт к игроку"
        tpPlayerBtn.BackgroundColor3 = T.Accent
        return
    end

    local target = nil
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Name:lower():find(name:lower()) then
            target = plr
            break
        end
    end

    if target and target.Character then
        local hrp = target.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            teleportTo(hrp.Position)
            tpPlayerBtn.Text = "✅ Телепорт к " .. target.Name
            task.wait(1)
            tpPlayerBtn.Text = "🎯 Телепорт к игроку"
        end
    else
        tpPlayerBtn.Text = "❌ Игрок не найден"
        tpPlayerBtn.BackgroundColor3 = T.Danger
        task.wait(1)
        tpPlayerBtn.Text = "🎯 Телепорт к игроку"
        tpPlayerBtn.BackgroundColor3 = T.Accent
    end
end)

print("🐗 Teleport модуль загружен")
