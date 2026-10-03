-- === TOGGLE (с ПКМ для настроек) ===
function Hub.createToggle(parent, name, default, callback, onRightClick)
    local state = default or false
    local container = Instance.new("Frame")
    container.BackgroundColor3 = T.Bg3
    container.BackgroundTransparency = 0.4
    container.BorderSizePixel = 0
    container.Parent = parent
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 14)

    local stroke = Instance.new("UIStroke", container)
    stroke.Color = T.Stroke
    stroke.Thickness = 1
    stroke.Transparency = 0.4

    local grad = Instance.new("UIGradient", container)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, T.Bg4),
        ColorSequenceKeypoint.new(1, T.Bg3),
    })
    grad.Rotation = 45

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -90, 1, 0)
    label.Position = UDim2.new(0, 18, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = T.Text
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    -- Индикатор "⚙" справа (появляется при наведении если есть onRightClick)
    if onRightClick then
        local gearIcon = Instance.new("TextLabel")
        gearIcon.Size = UDim2.new(0, 20, 0, 20)
        gearIcon.Position = UDim2.new(1, -88, 0.5, -10)
        gearIcon.BackgroundTransparency = 1
        gearIcon.Text = "⚙"
        gearIcon.TextColor3 = T.TextDim
        gearIcon.Font = Enum.Font.GothamBold
        gearIcon.TextSize = 14
        gearIcon.TextTransparency = 1
        gearIcon.Parent = container

        -- Показываем "⚙" при hover
        container.MouseEnter:Connect(function()
            TweenService:Create(gearIcon, TweenInfo.new(0.2), {TextTransparency = 0.3}):Play()
        end)
        container.MouseLeave:Connect(function()
            TweenService:Create(gearIcon, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
        end)
    end

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 48, 0, 26)
    toggleBtn.Position = UDim2.new(1, -60, 0.5, -13)
    toggleBtn.BackgroundColor3 = T.Bg
    toggleBtn.Text = ""
    toggleBtn.BorderSizePixel = 0
    toggleBtn.AutoButtonColor = false
    toggleBtn.Parent = container
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

    local toggleStroke = Instance.new("UIStroke", toggleBtn)
    toggleStroke.Color = T.Stroke
    toggleStroke.Thickness = 1
    toggleStroke.Transparency = 0.5

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 20, 0, 20)
    knob.Position = UDim2.new(0, 3, 0.5, -10)
    knob.BackgroundColor3 = T.TextDim
    knob.BorderSizePixel = 0
    knob.Parent = toggleBtn
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local knobGlow = Instance.new("UIStroke", knob)
    knobGlow.Color = T.AccentGlow
    knobGlow.Thickness = 2
    knobGlow.Transparency = 1

    local function upd()
        if state then
            TweenService:Create(toggleBtn, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {BackgroundColor3 = T.Accent}):Play()
            TweenService:Create(toggleStroke, TweenInfo.new(0.25), {Color = T.AccentGlow, Transparency = 0.3}):Play()
            TweenService:Create(knob, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
                Position = UDim2.new(1, -23, 0.5, -10),
                BackgroundColor3 = Color3.new(1,1,1)
            }):Play()
            TweenService:Create(knobGlow, TweenInfo.new(0.25), {Transparency = 0.5}):Play()
        else
            TweenService:Create(toggleBtn, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {BackgroundColor3 = T.Bg}):Play()
            TweenService:Create(toggleStroke, TweenInfo.new(0.25), {Color = T.Stroke, Transparency = 0.5}):Play()
            TweenService:Create(knob, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
                Position = UDim2.new(0, 3, 0.5, -10),
                BackgroundColor3 = T.TextDim
            }):Play()
            TweenService:Create(knobGlow, TweenInfo.new(0.25), {Transparency = 1}):Play()
        end
    end
    upd()

    -- Hover
    container.MouseEnter:Connect(function()
        TweenService:Create(container, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Color = T.Accent, Transparency = 0.5}):Play()
    end)
    container.MouseLeave:Connect(function()
        TweenService:Create(container, TweenInfo.new(0.2), {BackgroundTransparency = 0.4}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Color = T.Stroke, Transparency = 0.4}):Play()
    end)

    -- ЛКМ по toggle
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        upd()
        if callback then callback(state) end
    end)

    -- ЛКМ по карточке = тоже переключение
    -- ПКМ = открыть настройки
    container.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            state = not state
            upd()
            if callback then callback(state) end
        elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
            if onRightClick then
                onRightClick()
            end
        end
    end)

    return container
end

