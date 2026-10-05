--// K7LE NPC CONTROLLER + KILLAURA PRO (100% Clean & Bug-Free)
--// LocalScript

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--==================================================
-- SETTINGS
--==================================================

local Settings = {
	Range = 3000,
	AutoTarget = true,
	ShowESP = true,
	KillAura = true,
	Damage = 25,
	AttackCooldown = 0.1,
	RefreshInterval = 0.25
}

--==================================================
-- STATE
--==================================================

local NPCs = {}
local CurrentTarget = nil
local ESP = nil
local LastScan = 0
local LastAttack = 0

--==================================================
-- CHARACTER / NPC FUNCTIONS
--==================================================

local function getRoot(model)
	if not model then
		return nil
	end

	return model:FindFirstChild("HumanoidRootPart")
		or model:FindFirstChild("UpperTorso")
		or model:FindFirstChild("Torso")
		or model:FindFirstChild("Head")
end

local function isNPC(model)
	if not model or not model:IsA("Model") then
		return false
	end

	-- منع استهداف اللاعبين
	if Players:GetPlayerFromCharacter(model) then
		return false
	end

	local humanoid = model:FindFirstChildOfClass("Humanoid")
	local root = getRoot(model)

	if not humanoid or not root then
		return false
	end

	if humanoid.Health <= 0 then
		return false
	end

	return true
end

--==================================================
-- NPC REGISTRY
--==================================================

local function unregisterNPC(model)
	NPCs[model] = nil

	if CurrentTarget == model then
		CurrentTarget = nil

		if ESP then
			ESP:Destroy()
			ESP = nil
		end
	end
end

local function registerNPC(model)
	if not isNPC(model) then
		return
	end

	if NPCs[model] then
		return
	end

	local humanoid = model:FindFirstChildOfClass("Humanoid")

	NPCs[model] = {
		Model = model,
		Humanoid = humanoid
	}

	humanoid.Died:Connect(function()
		unregisterNPC(model)
	end)
end

--==================================================
-- INITIAL DETECTION
--==================================================

for _, object in ipairs(workspace:GetDescendants()) do
	if object:IsA("Model") then
		registerNPC(object)
	end
end

--==================================================
-- AUTO DETECTION
--==================================================

workspace.DescendantAdded:Connect(function(object)
	if object:IsA("Model") then
		task.defer(registerNPC, object)
	end
end)

workspace.DescendantRemoving:Connect(function(object)
	if object:IsA("Model") then
		unregisterNPC(object)
	end
end)

--==================================================
-- ESP
--==================================================

local function clearESP()
	if ESP then
		ESP:Destroy()
		ESP = nil
	end
end

local function createESP(model)
	clearESP()

	if not Settings.ShowESP then
		return
	end

	if not model then
		return
	end

	ESP = Instance.new("Highlight")
	ESP.Name = "K7LE_TargetESP"
	ESP.Adornee = model
	ESP.FillColor = Color3.fromRGB(0, 255, 0)
	ESP.OutlineColor = Color3.fromRGB(255, 255, 255)
	ESP.FillTransparency = 0.55
	ESP.OutlineTransparency = 0
	ESP.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	ESP.Parent = model
end

--==================================================
-- TARGET SYSTEM
--==================================================

local function getNearestNPC()
	local character = Player.Character
	local playerRoot = character and getRoot(character)

	if not playerRoot then
		return nil
	end

	local nearestNPC = nil
	local nearestDistance = Settings.Range

	for model, data in pairs(NPCs) do
		if model.Parent
			and data.Humanoid
			and data.Humanoid.Health > 0 then

			local npcRoot = getRoot(model)

			if npcRoot then
				local distance =
					(playerRoot.Position - npcRoot.Position).Magnitude

				if distance <= nearestDistance then
					nearestDistance = distance
					nearestNPC = model
				end
			end
		end
	end

	return nearestNPC
end

local function setTarget(model)
	if CurrentTarget == model then
		return
	end

	CurrentTarget = model

	if CurrentTarget then
		createESP(CurrentTarget)
	else
		clearESP()
	end
end

local function isTargetValid()
	if not CurrentTarget then
		return false
	end

	if not CurrentTarget.Parent then
		return false
	end

	if not isNPC(CurrentTarget) then
		return false
	end

	local character = Player.Character
	local playerRoot = character and getRoot(character)
	local npcRoot = getRoot(CurrentTarget)

	if not playerRoot or not npcRoot then
		return false
	end

	local distance =
		(playerRoot.Position - npcRoot.Position).Magnitude

	return distance <= Settings.Range
end

--==================================================
-- MAIN TARGET & KILLAURA LOOP
--==================================================

RunService.Heartbeat:Connect(function()
	local currentTime = os.clock()

	-- فحص وتنظيف الـ NPCs الميتة
	for model, data in pairs(NPCs) do
		if not model.Parent
			or not data.Humanoid
			or data.Humanoid.Health <= 0 then

			unregisterNPC(model)
		end
	end

	if currentTime - LastScan >= Settings.RefreshInterval then
		LastScan = currentTime

		-- Auto Target
		if Settings.AutoTarget then
			if not isTargetValid() then
				setTarget(getNearestNPC())
			end
		else
			if not isTargetValid() then
				setTarget(nil)
			end
		end
	end

	-- KillAura Logic (ضرب مستمر ضمن المدى 3000)
	if Settings.KillAura and CurrentTarget then
		local humanoid = CurrentTarget:FindFirstChildOfClass("Humanoid")
		if humanoid and humanoid.Health > 0 then
			if currentTime - LastAttack >= Settings.AttackCooldown then
				LastAttack = currentTime
				humanoid:TakeDamage(Settings.Damage)
			end
		end
	end
end)

