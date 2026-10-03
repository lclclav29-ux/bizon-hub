-- 🐗 Bizon Hub v3.1 — Safe Mode
local BASE = "https://raw.githubusercontent.com/lclclav29-ux/bizon-hub/main/"
local CACHE = "?t=" .. tostring(os.time())

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- === НАСТРОЙКИ ===
local AD_CONFIG = {
    Title = "🐗 BIZON HUB",
    PromoText = "📢 Подпишись на наш канал!",
    PromoURL = "https://www.youtube.com/@HOBONI-f9t",
    WaitTime = 5,
}

-- === СОХРАНЕНИЕ КЛЮЧА ===
local SAVE_FILE = "bizon_key.txt"

local function hasFileAPI()
    return writefile ~= nil and readfile ~= nil and isfile ~= nil
end

local function saveKey(key, expiryTs)
    if not hasFileAPI() then return false end
    local ok = pcall(function()
        writefile(SAVE_FILE, tostring(key) .. "|" .. tostring(expiryTs or 0))
    end)
    return ok
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

-- === ГЕНЕРАЦИЯ AUTO-КЛЮЧА ===
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

-- === ЗАГРУЗКА КЛЮЧЕЙ ===
local function loadValidKeys()
    local ok, data = pcall(function()
        return game:HttpGet(BASE .. "keys.txt" .. CACHE, true)
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

-- === UI ===
local function showUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BizonKeySystem"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.IgnoreGuiInset = true
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
    local HF = Instance.new("Frame")
    HF.Size = UDim2.new(1, 0, 0, 20)
    HF.Position = UDim2.new(0, 0, 1, -20)
    HF.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    HF.BorderSizePixel = 0
    HF.Parent = Header

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
    SubTitle.Text = "Премиум чит для Roblox"
    SubTitle.TextColor3 = Color3.fromRGB(140, 140, 165)
    SubTitle.Font = Enum.Font.Gotham
    SubTitle.TextSize = 12
    SubTitle.Parent = Header

    local Promo = Instance.new("TextLabel")
    Promo.Size = UDim2.new(1, -40, 0, 60)
    Promo.Position = UDim2.new(0, 20, 0, 85)
    Promo.BackgroundTransparency = 1
    Promo.Text = AD_CONFIG.PromoText .. "\n\n🎁 Ключ на 1 день бесплатно"
    Promo.TextColor3 = Color3.fromRGB(235, 235, 245)
    Promo.Font = Enum.Font.GothamMedium
    Promo.TextSize = 14
    Promo.TextWrapped = true
    Promo.TextYAlignment = Enum.TextYAlignment.Top
    Promo.Parent = Frame

    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(1, -40, 0, 22)
    Status.Position = UDim2.new(0, 20, 0, 155)
    Status.BackgroundTransparency = 1
    Status.Text = "⏳ Подожди " .. AD_CONFIG.WaitTime .. " сек..."
    Status.TextColor3 = Color3.fromRGB(255, 200, 0)
    Status.Font = Enum.Font.GothamBold
    Status.TextSize = 13
    Status.TextXAlignment = Enum.TextXAlignment.Left
    Status.Parent = Frame

    local SubBtn = Instance.new("TextButton")
    SubBtn.Size = UDim2.new(1, -40, 0, 44)
    SubBtn.Position = UDim2.new(0, 20, 0, 190)
    SubBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    SubBtn.Text = "🔒 Подожди..."
    SubBtn.TextColor3 = Color3.fromRGB(140, 140, 165)
    SubBtn.Font = Enum.Font.GothamBold
    SubBtn.TextSize = 14
    SubBtn.BorderSizePixel = 0
    SubBtn.AutoButtonColor = false
    SubBtn.Active = false
    SubBtn.Parent = Frame
    Instance.new("UICorner", SubBtn).CornerRadius = UDim.new(0, 10)

    local timerFrame = Instance.new("Frame")
    timerFrame.Size = UDim2.new(1, -40, 0, 1)
    timerFrame.Position = UDim2.new(0, 20, 0, 250)
    timerFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 85)
    timerFrame.BorderSizePixel = 0
    timerFrame.Parent = Frame

    local orLabel = Instance.new("TextLabel")
    orLabel.Size = UDim2.new(1, 0, 0, 20)
    orLabel.Position = UDim2.new(0, 0, 0, 244)
    orLabel.BackgroundTransparency = 1
    orLabel.Text = "или введи свой ключ"
    orLabel.TextColor3 = Color3.fromRGB(140, 140, 165)
    orLabel.Font = Enum.Font.Gotham
    orLabel.TextSize = 11
    orLabel.Parent = Frame

    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(1, -40, 0, 44)
    KeyInput.Position = UDim2.new(0, 20, 0, 270)
    KeyInput.BackgroundColor3 = Color3.fromRGB(42, 42, 58)
    KeyInput.Text = ""
    KeyInput.PlaceholderText = "BISON-XXXX-XXXX"
    KeyInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
    KeyInput.TextColor3 = Color3.fromRGB(255, 145, 30)
    KeyInput.Font = Enum.Font.GothamBold
    KeyInput.TextSize = 14
    KeyInput.BorderSizePixel = 0
    KeyInput.ClearTextOnFocus = false
    KeyInput.Parent = Frame
    Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 10)

    -- Remember me
    local rememberState = true
    local RemBox = Instance.new("Frame")
    RemBox.Size = UDim2.new(1, -40, 0, 26)
    RemBox.Position = UDim2.new(0, 20, 0, 324)
    RemBox.BackgroundTransparency = 1
    RemBox.Parent = Frame

    local cb = Instance.new("TextButton")
    cb.Size = UDim2.new(0, 20, 0, 20)
    cb.Position = UDim2.new(0, 0, 0.5, -10)
    cb.BackgroundColor3 = Color3.fromRGB(50, 220, 130)
    cb.Text = "✓"
    cb.TextColor3 = Color3.fromRGB(22, 22, 30)
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
            cb.BackgroundColor3 = Color3.fromRGB(50, 220, 130)
            cb.Text = "✓"
        else
            cb.BackgroundColor3 = Color3.fromRGB(42, 42, 58)
            cb.Text = ""
        end
    end)

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

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, -40, 0, 22)
    StatusLabel.Position = UDim2.new(0, 20, 1, -84)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = ""
    StatusLabel.TextColor3 = Color3.fromRGB(255, 70, 70)
    StatusLabel.Font = Enum.Font.GothamBold
    StatusLabel.TextSize = 12
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
    StatusLabel.Parent = Frame

    -- Таймер + подписка
    local subPhase = 1
    task.spawn(function()
        for i = AD_CONFIG.WaitTime, 1, -1 do
            Status.Text = "⏳ Подожди " .. i .. " сек..."
            task.wait(1)
        end
        Status.Text = "✅ Готово! Забери ключ"
        Status.TextColor3 = Color3.fromRGB(50, 220, 130)
        SubBtn.Active = true
        SubBtn.BackgroundColor3 = Color3.fromRGB(255, 90, 20)
        SubBtn.TextColor3 = Color3.new(1, 1, 1)
        SubBtn.Text = "🎁 ПОЛУЧИТЬ КЛЮЧ НА 1 ДЕНЬ"

        SubBtn.MouseButton1Click:Connect(function()
            if subPhase == 1 then
                subPhase = 2
                pcall(function()
                    if setclipboard then setclipboard(AD_CONFIG.PromoURL) end
                end)
                SubBtn.Text = "✅ Ссылка скопирована! Подпишись и жми снова"
                SubBtn.BackgroundColor3 = Color3.fromRGB(50, 220, 130)
                task.wait(1.5)
                SubBtn.Text = "🔓 Я ПОДПИСАЛСЯ — ДАТЬ КЛЮЧ"
                SubBtn.BackgroundColor3 = Color3.fromRGB(255, 145, 30)
                SubBtn.TextColor3 = Color3.fromRGB(22, 22, 30)
            elseif subPhase == 2 then
                local newKey = generateKey()
                local expiryTs = os.time() + 86400  -- +1 день
                saveKey(newKey, expiryTs)

                Status.Text = "🎁 Твой ключ: " .. newKey
                Status.TextColor3 = Color3.fromRGB(50, 220, 130)
                SubBtn.Text = "✅ Ключ получен!"
                SubBtn.BackgroundColor3 = Color3.fromRGB(50, 220, 130)
                task.wait(1.5)
                ScreenGui:Destroy()
            end
        end)
    end)

    -- Вход по введённому ключу
    local function tryLogin()
        local entered = KeyInput.Text:upper():gsub("%s", "")
        if entered == "" then
            StatusLabel.Text = "❌ Введи ключ"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 70, 70)
            return
        end

        StatusLabel.Text = "⏳ Проверка..."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
        LoginBtn.Text = "ПРОВЕРКА..."

        task.spawn(function()
            local validKeys = loadValidKeys()
            task.wait(0.3)

            local saved = loadSavedKey()
            local valid = false

            if validKeys[entered] then
                valid = true
            elseif saved and saved.key == entered and os.time() < saved.expiry then
                valid = true
            end

            if valid then
                StatusLabel.Text = "✅ Ключ принят!"
                StatusLabel.TextColor3 = Color3.fromRGB(50, 220, 130)
                LoginBtn.Text = "✅ OK"
                LoginBtn.BackgroundColor3 = Color3.fromRGB(50, 220, 130)

                if rememberState and hasFileAPI() then
                    local exp = os.time() + 7 * 86400
                    saveKey(entered, exp)
                end

                task.wait(0.6)
                ScreenGui:Destroy()
            else
                StatusLabel.Text = "❌ Неверный ключ"
                StatusLabel.TextColor3 = Color3.fromRGB(255, 70, 70)
                LoginBtn.Text = "🔑 ВОЙТИ"
                KeyInput.Text = ""
            end
        end)
    end

    LoginBtn.MouseButton1Click:Connect(tryLogin)
    KeyInput.FocusLost:Connect(function(enter)
        if enter then tryLogin() end
    end)

    while ScreenGui.Parent do
        task.wait(0.1)
    end
end

-- === ЗАГРУЗКА ===
local function loadModule(name)
    local url = BASE .. name .. ".lua" .. CACHE
    local ok, err = pcall(function()
        loadstring(game:HttpGet(url))()
    end)
    if not ok then warn("🐗 Ошибка " .. name .. ": " .. tostring(err)) end
    task.wait(0.1)
end

print("🐗 Bizon Hub: старт")

-- Проверка сохранённого ключа
local saved = loadSavedKey()
if saved and saved.key and os.time() < saved.expiry then
    print("✅ Автовход: " .. saved.key)
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
    end)
else
    task.spawn(function()
        showUI()
        print("✅ Ключ подтверждён!")
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
    end)
end
loadModule("core")
loadModule("utilities")
loadModule("farm")
loadModule("misc")
