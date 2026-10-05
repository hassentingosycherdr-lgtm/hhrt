--// K7LE NPC CONTROLLER + KILLAURA PRO (Advanced & Clean UI)
--// Updated: Egg-focused ESP with inner entity names + Automated KillAura

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- واجهة المستخدم الاحترافية (Modern UI)
local ScreenGui = script:FindFirstAncestorOfClass("ScreenGui") or Instance.new("ScreenGui", LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "K7LE_Advanced_Gui"

local Main = script.Parent and script.Parent.Parent or Instance.new("Frame", ScreenGui)
Main.Size = UDim2.fromOffset(300, 260)
Main.Position = UDim2.new(0.5, -150, 0.5, -130)
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
Title.Text = "K7LE PRO CONTROLLER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
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

-- زر عرض الهدف (Target Display)
local TargetButton = Instance.new("TextLabel", Main)
TargetButton.Size = UDim2.new(1, -30, 0, 36)
TargetButton.Position = UDim2.new(0, 15, 0, 55)
TargetButton.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
TargetButton.Text = "TARGET : NONE"
TargetButton.TextColor3 = Color3.fromRGB(180, 180, 200)
TargetButton.TextSize = 12
TargetButton.Font = Enum.Font.GothamSemibold

local UICornerT = Instance.new("UICorner", TargetButton)
UICornerT.CornerRadius = UDim.new(0, 8)

-- زر الـ ESP (خاص بالبيض واسم الكائن فقط)
local ESPButton = Instance.new("TextButton", Main)
ESPButton.Size = UDim2.new(1, -30, 0, 42)
ESPButton.Position = UDim2.new(0, 15, 0, 105)
ESPButton.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
ESPButton.Text = "ESP EGG : OFF"
ESPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPButton.TextSize = 13
ESPButton.Font = Enum.Font.GothamBold

local UICornerESP = Instance.new("UICorner", ESPButton)
UICornerESP.CornerRadius = UDim.new(0, 8)

-- زر الـ KillAura (لضرب الأعداء و الـ NPCs تلقائياً)
local KillAuraButton = Instance.new("TextButton", Main)
KillAuraButton.Size = UDim2.new(1, -30, 0, 42)
KillAuraButton.Position = UDim2.new(0, 15, 0, 157)
KillAuraButton.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
KillAuraButton.Text = "KILLAURA : OFF"
KillAuraButton.TextColor3 = Color3.fromRGB(255, 255, 255)
KillAuraButton.TextSize = 13
KillAuraButton.Font = Enum.Font.GothamBold

local UICornerKA = Instance.new("UICorner", KillAuraButton)
UICornerKA.CornerRadius = UDim.new(0, 8)

-- المتغيرات الأساسية
local CurrentTarget = nil
local ESPEnabled = false
local KillAuraEnabled = false
local ActiveESPElements = {}
local KillRange = 25 -- مدى الهجوم التلقائي (بالأمتار)

--==================================================
-- EGG ESP SYSTEM (إخفاء البوسات/الأعشاش وإظهار البيض مع اسم الكائن)
--==================================================

local function clearESP()
	for _, espObj in pairs(ActiveESPElements) do
		if espObj then
			espObj:Destroy()
		end
	end
	ActiveESPElements = {}
end

local function createEggESP(targetPart, creatureName)
	if not targetPart or not targetPart:IsA("BasePart") then return end

	local bill = Instance.new("BillboardGui")
	bill.Name = "K7LE_Egg_Tag"
	bill.Adornee = targetPart
	bill.Size = UDim2.new(0, 140, 0, 50)
	bill.StudsOffset = Vector3.new(0, 3.5, 0)
	bill.AlwaysOnTop = true

	local label = Instance.new("TextLabel", bill)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = "🥚 [Egg]\n" .. creatureName
	label.TextColor3 = Color3.fromRGB(255, 220, 50) -- لون أصفر ذهبي للبيضة
	label.TextStrokeTransparency = 0.3
	label.TextSize = 13
	label.Font = Enum.Font.GothamBold

	-- إطار توضيحي للبيضة
	local highlight = Instance.new("Highlight")
	highlight.Adornee = targetPart.Parent:IsA("Model") and targetPart.Parent or targetPart
	highlight.FillColor = Color3.fromRGB(255, 200, 0)
	highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
	highlight.FillTransparency = 0.5
	highlight.Parent = bill

	bill.Parent = ScreenGui
	table.insert(ActiveESPElements, bill)
end

local function refreshWorldESP()
	clearESP()
	if not ESPEnabled then return end

	-- البحث في الـ Workspace فقط عن البيض وفتحات البيض واستخلاص اسم الكائن
	for _, obj in ipairs(Workspace:GetDescendants()) do
		local nameLower = obj.Name:lower()

		if nameLower:find("egg") or nameLower:find("slot") or nameLower:find("areaeggslotsclient") then
			if obj:IsA("BasePart") or obj:IsA("Model") then
				local primaryPart = obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) or obj
				
				if primaryPart then
					-- استخراج اسم الكائن المرتبط من اسم العنصر أو الأب (تصفية وتنظيف الاسم)
					local creatureName = obj.Name
					creatureName = creatureName:gsub("Egg", ""):gsub("Slot", ""):gsub("Area", ""):gsub("Client", ""):gsub("_", " ")
					if creatureName == "" or creatureName == " " then
						creatureName = "Unknown Creature"
					end

					createEggESP(primaryPart, creatureName)
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

