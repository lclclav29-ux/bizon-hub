-- 🐗 Bizon Hub UI (Toggle, Slider, Label, Keybind)
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Hub = _G.BizonHub
if not Hub then warn("🐗 Загрузи core.lua!") return end
local T = Hub.Theme

function Hub.createToggle(parent, name, default, callback, onRightClick)
    local state = default or false
    local container = Instance.new("Frame")
    container.Background
