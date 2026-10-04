-- BIZON HUB — Splash + Key UI
local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer

local BASE = "https://raw.githubusercontent.com/lclclav29-ux/bizon-hub/main/"

local THEME = {
    Bg = Color3.fromRGB(10, 10, 18),
    Bg2 = Color3.fromRGB(18, 18, 30),
    Accent = Color3.fromRGB(168, 85, 247),
    AccentGlow = Color3.fromRGB(200, 130, 255),
    Text = Color3.fromRGB(240, 240, 245),
    TextDim = Color3.fromRGB(140, 140, 160),
    Success = Color3.fromRGB(80, 240, 160),
    Danger = Color3.fromRGB(240, 70, 100),
    Warning = Color3.fromRGB(255, 200, 50),
}

local AD_CONFIG = {
    Title = "BIZON HUB",
    SubTitle = "Premium скрипт для Roblox",
    PromoText = "Подпишись на наш канал!\n\nПолучи бесплатный доступ",
    PromoURL = "https://www.youtube.com/@HOBONI-f9t",
    WaitTime = 5,
}

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

-- ===== KEY UI =====
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
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 20)

    local s1 = Instance.new("UIStroke", Frame)
    s1.Color = THEME.Accent
    s1.Thickness = 2
    local s2 = Instance.new("UIStroke", Frame)
    s2.Color = THEME.AccentGlow
    s2.Thickness = 4
    s2.Transparency = 0.6
    local s3 = Instance.new("UIStroke", Frame)
    s3.Color = THEME.AccentGlow
    s3.Thickness = 8
    s3.Transparency = 0.85

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 32, 0, 32)
    CloseBtn.Position = UDim2.new(1, -42, 0, 10)
    CloseBtn.BackgroundColor3 = THEME.Bg2
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = THEME.TextDim
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 14
    CloseBtn.BorderSizePixel = 0
    CloseBtn.AutoButtonColor = false
    CloseBtn.Parent = Frame
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)

    CloseBtn.MouseEnter:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = THEME.Danger, TextColor3 = Color3.new(1,1,1)}):Play()
    end)
    CloseBtn.MouseLeave:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = THEME.Bg2, TextColor3 = THEME.TextDim}):Play()
    end)
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    -- Logo B
    local TitleImg = Instance.new("Frame")
    TitleImg.Size = UDim2.new(0, 36, 0, 36)
    TitleImg.Position = UDim2.new(0.5, -90, 0, 25)
    TitleImg.BackgroundColor3 = THEME.Bg2
    TitleImg.BorderSizePixel = 0
    TitleImg.Parent = Frame
    Instance.new("UICorner", TitleImg).CornerRadius = UDim.new(1, 0)

    local TIS = Instance.new("UIStroke", TitleImg)
    TIS.Color = THEME.Accent
    TIS.Thickness = 1.5

    local TIL = Instance.new("TextLabel")
    TIL.Size = UDim2.new(1, 0, 1, 0)
    TIL.BackgroundTransparency = 1
    TIL.Text = "B"
    TIL.TextColor3 = THEME.Accent
    TIL.Font = Enum.Font.GothamBlack
    TIL.TextSize = 20
    TIL.Parent = TitleImg

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -100, 0, 36)
    Title.Position = UDim2.new(0, 95, 0, 25)
    Title.BackgroundTransparency = 1
    Title.Text = AD_CONFIG.Title
    Title.TextColor3 = THEME.Accent
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 20
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Frame

    local SubTitle = Instance.new("TextLabel")
    SubTitle.Size = UDim2.new(1, 0, 0, 20)
    SubTitle.Position = UDim2.new(0, 0, 0, 72)
    SubTitle.BackgroundTransparency = 1
    SubTitle.Text = AD_CONFIG.SubTitle
    SubTitle.TextColor3 = THEME.TextDim
    SubTitle.Font = Enum.Font.Gotham
    SubTitle.TextSize = 11
    SubTitle.Parent = Frame

    local d1 = Instance.new("Frame")
    d1.Size = UDim2.new(1, -40, 0, 1)
    d1.Position = UDim2.new(0, 20, 0, 100)
    d1.BackgroundColor3 = Color3.fromRGB(50, 45, 70)
    d1.BorderSizePixel = 0
    d1.Parent = Frame

    local Promo = Instance.new("TextLabel")
    Promo.Size = UDim2.new(1, -40, 0, 60)
    Promo.Position = UDim2.new(0, 20, 0, 115)
    Promo.BackgroundTransparency = 1
    Promo.Text = AD_CONFIG.PromoText
    Promo.TextColor3 = THEME.Text
    Promo.Font = Enum.Font.GothamMedium
    Promo.TextSize = 13
    Promo.TextWrapped = true
    Promo.TextYAlignment = Enum.TextYAlignment.Top
    Promo.Parent = Frame

    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(1, -40, 0, 22)
    Status.Position = UDim2.new(0, 20, 0, 175)
    Status.BackgroundTransparency = 1
    Status.Text = "Подожди " .. AD_CONFIG.WaitTime .. " сек..."
    Status.TextColor3 = THEME.Warning
    Status.Font = Enum.Font.GothamBold
    Status.TextSize = 12
    Status.TextXAlignment = Enum.TextXAlignment.Left
    Status.Parent = Frame

    local SubBtn = Instance.new("TextButton")
    SubBtn.Size = UDim2.new(1, -40, 0, 44)
    SubBtn.Position = UDim2.new(0, 20, 0, 205)
    SubBtn.BackgroundColor3 = THEME.Bg2
    SubBtn.Text = "ПОДОЖДИ"
    SubBtn.TextColor3 = THEME.TextDim
    SubBtn.Font = Enum.Font.GothamBold
    SubBtn.TextSize = 13
    SubBtn.BorderSizePixel = 0
    SubBtn.AutoButtonColor = false
    SubBtn.Active = false
    SubBtn.Parent = Frame
    Instance.new("UICorner", SubBtn).CornerRadius = UDim.new(0, 10)

    local d2 = Instance.new("Frame")
    d2.Size = UDim2.new(1, -40, 0, 1)
    d2.Position = UDim2.new(0, 20, 0, 262)
    d2.BackgroundColor3 = Color3.fromRGB(50, 45, 70)
    d2.BorderSizePixel = 0
    d2.Parent = Frame

    local orLabel = Instance.new("TextLabel")
    orLabel.Size = UDim2.new(1, 0, 0, 20)
    orLabel.Position = UDim2.new(0, 0, 0, 256)
    orLabel.BackgroundTransparency = 1
    orLabel.Text = "или введи свой ключ"
    orLabel.TextColor3 = THEME.TextDim
    orLabel.Font = Enum.Font.Gotham
    orLabel.TextSize = 10
    orLabel.Parent = Frame

    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(1, -40, 0, 44)
    KeyInput.Position = UDim2.new(0, 20, 0, 282)
    KeyInput.BackgroundColor3 = THEME.Bg2
    KeyInput.Text = ""
    KeyInput.PlaceholderText = "BISON-XXXX-XXXX"
    KeyInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
    KeyInput.TextColor3 = THEME.Accent
    KeyInput.Font = Enum.Font.GothamBold
    KeyInput.TextSize = 13
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
    cb.Text = "V"
    cb.TextColor3 = THEME.Bg
    cb.Font = Enum.Font.GothamBlack
    cb.TextSize = 12
    cb.BorderSizePixel = 0
    cb.AutoButtonColor = false
    cb.Parent = RemBox
    Instance.new("UICorner", cb).CornerRadius = UDim.new(0, 4)

    local remLbl = Instance.new("TextLabel")
    remLbl.Size = UDim2.new(1, -30, 1, 0)
    remLbl.Position = UDim2.new(0, 28, 0, 0)
    remLbl.BackgroundTransparency = 1
    remLbl.Text = "Запомнить меня"
    remLbl.TextColor3 = Color3.fromRGB(200, 200, 220)
    remLbl.Font = Enum.Font.GothamMedium
    remLbl.TextSize = 11
    remLbl.TextXAlignment = Enum.TextXAlignment.Left
    remLbl.Parent = RemBox

    cb.MouseButton1Click:Connect(function()
        rememberState = not rememberState
        if rememberState then
            cb.BackgroundColor3 = THEME.Success
            cb.Text = "V"
        else
            cb.BackgroundColor3 = THEME.Bg2
            cb.Text = ""
        end
    end)

    local LoginBtn = Instance.new("TextButton")
    LoginBtn.Size = UDim2.new(1, -40, 0, 46)
    LoginBtn.Position = UDim2.new(0, 20, 1, -60)
    LoginBtn.BackgroundColor3 = THEME.Accent
    LoginBtn.Text = "ВОЙТИ"
    LoginBtn.TextColor3 = THEME.Bg
    LoginBtn.Font = Enum.Font.GothamBold
    LoginBtn.TextSize = 14
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
    StatusLabel.TextSize = 11
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
    StatusLabel.Parent = Frame

    local subPhase = 1
    task.spawn(function()
        for i = AD_CONFIG.WaitTime, 1, -1 do
            Status.Text = "Подожди " .. i .. " сек..."
            task.wait(1)
        end
        Status.Text = "Готово! Забери ключ"
        Status.TextColor3 = THEME.Success
        SubBtn.Active = true
        SubBtn.BackgroundColor3 = THEME.Accent
        SubBtn.TextColor3 = Color3.new(1, 1, 1)
        SubBtn.Text = "ПОЛУЧИТЬ КЛЮЧ НА 1 ДЕНЬ"

        SubBtn.MouseButton1Click:Connect(function()
            if subPhase == 1 then
                subPhase = 2
                pcall(function()
                    if setclipboard then setclipboard(AD_CONFIG.PromoURL) end
                end)
                SubBtn.Text = "Ссылка скопирована"
                SubBtn.BackgroundColor3 = THEME.Success
                task.wait(1.5)
                SubBtn.Text = "Я ПОДПИСАЛСЯ — ДАТЬ КЛЮЧ"
                SubBtn.BackgroundColor3 = THEME.Accent
                SubBtn.TextColor3 = THEME.Bg
            elseif subPhase == 2 then
                local newKey = generateKey()
                saveKey(newKey, os.time() + 86400)
                Status.Text = "Твой ключ: " .. newKey
                Status.TextColor3 = THEME.Success
                SubBtn.Text = "Ключ получен"
                SubBtn.BackgroundColor3 = THEME.Success
                task.wait(1.5)
                ScreenGui:Destroy()
            end
        end)
    end)

    local function tryLogin()
        local entered = KeyInput.Text:upper():gsub("%s", "")
        if entered == "" then
            StatusLabel.Text = "Введи ключ"
            return
        end
        StatusLabel.Text = "Проверка..."
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
                StatusLabel.Text = "Ключ принят"
                StatusLabel.TextColor3 = THEME.Success
                LoginBtn.Text = "OK"
                LoginBtn.BackgroundColor3 = THEME.Success
                if rememberState and hasFileAPI() then
                    saveKey(entered, os.time() + 7 * 86400)
                end
                task.wait(0.5)
                ScreenGui:Destroy()
            else
                StatusLabel.Text = "Неверный ключ"
                StatusLabel.TextColor3 = THEME.Danger
                LoginBtn.Text = "ВОЙТИ"
                KeyInput.Text = ""
            end
        end)
    end

    LoginBtn.MouseButton1Click:Connect(tryLogin)
    KeyInput.FocusLost:Connect(function(enter) if enter then tryLogin() end end)

    while ScreenGui.Parent do task.wait(0.1) end