-- === SLIDER ===
function Hub.createSlider(parent, name, minVal, maxVal, default, callback)
    local container = Instance.new("Frame")
    container.BackgroundColor3 = T.Bg3
    container.BackgroundTransparency = 0.4
    container.BorderSizePixel = 0
    container.Parent = parent
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 14)

    local stroke = Instance.new("UIStroke", container)
    stroke.Color = T.Stroke
    stroke.Thickness = 1
    stroke.Transparency = 0.4

    local grad = Instance.new("UIGradient", container)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, T.Bg4),
        ColorSequenceKeypoint.new(1, T.Bg3),
    })
    grad.Rotation = 45

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -90, 0, 22)
    label.Position = UDim2.new(0, 18, 0, 8)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = T.Text
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 55, 0, 22)
    valueLabel.Position = UDim2.new(1, -72, 0, 8)
    valueLabel.BackgroundColor3 = T.Accent
    valueLabel.BackgroundTransparency = 0.75
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = T.Accent
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 11
    valueLabel.BorderSizePixel = 0
    valueLabel.Parent = container
    Instance.new("UICorner", valueLabel).CornerRadius = UDim.new(1, 0)

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -36, 0, 6)
    sliderBg.Position = UDim2.new(0, 18, 1, -18)
    sliderBg.BackgroundColor3 = T.Bg
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = container
    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - minVal) / (maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = T.Accent
    fill.BorderSizePixel = 0
    fill.Parent = sliderBg
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local fillGrad = Instance.new("UIGradient", fill)
    fillGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, T.Accent),
        ColorSequenceKeypoint.new(1, T.AccentGlow),
    })

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.new((default - minVal) / (maxVal - minVal), -8, 0.5, -8)
    knob.BackgroundColor3 = Color3.new(1,1,1)
    knob.BorderSizePixel = 0
    knob.Parent = sliderBg
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local knobGlow = Instance.new("UIStroke", knob)
    knobGlow.Color = T.AccentGlow
    knobGlow.Thickness = 3

    local sliding = false
    local function upd(input)
        local relX = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        local v = math.floor(minVal + (maxVal - minVal) * relX)
        fill.Size = UDim2.new(relX, 0, 1, 0)
        knob.Position = UDim2.new(relX, -8, 0.5, -8)
        valueLabel.Text = tostring(v)
        callback(v)
    end
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then 
            sliding = true
            upd(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then upd(input) end
    end)

    container.MouseEnter:Connect(function()
        TweenService:Create(container, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Color = T.Accent, Transparency = 0.5}):Play()
    end)
    container.MouseLeave:Connect(function()
        TweenService:Create(container, TweenInfo.new(0.2), {BackgroundTransparency = 0.4}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Color = T.Stroke, Transparency = 0.4}):Play()
    end)

    return container
end

-- === LABEL ===
function Hub.createLabel(parent, text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, -4, 0, 28)
    label.BackgroundTransparency = 1
    label.Text = "— " .. string.upper(text) .. " —"
    label.TextColor3 = T.TextDim
    label.Font = Enum.Font.GothamBold
    label.TextSize = 10
    label.Parent = parent
    return label
end

-- === KEYBIND ===
function Hub.createKeybind(parent, name, defaultKey, callback)
    local container = Instance.new("Frame")
    container.BackgroundColor3 = T.Bg3
    container.BackgroundTransparency = 0.4
    container.BorderSizePixel = 0
    container.Parent = parent
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 14)

    local stroke = Instance.new("UIStroke", container)
    stroke.Color = T.Stroke
    stroke.Thickness = 1
    stroke.Transparency = 0.4

    local grad = Instance.new("UIGradient", container)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, T.Bg4),
        ColorSequenceKeypoint.new(1, T.Bg3),
    })
    grad.Rotation = 45

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Position = UDim2.new(0, 18, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = T.Text
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local keyBtn = Instance.new("TextButton")
    keyBtn.Size = UDim2.new(0, 90, 0, 28)
    keyBtn.Position = UDim2.new(1, -104, 0.5, -14)
    keyBtn.BackgroundColor3 = T.Accent
    keyBtn.BackgroundTransparency = 0.75
    keyBtn.Text = defaultKey.Name
    keyBtn.TextColor3 = T.Accent
    keyBtn.Font = Enum.Font.GothamBold
    keyBtn.TextSize = 11
    keyBtn.BorderSizePixel = 0
    keyBtn.AutoButtonColor = false
    keyBtn.Parent = container
    Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 8)

    local awaiting = false
    keyBtn.MouseButton1Click:Connect(function()
        awaiting = true
        keyBtn.Text = "Нажми..."
        keyBtn.BackgroundTransparency = 0.4
    end)
    UserInputService.InputBegan:Connect(function(input, gp)
        if awaiting and not gp and input.UserInputType == Enum.UserInputType.Keyboard then
            keyBtn.Text = input.KeyCode.Name
            keyBtn.BackgroundTransparency = 0.75
            awaiting = false
            callback(input.KeyCode)
        end
    end)
    return container
