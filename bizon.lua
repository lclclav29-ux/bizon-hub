-- 🐗 Bizon Hub v2.2 — Simple Key System + Ad Gate
local BASE = "https://raw.githubusercontent.com/lclclav29-ux/bizon-hub/main/"
local CACHE = "?t=" .. tostring(os.time())

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- === НАСТРОЙКИ РЕКЛАМЫ ===
local AD_CONFIG = {
    Title = "🐗 BIZON HUB",
    SubTitle = "Премиум чит для Roblox",
    PromoText = "📢 Подпишись на наш канал!\n\n🎁 Получи бесплатный доступ",
    PromoURL = "https://www.youtube.com/@HOBONI-f9t",
    ButtonURL = "🔗 Открыть YouTube канал",
    WaitTime = 5,
}

-- === ЗАГРУЗКА КЛЮЧЕЙ ИЗ keys.txt ===
local function loadValidKeys()
    local ok, data = pcall(function()
        return game:HttpGet(BASE .. "keys.txt" .. CACHE, true)
    end)
    if not ok or not data then
        warn("🐗 Не удалось загрузить keys.txt")
        return {}
    end
    local keys = {}
    for line in data:gmatch("[^\r\n]+") do
        local trimmed = line:match("^%s*(.-)%s*$")
        if trimmed and #trimmed > 0 and not trimmed:match("^#") then
            -- Поддержка формата "KEY" или "KEY|YYYY-MM-DD"
            local key, expiry = trimmed:match("^([^|]+)|?(.*)$")
            if key then
                keys[key:upper():gsub("%s", "")] = expiry ~= "" and expiry or nil
            end
        end
    end
    return keys
end

-- === ПРОВЕРКА СРОКА ===
local function isExpired(expiryStr)
    if not expiryStr or expiryStr == "" then return false end
    local y, m, d = expiryStr:match("(%d+)-(%d+)-(%d+)")
    if not y then return false end
    local expiryTime = os.time({year = tonumber(y), month = tonumber(m), day = tonumber(d), hour = 23, min = 59})
    return os.time() > expiryTime
end

