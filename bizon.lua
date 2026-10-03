-- 🐗 Bizon Hub v3.0 — Auto-Key + Remember Me
local BASE = "https://raw.githubusercontent.com/lclclav29-ux/bizon-hub/main/"
local CACHE = "?t=" .. tostring(os.time())

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- === НАСТРОЙКИ ===
local AD_CONFIG = {
    Title = "🐗 BIZON HUB",
    SubTitle = "Премиум чит для Roblox",
    PromoText = "📢 Подпишись на наш канал!\n\n🎁 Получи бесплатный доступ на 24 часа",
    PromoURL = "https://www.youtube.com/@HOBONI-f9t",
    SubBtnText = "✅ Я ПОДПИСАЛСЯ",
    WaitTime = 5,
    AutoKeyDays = 1,  -- срок авто-ключа в днях
}

-- === ФАЙЛ ПАМЯТИ ===
-- Сохраняем ключ локально чтобы не вводить каждый раз
local SAVE_FILE = "bizon_hub_key.txt"

local function getSaveFile()
    -- Пробуем разные пути executor'ов
    local paths = {
        "bizon_hub_key.txt",
        "workspace/bizon_hub_key.txt",
    }
    if writefile and isfile then
        return SAVE_FILE
    end
    return nil
end

local function saveKey(key, expiry)
    if not writefile then return end
    pcall(function()
        writefile(SAVE_FILE, key .. "|" .. tostring(expiry or 0))
    end)
end

local function loadSavedKey()
    if not readfile or not isfile then return nil end
    local ok, content = pcall(function()
        if isfile(SAVE_FILE) then
            return readfile(SAVE_FILE)
        end
        return nil
    end)
    if not ok or not content then return nil end
    local key, expiry = content:match("^([^|]+)|?(.*)$")
    if not key then return nil end
    return { key = key, expiry = tonumber(expiry) or 0 }
end

local function clearSavedKey()
    if not delfile or not isfile then return end
    pcall(function()
        if isfile(SAVE_FILE) then delfile(SAVE_FILE) end
    end)
end

