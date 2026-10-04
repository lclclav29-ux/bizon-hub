-- 🐗 Bizon Hub Key UI
local TweenService = game:GetService("TweenService")

local BASE = "https://raw.githubusercontent.com/lclclav29-ux/bizon-hub/main/"
local player = game.Players.LocalPlayer

-- Получаем THEME и AD_CONFIG из глобальных
local THEME = _G.BizonTheme
local AD_CONFIG = _G.BizonAdConfig

if not THEME or not AD_CONFIG then
    warn("🐗 keyui: THEME или AD_CONFIG не заданы!")
    return
end

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
        return game:HttpGet(BASE .. "keys.txt?t=" .. tick(), true)
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

return showKeyUI