end

-- ============================================
-- FLOATING SETTINGS PANEL (для ПКМ настроек)
-- ============================================
local SettingsPanel = Instance.new("Frame")
SettingsPanel.Name = "SettingsPanel"
SettingsPanel.Size = UDim2.new(0, 260, 0, 0)
SettingsPanel.Position = UDim2.new(0, 0, 0, 0)
SettingsPanel.BackgroundColor3 = T.Bg
SettingsPanel.BackgroundTransparency = 0.05
SettingsPanel.BorderSizePixel = 0
SettingsPanel.Visible = false
SettingsPanel.ZIndex = 50
SettingsPanel.Parent = ScreenGui
Instance.new("UICorner", SettingsPanel).CornerRadius = UDim.new(0, 14)

local SPstroke = Instance.new("UIStroke", SettingsPanel)
SPstroke.Color = T.Accent
SPstroke.Thickness = 1.5
SPstroke.Transparency = 0.3

-- Список настроек (контейнер)
local SPContent = Instance.new("ScrollingFrame")
SPContent.Name = "Content"
SPContent.Size = UDim2.new(1, -12, 1, -12)
SPContent.Position = UDim2.new(0, 6, 0, 6)
SPContent.BackgroundTransparency = 1
SPContent.BorderSizePixel = 0
SPContent.ScrollBarThickness = 3
SPContent.ScrollBarImageColor3 = T.Accent
SPContent.CanvasSize = UDim2.new(0, 0, 0, 0)
SPContent.Parent = SettingsPanel

local SPLayout = Instance.new("UIListLayout", SPContent)
SPLayout.Padding = UDim.new(0, 6)
SPLayout.SortOrder = Enum.SortOrder.LayoutOrder

SPLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    SPContent.CanvasSize = UDim2.new(0, 0, 0, SPLayout.AbsoluteContentSize.Y + 12)
    SettingsPanel.Size = UDim2.new(0, 260, 0, math.clamp(SPLayout.AbsoluteContentSize.Y + 20, 50, 400))
end)

Hub.SettingsPanel = SettingsPanel

-- Функция открытия панели настроек
function Hub.openSettings(sourceContainer, settingsFn)
    -- Очищаем
    for _, child in pairs(SPContent:GetChildren()) do
        if not child:IsA("UIListLayout") then
            child:Destroy()
        end
    end

    -- Заполняем настройками
    settingsFn(SPContent)

    -- Позиционируем рядом с карточкой (справа)
    local pos = sourceContainer.AbsolutePosition
    local size = sourceContainer.AbsoluteSize

    SettingsPanel.Position = UDim2.new(0, pos.X + size.X + 10, 0, pos.Y)
    SettingsPanel.Size = UDim2.new(0, 260, 0, 0)
    SettingsPanel.Visible = true
    SettingsPanel.BackgroundTransparency = 1

    -- Анимация открытия
    TweenService:Create(SettingsPanel, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
        BackgroundTransparency = 0.05,
    }):Play()

    -- Авто-закрытие через 5 сек если не активна
    task.spawn(function()
        task.wait(0.1)
        while SettingsPanel.Visible do
            task.wait(0.3)
        end
    end)
end

function Hub.closeSettings()
    SettingsPanel.Visible = false
    for _, child in pairs(SPContent:GetChildren()) do
        if not child:IsA("UIListLayout") then
            child:Destroy()
        end
    end
end

-- Закрытие панели по клику вне
Hub.addConnection(UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 and SettingsPanel.Visible then
        local mousePos = UserInputService:GetMouseLocation()
        local panelPos = SettingsPanel.AbsolutePosition
        local panelSize = SettingsPanel.AbsoluteSize

        if not (mousePos.X >= panelPos.X and mousePos.X <= panelPos.X + panelSize.X 
                and mousePos.Y >= panelPos.Y and mousePos.Y <= panelPos.Y + panelSize.Y) then
            -- Проверяем что клик не по кнопке которая открыла
            Hub.closeSettings()
        end
    end
end))

-- === TOGGLE MENU ===
local menuOpen = false
function Hub.toggleMenu()
    menuOpen = not menuOpen
    MainFrame.Visible = menuOpen
    if not menuOpen then Hub.closeSettings() end
    if menuOpen then
        MainFrame.Size = UDim2.new(0, 720, 0, 0)
        MainFrame.BackgroundTransparency = 1
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 720, 0, 500),
            BackgroundTransparency = 0.08,
        }):Play()
        if not Hub.CurrentTab then
            Hub.switchTab("Speed")
        end
    end
end

FloatBtn.MouseButton1Click:Connect(Hub.toggleMenu)

Hub.addConnection(UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        Hub.toggleMenu()
    end
end))

print("🐗 Core v3.5 (Right-click settings) загружен")