--==================================================
-- KILLAURA SYSTEM (ضرب أي لاعب أو NPC قريب تلقائياً)
--==================================================

KillAuraButton.MouseButton1Click:Connect(function()
	KillAuraEnabled = not KillAuraEnabled
	if KillAuraEnabled then
		KillAuraButton.Text = "KILLAURA : ON"
		KillAuraButton.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
	else
		KillAuraButton.Text = "KILLAURA : OFF"
		KillAuraButton.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
		CurrentTarget = nil
	end
end)

RunService.RenderStepped:Connect(function()
	local char = LocalPlayer.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	local myRoot = char.HumanoidRootPart

	if KillAuraEnabled then
		local closestTarget = nil
		local shortestDistance = KillRange

		-- البحث عن الأهداف (لاعبين آخرين أو NPCs في العالم)
		for _, target in ipairs(Workspace:GetDescendants()) do
			-- التحقق من كون الهدف شخصية أو NPC قابل للضرب
			if target:IsA("Model") and target ~= char then
				local humanoid = target:FindFirstChildOfClass("Humanoid")
				local rootPart = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChild("Head")

				-- استبعاد اللاعبين الحلفاء إذا وجدوا أو التأكد أنه عدو/NPC
				local isPlayer = Players:GetPlayerFromCharacter(target)
				
				if humanoid and humanoid.Health > 0 and rootPart then
					-- إذا لم يكن لاعباً (يعني NPC) أو كان لاعباً مختلفاً
					if not isPlayer or isPlayer ~= LocalPlayer then
						local dist = (myRoot.Position - rootPart.Position).Magnitude
						if dist < shortestDistance then
							shortestDistance = dist
							closestTarget = rootPart
							CurrentTarget = target
						end
					end
				end
			end
		end

		if closestTarget then
			-- محاكاة الهجوم التلقائي أو تفعيل أداة القتال المتوفرة في يد اللاعب
			local tool = char:FindFirstChildOfClass("Tool")
			if tool then
				pcall(function()
					tool:Activate()
				end)
			end
		else
			CurrentTarget = nil
		end
	end

	-- تحديث عرض الهدف الحالي على الواجهة
	if CurrentTarget and CurrentTarget.Parent then
		TargetButton.Text = "TARGET : " .. CurrentTarget.Name
		TargetButton.TextColor3 = Color3.fromRGB(0, 255, 150)
	else
		TargetButton.Text = "TARGET : NONE"
		TargetButton.TextColor3 = Color3.fromRGB(180, 180, 200)
	end
end)

--==================================================
-- MOBILE DRAG (تحريك النافذة بسلاسة للهواتف)
--==================================================

local dragging = false
local dragStart
local startPosition

TitleBar.InputBegan:Connect(function(input)
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
	if not dragging then return end

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
-- MINIMIZE SYSTEM (تصغير وتكبير الواجهة)
--==================================================

local minimized = false

Minimize.MouseButton1Click:Connect(function()
	minimized = not minimized

	if minimized then
		for _, child in ipairs(Main:GetChildren()) do
			if child ~= TitleBar and not child:IsA("UICorner") then
				child.Visible = false
			end
		end

		TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.fromOffset(300, 40)}):Play()
		Minimize.Text = "+"
	else
		TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.fromOffset(300, 260)}):Play()
		task.wait(0.2)
		for _, child in ipairs(Main:GetChildren()) do
			if not child:IsA("UICorner") then
				child.Visible = true
			end
		end
		Minimize.Text = "-"
	end
end)

print("[K7LE] Ultimate Controller + Clean Egg ESP + Auto KillAura Loaded Successfully!")
