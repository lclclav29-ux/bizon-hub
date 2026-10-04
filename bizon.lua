-- 🐗 Bizon Hub v3.7 — Loader (Split UI)
local BASE = "https://raw.githubusercontent.com/lclclav29-ux/bizon-hub/main/"

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local SESSION_ID = tostring(os.time()) .. "_" .. tostring(math.random(1, 999999999)) .. "_" .. tostring(math.floor(tick() * 1000))

local function bustCache(url)
    local sep = url:find("?") and "&" or "?"
    return url .. sep .. "s=" .. SESSION_ID .. "&r=" .. tostring(math.random(1, 999999999))
end

-- === ТЕМА ===
local THEME = {
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

local AD_CONFIG = {
    Title = "🐗 BIZON HUB",
    SubTitle = "Премиум чит для Roblox",
    PromoText = "📢 Подпишись на наш канал!\n\n🎁 Получи бесплатный доступ",
    PromoURL = "https://www.youtube.com/@HOBONI-f9t",
    WaitTime = 5,
}

-- ============================================
-- FULLSCREEN SPLASH
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

    local fillGrad = Instance.new("UIGradient", progressFill)
    fillGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, THEME.Accent),
        ColorSequenceKeypoint.new(1, THEME.AccentGlow),
    })

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
        TweenService:Create(icon, TweenInfo.new(0.5), {BackgroundTransparency = 0.3}):Play()
        TweenService:Create(icon, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
        task.wait(0.5)
        TweenService:Create(title, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
        task.wait(0.15)
        TweenService:Create(greeting, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
        task.wait(0.2)
        TweenService:Create(progressBg, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
        TweenService:Create(percentLabel, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    end)

    task.spawn(function()
        while centerFrame.Parent do
            TweenService:Create(icon, TweenInfo.new(0.8, Enum.EasingStyle.Sine), {Size = UDim2.new(0, 130, 0, 130), Position = UDim2.new(0.5, -65, 0, -5)}):Play()
            task.wait(0.8)
            if not centerFrame.Parent then break end
            TweenService:Create(icon, TweenInfo.new(0.8, Enum.EasingStyle.Sine), {Size = UDim2.new(0, 120, 0, 120), Position = UDim2.new(0.5, -60, 0, 0)}):Play()
            task.wait(0.8)
        end
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

    return splashGui, setProgress, close
end

-- === ПАМЯТЬ ===
local SAVE_FILE = "bizon_key.txt"

local function hasFileAPI()
    return writefile ~= nil and readfile ~= nil and isfile ~= nil
end

local function saveKey(key, expiryTs)
    if not hasFileAPI() then return false end
    return pcall(function()
        writefile(SAVE_FILE, tostring(key) .. "|" .. tostring(expiryTs or 0))
    end)
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

local function generateKey()
    local chars = "ABCDEFGHIJKLMNPQRSTUVWXYZ123456789"
    local function seg()
        local s = ""
        for i = 1, 4 do
            local idx = math.random(1, #chars)
            s = s .. chars:sub(idx, idx)
        end
        return s
    end
    return "AUTO-" .. seg() .. "-" .. seg()
end

local function loadValidKeys()
    local ok, data = pcall(function()
        return game:HttpGet(bustCache(BASE .. "keys.txt"), true)
    end)
    if not ok or not data then return {} end
    local keys = {}
    for line in data:gmatch("[^\r\n]+") do
        local trimmed = line:match("^%s*(.-)%s*$")
        if trimmed and #trimmed > 0 and trimmed:sub(1,1) ~= "#" then
            keys[trimmed:upper():gsub("%s", "")] = true
        end
    end
    return keys
end

-- ============================================
-- KEY UI
-- ============================================
local function showKeyUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BizonKeySystem"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = 1000
    ScreenGui.Parent = player:WaitForChild("PlayerGui")

    local Overlay = Instance.new("Frame")
    Overlay.Size = UDim2.new(1, 0, 1, 0)
    Overlay.BackgroundColor3 = Color3.new(0, 0, 0)
    Overlay.BackgroundTransparency = 0.5
    Overlay.BorderSizePixel = 0
    Overlay.Parent = ScreenGui

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 460, 0, 460)
    Frame.Position = UDim2.new(0.5, -230, 0.5, -230)
    Frame.BackgroundColor3 = THEME.Bg
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 22)

    local stroke1 = Instance.new("UIStroke", Frame)
    stroke1.Color = THEME.Accent
    stroke1.Thickness = 2
    stroke1.Transparency = 0

    local stroke2 = Instance.new("UIStroke", Frame)
    stroke2.Color = THEME.AccentGlow
    stroke2.Thickness = 4
    stroke2.Transparency = 0.6

    local stroke3 = Instance.new("UIStroke", Frame)
    stroke3.Color = THEME.AccentGlow
    stroke3.Thickness = 8
    stroke3.Transparency = 0.85

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 32, 0, 32)
    CloseBtn.Position = UDim2.new(1, -42, 0, 10)
    CloseBtn.BackgroundColor3 = THEME.Bg2
    CloseBtn.BackgroundTransparency = 0.3
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = THEME.TextDim
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 16
    CloseBtn.BorderSizePixel = 0
    CloseBtn.AutoButtonColor = false
    CloseBtn.Parent = Frame
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

    local closeStroke = Instance.new("UIStroke", CloseBtn)
    closeStroke.Color = Color3.fromRGB(60, 50, 90)
    closeStroke.Thickness = 1
    closeStroke.Transparency = 0.5

    CloseBtn.MouseEnter:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = THEME.Danger, BackgroundTransparency = 0, TextColor3 = Color3.new(1,1,1)}):Play()
        TweenService:Create(closeStroke, TweenInfo.new(0.15), {Color = THEME.Danger, Transparency = 0}):Play()
    end)
    CloseBtn.MouseLeave:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = THEME.Bg2, BackgroundTransparency = 0.3, TextColor3 = THEME.TextDim}):Play()
        TweenService:Create(closeStroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(60, 50, 90), Transparency = 0.5}):Play()
    end)
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Position = UDim2.new(0, 0, 0, 30)
    Title.BackgroundTransparency = 1
    Title.Text = AD_CONFIG.Title
    Title.TextColor3 = THEME.Accent
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 22
    Title.Parent = Frame

    local SubTitle = Instance.new("TextLabel")
    SubTitle.Size = UDim2.new(1, 0, 0, 20)
    SubTitle.Position = UDim2.new(0, 0, 0, 72)
    SubTitle.BackgroundTransparency = 1
    SubTitle.Text = AD_CONFIG.SubTitle
    SubTitle.TextColor3 = THEME.TextDim
    SubTitle.Font = Enum.Font.Gotham
    SubTitle.TextSize = 12
    SubTitle.Parent = Frame

    local divider1 = Instance.new("Frame")
    divider1.Size = UDim2.new(1, -40, 0, 1)
    divider1.Position = UDim2.new(0, 20, 0, 100)
    divider1.BackgroundColor3 = Color3.fromRGB(60, 50, 90)
    divider1.BorderSizePixel = 0
    divider1.Parent = Frame

    local Promo = Instance.new("TextLabel")
    Promo.Size = UDim2.new(1, -40, 0, 60)
    Promo.Position = UDim2.new(0, 20, 0, 115)
    Promo.BackgroundTransparency = 1
    Promo.Text = AD_CONFIG.PromoText
    Promo.TextColor3 = THEME.Text
    Promo.Font = Enum.Font.GothamMedium
    Promo.TextSize = 14
    Promo.TextWrapped = true
    Promo.TextYAlignment = Enum.TextYAlignment.Top
    Promo.Parent = Frame

    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(1, -40, 0, 22)
    Status.Position = UDim2.new(0, 20, 0, 175)
    Status.BackgroundTransparency = 1
    Status.Text = "⏳ Подожди " .. AD_CONFIG.WaitTime .. " сек..."
    Status.TextColor3 = THEME.Warning
    Status.Font = Enum.Font.GothamBold
    Status.TextSize = 13
    Status.TextXAlignment = Enum.TextXAlignment.Left
    Status.Parent = Frame

    local SubBtn = Instance.new("TextButton")
    SubBtn.Size = UDim2.new(1, -40, 0, 44)
    SubBtn.Position = UDim2.new(0, 20, 0, 205)
    SubBtn.BackgroundColor3 = THEME.Bg2
    SubBtn.Text = "🔒 Подожди..."
    SubBtn.TextColor3 = THEME.TextDim
    SubBtn.Font = Enum.Font.GothamBold
    SubBtn.TextSize = 14
    SubBtn.BorderSizePixel = 0
    SubBtn.AutoButtonColor = false
    SubBtn.Active = false
    SubBtn.Parent = Frame
    Instance.new("UICorner", SubBtn).CornerRadius = UDim.new(0, 10)

    local divider2 = Instance.new("Frame")
    divider2.Size = UDim2.new(1, -40, 0, 1)
    divider2.Position = UDim2.new(0, 20, 0, 262)
    divider2.BackgroundColor3 = Color3.fromRGB(60, 50, 90)
    divider2.BorderSizePixel = 0
    divider2.Parent = Frame

    local orLabel = Instance.new("TextLabel")
    orLabel.Size = UDim2.new(1, 0, 0, 20)
    orLabel.Position = UDim2.new(0, 0, 0, 256)
    orLabel.BackgroundTransparency = 1
    orLabel.Text = "или введи свой ключ"
    orLabel.TextColor3 = THEME.TextDim
    orLabel.Font = Enum.Font.Gotham
    orLabel.TextSize = 11
    orLabel.Parent = Frame

    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(1, -40, 0, 44)
    KeyInput.Position = UDim2.new(0, 20, 0, 282)
    KeyInput.BackgroundColor3 = THEME.Bg2
    KeyInput.Text = ""
    KeyInput.PlaceholderText = "BISON-XXXX-XXXX"
    KeyInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
    KeyInput.TextColor3 = THEME.Accent
    KeyInput.Font = Enum.Font.GothamBold
    KeyInput.TextSize = 14
    KeyInput.BorderSizePixel = 0
    KeyInput.ClearTextOnFocus = false
    KeyInput.Parent = Frame
    Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 10)

    local rememberState = true
    local RemBox = Instance.new("Frame")
    RemBox.Size = UDim2.new(1, -40, 0, 26)
    RemBox.Position = UDim2.new(0, 20, 0, 336)
    RemBox.BackgroundTransparency = 1
    RemBox.Parent = Frame

    local cb = Instance.new("TextButton")
    cb.Size = UDim2.new(0, 20, 0, 20)
    cb.Position = UDim2.new(0, 0, 0.5, -10)
    cb.BackgroundColor3 = THEME.Success
    cb.Text = "✓"
    cb.TextColor3 = THEME.Bg
    cb.Font = Enum.Font.GothamBold
    cb.TextSize = 16
    cb.BorderSizePixel = 0
    cb.AutoButtonColor = false
    cb.Parent = RemBox
    Instance.new("UICorner", cb).CornerRadius = UDim.new(0, 5)

    local remLbl = Instance.new("TextLabel")
    remLbl.Size = UDim2.new(1, -30, 1, 0)
    remLbl.Position = UDim2.new(0, 28, 0, 0)
    remLbl.BackgroundTransparency = 1
    remLbl.Text = "💾 Запомнить меня"
    remLbl.TextColor3 = Color3.fromRGB(200, 200, 220)
    remLbl.Font = Enum.Font.GothamMedium
    remLbl.TextSize = 12
    remLbl.TextXAlignment = Enum.TextXAlignment.Left
    remLbl.Parent = RemBox

    cb.MouseButton1Click:Connect(function()
        rememberState = not rememberState
        if rememberState then
            cb.BackgroundColor3 = THEME.Success
            cb.Text = "✓"
        else
            cb.BackgroundColor3 = THEME.Bg2
            cb.Text = ""
        end
    end)

    local LoginBtn = Instance.new("TextButton")
    LoginBtn.Size = UDim2.new(1, -40, 0, 46)
    LoginBtn.Position = UDim2.new(0, 20, 1, -60)
    LoginBtn.BackgroundColor3 = THEME.Accent
    LoginBtn.Text = "🔑 ВОЙТИ"
    LoginBtn.TextColor3 = THEME.Bg
    LoginBtn.Font = Enum.Font.GothamBold
    LoginBtn.TextSize = 15
    LoginBtn.BorderSizePixel = 0
    LoginBtn.AutoButtonColor = false
    LoginBtn.Parent = Frame
    Instance.new("UICorner", LoginBtn).CornerRadius = UDim.new(0, 10)

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, -40, 0, 22)
    StatusLabel.Position = UDim2.new(0, 20, 1, -84)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = ""
    StatusLabel.TextColor3 = THEME.Danger
    StatusLabel.Font = Enum.Font.GothamBold
    StatusLabel.TextSize = 12
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
    StatusLabel.Parent = Frame

    local subPhase = 1
    task.spawn(function()
        for i = AD_CONFIG.WaitTime, 1, -1 do
            Status.Text = "⏳ Подожди " .. i .. " сек..."
            task.wait(1)
        end
        Status.Text = "✅ Готово! Забери ключ"
        Status.TextColor3 = THEME.Success
        SubBtn.Active = true
        SubBtn.BackgroundColor3 = THEME.Accent
        SubBtn.TextColor3 = Color3.new(1, 1, 1)
        SubBtn.Text = "🎁 ПОЛУЧИТЬ КЛЮЧ НА 1 ДЕНЬ"

        SubBtn.MouseButton1Click:Connect(function()
            if subPhase == 1 then
                subPhase = 2
                pcall(function()
                    if setclipboard then setclipboard(AD_CONFIG.PromoURL) end
                end)
                SubBtn.Text = "✅ Ссылка скопирована!"
                SubBtn.BackgroundColor3 = THEME.Success
                task.wait(1.5)
                SubBtn.Text = "🔓 Я ПОДПИСАЛСЯ — ДАТЬ КЛЮЧ"
                SubBtn.BackgroundColor3 = THEME.Accent
                SubBtn.TextColor3 = THEME.Bg
            elseif subPhase == 2 then
                local newKey = generateKey()
                saveKey(newKey, os.time() + 86400)
                Status.Text = "🎁 Твой ключ: " .. newKey
                Status.TextColor3 = THEME.Success
                SubBtn.Text = "✅ Ключ получен!"
                SubBtn.BackgroundColor3 = THEME.Success
                task.wait(1.5)
                ScreenGui:Destroy()
            end
        end)
    end)

    local function tryLogin()
        local entered = KeyInput.Text:upper():gsub("%s", "")
        if entered == "" then
            StatusLabel.Text = "❌ Введи ключ"
            return
        end
        StatusLabel.Text = "⏳ Проверка..."
        StatusLabel.TextColor3 = THEME.Warning
        LoginBtn.Text = "ПРОВЕРКА..."
        task.spawn(function()
            local validKeys = loadValidKeys()
            task.wait(0.3)
            local saved = loadSavedKey()
            local valid = false
            if validKeys[entered] then valid = true
            elseif saved and saved.key == entered and os.time() < saved.expiry then valid = true end
            if valid then
                StatusLabel.Text = "✅ Ключ принят!"
                StatusLabel.TextColor3 = THEME.Success
                LoginBtn.Text = "✅ OK"
                LoginBtn.BackgroundColor3 = THEME.Success
                if rememberState and hasFileAPI() then
                    saveKey(entered, os.time() + 7 * 86400)
                end
                task.wait(0.6)
                ScreenGui:Destroy()
            else
                StatusLabel.Text = "❌ Неверный ключ"
                StatusLabel.TextColor3 = THEME.Danger
                LoginBtn.Text = "🔑 ВОЙТИ"
                KeyInput.Text = ""
            end
        end)
    end

    LoginBtn.MouseButton1Click:Connect(tryLogin)
    KeyInput.FocusLost:Connect(function(enter) if enter then tryLogin() end end)

    while ScreenGui.Parent do task.wait(0.1) end
end

-- === ЗАГРУЗКА МОДУЛЕЙ ===
local MODULES = {"core", "ui1", "ui2", "ui2b", "ui3", "utilities", "teleport", "rebirth", "farm", "misc"}

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
print("🐗 Bizon Hub: старт (v3.7)")
print("🔑 Session: " .. SESSION_ID)

local saved = loadSavedKey()
local needKey = not (saved and saved.key and os.time() < saved.expiry)

if needKey then
    task.spawn(function()
        showKeyUI()
        print("✅ Ключ подтверждён!")
        task.wait(0.3)
        
        local splashGui, setProgress, closeSplash = showSplash()
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
        local splashGui, setProgress, closeSplash = showSplash()
        loadAllModulesWithProgress(setProgress)
        task.wait(1)
        closeSplash()
        
        pcall(function()
            game.StarterGui:SetCore("SendNotification", {
                Title = "🐗 Bizon Hub",
                Text = "Автовход (v3.7)",
                Duration = 3,
            })
        end)
        print("🐗 Bizon Hub: готово (автовход)!")
    end)
end
