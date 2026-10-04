-- BIZON HUB — Misc
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local Hub = _G.BizonHub
if not Hub then warn("[Bizon Hub] Загрузи core.lua!") return end
local T = Hub.Theme
local S = Hub.Settings
local player = game.Players.LocalPlayer

local MiscTab = Hub.createTab("Misc", "")

Hub.createLabel(MiscTab, "Прочее")

Hub.createToggle(MiscTab, "Noclip", S.Noclip, function(state) S.Noclip = state end)
Hub.createToggle(MiscTab, "Fullbright", S.Fullbright, function(state)
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

Hub.createToggle(MiscTab, "Убрать туман", false, function(state)
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

-- Noclip
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

-- PANIC
Hub.createLabel(MiscTab, "Опасная зона")

local panicContainer = Instance.new("Frame")
panicContainer.Size = UDim2.new(1, 0, 0, 60)
panicContainer.BackgroundColor3 = T.Bg3
panicContainer.BackgroundTransparency = 0.3
panicContainer.BorderSizePixel = 0
panicContainer.Parent = MiscTab
Instance.new("UICorner", panicContainer).CornerRadius = UDim.new(0, 12)

local panicStroke = Instance.new("UIStroke", panicContainer)
panicStroke.Color = T.Danger
panicStroke.Thickness = 1.5
panicStroke.Transparency = 0.3

local panicBtn = Instance.new("TextButton")
panicBtn.Size = UDim2.new(1, -20, 1, -20)
panicBtn.Position = UDim2.new(0, 10, 0, 10)
panicBtn.BackgroundColor3 = T.Danger
panicBtn.Text = "PANIC — УДАЛИТЬ СКРИПТ"
panicBtn.TextColor3 = Color3.new(1, 1, 1)
panicBtn.Font = Enum.Font.GothamBold
panicBtn.TextSize = 14
panicBtn.BorderSizePixel = 0
panicBtn.AutoButtonColor = false
panicBtn.Parent = panicContainer
Instance.new("UICorner", panicBtn).CornerRadius = UDim.new(0, 10)

panicBtn.MouseButton1Click:Connect(function()
    panicBtn.Text = "УДАЛЕНО"
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
    end)
    for _, c in pairs(Hub.Connections) do pcall(function() c:Disconnect() end) end
    Hub.Connections = {}
    pcall(function()
        if Hub.ScreenGui and Hub.ScreenGui.Parent then Hub.ScreenGui:Destroy() end
        local wm = player.PlayerGui:FindFirstChild("BizonWatermark")
        if wm then wm:Destroy() end
        local tt = player.PlayerGui:FindFirstChild("BizonTooltip")
        if tt then tt:Destroy() end
    end)
    print("[Bizon Hub] PANIC")
end)

print("[Bizon Hub] Misc модуль загружен")
