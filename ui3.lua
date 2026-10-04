-- BIZON HUB — Keybind
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

function Hub.createKeybind(parent, name, defaultKey, callback)
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
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Position = UDim2.new(0, 16, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = T.Text
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local keyBtn = Instance.new("TextButton")
    keyBtn.Size = UDim2.new(0, 70, 0, 28)
    keyBtn.Position = UDim2.new(1, -84, 0.5, -14)
    keyBtn.BackgroundColor3 = T.Bg
    keyBtn.Text = defaultKey.Name
    keyBtn.TextColor3 = T.Accent
    keyBtn.Font = Enum.Font.GothamBold
    keyBtn.TextSize = 12
    keyBtn.BorderSizePixel = 0
    keyBtn.AutoButtonColor = false
    keyBtn.Parent = container
    Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 6)

    local awaiting = false
    keyBtn.MouseButton1Click:Connect(function()
        awaiting = true
        keyBtn.Text = "..."
        keyBtn.TextColor3 = T.Warning
    end)
    UserInputService.InputBegan:Connect(function(input, gp)
        if awaiting and not gp and input.UserInputType == Enum.UserInputType.Keyboard then
            keyBtn.Text = input.KeyCode.Name
            keyBtn.TextColor3 = T.Accent
            awaiting = false
            callback(input.KeyCode)
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

print("[Bizon Hub] UI-3 загружен (Keybind)")
