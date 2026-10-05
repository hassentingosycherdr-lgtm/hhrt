--// K7LE NPC CONTROLLER + AUTO WALK EGG + KILLAURA + AUTO DR. SCRAMBLE FIGHT

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- واجهة المستخدم الأساسية
local ScreenGui = script:FindFirstAncestorOfClass("ScreenGui") or Instance.new("ScreenGui", LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "K7LE_Advanced_Gui"

local Main = script.Parent and script.Parent.Parent or Instance.new("Frame", ScreenGui)
Main.Size = UDim2.fromOffset(300, 360)
Main.Position = UDim2.new(0.5, -150, 0.5, -180)
Main.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
Main.BorderSizePixel = 0
Main.Active = true

local UICornerMain = Instance.new("UICorner", Main)
UICornerMain.CornerRadius = UDim.new(0, 12)

-- شريط العنوان العلوي
local TitleBar = Instance.new("Frame", Main)
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
TitleBar.BorderSizePixel = 0

local UICornerTitle = Instance.new("UICorner", TitleBar)
UICornerTitle.CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "K7LE PRO BOSS CONTROLLER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

local Minimize = Instance.new("TextButton", TitleBar)
Minimize.Size = UDim2.fromOffset(30, 30)
Minimize.Position = UDim2.new(1, -35, 0, 5)
Minimize.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
Minimize.Text = "-"
Minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
Minimize.TextSize = 16
Minimize.Font = Enum.Font.GothamBold

local UICornerMin = Instance.new("UICorner", Minimize)
UICornerMin.CornerRadius = UDim.new(0, 8)

-- زر عرض الهدف الحالي
local TargetButton = Instance.new("TextLabel", Main)
TargetButton.Size = UDim2.new(1, -30, 0, 30)
TargetButton.Position = UDim2.new(0, 15, 0, 48)
TargetButton.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
TargetButton.Text = "TARGET : NONE"
TargetButton.TextColor3 = Color3.fromRGB(180, 180, 200)
TargetButton.TextSize = 11
TargetButton.Font = Enum.Font.GothamSemibold

local UICornerT = Instance.new("UICorner", TargetButton)
UICornerT.CornerRadius = UDim.new(0, 8)

-- زر الـ ESP للبيض
local ESPButton = Instance.new("TextButton", Main)
ESPButton.Size = UDim2.new(1, -30, 0, 34)
ESPButton.Position = UDim2.new(0, 15, 0, 85)
ESPButton.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
ESPButton.Text = "ESP EGG : OFF"
ESPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPButton.TextSize = 12
ESPButton.Font = Enum.Font.GothamBold

local UICornerESP = Instance.new("UICorner", ESPButton)
UICornerESP.CornerRadius = UDim.new(0, 8)

-- زر قائمة البيض للمشي التلقائي
local MenuButton = Instance.new("TextButton", Main)
MenuButton.Size = UDim2.new(1, -30, 0, 34)
MenuButton.Position = UDim2.new(0, 15, 0, 125)
MenuButton.BackgroundColor3 = Color3.fromRGB(60, 45, 85)
MenuButton.Text = "📋 قائمة البيض (المشي التلقائي)"
MenuButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MenuButton.TextSize = 12
MenuButton.Font = Enum.Font.GothamBold

local UICornerMenu = Instance.new("UICorner", MenuButton)
UICornerMenu.CornerRadius = UDim.new(0, 8)

-- زر الـ KillAura العام
local KillAuraButton = Instance.new("TextButton", Main)
KillAuraButton.Size = UDim2.new(1, -30, 0, 34)
KillAuraButton.Position = UDim2.new(0, 15, 0, 165)
KillAuraButton.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
KillAuraButton.Text = "KILLAURA : OFF"
KillAuraButton.TextColor3 = Color3.fromRGB(255, 255, 255)
KillAuraButton.TextSize = 12
KillAuraButton.Font = Enum.Font.GothamBold

local UICornerKA = Instance.new("UICorner", KillAuraButton)
UICornerKA.CornerRadius = UDim.new(0, 8)

-- زر قتال دكتور سكرمبل تلقائياً (Auto Dr. Scramble)
local ScrambleButton = Instance.new("TextButton", Main)
ScrambleButton.Size = UDim2.new(1, -30, 0, 34)
ScrambleButton.Position = UDim2.new(0, 15, 0, 205)
ScrambleButton.BackgroundColor3 = Color3.fromRGB(85, 45, 45)
ScrambleButton.Text = "DR. SCRAMBLE FIGHT : OFF"
ScrambleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ScrambleButton.TextSize = 12
ScrambleButton.Font = Enum.Font.GothamBold

local UICornerScr = Instance.new("UICorner", ScrambleButton)
UICornerScr.CornerRadius = UDim.new(0, 8)

-- حالة المشي التلقائي
local AutoWalkStatus = Instance.new("TextLabel", Main)
AutoWalkStatus.Size = UDim2.new(1, -30, 0, 30)
AutoWalkStatus.Position = UDim2.new(0, 15, 0, 245)
AutoWalkStatus.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
AutoWalkStatus.Text = "الحالة: واقف مكانه"
AutoWalkStatus.TextColor3 = Color3.fromRGB(200, 200, 200)
AutoWalkStatus.TextSize = 11
AutoWalkStatus.Font = Enum.Font.Gotham

local UICornerAS = Instance.new("UICorner", AutoWalkStatus)
UICornerAS.CornerRadius = UDim.new(0, 8)

-- إطار القائمة المنسدلة للبيض
local DropdownFrame = Instance.new("ScrollingFrame", Main)
DropdownFrame.Size = UDim2.new(1, -30, 0, 110)
DropdownFrame.Position = UDim2.new(0, 15, 0, 162)
DropdownFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
DropdownFrame.BorderSizePixel = 0
DropdownFrame.Visible = false
DropdownFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
DropdownFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

local UICornerDF = Instance.new("UICorner", DropdownFrame)
UICornerDF.CornerRadius = UDim.new(0, 8)

local UIListLayout = Instance.new("UIListLayout", DropdownFrame)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 4)

