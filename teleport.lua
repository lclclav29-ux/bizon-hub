-- 🐗 Bizon Hub Teleport (FULL)
local Hub = _G.BizonHub
if not Hub then warn("🐗 Загрузи core.lua!") return end
local T = Hub.Theme
local S = Hub.Settings
local player = game.Players.LocalPlayer

-- === КООРДИНАТЫ МИРОВ ===
local WORLDS = {
    {name = "🏠 Спавн",           pos = Vector3.new(0, 10, 0)},
    {name = "🌀 Мир 1 (Портал)",  pos = Vector3.new(10, 10, 78)},
    {name = "🌀 Мир 2",           pos = Vector3.new(763, 10, 92)},
}

local savedPos = nil

-- === TELEPORT TAB ===
local TpTab = Hub.createTab("Teleport", "🌀")

Hub.createLabel(TpTab, "БЫСТРЫЙ ТЕЛЕПОРТ")

-- Функция телепорта
local function teleportTo(pos)
    local ch = player.Character
    if not ch then return end
    local hrp = ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
    print("🌀 Телепорт в " .. tostring(pos))
end

-- Кнопки телепорта
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

    btn.MouseButton1Click:Connect(function()
        teleportTo(world.pos)
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
    task.wait(0.5)
    saveBtn.Text = "💾 Сохранить позицию"
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
        task.wait(1)
        loadBtn.Text = "📍 Вернуться к точке"
        return
    end
    teleportTo(savedPos)
end)

-- === СПИСОК ИГРОКОВ ОНЛАЙН ===
Hub.createLabel(TpTab, "ИГРОКИ ОНЛАЙН")

local playersList = Instance.new("ScrollingFrame")
playersList.Size = UDim2.new(1, 0, 0, 200)
playersList.BackgroundColor3 = T.Bg
playersList.BorderSizePixel = 0
playersList.ScrollBarThickness = 4
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
        btn.Size = UDim2.new(1, 0, 0, 36)
        btn.BackgroundColor3 = T.Bg3
        btn.Text = ""
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Parent = playersList
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, 8, 0, 8)
        dot.Position = UDim2.new(0, 10, 0.5, -4)
        dot.BackgroundColor3 = T.Success
        dot.BorderSizePixel = 0
        dot.Parent = btn
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, -50, 1, 0)
        nameLabel.Position = UDim2.new(0, 26, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = plr.Name
        nameLabel.TextColor3 = T.Text
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 13
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Parent = btn

        local tpLabel = Instance.new("TextLabel")
        tpLabel.Size = UDim2.new(0, 30, 1, 0)
        tpLabel.Position = UDim2.new(1, -36, 0, 0)
        tpLabel.BackgroundTransparency = 1
        tpLabel.Text = "TP →"
        tpLabel.TextColor3 = T.Accent
        tpLabel.Font = Enum.Font.GothamBold
        tpLabel.TextSize = 11
        tpLabel.Parent = btn

        btn.MouseEnter:Connect(function() btn.BackgroundColor3 = T.Bg4 end)
        btn.MouseLeave:Connect(function() btn.BackgroundColor3 = T.Bg3 end)

        btn.MouseButton1Click:Connect(function()
            if not plr.Character then
                btn.BackgroundColor3 = T.Danger
                nameLabel.Text = "❌ " .. plr.Name .. " (нет персонажа)"
                task.wait(1.5)
                nameLabel.Text = plr.Name
                btn.BackgroundColor3 = T.Bg3
                return
            end
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                teleportTo(hrp.Position)
                btn.BackgroundColor3 = T.Success
                nameLabel.Text = "✅ " .. plr.Name
                task.wait(0.6)
                nameLabel.Text = plr.Name
                btn.BackgroundColor3 = T.Bg3
            end
        end)
    end
end

updatePlayersList()

task.spawn(function()
    while TpTab.Parent and not Hub.IsPanicked do
        task.wait(2)
        if TpTab.Parent then
            updatePlayersList()
        end
    end
end)

print("🐗 Teleport модуль загружен")
