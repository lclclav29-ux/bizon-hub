-- BIZON HUB — Slider
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Hub = _G.BizonHub
if not Hub then warn("[Bizon Hub] Загрузи core.lua!") return end
local T = Hub.Theme

local function findTabByParent(parent)
    for name, tab in pairs(Hub.Tabs) do
        if tab.container == parent then return name end
    end
    return nil
end

local function getRowParent(parent, fullWidth)
    local tabName = findTabByParent(parent)
    if not tabName then return parent end
    local tab = Hub.Tabs[tabName]
    if not tab then return parent end
    if fullWidth then
        tab.currentRow = nil
        tab.colCount = 0
        return tab.container
    end
    if not tab.currentRow or (tab.colCount or 0) >= 2 then
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 54)
        row.BackgroundTransparency = 1
        row.Parent = tab.container
        local layout = Instance.new("UIListLayout", row)
        layout.FillDirection = Enum.FillDirection.Horizontal
        layout.Padding = UDim.new(0, 6)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        tab.currentRow = row
        tab.colCount = 0
    end
    tab.colCount = (tab.colCount or 0) + 1
    return tab.currentRow
end

Hub.getRowParent = getRowParent

function Hub.createSlider(parent, name, minVal, maxVal, default, callback)
    local actualParent = getRowParent(parent, false)
    local isInRow = (actualParent ~= parent)
    
    local container = Instance.new("Frame")
    container.Size = isInRow and UDim2.new(0.5, -3, 1, 0) or UDim2.new(0.5, -3, 0, 54)
    container.BackgroundColor3 = T.Bg3
    container.BackgroundTransparency = 0.3
    container.BorderSizePixel = 0
    container.Parent = actualParent
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 10)

    local stroke = Instance.new("UIStroke", container)
    stroke.Color = T.Stroke
    stroke.Thickness = 1
    stroke.Transparency = 0.4

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -80, 0, 18)
    label.Position = UDim2.new(0, 16, 0, 6)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = T.Text
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 50, 0, 20)
    valueLabel.Position = UDim2.new(1, -66, 0, 6)
    valueLabel.BackgroundColor3 = T.Accent
    valueLabel.BackgroundTransparency = 0.8
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = T.Accent
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 12
    valueLabel.BorderSizePixel = 0
    valueLabel.Parent = container
    Instance.new("UICorner", valueLabel).CornerRadius = UDim.new(1, 0)

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -32, 0, 6)
    sliderBg.Position = UDim2.new(0, 16, 1, -14)
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

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new((default - minVal) / (maxVal - minVal), -7, 0.5, -7)
    knob.BackgroundColor3 = Color3.new(1,1,1)
    knob.BorderSizePixel = 0
    knob.Parent = sliderBg
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local knobStroke = Instance.new("UIStroke", knob)
    knobStroke.Color = T.AccentGlow
    knobStroke.Thickness = 2

    local sliding = false
    local function upd(input)
        local relX = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        local v = math.floor(minVal + (maxVal - minVal) * relX)
        fill.Size = UDim2.new(relX, 0, 1, 0)
        knob.Position = UDim2.new(relX, -7, 0.5, -7)
        valueLabel.Text = tostring(v)
        callback(v)
    end
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true; upd(input) end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then upd(input) end
    end)

    container.MouseEnter:Connect(function()
        TweenService:Create(container, TweenInfo.new(0.15), {BackgroundTransparency = 0.15}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.15), {Color = T.Accent, Transparency = 0.5}):Play()
    end)
    container.MouseLeave:Connect(function()
        TweenService:Create(container, TweenInfo.new(0.15), {BackgroundTransparency = 0.3}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.15), {Color = T.Stroke, Transparency = 0.4}):Play()
    end)

    return container
end

print("[Bizon Hub] UI-2 загружен (Slider)")
