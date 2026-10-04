-- BIZON HUB — Toggle (с ПКМ)
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

-- createToggle с поддержкой ПКМ настроек
function Hub.createToggle(parent, name, default, callback, settingsFn)
    local state = default or false
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
    label.Size = UDim2.new(1, -80, 1, 0)
    label.Position = UDim2.new(0, 16, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = T.Text
    label.Font = Enum.Font.GothamBold
    label.TextSize = 15
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    -- Индикатор ПКМ
    if settingsFn then
        local gear = Instance.new("TextLabel")
        gear.Size = UDim2.new(0, 18, 0, 18)
        gear.Position = UDim2.new(1, -80, 0.5, -9)
        gear.BackgroundTransparency = 1
        gear.Text = "..."
        gear.TextColor3 = T.TextDim
        gear.Font = Enum.Font.GothamBold
        gear.TextSize = 14
        gear.TextTransparency = 0.5
        gear.Parent = container
        
        container.MouseEnter:Connect(function()
            TweenService:Create(gear, TweenInfo.new(0.15), {TextTransparency = 0}):Play()
        end)
        container.MouseLeave:Connect(function()
            TweenService:Create(gear, TweenInfo.new(0.15), {TextTransparency = 0.5}):Play()
        end)
    end

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

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = UDim2.new(0, 3, 0.5, -9)
    knob.BackgroundColor3 = T.TextDim
    knob.BorderSizePixel = 0
    knob.Parent = toggleBtn
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local function upd()
        if state then
            TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = T.Accent}):Play()
            TweenService:Create(toggleStroke, TweenInfo.new(0.2), {Color = T.AccentGlow, Transparency = 0.3}):Play()
            TweenService:Create(knob, TweenInfo.new(0.2), {Position = UDim2.new(1, -21, 0.5, -9), BackgroundColor3 = Color3.new(1,1,1)}):Play()
        else
            TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = T.Bg}):Play()
            TweenService:Create(toggleStroke, TweenInfo.new(0.2), {Color = T.Stroke, Transparency = 0.5}):Play()
            TweenService:Create(knob, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -9), BackgroundColor3 = T.TextDim}):Play()
        end
    end
    upd()

    -- ЛКМ = переключить
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        upd()
        if callback then callback(state) end
    end)
    
    -- ⭐ ПКМ = открыть настройки
    container.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            state = not state
            upd()
            if callback then callback(state) end
        elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
            if settingsFn and Hub.openContext then
                Hub.openContext(container, function(menuParent)
                    -- Заголовок
                    Hub.addContextLabel(menuParent, name)
                    settingsFn(menuParent, state, function(newState)
                        if newState ~= nil then
                            state = newState
                            upd()
                            if callback then callback(state) end
                        end
                    end)
                end)
            end
        end
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

print("[Bizon Hub] UI-1 загружен (Toggle + ПКМ)")
