-- 🐗 Bizon Hub Utilities v2.1 (Optimized)
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local Hub = _G.BizonHub
if not Hub then warn("🐗 Загрузи core.lua!") return end
local T = Hub.Theme
local S = Hub.Settings
local player = game.Players.LocalPlayer

-- === SPEED TAB ===
local SpeedTab = Hub.createTab("Speed", "⚡")

Hub.createLabel(SpeedTab, "СКОРОСТЬ")

Hub.createToggle(SpeedTab, "Speed Hack", S.SpeedEnabled, function(state)
    S.SpeedEnabled = state
    local ch = player.Character
    if ch and ch:FindFirstChild("Humanoid") then
        ch.Humanoid.WalkSpeed = state and S.SpeedValue or 16
    end
end)

Hub.createSlider(SpeedTab, "Скорость", 16, 500, S.SpeedValue, function(v)
    S.SpeedValue = v
    if S.SpeedEnabled then
       