-- المتغيرات
local CurrentTarget = nil
local ESPEnabled = false
local KillAuraEnabled = false
local ScrambleFightEnabled = false
local ActiveESPElements = {}
local KillRange = 35
local isWalkingToEgg = false
local originalPosition = nil

-- وظيفة المشي للبيضة والرجوع
local function walkToTargetAndBack(targetPart)
	if isWalkingToEgg or not targetPart or not targetPart.Parent then return end
	local char = LocalPlayer.Character
	local humanoid = char and char:FindFirstChildOfClass("Humanoid")
	local rootPart = char and char:FindFirstChild("HumanoidRootPart")

	if not humanoid or not rootPart then return end

	isWalkingToEgg = true
	originalPosition = rootPart.Position
	AutoWalkStatus.Text = "الحالة: ماشي باتجاه البيضة..."
	AutoWalkStatus.TextColor3 = Color3.fromRGB(255, 200, 0)

	humanoid:MoveTo(targetPart.Position)
	
	local startTime = tick()
	repeat
		task.wait(0.2)
		if (rootPart.Position - targetPart.Position).Magnitude < 6 then
			break
		end
	until not targetPart.Parent or (tick() - startTime) > 10

	AutoWalkStatus.Text = "الحالة: تم الوصول! جاري الرجوع..."
	task.wait(0.5)

	if originalPosition then
		humanoid:MoveTo(originalPosition)
		local returnStart = tick()
		repeat
			task.wait(0.2)
			if (rootPart.Position - originalPosition).Magnitude < 5 then
				break
			end
		until (tick() - returnStart) > 10
	end

	AutoWalkStatus.Text = "الحالة: تم العودة بنجاح ✅"
	AutoWalkStatus.TextColor3 = Color3.fromRGB(0, 255, 150)
	isWalkingToEgg = false
end

