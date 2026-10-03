-- ============================================
-- WATERMARK (Large, Right Top)
-- ============================================
local WatermarkGui = Instance.new("ScreenGui")
WatermarkGui.Name = "BizonWatermark"
WatermarkGui.ResetOnSpawn = false
WatermarkGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
WatermarkGui.IgnoreGuiInset = true
WatermarkGui.Parent = player:WaitForChild("PlayerGui")

-- Основной фрейм (больше и в правом верхнем углу)
local WMFrame = Instance.new("Frame")
WMFrame.Size = UDim2.new(0, 460, 0, 58)
WMFrame.Position = UDim2.new(1, -480, 0, 20)  -- правый верхний угол
WMFrame.BackgroundColor3 = T.Bg
WMFrame.BackgroundTransparency = 0.1
WMFrame.BorderSizePixel = 0
WMFrame.Parent = WatermarkGui
Instance.new("UICorner", WMFrame).CornerRadius = UDim.new(0, 14)

local WMstroke = Instance.new("UIStroke", WMFrame)
WMstroke.Color = T.Accent
WMstroke.Thickness = 2

-- Градиент
local WMgrad = Instance.new("UIGradient", WMFrame)
WMgrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, T.Bg2),
    ColorSequenceKeypoint.new(1, T.Bg),
})
WMgrad.Rotation = 45

-- Иконка 🐗 (больше)
local WMicon = Instance.new("TextLabel")
WMicon.Size = UDim2.new(0, 50, 1, 0)
WMicon.Position = UDim2.new(0, 12, 0, 0)
WMicon.BackgroundTransparency = 1
WMicon.Text = "🐗"
WMicon.TextColor3 = T.Accent
WMicon.Font = Enum.Font.GothamBold
WMicon.TextSize = 30
WMicon.Parent = WMFrame

-- Название (больше)
local WMtitle = Instance.new("TextLabel")
WMtitle.Size = UDim2.new(0, 180, 0, 32)
WMtitle.Position = UDim2.new(0, 62, 0, 6)
WMtitle.BackgroundTransparency = 1
WMtitle.Text = "BIZON HUB"
WMtitle.TextColor3 = T.Accent
WMtitle.Font = Enum.Font.GothamBlack
WMtitle.TextSize = 24
WMtitle.TextXAlignment = Enum.TextXAlignment.Left
WMtitle.Parent = WMFrame

-- Версия (под названием)
local WMversion = Instance.new("TextLabel")
WMversion.Size = UDim2.new(0, 180, 0, 18)
WMversion.Position = UDim2.new(0, 62, 0, 36)
WMversion.BackgroundTransparency = 1
WMversion.Text = "version v2.1"
WMversion.TextColor3 = T.TextDim
WMversion.Font = Enum.Font.GothamMedium
WMversion.TextSize = 12
WMversion.TextXAlignment = Enum.TextXAlignment.Left
WMversion.Parent = WMFrame

-- Разделитель 1
local WMsep1 = Instance.new("Frame")
WMsep1.Size = UDim2.new(0, 2, 0, 32)
WMsep1.Position = UDim2.new(0, 250, 0.5, -16)
WMsep1.BackgroundColor3 = T.Stroke
WMsep1.BorderSizePixel = 0
WMsep1.Parent = WMFrame

-- FREE / PREMIUM (больше)
local WMedition = Instance.new("TextLabel")
WMedition.Size = UDim2.new(0, 80, 0, 22)
WMedition.Position = UDim2.new(0, 262, 0, 10)
WMedition.BackgroundTransparency = 1
WMedition.Text = "FREE"
WMedition.TextColor3 = T.TextDim
WMedition.Font = Enum.Font.GothamBlack
WMedition.TextSize = 16
WMedition.TextXAlignment = Enum.TextXAlignment.Left
WMedition.Parent = WMFrame

-- Плашка версии под FREE/PREMIUM
local WMeditionLabel = Instance.new("TextLabel")
WMeditionLabel.Size = UDim2.new(0, 80, 0, 16)
WMeditionLabel.Position = UDim2.new(0, 262, 0, 32)
WMeditionLabel.BackgroundTransparency = 1
WMeditionLabel.Text = "edition"
WMeditionLabel.TextColor3 = T.TextDim
WMeditionLabel.Font = Enum.Font.Gotham
WMeditionLabel.TextSize = 10
WMeditionLabel.TextXAlignment = Enum.TextXAlignment.Left
WMeditionLabel.Parent = WMFrame

