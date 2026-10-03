-- ============================================
-- WATERMARK (FPS + Ping + Version)
-- ============================================
local Stats = game:GetService("Stats")

-- Настройки watermark
local WATERMARK_CONFIG = {
    Version = "v2.0",
    Edition = "FREE",  -- "FREE" или "PREMIUM"
    Position = UDim2.new(0, 20, 0, 20),  -- верхний левый угол
}

-- Цвета для версии
local EDITION_COLORS = {
    FREE = Color3.fromRGB(180, 180, 200),
    PREMIUM = Color3.fromRGB(255, 200, 50),  -- золотой для премиума
}

-- Создаём GUI
local WatermarkGui = Instance.new("ScreenGui")
WatermarkGui.Name = "BizonWatermark"
WatermarkGui.ResetOnSpawn = false
WatermarkGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
WatermarkGui.IgnoreGuiInset = true
WatermarkGui.Parent = ScreenGui

-- Основной контейнер
local WMFrame = Instance.new("Frame")
WMFrame.Size = UDim2.new(0, 220, 0, 36)
WMFrame.Position = WATERMARK_CONFIG.Position
WMFrame.BackgroundColor3 = T.Bg
WMFrame.BackgroundTransparency = 0.15
WMFrame.BorderSizePixel = 0
WMFrame.Parent = WatermarkGui
Instance.new("UICorner", WMFrame).CornerRadius = UDim.new(0, 10)

-- Обводка (accent цвет)
local WMstroke = Instance.new("UIStroke", WMFrame)
WMstroke.Color = T.Accent
WMstroke.Thickness = 1.5

-- Градиент (для красоты)
local WMgrad = Instance.new("UIGradient", WMFrame)
WMgrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, T.Bg2),
    ColorSequenceKeypoint.new(1, T.Bg),
})
WMgrad.Rotation = 45

-- Иконка 🐗
local WMicon = Instance.new("TextLabel")
WMicon.Size = UDim2.new(0, 26, 1, 0)
WMicon.Position = UDim2.new(0, 6, 0, 0)
WMicon.BackgroundTransparency = 1
WMicon.Text = "🐗"
WMicon.TextColor3 = T.Accent
WMicon.Font = Enum.Font.GothamBold
WMicon.TextSize = 16
WMicon.Parent = WMFrame

-- Название "BIZON HUB"
local WMtitle = Instance.new("TextLabel")
WMtitle.Size = UDim2.new(0, 90, 1, 0)
WMtitle.Position = UDim2.new(0, 32, 0, 0)
WMtitle.BackgroundTransparency = 1
WMtitle.Text = "BIZON HUB"
WMtitle.TextColor3 = T.Accent
WMtitle.Font = Enum.Font.GothamBlack
WMtitle.TextSize = 13
WMtitle.TextXAlignment = Enum.TextXAlignment.Left
WMtitle.Parent = WMFrame

-- Версия "v2.0"
local WMversion = Instance.new("TextLabel")
WMversion.Size = UDim2.new(0, 30, 1, 0)
WMversion.Position = UDim2.new(0, 120, 0, 0)
WMversion.BackgroundTransparency = 1
WMversion.Text = WATERMARK_CONFIG.Version
WMversion.TextColor3 = T.TextDim
WMversion.Font = Enum.Font.GothamBold
WMversion.TextSize = 9
WMversion.TextXAlignment = Enum.TextXAlignment.Left
WMversion.Parent = WMFrame

-- Разделитель
local WMsep1 = Instance.new("Frame")
WMsep1.Size = UDim2.new(0, 1, 0, 18)
WMsep1.Position = UDim2.new(0, 148, 0.5, -9)
WMsep1.BackgroundColor3 = T.Stroke
WMsep1.BorderSizePixel = 0
WMsep1.Parent = WMFrame