-- === AD GATE + KEY INPUT ===
local function showAdGate()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BizonKeySystem"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.Parent = player:WaitForChild("PlayerGui")

    local Overlay = Instance.new("Frame")
    Overlay.Size = UDim2.new(1, 0, 1, 0)
    Overlay.BackgroundColor3 = Color3.new(0, 0, 0)
    Overlay.BackgroundTransparency = 0.45
    Overlay.BorderSizePixel = 0
    Overlay.Parent = ScreenGui

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 460, 0, 420)
    Frame.Position = UDim2.new(0.5, -230, 0.5, -210)
    Frame.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 22)

    local stroke = Instance.new("UIStroke", Frame)
    stroke.Color = Color3.fromRGB(255, 145, 30)
    stroke.Thickness = 2

    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 70)
    Header.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    Header.BorderSizePixel = 0
    Header.Parent = Frame
    Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 22)

    local HeaderFix = Instance.new("Frame")
    HeaderFix.Size = UDim2.new(1, 0, 0, 20)
    HeaderFix.Position = UDim2.new(0, 0, 1, -20)
    HeaderFix.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    HeaderFix.BorderSizePixel = 0
    HeaderFix.Parent = Header

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Position = UDim2.new(0, 0, 0, 8)
    Title.BackgroundTransparency = 1
    Title.Text = AD_CONFIG.Title
    Title.TextColor3 = Color3.fromRGB(255, 145, 30)
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 22
    Title.Parent = Header

    local SubTitle = Instance.new("TextLabel")
    SubTitle.Size = UDim2.new(1, 0, 0, 20)
    SubTitle.Position = UDim2.new(0, 0, 0, 44)
    SubTitle.BackgroundTransparency = 1
    SubTitle.Text = AD_CONFIG.SubTitle
    SubTitle.TextColor3 = Color3.fromRGB(140, 140, 165)
    SubTitle.Font = Enum.Font.Gotham
    SubTitle.TextSize = 12
    SubTitle.Parent = Header

    local Promo = Instance.new("TextLabel")
    Promo.Size = UDim2.new(1, -40, 0, 100)
    Promo.Position = UDim2.new(0, 20, 0, 90)
    Promo.BackgroundTransparency = 1
    Promo.Text = AD_CONFIG.PromoText
    Promo.TextColor3 = Color3.fromRGB(235, 235, 245)
    Promo.Font = Enum.Font.GothamMedium
    Promo.TextSize = 15
    Promo.TextWrapped = true
    Promo.TextYAlignment = Enum.TextYAlignment.Top
    Promo.Parent = Frame

    local PromoBtn = Instance.new("TextButton")
    PromoBtn.Size = UDim2.new(1, -40, 0, 40)
    PromoBtn.Position = UDim2.new(0, 20, 0, 200)
    PromoBtn.BackgroundColor3 = Color3.fromRGB(255, 90, 20)
    PromoBtn.Text = AD_CONFIG.ButtonURL
    PromoBtn.TextColor3 = Color3.new(1, 1, 1)
    PromoBtn.Font = Enum.Font.GothamBold
    PromoBtn.TextSize = 14
    PromoBtn.BorderSizePixel = 0
    PromoBtn.AutoButtonColor = false
    PromoBtn.Parent = Frame
    Instance.new("UICorner", PromoBtn).CornerRadius = UDim.new(0, 10)

    PromoBtn.MouseButton1Click:Connect(function()
        pcall(function()
            if setclipboard then setclipboard(AD_CONFIG.PromoURL) end
        end)
        PromoBtn.Text = "✅ Ссылка скопирована!"
        PromoBtn.BackgroundColor3 = Color3.fromRGB(50, 220, 130)
    end)

    local timerLabel = Instance.new("TextLabel")
    timerLabel.Size = UDim2.new(1, -40, 0, 26)
    timerLabel.Position = UDim2.new(0, 20, 0, 252)
    timerLabel.BackgroundTransparency = 1
    timerLabel.Text = "⏳ Подожди " .. AD_CONFIG.WaitTime .. " секунд..."
    timerLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    timerLabel.Font = Enum.Font.GothamBold
    timerLabel.TextSize = 13
    timerLabel.Parent = Frame

    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(1, -40, 0, 44)
    KeyInput.Position = UDim2.new(0, 20, 0, 288)
    KeyInput.BackgroundColor3 = Color3.fromRGB(42, 42, 58)
    KeyInput.Text = ""
    KeyInput.PlaceholderText = "BISON-XXXX-XXXX"
    KeyInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
    KeyInput.TextColor3 = Color3.fromRGB(255, 145, 30)
    KeyInput.Font = Enum.Font.GothamBold
    KeyInput.TextSize = 15
    KeyInput.BorderSizePixel = 0
    KeyInput.ClearTextOnFocus = false
    KeyInput.Visible = false
    KeyInput.Parent = Frame
    Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 10)

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -40, 0, 46)
    Btn.Position = UDim2.new(0, 20, 1, -60)
    Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    Btn.Text = "🔒 Заблокировано"
    Btn.TextColor3 = Color3.fromRGB(140, 140, 165)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 15
    Btn.BorderSizePixel = 0
    Btn.AutoButtonColor = false
    Btn.Active = false
    Btn.Parent = Frame
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 10)

    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(1, -40, 0, 22)
    Status.Position = UDim2.new(0, 20, 1, -84)
    Status.BackgroundTransparency = 1
    Status.Text = ""
    Status.TextColor3 = Color3.fromRGB(255, 70, 70)
    Status.Font = Enum.Font.GothamBold
    Status.TextSize = 12
    Status.TextXAlignment = Enum.TextXAlignment.Left
    Status.Parent = Frame

    task.spawn(function()
        for i = AD_CONFIG.WaitTime, 1, -1 do
            timerLabel.Text = "⏳ Подожди " .. i .. " секунд..."
            task.wait(1)
        end
        timerLabel.Text = "✅ Доступ разблокирован"
        timerLabel.TextColor3 = Color3.fromRGB(50, 220, 130)
        Btn.Active = true
        Btn.BackgroundColor3 = Color3.fromRGB(255, 145, 30)
        Btn.TextColor3 = Color3.fromRGB(22, 22, 30)
        Btn.Text = "🔓 ПОЛУЧИТЬ ДОСТУП"
    end)

    local phase = 1
    Btn.MouseButton1Click:Connect(function()
        if not Btn.Active then return end
        if phase == 1 then
            phase = 2
            KeyInput.Visible = true
            Btn.Text = "✅ ПОДТВЕРДИТЬ КЛЮЧ"
            timerLabel.Text = "Введи ключ и нажми кнопку"
            timerLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
        elseif phase == 2 then
            local entered = KeyInput.Text:upper():gsub("%s", "")
            if entered == "" then
                Status.Text = "❌ Введи ключ"
                Status.TextColor3 = Color3.fromRGB(255, 70, 70)
                return
            end
            Status.Text = "⏳ Проверка..."
            Status.TextColor3 = Color3.fromRGB(255, 200, 0)
            Btn.Text = "ПРОВЕРКА..."
            task.spawn(function()
                local validKeys = loadValidKeys()
                task.wait(0.3)
                local expiry = validKeys[entered]
                if expiry ~= nil or validKeys[entered] == nil and rawget(validKeys, entered) then
                    -- Проверка срока
                    if expiry and isExpired(expiry) then
                        Status.Text = "❌ Ключ истёк (" .. expiry .. ")"
                        Status.TextColor3 = Color3.fromRGB(255, 70, 70)
                        Btn.Text = "✅ ПОДТВЕРДИТЬ КЛЮЧ"
                        KeyInput.Text = ""
                        return
                    end
                    Status.Text = "✅ Ключ принят!"
                    Status.TextColor3 = Color3.fromRGB(50, 220, 130)
                    Btn.Text = "✅ OK"
                    Btn.BackgroundColor3 = Color3.fromRGB(50, 220, 130)
                    task.wait(0.5)
                    ScreenGui:Destroy()
                else
                    Status.Text = "❌ Неверный ключ"
                    Status.TextColor3 = Color3.fromRGB(255, 70, 70)
                    Btn.Text = "✅ ПОДТВЕРДИТЬ КЛЮЧ"
                    KeyInput.Text = ""
                end
            end)
        end
    end)

    while ScreenGui.Parent do
        task.wait(0.1)
    end
end

-- === ЗАГРУЗКА МОДУЛЕЙ ===
local function loadModule(name)
    local url = BASE .. name .. ".lua" .. CACHE
    local ok, err = pcall(function()
        loadstring(game:HttpGet(url))()
    end)
    if not ok then
        warn("🐗 Ошибка модуля " .. name .. ": " .. tostring(err))
    end
    task.wait(0.1)
end

print("🐗 Bizon Hub: запуск...")

task.spawn(function()
    showAdGate()
    print("✅ Ключ подтверждён! Загрузка модулей...")
    loadModule("core")
    loadModule("utilities")
    loadModule("farm")
    loadModule("misc")
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "🐗 Bizon Hub",
            Text = "Загружен! Нажми 'BIZON HUB'",
            Duration = 4,
        })
    end)
    print("🐗 Bizon Hub: готово!")
end)
