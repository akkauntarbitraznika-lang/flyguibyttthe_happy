--[[
	Оригинальный скрипт fly с обновленным GUI
]]

local main = Instance.new("ScreenGui")
local mainFrame = Instance.new("Frame")
local toggleButton = Instance.new("TextButton")
local upButton = Instance.new("TextButton")
local downButton = Instance.new("TextButton")
local speedFrame = Instance.new("Frame")
local speedPlus = Instance.new("TextButton")
local speedMinus = Instance.new("TextButton")
local speedLabel = Instance.new("TextLabel")
local closeButton = Instance.new("TextButton")

local speeds = 1
local nowe = false
local tpwalking = false
local isFlyingWithBodymoers = false

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Humanoid.RigType == Enum.HumanoidRigType.R6 and Character:FindFirstChild("Torso") or Character:FindFirstChild("UpperTorso")

-- Настройка GUI
main.Name = "FlyUI"
main.Parent = LocalPlayer:WaitForChild("PlayerGui")
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
main.ResetOnSpawn = false

mainFrame.Name = "MainFrame"
mainFrame.Parent = main
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BorderSizePixel = 2
mainFrame.Size = UDim2.new(0, 200, 0, 180)
mainFrame.Position = UDim2.new(0.1, 0, 0.35, 0)
mainFrame.Active = true
mainFrame.Draggable = true

-- Заголовок
local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = mainFrame
titleLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Text = "FLY GUI V3"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 18.000

-- Кнопка ВКЛ/ВЫКЛ
toggleButton.Name = "FlyToggle"
toggleButton.Parent = mainFrame
toggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
toggleButton.Position = UDim2.new(0.05, 0, 0.2, 0)
toggleButton.Size = UDim2.new(0.9, 0, 0.2, 0)
toggleButton.Text = "Полет: ВЫКЛ"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 18.000

-- Кнопки вверх/вниз
upButton.Name = "UpButton"
upButton.Parent = mainFrame
upButton.BackgroundColor3 = Color3.fromRGB(50, 150, 200)
upButton.Position = UDim2.new(0.05, 0, 0.45, 0)
upButton.Size = UDim2.new(0.4, 0, 0.2, 0)
upButton.Text = "ВВЕРХ"
upButton.TextColor3 = Color3.fromRGB(255, 255, 255)
upButton.Font = Enum.Font.SourceSansBold
upButton.TextSize = 18.000

downButton.Name = "DownButton"
downButton.Parent = mainFrame
downButton.BackgroundColor3 = Color3.fromRGB(200, 150, 50)
downButton.Position = UDim2.new(0.55, 0, 0.45, 0)
downButton.Size = UDim2.new(0.4, 0, 0.2, 0)
downButton.Text = "ВНИЗ"
downButton.TextColor3 = Color3.fromRGB(255, 255, 255)
downButton.Font = Enum.Font.SourceSansBold
downButton.TextSize = 18.000

-- Управление скоростью
speedFrame.Name = "SpeedFrame"
speedFrame.Parent = mainFrame
speedFrame.Position = UDim2.new(0.05, 0, 0.7, 0)
speedFrame.Size = UDim2.new(0.9, 0, 0.2, 0)
speedFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

speedMinus.Name = "MinusButton"
speedMinus.Parent = speedFrame
speedMinus.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
speedMinus.Position = UDim2.new(0, 0, 0, 0)
speedMinus.Size = UDim2.new(0.25, 0, 1, 0)
speedMinus.Text = "-"
speedMinus.TextColor3 = Color3.fromRGB(255, 255, 255)
speedMinus.Font = Enum.Font.SourceSansBold
speedMinus.TextScaled = true

speedLabel.Name = "SpeedLabel"
speedLabel.Parent = speedFrame
speedLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedLabel.Position = UDim2.new(0.25, 0, 0, 0)
speedLabel.Size = UDim2.new(0.5, 0, 1, 0)
speedLabel.Text = "Скорость: " .. speeds
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.Font = Enum.Font.SourceSansBold
speedLabel.TextScaled = true

speedPlus.Name = "PlusButton"
speedPlus.Parent = speedFrame
speedPlus.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
speedPlus.Position = UDim2.new(0.75, 0, 0, 0)
speedPlus.Size = UDim2.new(0.25, 0, 1, 0)
speedPlus.Text = "+"
speedPlus.TextColor3 = Color3.fromRGB(255, 255, 255)
speedPlus.Font = Enum.Font.SourceSansBold
speedPlus.TextScaled = true

-- Кнопка закрытия
closeButton.Name = "CloseButton"
closeButton.Parent = mainFrame
closeButton.BackgroundColor3 = Color3.fromRGB(225, 25, 0)
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 25.000

-- Логика из оригинального скрипта
local speaker = Players.LocalPlayer

