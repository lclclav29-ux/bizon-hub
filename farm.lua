-- 🐗 Bizon Hub Farm — Auto Clicker
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Hub = _G.BizonHub
if not Hub then warn("🐗 Загрузи core.lua!") return end
local T = Hub.Theme
local S = Hub.Settings
local player = game.Players.LocalPlayer

-- Настройки
S.FarmTargetName = "Hitbox"
S.FarmRange = 20
S.FarmHitCooldown = 0.1
S.FarmUseTool = true

-- === FARM TAB ===
local FarmTab = Hub.createTab("Farm", "🌾")

Hub.createLabel(FarmTab, "АВТО КЛИКЕР ГРУШ")

Hub.createToggle(FarmTab, "👊 Auto Clicker", false, function(state)
    S.AutoFarmEnabled = state
    print("🐗 Auto Clicker: " .. (state and "ВКЛ" or "ВЫКЛ"))
end)

Hub.createLabel(FarmTab, "Цель: Hitbox · Радиус: 20")

-- === ПОИСК ЦЕЛИ ===
local function hasTargetNearby()
    local ch = player.Character
    if not ch then return false end
    local rp = ch:FindFirstChild("HumanoidRootPart")
    if not rp then return false end

    local searchRoot = Workspace:FindFirstChild("Map") or Workspace
    local targetName = S.FarmTargetName:lower()

    for _, obj in pairs(searchRoot:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find(targetName) then
            local isPlayerPart = false
            for _, plr in pairs(game.Players:GetPlayers()) do
                if plr.Character and obj:IsDescendantOf(plr.Character) then
                    isPlayerPart = true
                    break
                end
            end
            if not isPlayerPart then
                local d = (obj.Position - rp.Position).Magnitude
                if d <= S.FarmRange then
                    return true
                end
            end
        end
    end
    return false
end

-- === ЦИКЛ КЛИКЕРА ===
task.spawn(function()
    while not Hub.IsPanicked do
        task.wait(S.FarmHitCooldown)
        if not S.AutoFarmEnabled then
            continue
        end
        if hasTargetNearby() then
            local ch = player.Character
            if ch then
                local tool = ch:FindFirstChildWhichIsA("Tool")
                if tool and S.FarmUseTool then
                    pcall(function() tool:Activate() end)
                end
                pcall(function()
                    VirtualUser:Button1Down(Vector2.new(0, 0))
                    task.wait(S.FarmHitCooldown)
                    VirtualUser:Button1Up(Vector2.new(0, 0))
                end)
            end
        end
    end
end)

print("🐗 Farm модуль загружен")
