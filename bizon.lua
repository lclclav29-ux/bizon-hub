-- 🐗 Bizon Hub v4.1 — Loader (Split)
local BASE = "https://raw.githubusercontent.com/lclclav29-ux/bizon-hub/main/"

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local SESSION_ID = tostring(os.time()) .. "_" .. tostring(math.random(1, 999999999))

local function bustCache(url)
    local sep = url:find("?") and "&" or "?"
    return url .. sep .. "s=" .. SESSION_ID .. "&r=" .. tostring(math.random(1, 999999999))
end

-- Экспортируем тему и конфиг для keyui.lua
_G.BizonTheme = {
    Bg = Color3.fromRGB(15, 12, 25),
    Bg2 = Color3.fromRGB(28, 22, 45),
    Accent = Color3.fromRGB(168, 85, 247),
    AccentGlow = Color3.fromRGB(200, 130, 255),
    Text = Color3.fromRGB(240, 235, 255),
    TextDim = Color3.fromRGB(140, 130, 165),
    Success = Color3.fromRGB(80, 240, 160),
    Danger = Color3.fromRGB(240, 70, 100),
    Warning = Color3.fromRGB(255, 200, 50),
}

_G.BizonAdConfig = {
    Title = "🐗 BIZON HUB",
    SubTitle = "Премиум чит для Roblox",
    PromoText = "📢 Подпишись на наш канал!\n\n🎁 Получи бесплатный доступ",
    PromoURL = "https://www.youtube.com/@HOBONI-f9t",
    WaitTime = 5,
}

local THEME = _G.BizonTheme
local AD_CONFIG = _G.BizonAdConfig