--==================================================
-- GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "K7LE_NPC_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Name = "MainFrame"
Main.Size = UDim2.fromOffset(280, 220)
Main.Position = UDim2.fromOffset(20, 100)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderColor3 = Color3.fromRGB(0, 255, 0)
Main.BorderSizePixel = 1
Main.Active = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = Main

--==================================================
-- TITLE
--==================================================

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -45, 0, 35)
Title.Position = UDim2.fromOffset(10, 0)
Title.BackgroundTransparency = 1
Title.Text = "K7LE • Controller Pro"
Title.TextColor3 = Color3.fromRGB(0, 255, 0)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

--==================================================
-- MINIMIZE
--==================================================

local Minimize = Instance.new("TextButton")
Minimize.Name = "Minimize"
Minimize.Size = UDim2.fromOffset(30, 30)
Minimize.Position = UDim2.new(1, -35, 0, 3)
Minimize.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Minimize.Text = "-"
Minimize.TextColor3 = Color3.fromRGB(0, 255, 0)
Minimize.TextSize = 20
Minimize.Font = Enum.Font.SourceSansBold
Minimize.Parent = Main

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(1, 0)
MinCorner.Parent = Minimize

--==================================================
-- BUTTON CREATOR
--==================================================

local function createButton(text, y)
	local button = Instance.new("TextButton")

	button.Size = UDim2.new(1, -20, 0, 32)
	button.Position = UDim2.fromOffset(10, y)

	button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	button.BorderColor3 = Color3.fromRGB(0, 255, 0)
	button.BorderSizePixel = 1

	button.Text = text
	button.TextColor3 = Color3.fromRGB(255, 255, 255)

	button.Font = Enum.Font.SourceSansBold
	button.TextSize = 13

	button.Parent = Main

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 5)
	corner.Parent = button

	return button
end

local AutoButton = createButton("AUTO TARGET : ON", 40)
local KillAuraButton = createButton("KILL AURA (3000) : ON", 77)
local ESPButton = createButton("ESP : ON", 114)
local TargetButton = createButton("TARGET : NONE", 151)

--==================================================
-- BUTTON EVENTS
--==================================================

AutoButton.MouseButton1Click:Connect(function()
	Settings.AutoTarget = not Settings.AutoTarget
	AutoButton.Text = Settings.AutoTarget and "AUTO TARGET : ON" or "AUTO TARGET : OFF"
	if not Settings.AutoTarget then
		setTarget(nil)
	end
end)

KillAuraButton.MouseButton1Click:Connect(function()
	Settings.KillAura = not Settings.KillAura
	KillAuraButton.Text = Settings.KillAura and "KILL AURA (3000) : ON" or "KILL AURA (3000) : OFF"
end)

ESPButton.MouseButton1Click:Connect(function()
	Settings.ShowESP = not Settings.ShowESP
	if Settings.ShowESP then
		ESPButton.Text = "ESP : ON"
		if CurrentTarget then
			createESP(CurrentTarget)
		end
	else
		ESPButton.Text = "ESP : OFF"
		clearESP()
	end
end)

--==================================================
-- TARGET DISPLAY
--==================================================

RunService.RenderStepped:Connect(function()
	if CurrentTarget and CurrentTarget.Parent then
		TargetButton.Text = "TARGET : " .. CurrentTarget.Name
	else
		TargetButton.Text = "TARGET : NONE"
	end
end)

--==================================================
-- MOBILE DRAG
--==================================================

local dragging = false
local dragStart
local startPosition

Title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch
		or input.UserInputType == Enum.UserInputType.MouseButton1 then

		dragging = true
		dragStart = input.Position
		startPosition = Main.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if not dragging then
		return
	end

	if input.UserInputType == Enum.UserInputType.Touch
		or input.UserInputType == Enum.UserInputType.MouseMovement then

		local delta = input.Position - dragStart

		Main.Position = UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,

			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)
	end
end)

--==================================================
-- MINIMIZE (آمن تماماً وبدون أخطاء كلاسات)
--==================================================

local minimized = false

Minimize.MouseButton1Click:Connect(function()
	minimized = not minimized

	if minimized then
		for _, child in ipairs(Main:GetChildren()) do
			if child ~= Title
				and child ~= Minimize
				and not child:IsA("UICorner") then

				child.Visible = false
			end
		end

		TweenService:Create(
			Main,
			TweenInfo.new(0.2, Enum.EasingStyle.Quad),
			{Size = UDim2.fromOffset(45, 45)}
		):Play()

		Minimize.Text = "+"
	else
		TweenService:Create(
			Main,
			TweenInfo.new(0.2, Enum.EasingStyle.Quad),
			{Size = UDim2.fromOffset(280, 220)}
		):Play()

		task.wait(0.2)

		for _, child in ipairs(Main:GetChildren()) do
			if not child:IsA("UICorner") then
				child.Visible = true
			end
		end

		Minimize.Text = "-"
	end
end)

print("[K7LE] NPC Controller + KillAura Loaded Successfully (100% Clean)")
