-- 🐗 Bizon Hub Misc (with Skybox)
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local Hub = _G.BizonHub
if not Hub then warn("🐗 Загрузи core.lua!") return end
local T = Hub.Theme
local S = Hub.Settings
local player = game.Players.LocalPlayer

local MiscTab = Hub.createTab("Misc", "🎯")

Hub.createLabel(MiscTab, "ПРОЧЕЕ")

Hub.createToggle(MiscTab, "🚶 Noclip", S.Noclip, function(state)
    S.Noclip = state
end)

Hub.createToggle(MiscTab, "💡 Fullbright", S.Fullbright, function(state)
    S.Fullbright = state
    if state then
        Lighting.Ambient = Color3.fromRGB(178, 178, 178)
        Lighting.Brightness = 3
        Lighting.OutdoorAmbient = Color3.fromRGB(178, 178, 178)
    else
        Lighting.Ambient = Color3.fromRGB(70, 70, 70)
        Lighting.Brightness = 1
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    end
end)

Hub.createToggle(MiscTab, "🌫 Убрать туман", false, function(state)
    if state then
        if not S.OriginalFogEnd then
            S.OriginalFogEnd = Lighting.FogEnd
            S.OriginalFogStart = Lighting.FogStart
        end
        Lighting.FogEnd = 100000
        Lighting.FogStart = 100000
    else
        Lighting.FogEnd = S.OriginalFogEnd or 100000
        Lighting.FogStart = S.OriginalFogStart or 0
    end
end)

-- === CUSTOM SKYBOX ===
Hub.createLabel(MiscTab, "НЕБО (SKYBOX)")

-- Список небес
local SKYBOXES = {
    {name = "❌ Выключено",           id = nil},
    {name = "☀ Дневное",              id = "rbxassetid://159454299"},
    {name = "🌅 Закат",               id = "rbxassetid://159454272"},
    {name = "🌌 Космос",              id = "rbxassetid://159454279"},
    {name = "🌃 Ночное",              id = "rbxassetid://159454264"},
    {name = "🌈 Розовое",             id = "rbxassetid://5159901416"},
    {name = "⚡ Гроза",               id = "rbxassetid://159454288"},
    {name = "❄ Зимнее",              id = "rbxassetid://159454294"},
    {name = "🔥 Огненное",            id = "rbxassetid://5159901288"},
    {name = "🌊 Океан",              id = "rbxassetid://5159901529"},
}

local currentSkybox = nil

-- Функция установки skybox
local function setSkybox(id)
    -- Удаляем старый
    if currentSkybox then
        currentSkybox:Destroy()
        currentSkybox = nil
    end

    -- Если "выключено" — просто удаляем
    if not id then
        print("🐗 Skybox выключен")
        return
    end

    -- Создаём новый
    local sky = Instance.new("Sky")
    sky.SkyboxBk = id
    sky.SkyboxDn = id
    sky.SkyboxFt = id
    sky.SkyboxLf = id
    sky.SkyboxRt = id
    sky.SkyboxUp = id
    sky.Parent = Lighting
    currentSkybox = sky
    print("🐗 Skybox установлен: " .. id)
end

-- Выпадающее меню (Dropdown)
local dropdownContainer = Instance.new("Frame")
dropdownContainer.Size = UDim2.new(1, 0, 0, 44)
dropdownContainer.BackgroundColor3 = T.Bg3
dropdownContainer.BorderSizePixel = 0
dropdownContainer.Parent = MiscTab
Instance.new("UICorner", dropdownContainer).CornerRadius = UDim.new(0, 12)

local ddLabel = Instance.new("TextLabel")
ddLabel.Size = UDim2.new(1, -140, 1, 0)
ddLabel.Position = UDim2.new(0, 16, 0, 0)
ddLabel.BackgroundTransparency = 1
ddLabel.Text = "Skybox"
ddLabel.TextColor3 = T.Text
ddLabel.Font = Enum.Font.GothamMedium
ddLabel.TextSize = 13
ddLabel.TextXAlignment = Enum.TextXAlignment.Left
ddLabel.Parent = dropdownContainer

local ddBtn = Instance.new("TextButton")
ddBtn.Size = UDim2.new(0, 120, 0, 30)
ddBtn.Position = UDim2.new(1, -130, 0.5, -15)
ddBtn.BackgroundColor3 = T.Bg
ddBtn.Text = "❌ Выключено ▾"
ddBtn.TextColor3 = T.Accent
ddBtn.Font = Enum.Font.GothamBold
ddBtn.TextSize = 12
ddBtn.BorderSizePixel = 0
ddBtn.AutoButtonColor = false
ddBtn.Parent = dropdownContainer
Instance.new("UICorner", ddBtn).CornerRadius = UDim.new(0, 8)

-- Список (появляется при клике)
local ddList = Instance.new("Frame")
ddList.Size = UDim2.new(1, 0, 0, 0)
ddList.Position = UDim2.new(0, 0, 1, 6)
ddList.BackgroundColor3 = T.Bg2
ddList.BorderSizePixel = 0
ddList.Visible = false
ddList.ClipsDescendants = true
ddList.Parent = MiscTab
Instance.new("UICorner", ddList).CornerRadius = UDim.new(0, 12)

local ddListStroke = Instance.new("UIStroke", ddList)
ddListStroke.Color = T.Stroke
ddListStroke.Thickness = 1

local ddListLayout = Instance.new("UIListLayout", ddList)
ddListLayout.Padding = UDim.new(0, 2)
ddListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local ddListPad = Instance.new("UIPadding", ddList)
ddListPad.PaddingTop = UDim.new(0, 6)
ddListPad.PaddingBottom = UDim.new(0, 6)
ddListPad.PaddingLeft = UDim.new(0, 6)
ddListPad.PaddingRight = UDim.new(0, 6)