-- تعبئة القائمة بالبيض
local function populateEggDropdown()
	for _, child in ipairs(DropdownFrame:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end

	for _, obj in ipairs(Workspace:GetDescendants()) do
		local fullName = obj.Name
		local nameLower = fullName:lower()

		if not nameLower:find("treadmill") and not nameLower:find("machine") and not nameLower:find("fuse") and not nameLower:find("player") then
			if nameLower:find("egg") or nameLower:find("slot") or nameLower:find("areaeggslotsclient") then
				if obj:IsA("BasePart") or obj:IsA("Model") then
					local primaryPart = obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) or obj
					
					if primaryPart then
						local creatureName = fullName
						creatureName = creatureName:gsub("Modelsforegg", ""):gsub("Model", ""):gsub("Egg", ""):gsub("Slot", ""):gsub("Area", ""):gsub("Client", ""):gsub("_", " "):gsub("%.", "")
						creatureName = creatureName:match("^%s*(.-)%s*$")
						if creatureName == "" or #creatureName < 2 then creatureName = "Boss Egg" end

						local eggBtn = Instance.new("TextButton", DropdownFrame)
						eggBtn.Size = UDim2.new(1, -10, 0, 28)
						eggBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
						eggBtn.Text = "🥚 " .. creatureName
						eggBtn.TextColor3 = Color3.fromRGB(255, 220, 50)
						eggBtn.TextSize = 11
						eggBtn.Font = Enum.Font.GothamBold

						local btnCorner = Instance.new("UICorner", eggBtn)
						btnCorner.CornerRadius = UDim.new(0, 6)

						eggBtn.MouseButton1Click:Connect(function()
							DropdownFrame.Visible = false
							walkToTargetAndBack(primaryPart)
						end)
					end
				end
			end
		end
	end
end

MenuButton.MouseButton1Click:Connect(function()
	DropdownFrame.Visible = not DropdownFrame.Visible
	if DropdownFrame.Visible then populateEggDropdown() end
end)

--==================================================
-- ESP EGG SYSTEM
--==================================================

local function clearESP()
	for _, data in pairs(ActiveESPElements) do
		if data and data.Gui then data.Gui:Destroy() end
	end
	ActiveESPElements = {}
end

local function createEggESP(targetPart, creatureName)
	if not targetPart or not targetPart:IsA("BasePart") then return end

	local bill = Instance.new("BillboardGui")
	bill.Name = "K7LE_CleanEgg_Tag"
	bill.Adornee = targetPart
	bill.Size = UDim2.new(0, 150, 0, 50)
	bill.StudsOffset = Vector3.new(0, 3.5, 0)
	bill.AlwaysOnTop = true

	local label = Instance.new("TextLabel", bill)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = "🥚 [" .. creatureName .. "]\n[ 0m ]"
	label.TextColor3 = Color3.fromRGB(255, 220, 50)
	label.TextStrokeTransparency = 0.3
	label.TextSize = 12
	label.Font = Enum.Font.GothamBold

	local highlight = Instance.new("Highlight")
	highlight.Adornee = targetPart.Parent:IsA("Model") and targetPart.Parent or targetPart
	highlight.FillColor = Color3.fromRGB(255, 200, 0)
	highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
	highlight.FillTransparency = 0.5
	highlight.Parent = bill

	bill.Parent = ScreenGui
	table.insert(ActiveESPElements, {Gui = bill, Part = targetPart, Label = label})
end

local function refreshWorldESP()
	clearESP()
	if not ESPEnabled then return end

	for _, obj in ipairs(Workspace:GetDescendants()) do
		local fullName = obj.Name
		local nameLower = fullName:lower()

		if not nameLower:find("treadmill") and not nameLower:find("machine") and not nameLower:find("fuse") and not nameLower:find("player") then
			if nameLower:find("egg") or nameLower:find("slot") or nameLower:find("areaeggslotsclient") then
				if obj:IsA("BasePart") or obj:IsA("Model") then
					local primaryPart = obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) or obj
					
					if primaryPart then
						local creatureName = fullName
						creatureName = creatureName:gsub("Modelsforegg", ""):gsub("Model", ""):gsub("Egg", ""):gsub("Slot", ""):gsub("Area", ""):gsub("Client", ""):gsub("_", " "):gsub("%.", "")
						creatureName = creatureName:match("^%s*(.-)%s*$")
						if creatureName == "" or #creatureName < 2 then creatureName = "Boss Egg" end

						createEggESP(primaryPart, creatureName)
					end
				end
			end
		end
	end
end

ESPButton.MouseButton1Click:Connect(function()
	ESPEnabled = not ESPEnabled
	if ESPEnabled then
		ESPButton.Text = "ESP EGG : ON"
		ESPButton.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
		refreshWorldESP()
	else
		ESPButton.Text = "ESP EGG : OFF"
		ESPButton.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
		clearESP()
	end
end)

