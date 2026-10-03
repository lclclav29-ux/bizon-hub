-- 🐗 Bizon Hub v1.5 — Loader
local BASE = "https://raw.githubusercontent.com/lclclav29-ux/bizon-hub/main/"

local function loadModule(name)
    local ok, err = pcall(function()
        loadstring(game:HttpGet(BASE .. name .. ".lua"))()
    end)
    if not ok then
        warn("🐗 Bizon Hub: ошибка " .. name .. ": " .. tostring(err))
    end
    task.wait(0.05)
end

print("🐗 Bizon Hub: загрузка...")

loadModule("core")
loadModule("speed")
loadModule("farm")
loadModule("misc")

pcall(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "🐗 Bizon Hub",
        Text = "Загружен! Нажми 'BIZON HUB' слева или RCtrl",
        Duration = 4,
    })
end)

print("🐗 Bizon Hub: готово!")