toggleButton.MouseButton1Down:Connect(function()
	if nowe then
		nowe = false
		toggleButton.Text = "Полет: ВЫКЛ"
		toggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		
		tpwalking = false
		isFlyingWithBodymoers = false

		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
		Humanoid:ChangeState(Enum.HumanoidStateType.Running)

		for _, v in ipairs(Character:GetChildren()) do
			if v:IsA("BodyGyro") or v:IsA("BodyVelocity") then
				v:Destroy()
			end
		end

	else
		nowe = true
		toggleButton.Text = "Полет: ВКЛ"
		toggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)

		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
		Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)

		local isR6 = Humanoid.RigType == Enum.HumanoidRigType.R6

		spawn(function()
			tpwalking = true
			while tpwalking and Character and Humanoid and Humanoid.Parent do
				if Humanoid.MoveDirection.Magnitude > 0 then
					Character:TranslateBy(Humanoid.MoveDirection)
				end
				RunService.Heartbeat:Wait()
			end
		end)

		spawn(function()
			isFlyingWithBodymoers = true
			local bodyPart = isR6 and Character:FindFirstChild("Torso") or Character:FindFirstChild("UpperTorso")
			if not bodyPart then return end

			local bg = Instance.new("BodyGyro", bodyPart)
			bg.P = 9e4
			bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
			
			local bv = Instance.new("BodyVelocity", bodyPart)
			bv.maxForce = Vector3.new(9e9, 9e9, 9e9)

			Humanoid.PlatformStand = true

			local lastCtrl = {f = 0, b = 0, l = 0, r = 0}
			local speed = 0
			local maxspeed = 50

			while isFlyingWithBodymoers and Character and Humanoid.Parent do
				local ctrl = {f = 0, b = 0, l = 0, r = 0}
				
				local inputVector = Humanoid.MoveDirection
				if inputVector.Z < 0 then ctrl.f = 1 end
				if inputVector.Z > 0 then ctrl.b = 1 end
				if inputVector.X < 0 then ctrl.l = 1 end
				if inputVector.X > 0 then ctrl.r = 1 end

				if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
					speed = speed + 0.5 + (speed / maxspeed)
					if speed > maxspeed then speed = maxspeed end
				elseif speed ~= 0 then
					speed = speed - 1
					if speed < 0 then speed = 0 end
				end
				
				if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
					bv.velocity = ((workspace.CurrentCamera.CoordinateFrame.LookVector * (ctrl.f + ctrl.b)) +
								((workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b) * 0.2, 0)).p - workspace.CurrentCamera.CoordinateFrame.p)) * speed
					lastCtrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
				elseif speed ~= 0 then
					bv.velocity = ((workspace.CurrentCamera.CoordinateFrame.LookVector * (lastCtrl.f + lastCtrl.b)) +
								((workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastCtrl.l + lastCtrl.r, (lastCtrl.f + lastCtrl.b) * 0.2, 0)).p - workspace.CurrentCamera.CoordinateFrame.p)) * speed
				else
					bv.velocity = Vector3.new(0, 0, 0)
				end

				bg.cframe = workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f + ctrl.b) * 50 * speed / maxspeed), 0, 0)
				RunService.RenderStepped:Wait()
			end

			Humanoid.PlatformStand = false
			bg:Destroy()
			bv:Destroy()
		end)
	end
end)

local tis
upButton.MouseButton1Down:Connect(function()
	tis = RunService.Heartbeat:Connect(function()
		LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 1, 0)
	end)
end)
upButton.MouseButton1Up:Connect(function()
	if tis then
		tis:Disconnect()
		tis = nil
	end
end)

local dis
downButton.MouseButton1Down:Connect(function()
	dis = RunService.Heartbeat:Connect(function()
		LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, -1, 0)
	end)
end)
downButton.MouseButton1Up:Connect(function()
	if dis then
		dis:Disconnect()
		dis = nil
	end
end)

speedPlus.MouseButton1Click:Connect(function()
	speeds = speeds + 1
	speedLabel.Text = "Скорость: " .. speeds
	if nowe then
		tpwalking = false
		for i = 1, speeds do
			spawn(function()
				tpwalking = true
				while tpwalking do
					if Humanoid.MoveDirection.Magnitude > 0 then
						Character:TranslateBy(Humanoid.MoveDirection)
					end
					RunService.Heartbeat:Wait()
				end
			end)
		end
	end
end)

speedMinus.MouseButton1Click:Connect(function()
	if speeds > 1 then
		speeds = speeds - 1
		speedLabel.Text = "Скорость: " .. speeds
		if nowe then
			tpwalking = false
			for i = 1, speeds do
				spawn(function()
					tpwalking = true
					while tpwalking do
						if Humanoid.MoveDirection.Magnitude > 0 then
							Character:TranslateBy(Humanoid.MoveDirection)
						end
						RunService.Heartbeat:Wait()
					end
				end)
			end
		end
	end
end)

closeButton.MouseButton1Click:Connect(function()
	main:Destroy()
end)

LocalPlayer.CharacterAdded:Connect(function(char)
	wait(0.7)
	nowe = false
	Humanoid.PlatformStand = false
end)
