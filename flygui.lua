--[[
	Скрипт полета для телефона
	Разработано для Delta Executor
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

local flyActive = false
local flySpeed = 50

-- Функция для включения и выключения полета
local function setFlyState(enabled)
	flyActive = enabled
	Humanoid.PlatformStand = enabled

	if enabled then
		-- Создаем BodyVelocity и BodyGyro для управления
		local bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
		bodyVelocity.Parent = RootPart

		local bodyGyro = Instance.new("BodyGyro")
		bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
		bodyGyro.Parent = RootPart

		-- Создаём цикл полета, который будет работать, пока режим включён
		local flyConnection
		flyConnection = RunService.Heartbeat:Connect(function()
			-- Если режим выключен или персонаж умер, отключаем цикл
			if not flyActive or not RootPart.Parent or Humanoid.Health <= 0 then
				flyConnection:Disconnect()
				bodyVelocity:Destroy()
				bodyGyro:Destroy()
				return
			end

			bodyGyro.CFrame = CFrame.new(RootPart.Position, RootPart.Position + Humanoid.MoveDirection)
			bodyVelocity.Velocity = Humanoid.MoveDirection * flySpeed
		end)
	else
		-- Убираем BodyMovers при выключении режима
		for _, v in ipairs(RootPart:GetChildren()) do
			if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then
				v:Destroy()
			end
		end
	end
end

-- Создаём простой GUI для включения/выключения
local function createGui()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "FlyGUI"
	screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
	screenGui.ResetOnSpawn = false

	local frame = Instance.new("Frame")
	frame.Name = "FlyFrame"
	frame.Size = UDim2.new(0, 150, 0, 90)
	frame.Position = UDim2.new(0.5, -75, 0.8, -45)
	frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	frame.Active = true
	frame.Draggable = true
	frame.Parent = screenGui

	local toggleButton = Instance.new("TextButton")
	toggleButton.Name = "ToggleButton"
	toggleButton.Size = UDim2.new(1, -10, 0.4, -5)
	toggleButton.Position = UDim2.new(0, 5, 0, 5)
	toggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	toggleButton.Text = "Полет: ВЫКЛ"
	toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	toggleButton.Font = Enum.Font.SourceSansBold
	toggleButton.TextSize = 18
	toggleButton.Parent = frame

	local speedFrame = Instance.new("Frame")
	speedFrame.Size = UDim2.new(1, -10, 0.4, -5)
	speedFrame.Position = UDim2.new(0, 5, 0.5, 0)
	speedFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	speedFrame.Parent = frame

	local speedLabel = Instance.new("TextLabel")
	speedLabel.Name = "SpeedLabel"
	speedLabel.Size = UDim2.new(0.5, -5, 1, -5)
	speedLabel.Position = UDim2.new(0.25, 0, 0, 2.5)
	speedLabel.Text = tostring(flySpeed)
	speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	speedLabel.BackgroundTransparency = 1
	speedLabel.Font = Enum.Font.SourceSansBold
	speedLabel.TextScaled = true
	speedLabel.Parent = speedFrame

	local plusButton = Instance.new("TextButton")
	plusButton.Name = "PlusButton"
	plusButton.Size = UDim2.new(0.25, -5, 1, -5)
	plusButton.Position = UDim2.new(0.75, 0, 0, 2.5)
	plusButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
	plusButton.Text = "+"
	plusButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	plusButton.Font = Enum.Font.SourceSansBold
	plusButton.TextScaled = true
	plusButton.Parent = speedFrame

	local minusButton = Instance.new("TextButton")
	minusButton.Name = "MinusButton"
	minusButton.Size = UDim2.new(0.25, -5, 1, -5)
	minusButton.Position = UDim2.new(0, 0, 0, 2.5)
	minusButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	minusButton.Text = "-"
	minusButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	minusButton.Font = Enum.Font.SourceSansBold
	minusButton.TextScaled = true
	minusButton.Parent = speedFrame

	toggleButton.MouseButton1Click:Connect(function()
		setFlyState(not flyActive)
		if flyActive then
			toggleButton.Text = "Полет: ВКЛ"
			toggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
		else
			toggleButton.Text = "Полет: ВЫКЛ"
			toggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		end
	end)

	plusButton.MouseButton1Click:Connect(function()
		flySpeed += 10
		speedLabel.Text = tostring(flySpeed)
	end)

	minusButton.MouseButton1Click:Connect(function()
		if flySpeed > 10 then
			flySpeed -= 10
			speedLabel.Text = tostring(flySpeed)
		end
	end)
end

-- Запуск скрипта
createGui()

-- Отключаем полёт, если персонаж умирает
LocalPlayer.CharacterAdded:Connect(function(char)
	setFlyState(false)
end)