-- === ГЕНЕРАЦИЯ КЛЮЧА ===
local function generateKey()
    local chars = "ABCDEFGHIJKLMNPQRSTUVWXYZ123456789"
    local seg = function()
        local s = ""
        for _ = 1, 4 do
            s = s .. chars:sub(math.random(1, #chars), math.random(1, #chars))
        end
        return s
    end
    return "AUTO-" .. seg() .. "-" .. seg()
end

-- === ЗАГРУЗКА СПИСКА КЛЮЧЕЙ ===
local function loadValidKeys()
    local ok, data = pcall(function()
        return game:HttpGet(BASE .. "keys.txt" .. CACHE, true)
    end)
    if not ok or not data then return {} end
    local keys = {}
    for line in data:gmatch("[^\r\n]+") do
        local trimmed = line:match("^%s*(.-)%s*$")
        if trimmed and #trimmed > 0 and not trimmed:match("^#") then
            local key, expiry = trimmed:match("^([^|]+)|?(.*)$")
            if key then
                keys[key:upper():gsub("%s", "")] = expiry ~= "" and expiry or nil
            end
        end
    end
    return keys
end

local function isExpired(expiryStr)
    if not expiryStr or expiryStr == "" then return false end
    local y, m, d = tostring(expiryStr):match("(%d+)-(%d+)-(%d+)")
    if not y then return false end
    local expiryTime = os.time({year = tonumber(y), month = tonumber(m), day = tonumber(d), hour = 23, min = 59})
    return os.time() > expiryTime
end

-- === UI ===
local function showKeyUI()
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
    Frame.Size = UDim2.new(0, 480, 0, 500)
    Frame.Position = UDim2.new(0.5, -240, 0.5, -250)
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
    Promo.Position = UDim2.new(0, 20, 0, 85)
    Promo.BackgroundTransparency = 1
    Promo.Text = AD_CONFIG.PromoText
    Promo.TextColor3 = Color3.fromRGB(235, 235, 245)
    Promo.Font = Enum.Font.GothamMedium
    Promo.TextSize = 14
    Promo.TextWrapped = true
    Promo.TextYAlignment = Enum.TextYAlignment.Top
    Promo.Parent = Frame

    -- Кнопка подписки
    local SubBtn = Instance.new("TextButton")
    SubBtn.Size = UDim2.new(1, -40, 0, 44)
    SubBtn.Position = UDim2.new(0, 20, 0, 190)
    SubBtn.BackgroundColor3 = Color3.fromRGB(255, 90, 20)
    SubBtn.Text = AD_CONFIG.SubBtnText
    SubBtn.TextColor3 = Color3.new(1, 1, 1)
    SubBtn.Font = Enum.Font.GothamBold
    SubBtn.TextSize = 14
    SubBtn.BorderSizePixel = 0
    SubBtn.AutoButtonColor = false
    SubBtn.Parent = Frame
    Instance.new("UICorner", SubBtn).CornerRadius = UDim.new(0, 10)

    local subPhase = 1  -- 1 = открыть канал, 2 = подписался
    SubBtn.MouseButton1Click:Connect(function()
        if subPhase == 1 then
            pcall(function()
                if setclipboard then setclipboard(AD_CONFIG.PromoURL) end
            end)
            SubBtn.Text = "✅ Ссылка скопирована! Открой канал и подпишись"
            SubBtn.BackgroundColor3 = Color3.fromRGB(50, 220, 130)
            task.wait(1.5)
            subPhase = 2
            SubBtn.Text = "🔓 ПОЛУЧИТЬ КЛЮЧ"
            SubBtn.BackgroundColor3 = Color3.fromRGB(255, 145, 30)
            SubBtn.TextColor3 = Color3.fromRGB(22, 22, 30)
        elseif subPhase == 2 then
            -- Выдать авто-ключ
            SubBtn.Text = "⏳ Генерация ключа..."
            task.spawn(function()
                local newKey = generateKey()
                local expiry = os.time() + (AD_CONFIG.AutoKeyDays * 86400)

                -- Сохраняем локально
                saveKey(newKey, expiry)

                SubBtn.Text = "✅ Ключ получен: " .. newKey
                SubBtn.BackgroundColor3 = Color3.fromRGB(50, 220, 130)

                -- Показываем информацию
                timerLabel.Text = "🎁 Твой ключ: " .. newKey .. " (на " .. AD_CONFIG.AutoKeyDays .. " дн.)"
                timerLabel.TextColor3 = Color3.fromRGB(50, 220, 130)

                task.wait(1.5)
                ScreenGui:Destroy()
            end)
        end
    end)

    -- Разделитель
    local divider = Instance.new("Frame")
    divider.Size = UDim2.new(1, -40, 0, 1)
    divider.Position = UDim2.new(0, 20, 0, 248)
    divider.BackgroundColor3 = Color3.fromRGB(60, 60, 85)
    divider.BorderSizePixel = 0
    divider.Parent = Frame

    local OrLabel = Instance.new("TextLabel")
    OrLabel.Size = UDim2.new(1, 0, 0, 20)
    OrLabel.Position = UDim2.new(0, 0, 0, 242)
    OrLabel.BackgroundTransparency = 1
    OrLabel.Text = "или введи свой ключ"
    OrLabel.TextColor3 = Color3.fromRGB(140, 140, 165)
    OrLabel.Font = Enum.Font.Gotham
    OrLabel.TextSize = 11
    OrLabel.Parent = Frame

    -- Поле ввода ключа
    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(1, -40, 0, 44)
    KeyInput.Position = UDim2.new(0, 20, 0, 270)
    KeyInput.BackgroundColor3 = Color3.fromRGB(42, 42, 58)
    KeyInput.Text = ""
    KeyInput.PlaceholderText = "BISON-XXXX-XXXX или AUTO-XXXX-XXXX"
    KeyInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
    KeyInput.TextColor3 = Color3.fromRGB(255, 145, 30)
    KeyInput.Font = Enum.Font.GothamBold
    KeyInput.TextSize = 14
    KeyInput.BorderSizePixel = 0
    KeyInput.ClearTextOnFocus = false
    KeyInput.Parent = Frame
    Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 10)

    -- Чекбокс "Запомнить меня"
    local RememberBox = Instance.new("Frame")
    RememberBox.Size = UDim2.new(1, -40, 0, 26)
    RememberBox.Position = UDim2.new(0, 20, 0, 324)
    RememberBox.BackgroundTransparency = 1
    RememberBox.Parent = Frame

    local checkbox = Instance.new("TextButton")
    checkbox.Size = UDim2.new(0, 20, 0, 20)
    checkbox.Position = UDim2.new(0, 0, 0.5, -10)
    checkbox.BackgroundColor3 = Color3.fromRGB(42, 42, 58)
    checkbox.Text = ""
    checkbox.BorderSizePixel = 0
    checkbox.AutoButtonColor = false
    checkbox.Parent = RememberBox
    Instance.new("UICorner", checkbox).CornerRadius = UDim.new(0, 5)

    local checkMark = Instance.new("TextLabel")
    checkMark.Size = UDim2.new(1, 0, 1, 0)
    checkMark.BackgroundTransparency = 1
    checkMark.Text = "✓"
    checkMark.TextColor3 = Color3.fromRGB(50, 220, 130)
    checkMark.Font = Enum.Font.GothamBold
    checkMark.TextSize = 16
    checkMark.Visible = false
    checkMark.Parent = checkbox

    local rememberState = true  -- по умолчанию вкл

    local function updateCheckbox()
        if rememberState then
            checkbox.BackgroundColor3 = Color3.fromRGB(50, 220, 130)
            checkMark.Visible = true
        else
            checkbox.BackgroundColor3 = Color3.fromRGB(42, 42, 58)
            checkMark.Visible = false
        end
    end
    updateCheckbox()

    checkbox.MouseButton1Click:Connect(function()
        rememberState = not rememberState
        updateCheckbox()
    end)

    local remLabel = Instance.new("TextLabel")
    remLabel.Size = UDim2.new(1, -30, 1, 0)
    remLabel.Position = UDim2.new(0, 28, 0, 0)
    remLabel.BackgroundTransparency = 1
    remLabel.Text = "💾 Запомнить меня (входить без ключа)"
    remLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    remLabel.Font = Enum.Font.GothamMedium
    remLabel.TextSize = 12
    remLabel.TextXAlignment = Enum.TextXAlignment.Left
    remLabel.Parent = RememberBox

    remLabel.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            rememberState = not rememberState
            updateCheckbox()
        end
    end)

    -- Кнопка "Войти"
    local LoginBtn = Instance.new("TextButton")
    LoginBtn.Size = UDim2.new(1, -40, 0, 46)
    LoginBtn.Position = UDim2.new(0, 20, 1, -60)
    LoginBtn.BackgroundColor3 = Color3.fromRGB(255, 145, 30)
    LoginBtn.Text = "🔑 ВОЙТИ"
    LoginBtn.TextColor3 = Color3.fromRGB(22, 22, 30)
    LoginBtn.Font = Enum.Font.GothamBold
    LoginBtn.TextSize = 15
    LoginBtn.BorderSizePixel = 0
    LoginBtn.AutoButtonColor = false
    LoginBtn.Parent = Frame
    Instance.new("UICorner", LoginBtn).CornerRadius = UDim.new(0, 10)

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

    local timerLabel = Instance.new("TextLabel")
    timerLabel.Size = UDim2.new(1, -40, 0, 20)
    timerLabel.Position = UDim2.new(0, 20, 0, 356)
    timerLabel.BackgroundTransparency = 1
    timerLabel.Text = ""
    timerLabel.TextColor3 = Color3.fromRGB(50, 220, 130)
    timerLabel.Font = Enum.Font.GothamBold
    timerLabel.TextSize = 12
    timerLabel.Parent = Frame

    -- Функция входа
    local function tryLogin()
        local entered = KeyInput.Text:upper():gsub("%s", "")
        if entered == "" then
            Status.Text = "❌ Введи ключ"
            Status.TextColor3 = Color3.fromRGB(255, 70, 70)
            return
        end

        Status.Text = "⏳ Проверка..."
        Status.TextColor3 = Color3.fromRGB(255, 200, 0)
        LoginBtn.Text = "ПРОВЕРКА..."

        task.spawn(function()
            local validKeys = loadValidKeys()
            task.wait(0.3)

            -- Проверяем ключ в GitHub или в локальных AUTO-ключах
            local savedData = loadSavedKey()
            local valid = false
            local expiryDate = nil

            if validKeys[entered] ~= nil or (validKeys[entered] == nil and validKeys[entered] ~= false) then
                -- Проверка наличия ключа (если есть запись — она либо true, либо дата)
                if validKeys[entered] ~= nil or rawget(validKeys, entered) ~= nil then
                    valid = true
                    expiryDate = validKeys[entered]
                end
            end

            -- Проверяем AUTO ключ (локально сохранённый)
            if not valid and savedData and savedData.key == entered then
                if os.time() < savedData.expiry then
                    valid = true
                else
                    Status.Text = "❌ Ключ истёк"
                    Status.TextColor3 = Color3.fromRGB(255, 70, 70)
                    LoginBtn.Text = "🔑 ВОЙТИ"
                    return
                end
            end

            -- Проверка на срок
            if valid and expiryDate and isExpired(expiryDate) then
                valid = false
                Status.Text = "❌ Ключ истёк (" .. tostring(expiryDate) .. ")"
                Status.TextColor3 = Color3.fromRGB(255, 70, 70)
                LoginBtn.Text = "🔑 ВОЙТИ"
                return
            end

            if valid then
                Status.Text = "✅ Ключ принят!"
                Status.TextColor3 = Color3.fromRGB(50, 220, 130)
                LoginBtn.Text = "✅ OK"
                LoginBtn.BackgroundColor3 = Color3.fromRGB(50, 220, 130)

                -- Сохраняем если "Запомнить меня"
                if rememberState then
                    if not savedData or savedData.key ~= entered then
                        local exp = os.time() + 7 * 86400  -- 7 дней по умолчанию
                        saveKey(entered, exp)
                    end
                end

                task.wait(0.6)
                ScreenGui:Destroy()
            else
                Status.Text = "❌ Неверный ключ"
                Status.TextColor3 = Color3.fromRGB(255, 70, 70)
                LoginBtn.Text = "🔑 ВОЙТИ"
                KeyInput.Text = ""
            end
        end)
    end

    LoginBtn.MouseButton1Click:Connect(tryLogin)
    KeyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then tryLogin() end
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

-- === СТАРТ ===
print("🐗 Bizon Hub: запуск...")

-- Проверяем сохранённый ключ
local saved = loadSavedKey()
if saved and saved.key and os.time() < saved.expiry then
    print("✅ Найден сохранённый ключ: " .. saved.key)
    print("⏰ Действует до: " .. os.date("%Y-%m-%d %H:%M", saved.expiry))
    -- Загружаем сразу без UI
    task.spawn(function()
        loadModule("core")
        loadModule("utilities")
        loadModule("farm")
        loadModule("misc")
        pcall(function()
            game.StarterGui:SetCore("SendNotification", {
                Title = "🐗 Bizon Hub",
                Text = "Автовход (ключ сохранён)",
                Duration = 3,
            })
        end)
        print("🐗 Bizon Hub: готово (автовход)!")
    end)
else
    -- Показываем UI для ввода
    task.spawn(function()
        showKeyUI()
        print("✅ Ключ подтверждён! Загрузка модулей...")
        loadModule("core")
        loadModule("utilities")
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
    end)
end
