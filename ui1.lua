-- 🐗 Bizon Hub UI-1 (Toggle — Aesthetic)
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Hub = _G.BizonHub
if not Hub then warn("🐗 Загрузи core.lua!") return end
local T = Hub.Theme

function Hub.createToggle(parent, name, default, callback, onRightClick)
    local state = default or false

    local container = Instance.new("Frame")
    container.BackgroundColor3 = T.Bg3
    container.BackgroundTransparency = 0.35
    container.BorderSizePixel = 0
    container.Parent = parent
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 12)

    -- Градиент фона
    local grad = Instance.new("UIGradient", container)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, T.Bg4),
        ColorSequenceKeypoint.new(1, T.Bg3),
    })
    grad.Rotation = 45

    -- Обводка
    local stroke = Instance.new("UIStroke", container)
    stroke.Color = T.Stroke
    stroke.Thickness = 1
    stroke.Transparency = 0.5

    -- Название
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -80, 1, 0)
    label.Position = UDim2.new(0, 16, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = T.Text
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    -- Toggle кнопка
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 44, 0, 24)
    toggleBtn.Position = UDim2.new(1, -56, 0.5, -12)
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

    -- Кружок
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = UDim2.new(0, 3, 0.5, -9)
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
                Position = UDim2.new(1, -21, 0.5, -9),
                BackgroundColor3 = Color3.new(1,1,1),
            }):Play()
            TweenService:Create(knobGlow, TweenInfo.new(0.25), {Transparency = 0.4}):Play()
        else
            TweenService:Create(toggleBtn, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {BackgroundColor3 = T.Bg}):Play()
            TweenService:Create(toggleStroke, TweenInfo.new(0.25), {Color = T.Stroke, Transparency = 0.5}):Play()
            TweenService:Create(knob, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
                Position = UDim2.new(0, 3, 0.5, -9),
                BackgroundColor3 = T.TextDim,
            }):Play()
            TweenService:Create(knobGlow, TweenInfo.new(0.25), {Transparency = 1}):Play()
        end
    end
    upd()

    -- Hover
    container.MouseEnter:Connect(function()
        TweenService:Create(container, TweenInfo.new(0.2), {BackgroundTransparency = 0.15}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Color = T.Accent, Transparency = 0.55}):Play()
    end)
    container.MouseLeave:Connect(function()
        TweenService:Create(container, TweenInfo.new(0.2), {BackgroundTransparency = 0.35}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Color = T.Stroke, Transparency = 0.5}):Play()
    end)

    -- ЛКМ
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        upd()
        if callback then callback(state) end
    end)
    container.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            state = not state
            upd()
            if callback then callback(state) end
        elseif input.UserInputType == Enum.UserInputType.MouseButton2 and onRightClick then
            onRightClick()
        end
    end)
    return container
end

print("🐗 UI-1 загружен (Toggle)")
