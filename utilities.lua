-- BIZON HUB — Utilities (Speed, Jump, Fly)
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local Hub = _G.BizonHub
if not Hub then warn("[Bizon Hub] Загрузи core.lua!") return end
local T = Hub.Theme
local S = Hub.Settings
local player = game.Players.LocalPlayer

-- ===== SPEED TAB =====
local SpeedTab = Hub.createTab("Speed", "")

Hub.createLabel(SpeedTab, "Движение")

Hub.createToggle(SpeedTab, "Speed Hack", S.SpeedEnabled, function(state)
    S.SpeedEnabled = state
    local ch = player.Character
    if ch and ch:FindFirstChild("Humanoid") then
        ch.Humanoid.WalkSpeed = state and S.SpeedValue or 16
    end
end)

Hub.createSlider(SpeedTab, "Скорость", 16, 500, S.SpeedValue, function(v)
    S.SpeedValue = v
    if S.SpeedEnabled then
        local ch = player.Character
        if ch and ch:FindFirstChild("Humanoid") then ch.Humanoid.WalkSpeed = v end
    end
end)

Hub.createLabel(SpeedTab, "Дополнительно")

Hub.createToggle(SpeedTab, "Плавное ускорение", S.SmoothSpeed, function(s) S.SmoothSpeed = s end)
Hub.createToggle(SpeedTab, "Ускорение в воздухе", S.SpeedInAir, function(s) S.SpeedInAir = s end)

Hub.createLabel(SpeedTab, "Прыжок")

Hub.createToggle(SpeedTab, "Jump Power", S.JumpEnabled, function(state)
    S.JumpEnabled = state
    local ch = player.Character
    if ch and ch:FindFirstChild("Humanoid") then
        ch.Humanoid.UseJumpPower = true
        ch.Humanoid.JumpPower = state and S.JumpValue or 50
    end
end)

Hub.createSlider(SpeedTab, "Сила прыжка", 50, 500, S.JumpValue, function(v)
    S.JumpValue = v
    if S.JumpEnabled then
        local ch = player.Character
        if ch and ch:FindFirstChild("Humanoid") then ch.Humanoid.JumpPower = v end
    end
end)

Hub.createToggle(SpeedTab, "Infinite Jump", S.InfiniteJump, function(s) S.InfiniteJump = s end)

Hub.createLabel(SpeedTab, "Полёт")

local flyBodyVel, flyBodyGyro, flyConnection

local function startFly()
    local ch = player.Character
    if not ch then return end
    local hrp = ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if flyBodyVel then flyBodyVel:Destroy() end
    if flyBodyGyro then flyBodyGyro:Destroy() end
    if flyConnection then flyConnection:Disconnect() end

    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.Parent = hrp
    flyBodyVel = bv

    local bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
    bg.P = 1000
    bg.D = 50
    bg.Parent = hrp
    flyBodyGyro = bg

    flyConnection = RunService.RenderStepped:Connect(function()
        if not S.FlyEnabled or not flyBodyVel or not flyBodyVel.Parent then return end
        local cam = workspace.CurrentCamera
        local moveDir = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end
        flyBodyVel.Velocity = moveDir * S.FlySpeed
        flyBodyGyro.CFrame = cam.CFrame
    end)
end

local function stopFly()
    if flyBodyVel then flyBodyVel:Destroy(); flyBodyVel = nil end
    if flyBodyGyro then flyBodyGyro:Destroy(); flyBodyGyro = nil end
    if flyConnection then flyConnection:Disconnect(); flyConnection = nil end
end

Hub.createToggle(SpeedTab, "Fly", S.FlyEnabled, function(state)
    S.FlyEnabled = state
    if state then startFly() else stopFly() end
end)

Hub.createSlider(SpeedTab, "Скорость полёта", 10, 300, S.FlySpeed, function(v) S.FlySpeed = v end)

-- ===== HEARTBEAT =====
Hub.addConnection(RunService.Heartbeat:Connect(function()
    if Hub.IsPanicked then return end
    if not S.SmoothSpeed and not S.SpeedInAir then return end
    local ch = player.Character
    if not ch then return end
    local hum = ch:FindFirstChild("Humanoid")
    if not hum then return end
    if S.SmoothSpeed and S.SpeedEnabled then
        local cur = hum.WalkSpeed
        hum.WalkSpeed = cur + (S.SpeedValue - cur) * 0.15
    end
    if S.SpeedInAir and S.SpeedEnabled then
        if hum:GetState() == Enum.HumanoidStateType.Freefall then
            hum.WalkSpeed = S.SpeedValue
        end
    end
end))

-- ===== INFINITE JUMP =====
Hub.addConnection(UserInputService.JumpRequest:Connect(function()
    if Hub.IsPanicked then return end
    if S.InfiniteJump then
        local ch = player.Character
        if ch and ch:FindFirstChild("Humanoid") then
            ch.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end))

-- ===== RESPAWN =====
Hub.addConnection(player.CharacterAdded:Connect(function()
    task.wait(0.5)
    if S.SpeedEnabled then
        local hum = player.Character:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = S.SpeedValue end
    end
    if S.JumpEnabled then
        local hum = player.Character:FindFirstChild("Humanoid")
        if hum then hum.UseJumpPower = true; hum.JumpPower = S.JumpValue end
    end
    if S.FlyEnabled then
        stopFly()
        task.wait(0.2)
        startFly()
    end
end))

print("[Bizon Hub] Utilities модуль загружен")