RunService.RenderStepped:Connect(function()
	local char = LocalPlayer.Character
	local myRoot = char and char:FindFirstChild("HumanoidRootPart")

	if ESPEnabled and myRoot then
		for _, data in ipairs(ActiveESPElements) do
			if data.Part and data.Part.Parent and data.Label then
				local dist = math.floor((myRoot.Position - data.Part.Position).Magnitude)
				local currentText = data.Label.Text:match("^(.-)\n") or "🥚 [Egg]"
				data.Label.Text = currentText .. "\n[ " .. dist .. "m ]"
			end
		end
	end
end)

--==================================================
-- KILLAURA & AUTO DR. SCRAMBLE FIGHT SYSTEM
--==================================================

KillAuraButton.MouseButton1Click:Connect(function()
	KillAuraEnabled = not KillAuraEnabled
	if KillAuraEnabled then
		KillAuraButton.Text = "KILLAURA : ON"
		KillAuraButton.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
	else
		KillAuraButton.Text = "KILLAURA : OFF"
		KillAuraButton.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
	end
end)

ScrambleButton.MouseButton1Click:Connect(function()
	ScrambleFightEnabled = not ScrambleFightEnabled
	if ScrambleFightEnabled then
		ScrambleButton.Text = "DR. SCRAMBLE : ON"
		ScrambleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
	else
		ScrambleButton.Text = "DR. SCRAMBLE : OFF"
		ScrambleButton.BackgroundColor3 = Color3.fromRGB(85, 45, 45)
	end
end)

RunService.RenderStepped:Connect(function()
	local char = LocalPlayer.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	local myRoot = char.HumanoidRootPart

	local targetToAttack = nil
	local shortestDistance = KillRange

	-- فحص القتال التلقائي (البحث عن دكتور سكرمبل أولاً إذا كان مفعل وموجود)
	for _, target in ipairs(Workspace:GetDescendants()) do
		if target:IsA("Model") and target ~= char then
			local nameLower = target.Name:lower()
			local humanoid = target:FindFirstChildOfClass("Humanoid")
			local rootPart = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChild("Head")

			if humanoid and humanoid.Health > 0 and rootPart then
				-- إذا كانت ميزة دكتور سكرمبل مفعلة والهدف هو دكتور سكرمبل
				if ScrambleFightEnabled and (nameLower:find("scramble") or nameLower:find("doctor")) then
					targetToAttack = rootPart
					CurrentTarget = target
					break
				elseif KillAuraEnabled then
					-- القتال العام (لاعبين أو NPCs)
					local isPlayer = Players:GetPlayerFromCharacter(target)
					if not isPlayer or isPlayer ~= LocalPlayer then
						local dist = (myRoot.Position - rootPart.Position).Magnitude
						if dist < shortestDistance then
							shortestDistance = dist
							targetToAttack = rootPart
							CurrentTarget = target
						end
					end
				end
			end
		end
	end

	if targetToAttack then
		local tool = char:FindFirstChildOfClass("Tool")
		if tool then
			pcall(function() tool:Activate() end)
		end
	else
		CurrentTarget = nil
	end

	if CurrentTarget and CurrentTarget.Parent then
		TargetButton.Text = "TARGET : " .. CurrentTarget.Name
		TargetButton.TextColor3 = Color3.fromRGB(0, 255, 150)
	else
		TargetButton.Text = "TARGET : NONE"
		TargetButton.TextColor3 = Color3.fromRGB(180, 180, 200)
	end
end)

--==================================================
-- DRAG & MINIMIZE
--==================================================

local dragging, dragStart, startPosition = false, nil, nil
TitleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPosition = Main.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if not dragging then return end
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		Main.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
	end
end)

local minimized = false
Minimize.MouseButton1Click:Connect(function()
	minimized = not minimized
	if minimized then
		for _, child in ipairs(Main:GetChildren()) do
			if child ~= TitleBar and not child:IsA("UICorner") then child.Visible = false end
		end
		DropdownFrame.Visible = false
		TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.fromOffset(300, 40)}):Play()
		Minimize.Text = "+"
	else
		TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.fromOffset(300, 360)}):Play()
		task.wait(0.2)
		for _, child in ipairs(Main:GetChildren()) do
			if not child:IsA("UICorner") then child.Visible = true end
		end
		Minimize.Text = "-"
	end
end)

print("[K7LE] Dr. Scramble Auto Fight & Controller Loaded Successfully!")
