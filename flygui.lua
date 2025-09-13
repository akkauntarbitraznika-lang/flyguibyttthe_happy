-- Fly GUI Mobile Joystick
local Player = game.Players.LocalPlayer
local Char = Player.Character or Player.CharacterAdded:Wait()
local HRP = Char:WaitForChild("HumanoidRootPart")

local ScreenGui = Instance.new("ScreenGui", Player.PlayerGui)
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 200, 0, 60)
Frame.Position = UDim2.new(0.1, 0, 0.4, 0)
Frame.BackgroundColor3 = Color3.fromRGB(150, 255, 150)
Frame.Active = true
Frame.Draggable = true

-- Кнопки
local function makeBtn(txt, pos)
    local b = Instance.new("TextButton", Frame)
    b.Size = UDim2.new(0, 45, 0, 25)
    b.Position = pos
    b.Text = txt
    b.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
    return b
end

local btnUp = makeBtn("UP", UDim2.new(0, 0, 0, 0))
local btnDown = makeBtn("DOWN", UDim2.new(0, 0, 0, 30))
local btnToggle = makeBtn("Fly OFF", UDim2.new(0, 50, 0, 0))
local btnPlus = makeBtn("+", UDim2.new(0, 100, 0, 0))
local btnMinus = makeBtn("-", UDim2.new(0, 150, 0, 0))
local speedLabel = Instance.new("TextLabel", Frame)
speedLabel.Position = UDim2.new(0, 100, 0, 30)
speedLabel.Size = UDim2.new(0, 90, 0, 25)
speedLabel.Text = "Speed: 1"
speedLabel.BackgroundColor3 = Color3.fromRGB(255, 100, 100)

-- Логика
local flying = false
local speed = 1
local moveUp, moveDown = false, false

btnToggle.MouseButton1Click:Connect(function()
    flying = not flying
    btnToggle.Text = flying and "Fly ON" or "Fly OFF"
end)

btnPlus.MouseButton1Click:Connect(function()
    speed += 1
    if speed > 5 then speed = 1 end
    speedLabel.Text = "Speed: " .. speed
end)

btnMinus.MouseButton1Click:Connect(function()
    if speed > 1 then
        speed -= 1
        speedLabel.Text = "Speed: " .. speed
    end
end)

btnUp.MouseButton1Down:Connect(function() moveUp = true end)
btnUp.MouseButton1Up:Connect(function() moveUp = false end)
btnDown.MouseButton1Down:Connect(function() moveDown = true end)
btnDown.MouseButton1Up:Connect(function() moveDown = false end)

-- Полёт через джойстик
game:GetService("RunService").RenderStepped:Connect(function()
    if flying and HRP then
        local hum = Char:FindFirstChildOfClass("Humanoid")
        if hum then
            local dir = hum.MoveDirection
            local moveVec = dir * speed
            if moveUp then moveVec += Vector3.new(0, speed, 0) end
            if moveDown then moveVec += Vector3.new(0, -speed, 0) end
            HRP.CFrame += moveVec * 0.2
        end
    end
end)
