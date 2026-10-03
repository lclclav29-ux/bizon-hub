-- 🐗 Bizon Hub UI-3 (Keybind — Aesthetic)
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Hub = _G.BizonHub
if not Hub then warn("🐗 Загрузи core.lua!") return end
local T = Hub.Theme

function Hub.createKeybind(parent, name, defaultKey, callback)
    local container = Instance.new("Frame")
    container.BackgroundColor3 = T.Bg3
    container.BackgroundTransparency = 0.35
    container.BorderSizePixel = 0
    container.Parent = parent
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
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Position = UDim2.new(0, 16, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = T.Text
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local keyBtn = Instance.new("TextButton")
    keyBtn.Size = UDim2.new(0, 80, 0, 24)
    keyBtn.Position = UDim2.new(1, -94, 0.5, -12)
    keyBtn.BackgroundColor3 = T.Accent
    keyBtn.BackgroundTransparency = 0.75
    keyBtn.Text = defaultKey.Name
    keyBtn.TextColor3 = T.Accent
    keyBtn.Font = Enum.Font.GothamBold
    keyBtn.TextSize = 11
    keyBtn.BorderSizePixel = 0
    keyBtn.AutoButtonColor = false
    keyBtn.Parent = container
    Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 6)

    local keyStroke = Instance.new("UIStroke", keyBtn)
    keyStroke.Color = T.Accent
    keyStroke.Thickness = 1
    keyStroke.Transparency = 0.5

    local awaiting = false
    keyBtn.MouseButton1Click:Connect(function()
        awaiting = true
        keyBtn.Text = "..."
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

    -- Hover
    container.MouseEnter:Connect(function()
        TweenService:Create(container, TweenInfo.new(0.2), {BackgroundTransparency = 0.15}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Color = T.Accent, Transparency = 0.55}):Play()
    end)
    container.MouseLeave:Connect(function()
        TweenService:Create(container, TweenInfo.new(0.2), {BackgroundTransparency = 0.35}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Color = T.Stroke, Transparency = 0.5}):Play()
    end)

    return container
end

print("🐗 UI-3 загружен (Keybind)")
