-- 🐗 Bizon Hub v4.3 — Loader (No Cache)
local BASE = "https://raw.githubusercontent.com/lclclav29-ux/bizon-hub/main/"

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- 🔥 ЖЁСТКИЙ ОБХОД КЭША — уникальная строка каждый раз
local function fetchFile(name)
    local url = BASE .. name .. ".lua"
    -- Пробуем несколько методов
    local attempts = {
        url .. "?v=" .. tick(),
        url .. "?v=" .. tick() .. "&r=" .. math.random(1, 99999999),
        url .. "?nocache=" .. tostring(os.time()),
    }
    
    for _, u in ipairs(attempts) do
        local ok, data = pcall(function()
            return game:HttpGet(u, true)
        end)
        if ok and data and #data > 100 then
            return data
        end
        task.wait(0.05)
    end
    return nil
end

-- Загружаем splash.lua
print("🐗 Bizon Hub: старт (v4.3)")

local splashCode = fetchFile("splash")
if not splashCode then
    warn("🐗 Не удалось скачать splash.lua")
    return
end

local ok, splash = pcall(function()
    return loadstring(splashCode)()
end)

if not ok or not splash then
    warn("🐗 Ошибка splash: " .. tostring(splash))
    return
end

-- Проверяем ключ
local saved = splash.loadSavedKey()
local needKey = not (saved and saved.key and os.time() < saved.expiry)

if needKey then
    splash.showKeyUI()
    print("✅ Ключ подтверждён!")
    task.wait(0.3)
end

-- Splash screen
local setProgress, closeSplash = splash.showSplash()

-- Список модулей
local MODULES = {"core", "ui1", "ui2", "ui2b", "ui3", "utilities", "teleport", "auto", "misc"}

-- Загружаем модули с force cache-bust
for i, name in ipairs(MODULES) do
    local pct = math.floor((i / #MODULES) * 100)
    setProgress(pct)
    print("🐗 Загрузка " .. name .. "... (" .. pct .. "%)")
    
    local code = fetchFile(name)
    if code then
        local ok2, err = pcall(function()
            loadstring(code)()
        end)
        
        if not ok2 then
            warn("🐗 ❌ Ошибка " .. name .. ": " .. tostring(err))
        else
            print("🐗 ✅ " .. name .. " загружен")
        end
    else
        warn("🐗 ❌ Не скачался: " .. name)
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