-- Разделитель 2
local WMsep2 = Instance.new("Frame")
WMsep2.Size = UDim2.new(0, 2, 0, 32)
WMsep2.Position = UDim2.new(0, 356, 0.5, -16)
WMsep2.BackgroundColor3 = T.Stroke
WMsep2.BorderSizePixel = 0
WMsep2.Parent = WMFrame

-- FPS (больше)
local WMfps = Instance.new("TextLabel")
WMfps.Size = UDim2.new(0, 60, 0, 22)
WMfps.Position = UDim2.new(0, 366, 0, 10)
WMfps.BackgroundTransparency = 1
WMfps.Text = "FPS: --"
WMfps.TextColor3 = T.Text
WMfps.Font = Enum.Font.GothamBlack
WMfps.TextSize = 15
WMfps.TextXAlignment = Enum.TextXAlignment.Left
WMfps.Parent = WMFrame

-- PING (под FPS)
local WMping = Instance.new("TextLabel")
WMping.Size = UDim2.new(0, 90, 0, 18)
WMping.Position = UDim2.new(0, 366, 0, 32)
WMping.BackgroundTransparency = 1
WMping.Text = "PING: --"
WMping.TextColor3 = T.Text
WMping.Font = Enum.Font.GothamBold
WMping.TextSize = 12
WMping.TextXAlignment = Enum.TextXAlignment.Left
WMping.Parent = WMFrame

-- Drag watermark
local wmDrag, wmStart, wmStartPos
Hub.addConnection(WMFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        wmDrag = true; wmStart = input.Position; wmStartPos = WMFrame.Position
    end
end))
Hub.addConnection(UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then wmDrag = false end
end))
Hub.addConnection(UserInputService.InputChanged:Connect(function(input)
    if wmDrag and input.UserInputType == Enum.UserInputType.MouseMovement then
        local d = input.Position - wmStart
        WMFrame.Position = UDim2.new(wmStartPos.X.Scale, wmStartPos.X.Offset + d.X, wmStartPos.Y.Scale, wmStartPos.Y.Offset + d.Y)
    end
end))

-- === СГЛАЖЕННЫЙ FPS (усреднение за 30 кадров) ===
local fpsHistory = {}
local FPS_SAMPLES = 30

task.spawn(function()
    local lastUpdate = tick()
    local frames = 0
    while WMFrame.Parent and not Hub.IsPanicked do
        RunService.RenderStepped:Wait()
        frames = frames + 1
        local now = tick()
        if now - lastUpdate >= 0.5 then
            local rawFps = frames / (now - lastUpdate)
            frames = 0
            lastUpdate = now

            table.insert(fpsHistory, rawFps)
            if #fpsHistory > FPS_SAMPLES then
                table.remove(fpsHistory, 1)
            end

            local sum = 0
            for _, v in pairs(fpsHistory) do sum = sum + v end
            local avgFps = math.floor(sum / #fpsHistory)

            local color = T.Success
            if avgFps < 30 then color = T.Danger
            elseif avgFps < 60 then color = Color3.fromRGB(255, 200, 0) end

            WMfps.Text = "FPS: " .. tostring(avgFps)
            WMfps.TextColor3 = color
        end
    end
end)

-- === СГЛАЖЕННЫЙ PING ===
local pingHistory = {}
local PING_SAMPLES = 10

task.spawn(function()
    while WMFrame.Parent and not Hub.IsPanicked do
        local ok, ping = pcall(function()
            return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
        end)
        if ok and ping then
            table.insert(pingHistory, ping)
            if #pingHistory > PING_SAMPLES then
                table.remove(pingHistory, 1)
            end

            local sum = 0
            for _, v in pairs(pingHistory) do sum = sum + v end
            local avgPing = math.floor(sum / #pingHistory)

            local color = T.Success
            if avgPing > 200 then color = T.Danger
            elseif avgPing > 100 then color = Color3.fromRGB(255, 200, 0) end

            WMping.Text = "PING: " .. tostring(avgPing)
            WMping.TextColor3 = color
        end
        task.wait(1)
    end
end)

-- API смены версии
Hub.Watermark = WMFrame
function Hub.setEdition(edition)
    Hub.WatermarkEdition = edition
    WMedition.Text = edition
    if edition == "PREMIUM" then
        WMedition.TextColor3 = Color3.fromRGB(255, 200, 50)
        WMstroke.Color = Color3.fromRGB(255, 200, 50)
        WMtitle.TextColor3 = Color3.fromRGB(255, 200, 50)
        WMicon.TextColor3 = Color3.fromRGB(255, 200, 50)
    else
        WMedition.TextColor3 = T.TextDim
        WMstroke.Color = T.Accent
        WMtitle.TextColor3 = T.Accent
        WMicon.TextColor3 = T.Accent
    end
end
