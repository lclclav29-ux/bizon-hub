-- 🐗 Bizon Hub Loader v4.4
local BASE = "https://raw.githubusercontent.com/lclclav29-ux/bizon-hub/main/"

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local SESSION = tostring(os.time()) .. "_" .. tostring(math.random(1, 999999))

local function get(url)
    local sep = url:find("?") and "&" or "?"
    return game:HttpGet(url .. sep .. "s=" .. SESSION, true)
end

print("🐗 Bizon Hub: старт (v4.4)")

-- Загружаем splash.lua
local ok, splash = pcall(function()
    return loadstring(get(BASE .. "splash.lua"))()
end)

if not ok or not splash then
    warn("🐗 Ошибка splash: " .. tostring(splash))
    return
end

-- Проверяем сохранённый ключ
local saved = splash.loadSavedKey()
local needKey = not (saved and saved.key and os.time() < saved.expiry)

if needKey then
    splash.showKeyUI()
    print("✅ Ключ подтверждён!")
    task.wait(0.3)
end

-- Splash screen
local setProgress, closeSplash = splash.showSplash()

-- ⚠️ ГЛАВНОЕ: список модулей с "worlds"
local MODULES = {"core", "ui1", "ui2", "ui2b", "ui3", "utilities", "teleport", "worlds", "auto", "misc"}

-- Загружаем модули
for i, name in ipairs(MODULES) do
    local pct = math.floor((i / #MODULES) * 100)
    setProgress(pct)
    print("🐗 Загрузка " .. name .. "... (" .. pct .. "%)")
    
    local ok2, err = pcall(function()
        loadstring(get(BASE .. name .. ".lua"))()
    end)
    
    if not ok2 then
        warn("🐗 ❌ Ошибка " .. name .. ": " .. tostring(err))
    else
        print("🐗 ✅ " .. name .. " загружен")
    end
    task.wait(0.2)
end

setProgress(100)
task.wait(0.8)
closeSplash()

pcall(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "🐗 Bizon Hub",
        Text = "Загружен!",
        Duration = 4,
    })
end)

print("🐗 Bizon Hub: готово!")
