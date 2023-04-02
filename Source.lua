local Backpack = script.Parent:WaitForChild("Backpack")
local Cam = Backpack:WaitForChild("Cam")
local UIS = game:GetService("UserInputService")

local Character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()

local function GetPoints()
	local Points = {}
	for i,v in ipairs(Backpack:FindFirstChild("Points"):GetChildren()) do
		table.insert(Points,v)
	end
	return Points
end

local function GetTools()
	local Tools = {}
	local PlayerBackpack = game.Players.LocalPlayer:WaitForChild("Backpack")
	for i,v in ipairs(PlayerBackpack:GetChildren()) do
		if v:GetAttribute("Type") then
			table.insert(Tools,v)
		end
	end
	return Tools
end

local function GetToolModelFor(Tool)
	local Tool1 = Tool
	local Name = Tool1.Name
	local ToolModelStorage = game:GetService("ReplicatedStorage"):FindFirstChild("ToolModelStorage")
	if ToolModelStorage:FindFirstChild(Name) then
		local Clone = ToolModelStorage:FindFirstChild(Name):Clone()
		return Clone
	end
end


local function BuildBackpack()
	local Points = GetPoints()
	local Tools = GetTools()
	for i,v in ipairs(Tools) do
		local Model = GetToolModelFor(v)
		local Point
		for x,y in ipairs(Points) do
			if string.find(y.Name,v:GetAttribute("Type")) then
				Point = y
			end
		end
		Model.Parent = Backpack:FindFirstChild("Models")
		if Model:IsA("Model") then
			Model:SetPrimaryPartCFrame(Point.CFrame)
		elseif Model:IsA("MeshPart") then
			Model.CFrame = Point.CFrame
			local NewWeld = Instance.new("Weld")
			NewWeld.Part0 = Point
			NewWeld.Part1 = Model
			NewWeld.Parent = Point
		end
	end
end
BuildBackpack()

local function ActionPoints(Activate)
	if Activate == true then
		for i,v in ipairs(Backpack:FindFirstChild("Points"):GetChildren()) do
			if v:FindFirstChildWhichIsA("BillboardGui") then
				v:FindFirstChildWhichIsA("BillboardGui").Enabled = true
				v.ClickDetector.MaxActivationDistance = 30
			end
		end
	elseif Activate == false then
		for i,v in ipairs(Backpack:FindFirstChild("Points"):GetChildren()) do
			if v:FindFirstChildWhichIsA("BillboardGui") then
				v:FindFirstChildWhichIsA("BillboardGui").Enabled = false
				v.ClickDetector.MaxActivationDistance = 0
			end
		end
	end
end

local function AnimateButtons()
	for i,v in ipairs(Backpack:FindFirstChild("Points"):GetChildren()) do
		if v:FindFirstChildWhichIsA("BillboardGui") then
			local Button = v.ClickDetector
			local OldSize = Button.Parent:FindFirstChild("BillboardGui"):FindFirstChild("ImageButton").Size
			Button.MouseHoverEnter:Connect(function()
				local NewSize = OldSize + UDim2.new(0.06,0,0.06,0)
				game:GetService("TweenService"):Create(Button.Parent:FindFirstChild("BillboardGui"):FindFirstChild("ImageButton"),TweenInfo.new(0.5),{Size = NewSize}):Play()
			end)
			Button.MouseHoverLeave:Connect(function()
				local NewSize = OldSize
				game:GetService("TweenService"):Create(Button.Parent:FindFirstChild("BillboardGui"):FindFirstChild("ImageButton"),TweenInfo.new(0.5),{Size = NewSize}):Play()
			end)
			Button.MouseClick:Connect(function()
				print("PRESSED")
			end)
		end
	end
end
AnimateButtons()

UIS.InputBegan:Connect(function(Input,gamep)
	if Input.KeyCode == Enum.KeyCode.Q then
		if not gamep then
			local Humanoid = Character:WaitForChild("Humanoid")
			Humanoid.WalkSpeed = 0
			Humanoid.JumpPower = 0
			local CurrentCamera = workspace.CurrentCamera
			CurrentCamera.CameraType = Enum.CameraType.Scriptable
			local TW = game:GetService("TweenService"):Create(CurrentCamera,TweenInfo.new(1),{CFrame = Cam.CFrame})
			TW:Play()
			TW.Completed:Wait()
			ActionPoints(true)
		end
	end
end)