-- Создаём кнопки для каждого неба
local dropdownOpen = false
local listHeight = 0

for _, sky in pairs(SKYBOXES) do
    local optBtn = Instance.new("TextButton")
    optBtn.Size = UDim2.new(1, 0, 0, 32)
    optBtn.BackgroundColor3 = T.Bg3
    optBtn.Text = sky.name
    optBtn.TextColor3 = T.Text
    optBtn.Font = Enum.Font.GothamMedium
    optBtn.TextSize = 12
    optBtn.BorderSizePixel = 0
    optBtn.AutoButtonColor = false
    optBtn.TextXAlignment = Enum.TextXAlignment.Left
    optBtn.Parent = ddList
    Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 8)

    local optPad = Instance.new("UIPadding", optBtn)
    optPad.PaddingLeft = UDim.new(0, 10)

    listHeight = listHeight + 34

    optBtn.MouseEnter:Connect(function()
        optBtn.BackgroundColor3 = T.Accent
        optBtn.TextColor3 = T.Bg
    end)
    optBtn.MouseLeave:Connect(function()
        optBtn.BackgroundColor3 = T.Bg3
        optBtn.TextColor3 = T.Text
    end)
    optBtn.MouseButton1Click:Connect(function()
        setSkybox(sky.id)
        ddBtn.Text = sky.name .. " ▾"
        -- Закрываем список
        dropdownOpen = false
        ddList.Visible = false
        ddList.Size = UDim2.new(1, 0, 0, 0)
    end)
end

-- Открытие/закрытие
ddBtn.MouseButton1Click:Connect(function()
    dropdownOpen = not dropdownOpen
    if dropdownOpen then
        ddList.Visible = true
        ddList.Size = UDim2.new(1, 0, 0, 0)
        for i = 0, listHeight, 8 do
            ddList.Size = UDim2.new(1, 0, 0, i)
            task.wait()
        end
        ddList.Size = UDim2.new(1, 0, 0, listHeight)
    else
        ddList.Size = UDim2.new(1, 0, 0, listHeight)
        for i = listHeight, 0, -8 do
            ddList.Size = UDim2.new(1, 0, 0, i)
            task.wait()
        end
        ddList.Visible = false
    end
end)

-- Заглушка под выпадающий список (чтобы следующий элемент не наложился)
local ddSpacer = Instance.new("Frame")
ddSpacer.Size = UDim2.new(1, 0, 0, 44)
ddSpacer.BackgroundTransparency = 1
ddSpacer.Parent = MiscTab

-- === ОПАСНАЯ ЗОНА ===
Hub.createLabel(MiscTab, "ОПАСНАЯ ЗОНА")

local panicContainer = Instance.new("Frame")
panicContainer.Size = UDim2.new(1, 0, 0, 60)
panicContainer.BackgroundColor3 = T.Bg3
panicContainer.BorderSizePixel = 0
panicContainer.Parent = MiscTab
Instance.new("UICorner", panicContainer).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", panicContainer)
stroke.Color = T.Danger
stroke.Thickness = 1.5
stroke.Transparency = 0.3

local panicBtn = Instance.new("TextButton")
panicBtn.Size = UDim2.new(1, -20, 1, -20)
panicBtn.Position = UDim2.new(0, 10, 0, 10)
panicBtn.BackgroundColor3 = T.Danger
panicBtn.Text = "🚨 PANIC — УДАЛИТЬ СКРИПТ"
panicBtn.TextColor3 = Color3.new(1, 1, 1)
panicBtn.Font = Enum.Font.GothamBold
panicBtn.TextSize = 14
panicBtn.BorderSizePixel = 0
panicBtn.AutoButtonColor = false
panicBtn.Parent = panicContainer
Instance.new("UICorner", panicBtn).CornerRadius = UDim.new(0, 10)

panicBtn.MouseButton1Click:Connect(function()
    panicBtn.Text = "✅ УДАЛЕНО"
    panicBtn.BackgroundColor3 = T.Success
    task.wait(0.15)
    Hub.IsPanicked = true
    pcall(function()
        local ch = player.Character
        if ch and ch:FindFirstChild("Humanoid") then
            ch.Humanoid.WalkSpeed = 16
            ch.Humanoid.JumpPower = 50
        end
    end)
    pcall(function()
        Lighting.Ambient = Color3.fromRGB(70, 70, 70)
        Lighting.Brightness = 1
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        if currentSkybox then currentSkybox:Destroy() end
    end)
    for _, c in pairs(Hub.Connections) do pcall(function() c:Disconnect() end) end
    Hub.Connections = {}
    pcall(function()
        if Hub.ScreenGui and Hub.ScreenGui.Parent then Hub.ScreenGui:Destroy() end
        local wm = player.PlayerGui:FindFirstChild("BizonWatermark")
        if wm then wm:Destroy() end
    end)
    print("🐗 Bizon Hub: PANIC")
end)

-- === NOCLIP ===
local noclipCounter = 0
Hub.addConnection(RunService.Heartbeat:Connect(function()
    if Hub.IsPanicked then return end
    if not S.Noclip then return end
    noclipCounter = noclipCounter + 1
    if noclipCounter < 10 then return end
    noclipCounter = 0

    local ch = player.Character
    if ch then
        for _, p in pairs(ch:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then
                p.CanCollide = false
            end
        end
    end
end))

print("🐗 Misc модуль загружен (Skybox + Fog)")
