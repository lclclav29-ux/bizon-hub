-- 🐗 Bizon Hub v1.4 — Loader
local BASE = "https://raw.githubusercontent.com/lclclav29-ux/bizon-hub/main/"

local function loadModule(name)
    local url = BASE .. name .. ".lua"
    local ok, err = pcall(function()
        loadstring(game:HttpGet(url))()
    end)
    if not ok then
        warn("🐗 Bizon Hub: ошибка модуля " .. name .. ": " .. tostring(err))
    end
    task.wait(0.1)
end

print("🐗 Bizon Hub: загрузка модулей...")

loadModule("core")
loadModule("speed")
loadModule("farm")
loadModule("misc")

game.StarterGui:SetCore("SendNotification", {
    Title = "🐗 Bizon Hub",
    Text = "Загружен! Нажми 'BIZON HUB' или RCtrl",
    Duration = 5,
})

print("🐗 Bizon Hub: готово!")
