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

-- Функция обновления списка игроков
local function updatePlayersList()
    -- Очищаем старые кнопки
    for _, child in pairs(playersList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    -- Собираем игроков
    local players = {}
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player then  -- себя не показываем
            table.insert(players, plr)
        end
    end

    -- Сортируем по имени
    table.sort(players, function(a, b) return a.Name:lower() < b.Name:lower() end)

    -- Если никого нет
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

    -- Создаём кнопку для каждого игрока
    for _, plr in pairs(players) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 36)
        btn.BackgroundColor3 = T.Bg3
        btn.Text = ""
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Parent = playersList
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

        -- Иконка игрока (кружок)
        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, 8, 0, 8)
        dot.Position = UDim2.new(0, 10, 0.5, -4)
        dot.BackgroundColor3 = T.Success
        dot.BorderSizePixel = 0
        dot.Parent = btn
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

        -- Имя игрока
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

        -- Текст "TP" справа
        local tpLabel = Instance.new("TextLabel")
        tpLabel.Size = UDim2.new(0, 30, 1, 0)
        tpLabel.Position = UDim2.new(1, -36, 0, 0)
        tpLabel.BackgroundTransparency = 1
        tpLabel.Text = "TP →"
        tpLabel.TextColor3 = T.Accent
        tpLabel.Font = Enum.Font.GothamBold
        tpLabel.TextSize = 11
        tpLabel.Parent = btn

        -- Hover эффекты
        btn.MouseEnter:Connect(function()
            btn.BackgroundColor3 = T.Bg4
        end)
        btn.MouseLeave:Connect(function()
            btn.BackgroundColor3 = T.Bg3
        end)

        -- Клик — телепорт к игроку
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

-- Обновляем список сразу
updatePlayersList()

-- Автообновление каждые 2 секунды
task.spawn(function()
    while TpTab.Parent and not Hub.IsPanicked do
        task.wait(2)
        if TpTab.Parent then
            updatePlayersList()
        end
    end
end)

print("🐗 Teleport модуль загружен")