end

-- ===== SPLASH =====
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

    local centerFrame = Instance.new("Frame")
    centerFrame.Size = UDim2.new(0, 500, 0, 300)
    centerFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
    centerFrame.BackgroundTransparency = 1
    centerFrame.Parent = splashGui

    local icon = Instance.new("Frame")
    icon.Size = UDim2.new(0, 100, 0, 100)
    icon.Position = UDim2.new(0.5, -50, 0, 10)
    icon.BackgroundColor3 = THEME.Bg2
    icon.BackgroundTransparency = 1
    icon.BorderSizePixel = 0
    icon.Parent = centerFrame
    Instance.new("UICorner", icon).CornerRadius = UDim.new(1, 0)

    local iconStroke = Instance.new("UIStroke", icon)
    iconStroke.Color = THEME.Accent
    iconStroke.Thickness = 2.5
    iconStroke.Transparency = 1

    local iconLetter = Instance.new("TextLabel")
    iconLetter.Size = UDim2.new(1, 0, 1, 0)
    iconLetter.BackgroundTransparency = 1
    iconLetter.Text = "B"
    iconLetter.TextColor3 = THEME.Accent
    iconLetter.Font = Enum.Font.GothamBlack
    iconLetter.TextSize = 70
    iconLetter.TextTransparency = 1
    iconLetter.Parent = icon

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 125)
    title.BackgroundTransparency = 1
    title.Text = "BIZON HUB"
    title.TextColor3 = THEME.Accent
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 34
    title.TextTransparency = 1
    title.Parent = centerFrame

    local version = Instance.new("TextLabel")
    version.Size = UDim2.new(1, 0, 0, 20)
    version.Position = UDim2.new(0, 0, 0, 165)
    version.BackgroundTransparency = 1
    version.Text = "Recode 1.0"
    version.TextColor3 = THEME.TextDim
    version.Font = Enum.Font.GothamMedium
    version.TextSize = 13
    version.TextTransparency = 1
    version.Parent = centerFrame

    local progressBg = Instance.new("Frame")
    progressBg.Size = UDim2.new(0, 380, 0, 6)
    progressBg.Position = UDim2.new(0.5, -190, 0, 210)
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
    percentLabel.Size = UDim2.new(0, 380, 0, 18)
    percentLabel.Position = UDim2.new(0.5, -190, 0, 226)
    percentLabel.BackgroundTransparency = 1
    percentLabel.Text = "Загрузка... 0%"
    percentLabel.TextColor3 = THEME.TextDim
    percentLabel.Font = Enum.Font.GothamBold
    percentLabel.TextSize = 12
    percentLabel.TextTransparency = 1
    percentLabel.Parent = centerFrame

    task.spawn(function()
        TweenService:Create(overlay, TweenInfo.new(0.4), {BackgroundTransparency = 0}):Play()
        TweenService:Create(icon, TweenInfo.new(0.4), {BackgroundTransparency = 0.3}):Play()
        TweenService:Create(iconStroke, TweenInfo.new(0.4), {Transparency = 0.3}):Play()
        TweenService:Create(iconLetter, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
        task.wait(0.4)
        TweenService:Create(title, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
        task.wait(0.15)
        TweenService:Create(version, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
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
        TweenService:Create(icon, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        TweenService:Create(iconStroke, TweenInfo.new(0.4), {Transparency = 1}):Play()
        TweenService:Create(iconLetter, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
        TweenService:Create(title, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
        TweenService:Create(version, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
        TweenService:Create(progressBg, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        TweenService:Create(progressFill, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        TweenService:Create(percentLabel, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
        task.wait(0.6)
        splashGui:Destroy()
    end

    return setProgress, close
end

return {
    showKeyUI = showKeyUI,
    showSplash = showSplash,
    loadSavedKey = loadSavedKey,
    hasFileAPI = hasFileAPI,
}