-- ============================================
-- SPLASH
-- ============================================
local function showSplash()
    local splashGui = Instance.new("ScreenGui")
    splashGui.Name = "BizonSplash"
    splashGui.ResetOnSpawn = false
    splashGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    splashGui.IgnoreGuiInset = true
    splashGui.DisplayOrder = 999
    splashGui.Parent = player:WaitForChild("PlayerGui")

    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = THEME.Bg
    overlay.BackgroundTransparency = 1
    overlay.BorderSizePixel = 0
    overlay.Parent = splashGui

    local bgGrad = Instance.new("UIGradient", overlay)
    bgGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 12, 25)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(25, 18, 45)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 12, 25)),
    })
    bgGrad.Rotation = 45

    local centerFrame = Instance.new("Frame")
    centerFrame.Size = UDim2.new(0, 500, 0, 300)
    centerFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
    centerFrame.BackgroundTransparency = 1
    centerFrame.Parent = splashGui

    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 120, 0, 120)
    icon.Position = UDim2.new(0.5, -60, 0, 0)
    icon.BackgroundColor3 = THEME.Bg2
    icon.BackgroundTransparency = 1
    icon.Text = "🐗"
    icon.TextColor3 = THEME.Accent
    icon.Font = Enum.Font.GothamBold
    icon.TextSize = 90
    icon.TextTransparency = 1
    icon.Parent = centerFrame
    Instance.new("UICorner", icon).CornerRadius = UDim.new(1, 0)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 130)
    title.BackgroundTransparency = 1
    title.Text = "BIZON HUB"
    title.TextColor3 = THEME.Accent
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 42
    title.TextTransparency = 1
    title.Parent = centerFrame

    local greeting = Instance.new("TextLabel")
    greeting.Size = UDim2.new(1, 0, 0, 30)
    greeting.Position = UDim2.new(0, 0, 0, 185)
    greeting.BackgroundTransparency = 1
    greeting.Text = "👋 Приветствуем в Bizon Hub!"
    greeting.TextColor3 = THEME.Text
    greeting.Font = Enum.Font.GothamBold
    greeting.TextSize = 18
    greeting.TextTransparency = 1
    greeting.Parent = centerFrame

    local progressBg = Instance.new("Frame")
    progressBg.Size = UDim2.new(0, 400, 0, 8)
    progressBg.Position = UDim2.new(0.5, -200, 0, 240)
    progressBg.BackgroundColor3 = THEME.Bg2
    progressBg.BorderSizePixel = 0
    progressBg.BackgroundTransparency = 1
    progressBg.Parent = centerFrame
    Instance.new("UICorner", progressBg).CornerRadius = UDim.new(1, 0)

    local progressFill = Instance.new("Frame")
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = THEME.Accent
    progressFill.BorderSizePixel = 0
    progressFill.Parent = progressBg
    Instance.new("UICorner", progressFill).CornerRadius = UDim.new(1, 0)

    local percentLabel = Instance.new("TextLabel")
    percentLabel.Size = UDim2.new(0, 400, 0, 20)
    percentLabel.Position = UDim2.new(0.5, -200, 0, 258)
    percentLabel.BackgroundTransparency = 1
    percentLabel.Text = "Загрузка... 0%"
    percentLabel.TextColor3 = THEME.TextDim
    percentLabel.Font = Enum.Font.GothamBold
    percentLabel.TextSize = 13
    percentLabel.TextTransparency = 1
    percentLabel.Parent = centerFrame

    task.spawn(function()
        TweenService:Create(overlay, TweenInfo.new(0.4), {BackgroundTransparency = 0}):Play()
        TweenService:Create(icon, TweenInfo.new(0.5), {BackgroundTransparency = 0.3, TextTransparency = 0}):Play()
        task.wait(0.5)
        TweenService:Create(title, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
        task.wait(0.15)
        TweenService:Create(greeting, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
        task.wait(0.2)
        TweenService:Create(progressBg, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
        TweenService:Create(percentLabel, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    end)

    local function setProgress(pct)
        pct = math.clamp(pct, 0, 100)
        TweenService:Create(progressFill, TweenInfo.new(0.3), {Size = UDim2.new(pct/100, 0, 1, 0)}):Play()
        percentLabel.Text = "Загрузка... " .. math.floor(pct) .. "%"
    end

    local function close()
        TweenService:Create(overlay, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        TweenService:Create(icon, TweenInfo.new(0.4), {TextTransparency = 1, BackgroundTransparency = 1}):Play()
        TweenService:Create(title, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
        TweenService:Create(greeting, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
        TweenService:Create(progressBg, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        TweenService:Create(progressFill, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        TweenService:Create(percentLabel, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
        task.wait(0.6)
        splashGui:Destroy()
    end

    return setProgress, close
end

-- === ПАМЯТЬ ===
local SAVE_FILE = "bizon_key.txt"

local function hasFileAPI()
    return writefile ~= nil and readfile ~= nil and isfile ~= nil
end

local function loadSavedKey()
    if not hasFileAPI() then return nil end
    local ok, content = pcall(function()
        if isfile(SAVE_FILE) then return readfile(SAVE_FILE) end
    end)
    if not ok or not content then return nil end
    local k, e = content:match("^([^|]+)|?(.*)$")
    if not k then return nil end
    return { key = k, expiry = tonumber(e) or 0 }
end

-- === KEY UI (загружаем из keyui.lua) ===
local function loadKeyUI()
    local ok, err = pcall(function()
        local code = game:HttpGet(bustCache(BASE .. "keyui.lua"), true)
        local fn = loadstring(code)
        local showKeyUI = fn()
        if type(showKeyUI) == "function" then
            showKeyUI()
        end
    end)
    if not ok then
        warn("🐗 Ошибка keyui: " .. tostring(err))
    end
end

-- === ЗАГРУЗКА МОДУЛЕЙ ===
local MODULES = {"core", "ui1", "ui2", "ui2b", "ui3", "utilities", "teleport", "auto", "misc"}

local function loadAllModulesWithProgress(setProgress)
    for i, name in ipairs(MODULES) do
        local pct = math.floor((i / #MODULES) * 100)
        if setProgress then setProgress(pct) end
        print("🐗 Загрузка " .. name .. "... (" .. pct .. "%)")
        
        local url = bustCache(BASE .. name .. ".lua")
        local ok, err = pcall(function()
            loadstring(game:HttpGet(url))()
        end)
        
        if not ok then
            warn("🐗 ❌ Ошибка " .. name .. ": " .. tostring(err))
        else
            print("🐗 ✅ " .. name .. " загружен")
        end
        task.wait(0.25)
    end
    if setProgress then setProgress(100) end
end

-- === ГЛАВНЫЙ ПОТОК ===
print("🐗 Bizon Hub: старт (v4.1)")
print("🔑 Session: " .. SESSION_ID)

local saved = loadSavedKey()
local needKey = not (saved and saved.key and os.time() < saved.expiry)

if needKey then
    task.spawn(function()
        loadKeyUI()
        print("✅ Ключ подтверждён!")
        task.wait(0.3)
        
        local setProgress, closeSplash = showSplash()
        loadAllModulesWithProgress(setProgress)
        task.wait(1)
        closeSplash()
        
        pcall(function()
            game.StarterGui:SetCore("SendNotification", {
                Title = "🐗 Bizon Hub",
                Text = "Загружен!",
                Duration = 4,
            })
        end)
        print("🐗 Bizon Hub: готово!")
    end)
else
    task.spawn(function()
        print("✅ Автовход: " .. saved.key)
        local setProgress, closeSplash = showSplash()
        loadAllModulesWithProgress(setProgress)
        task.wait(1)
        closeSplash()
        
        pcall(function()
            game.StarterGui:SetCore("SendNotification", {
                Title = "🐗 Bizon Hub",
                Text = "Автовход (v4.1)",
                Duration = 3,
            })
        end)
        print("🐗 Bizon Hub: готово (автовход)!")
    end)
end
