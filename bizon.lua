-- 🐗 Bizon Hub v1.8 — Key System Loader
local BASE = "https://raw.githubusercontent.com/lclclav29-ux/bizon-hub/main/"
local CACHE = "?t=" .. tostring(os.time())

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local function loadValidKeys()
    local ok, data = pcall(function()
        return game:HttpGet(BASE .. "keys.txt" .. CACHE, true)
    end)
    if not ok or not data then
        warn("🐗 Не удалось загрузить список ключей")
        return {}
    end
    local keys = {}
    for line in data:gmatch("[^\r\n]+") do
        local trimmed = line:match("^%s*(.-)%s*$")
        if trimmed and #trimmed > 0 then
            keys[trimmed:upper()] = true
        end
    end
    return keys
end

local function showKeyPrompt()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BizonKeySystem"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.Parent = player:WaitForChild("PlayerGui")

    local Overlay = Instance.new("Frame")
    Overlay.Size = UDim2.new(1, 0, 1, 0)
    Overlay.BackgroundColor3 = Color3.new(0, 0, 0)
    Overlay.BackgroundTransparency = 0.4
    Overlay.BorderSizePixel = 0
    Overlay.Parent = ScreenGui

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 420, 0, 260)
    Frame.Position = UDim2.new(0.5, -210, 0.5, -130)
    Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 14)

    local stroke = Instance.new("UIStroke", Frame)
    stroke.Color = Color3.fromRGB(255, 165, 0)
    stroke.Thickness = 2

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 60)
    Title.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    Title.Text = "🐗 BIZON HUB"
    Title.TextColor3 = Color3.fromRGB(255, 165, 0)
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 24
    Title.BorderSizePixel = 0
    Title.Parent = Frame
    Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 14)
    local fix = Instance.new("Frame")
    fix.Size = UDim2.new(1, 0, 0, 15)
    fix.Position = UDim2.new(0, 0, 1, -15)
    fix.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    fix.BorderSizePixel = 0
    fix.Parent = Title

    local Hint = Instance.new("TextLabel")
    Hint.Size = UDim2.new(1, -40, 0, 30)
    Hint.Position = UDim2.new(0, 20, 0, 75)
    Hint.BackgroundTransparency = 1
    Hint.Text = "Введи ключ доступа:"
    Hint.TextColor3 = Color3.fromRGB(200, 200, 210)
    Hint.Font = Enum.Font.GothamMedium
    Hint.TextSize = 15
    Hint.TextXAlignment = Enum.TextXAlignment.Left
    Hint.Parent = Frame

    local Input = Instance.new("TextBox")
    Input.Size = UDim2.new(1, -40, 0, 44)
    Input.Position = UDim2.new(0, 20, 0, 110)
    Input.BackgroundColor3 = Color3.fromRGB(38, 38, 52)
    Input.Text = ""
    Input.PlaceholderText = "BISON-XXXX-XXXX"
    Input.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
    Input.TextColor3 = Color3.fromRGB(255, 165, 0)
    Input.Font = Enum.Font.GothamBold
    Input.TextSize = 16
    Input.BorderSizePixel = 0
    Input.ClearTextOnFocus = false
    Input.Parent = Frame
    Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 10)

    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(1, -40, 0, 24)
    Status.Position = UDim2.new(0, 20, 0, 160)
    Status.BackgroundTransparency = 1
    Status.Text = ""
    Status.TextColor3 = Color3.fromRGB(255, 70, 70)
    Status.Font = Enum.Font.GothamBold
    Status.TextSize = 13
    Status.TextXAlignment = Enum.TextXAlignment.Left
    Status.Parent = Frame

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -40, 0, 44)
    Btn.Position = UDim2.new(0, 20, 1, -60)
    Btn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    Btn.Text = "✅ ПОДТВЕРДИТЬ КЛЮЧ"
    Btn.TextColor3 = Color3.fromRGB(18, 18, 24)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 15
    Btn.BorderSizePixel = 0
    Btn.AutoButtonColor = false
    Btn.Parent = Frame
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 10)

    local verified = false
    local function tryKey()
        local entered = Input.Text:upper():gsub("%s", "")
        if entered == "" then
            Status.Text = "❌ Введи ключ"
            return
        end
        Status.Text = "⏳ Проверка..."
        Status.TextColor3 = Color3.fromRGB(255, 200, 0)
        Btn.Text = "ПРОВЕРКА..."
        task.spawn(function()
            local validKeys = loadValidKeys()
            task.wait(0.3)
            if validKeys[entered] then
                verified = true
                Status.Text = "✅ Ключ принят!"
                Status.TextColor3 = Color3.fromRGB(0, 220, 120)
                Btn.Text = "✅ OK"
                Btn.BackgroundColor3 = Color3.fromRGB(0, 220, 120)
                task.wait(0.5)
                ScreenGui:Destroy()
            else
                Status.Text = "❌ Неверный ключ"
                Status.TextColor3 = Color3.fromRGB(255, 70, 70)
                Btn.Text = "✅ ПОДТВЕРДИТЬ КЛЮЧ"
                Input.Text = ""
            end
        end)
    end

    Btn.MouseButton1Click:Connect(tryKey)
    Input.FocusLost:Connect(function(enterPressed)
        if enterPressed then tryKey() end
    end)

    while not verified and ScreenGui.Parent do
        task.wait(0.1)
    end
end

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

print("🐗 Bizon Hub: запуск Key System...")

task.spawn(function()
    showKeyPrompt()
    while player.PlayerGui:FindFirstChild("BizonKeySystem") do
        task.wait(0.1)
    end
    print("✅ Ключ подтверждён! Загрузка модулей...")
    loadModule("core")
    loadModule("speed")
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
