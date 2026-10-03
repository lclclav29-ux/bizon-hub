-- 🐗 Bizon Hub Loader Test
print("🐗 Bizon Hub загружен успешно!")

game.StarterGui:SetCore("SendNotification", {
    Title = "🐗 Bizon Hub";
    Text = "Скрипт загружен и работает!";
    Duration = 5;
})

-- Тестовое GUI для проверки
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BizonTest"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 100)
Frame.Position = UDim2.new(0.5, -150, 0.5, -50)
Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", Frame)
stroke.Color = Color3.fromRGB(255, 165, 0)
stroke.Thickness = 2

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, 0, 1, 0)
label.BackgroundTransparency = 1
label.Text = "🐗 BIZON HUB\n✅ Работает!"
label.TextColor3 = Color3.fromRGB(255, 165, 0)
label.Font = Enum.Font.GothamBold
label.TextSize = 18
label.Parent = Frame

print("🐗 Тестовое GUI создано!")
