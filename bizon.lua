-- 🐗 Bizon Hub v2.6 (TEST — без ключа)
local BASE = "https://raw.githubusercontent.com/lclclav29-ux/bizon-hub/main/"
local CACHE = "?t=" .. tostring(os.time()) .. "_" .. tostring(math.random(1, 99999999))

local function loadModule(name)
    local url = BASE .. name .. ".lua" .. CACHE
    print("🐗 Загрузка " .. name .. "...")
    local ok, err = pcall(function()
        loadstring(game:HttpGet(url))()
    end)
    if not ok then
        warn("🐗 ❌ Ошибка " .. name .. ": " .. tostring(err))
    else
        print("🐗 ✅ " .. name .. " загружен")
    end
    task.wait(0.2)
end

print("🐗 Bizon Hub: старт (v2.6 TEST)")

loadModule("core")
loadModule("ui")
loadModule("utilities")
loadModule("teleport")
loadModule("farm")
loadModule("misc")

pcall(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "🐗 Bizon Hub",
        Text = "Загружен!",
        Duration = 4,
    })
end)

print("🐗 Bizon Hub: готово!")