-- Версия FREE/PREMIUM
local WMedition = Instance.new("TextLabel")
WMedition.Size = UDim2.new(0, 60, 1, 0)
WMedition.Position = UDim2.new(0, 154, 0, 0)
WMedition.BackgroundTransparency = 1
WMedition.Text = WATERMARK_CONFIG.Edition
WMedition.TextColor3 = EDITION_COLORS[WATERMARK_CONFIG.Edition] or T.TextDim
WMedition.Font = Enum.Font.GothamBold
WMedition.TextSize = 10
WMedition.TextXAlignment = Enum.TextXAlignment.Left
WMedition.Parent = WMFrame

-- Расширяем фрейм (FPS/Ping)
WMFrame.Size = UDim2.new(0, 320, 0, 36)

-- Разделитель 2
local WMsep2 = Instance.new("Frame")
WMsep2.Size = UDim2.new(0, 1, 0, 18)
WMsep2.Position = UDim2.new(0, 218, 0.5, -9)
WMsep2.BackgroundColor3 = T.Stroke
WMsep2.BorderSizePixel = 0
WMsep2.Parent = WMFrame

-- FPS
local WMfps = Instance.new("TextLabel")
WMfps.Size = UDim2.new(0, 55, 1, 0)
WMfps.Position = UDim2.new(0, 224, 0, 0)
WMfps.BackgroundTransparency = 1
WMfps.Text = "FPS: --"
WMfps.TextColor3 = T.Text
WMfps.Font = Enum.Font.GothamBold
WMfps.TextSize = 10
WMfps.TextXAlignment = Enum.TextXAlignment.Left
WMfps.Parent = WMFrame

-- Ping
local WMping = Instance.new("TextLabel")
WMping.Size = UDim2.new(0, 60, 1, 0)
WMping.Position = UDim2.new(0, 278, 0, 0)
WMping.BackgroundTransparency = 1
WMping.Text = "PING: --"
WMping.TextColor3 = T.Text
WMping.Font = Enum.Font.GothamBold
WMping.TextSize = 10
WMping.TextXAlignment = Enum.TextXAlignment.Left
WMping.Parent = WMFrame

-- Перетаскивание watermark
local wmDrag, wmStart, wmStartPos
WMFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        wmDrag = true
        wmStart = input.Position
        wmStartPos = WMFrame.Position
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        wmDrag = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if wmDrag and input.UserInputType == Enum.UserInputType.MouseMovement then
        local d = input.Position - wmStart
        WMFrame.Position = UDim2.new(wmStartPos.X.Scale, wmStartPos.X.Offset + d.X, wmStartPos.Y.Scale, wmStartPos.Y.Offset + d.Y)
    end
end)

-- Обновление FPS
task.spawn(function()
    while WMFrame.Parent and not Hub.IsPanicked do
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        if fps > 999 then fps = 999 end

        local color = T.Success
        if fps < 30 then
            color = T.Danger
        elseif fps < 60 then
            color = Color3.fromRGB(255, 200, 0)
        end

        WMfps.Text = "FPS: " .. tostring(fps)
        WMfps.TextColor3 = color
    end
end)

-- Обновление Ping
task.spawn(function()
    while WMFrame.Parent and not Hub.IsPanicked do
        local ok, ping = pcall(function()
            return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
        end)
        if ok and ping then
            local pingNum = math.floor(ping)
            local color = T.Success
            if pingNum > 200 then
                color = T.Danger
            elseif pingNum > 100 then
                color = Color3.fromRGB(255, 200, 0)
            end
            WMping.Text = "PING: " .. tostring(pingNum)
            WMping.TextColor3 = color
        else
            WMping.Text = "PING: --"
        end
        task.wait(1)
    end
end)

-- Включаем/выключаем watermark через API
Hub.Watermark = WMFrame
function Hub.setEdition(edition)
    WATERMARK_CONFIG.Edition = edition
    WMedition.Text = edition
    WMedition.TextColor3 = EDITION_COLORS[edition] or T.TextDim
end

print("🐗 Watermark активирован")
