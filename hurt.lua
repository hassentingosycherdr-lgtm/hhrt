--// K7LE PRO ULTIMATE EXECUTOR SCRIPT - STABLE & CLEAN
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- تنظيف النسخة القديمة إن وجدت لمنع التكرار
pcall(function()
	if CoreGui:FindFirstChild("K7LE_Advanced_Gui") then
		CoreGui.K7LE_Advanced_Gui:Destroy()
	end
	if LocalPlayer.PlayerGui:FindFirstChild("K7LE_Advanced_Gui") then
		LocalPlayer.PlayerGui.K7LE_Advanced_Gui:Destroy()
	end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "K7LE_Advanced_Gui"
ScreenGui.ResetOnSpawn = false
pcall(function()
	ScreenGui.Parent = CoreGui
end)
if not ScreenGui.Parent then
	ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

--==================================================
-- 🎬 واجهة البداية (INTRO SCREEN)
--==================================================
local IntroFrame = Instance.new("Frame", ScreenGui)
IntroFrame.Size = UDim2.new(1, 0, 1, 0)
IntroFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
IntroFrame.BorderSizePixel = 0
IntroFrame.ZIndex = 10

local IntroTitle = Instance.new("TextLabel", IntroFrame)
IntroTitle.Size = UDim2.new(1, 0, 0, 60)
IntroTitle.Position = UDim2.new(0, 0, 0.45, -40)
IntroTitle.BackgroundTransparency = 1
IntroTitle.Text = "K7LE"
IntroTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
IntroTitle.TextSize = 42
IntroTitle.Font = Enum.Font.GothamBlack
IntroTitle.TextTransparency = 1
IntroTitle.ZIndex = 11

local IntroSub = Instance.new("TextLabel", IntroFrame)
IntroSub.Size = UDim2.new(1, 0, 0, 30)
IntroSub.Position = UDim2.new(0, 0, 0.45, 20)
IntroSub.BackgroundTransparency = 1
IntroSub.Text = "k7le-script.com"
IntroSub.TextColor3 = Color3.fromRGB(150, 100, 255)
IntroSub.TextSize = 14
IntroSub.Font = Enum.Font.GothamBold
IntroSub.TextTransparency = 1
IntroSub.ZIndex = 11

task.spawn(function()
	TweenService:Create(IntroTitle, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {TextTransparency = 0}):Play()
	TweenService:Create(IntroSub, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {TextTransparency = 0}):Play()
	TweenService:Create(IntroTitle, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {TextSize = 46}):Play()
	
	task.wait(2)
	
	TweenService:Create(IntroTitle, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {TextTransparency = 1}):Play()
	TweenService:Create(IntroSub, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {TextTransparency = 1}):Play()
	local fadeOut = TweenService:Create(IntroFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {BackgroundTransparency = 1})
	fadeOut:Play()
	fadeOut.Completed:Connect(function()
		IntroFrame:Destroy()
	end)
end)

--==================================================
-- 🖥️ الواجهة الرئيسية (MAIN UI)
--==================================================
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.fromOffset(320, 420)
Main.Position = UDim2.new(0.5, -160, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
Main.BorderSizePixel = 0
Main.Active = true

local UICornerMain = Instance.new("UICorner", Main)
UICornerMain.CornerRadius = UDim.new(0, 14)

local UIStrokeMain = Instance.new("UIStroke", Main)
UIStrokeMain.Color = Color3.fromRGB(60, 60, 90)
UIStrokeMain.Thickness = 1.5

-- شريط العنوان العلوي
local TitleBar = Instance.new("Frame", Main)
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TitleBar.BorderSizePixel = 0

local UICornerTitle = Instance.new("UICorner", TitleBar)
UICornerTitle.CornerRadius = UDim.new(0, 14)

local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ K7LE PRO SYSTEM"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

local Minimize = Instance.new("TextButton", TitleBar)
Minimize.Size = UDim2.fromOffset(32, 32)
Minimize.Position = UDim2.new(1, -40, 0, 6.5)
Minimize.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
Minimize.Text = "-"
Minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
Minimize.TextSize = 16
Minimize.Font = Enum.Font.GothamBold

local UICornerMin = Instance.new("UICorner", Minimize)
UICornerMin.CornerRadius = UDim.new(0, 8)

-- هدف الكيل أورا الحالي
local TargetButton = Instance.new("TextLabel", Main)
TargetButton.Size = UDim2.new(1, -30, 0, 32)
TargetButton.Position = UDim2.new(0, 15, 0, 55)
TargetButton.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TargetButton.Text = "TARGET : NONE"
TargetButton.TextColor3 = Color3.fromRGB(150, 150, 180)
TargetButton.TextSize = 11
TargetButton.Font = Enum.Font.GothamSemibold

local UICornerT = Instance.new("UICorner", TargetButton)
UICornerT.CornerRadius = UDim.new(0, 8)

-- زر قائمة البيض النادر (Secret, Eternal, Divine)
local MenuButton = Instance.new("TextButton", Main)
MenuButton.Size = UDim2.new(1, -30, 0, 40)
MenuButton.Position = UDim2.new(0, 15, 0, 97)
MenuButton.BackgroundColor3 = Color3.fromRGB(75, 45, 110)
MenuButton.Text = "✨ قائمة البيض النادر والمسافات"
MenuButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MenuButton.TextSize = 12
MenuButton.Font = Enum.Font.GothamBold

local UICornerMenu = Instance.new("UICorner", MenuButton)
UICornerMenu.CornerRadius = UDim.new(0, 8)

-- زر التيلبرورت الفوري للسيف زون
local SafeZoneButton = Instance.new("TextButton", Main)
SafeZoneButton.Size = UDim2.new(1, -30, 0, 38)
SafeZoneButton.Position = UDim2.new(0, 15, 0, 145)
SafeZoneButton.BackgroundColor3 = Color3.fromRGB(30, 90, 70)
SafeZoneButton.Text = "🛡️ تيلبرورت إلى Safe Zone"
SafeZoneButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SafeZoneButton.TextSize = 12
SafeZoneButton.Font = Enum.Font.GothamBold

local UICornerSZ = Instance.new("UICorner", SafeZoneButton)
UICornerSZ.CornerRadius = UDim.new(0, 8)

-- زر الـ KillAura
local KillAuraButton = Instance.new("TextButton", Main)
KillAuraButton.Size = UDim2.new(1, -30, 0, 38)
KillAuraButton.Position = UDim2.new(0, 15, 0, 191)
KillAuraButton.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
KillAuraButton.Text = "KILLAURA : OFF"
KillAuraButton.TextColor3 = Color3.fromRGB(255, 255, 255)
KillAuraButton.TextSize = 12
KillAuraButton.Font = Enum.Font.GothamBold

local UICornerKA = Instance.new("UICorner", KillAuraButton)
UICornerKA.CornerRadius = UDim.new(0, 8)

-- زر دكتور سكرمبل
local ScrambleButton = Instance.new("TextButton", Main)
ScrambleButton.Size = UDim2.new(1, -30, 0, 38)
ScrambleButton.Position = UDim2.new(0, 15, 0, 237)
ScrambleButton.BackgroundColor3 = Color3.fromRGB(90, 40, 40)
ScrambleButton.Text = "DR. SCRAMBLE : OFF"
ScrambleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ScrambleButton.TextSize = 12
ScrambleButton.Font = Enum.Font.GothamBold

local UICornerScr = Instance.new("UICorner", ScrambleButton)
UICornerScr.CornerRadius = UDim.new(0, 8)

-- شريط الحالة التفاعلي
local StatusLabel = Instance.new("TextLabel", Main)
StatusLabel.Size = UDim2.new(1, -30, 0, 35)
StatusLabel.Position = UDim2.new(0, 15, 0, 283)
StatusLabel.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
StatusLabel.Text = "الحالة: جاهز وبدون لاق ✅"
StatusLabel.TextColor3 = Color3.fromRGB(180, 220, 180)
StatusLabel.TextSize = 11
StatusLabel.Font = Enum.Font.Gotham

local UICornerAS = Instance.new("UICorner", StatusLabel)
UICornerAS.CornerRadius = UDim.new(0, 8)

-- إطار القائمة المنسدلة للبيض النادر
local DropdownFrame = Instance.new("ScrollingFrame", Main)
DropdownFrame.Size = UDim2.new(1, -30, 0, 215)
DropdownFrame.Position = UDim2.new(0, 15, 0, 145)
DropdownFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
DropdownFrame.BorderSizePixel = 0
DropdownFrame.Visible = false
DropdownFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
DropdownFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

local UICornerDF = Instance.new("UICorner", DropdownFrame)
UICornerDF.CornerRadius = UDim.new(0, 10)

local UIListLayout = Instance.new("UIListLayout", DropdownFrame)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)

-- متغيرات التحكم
local CurrentTarget = nil
local KillAuraEnabled = false
local ScrambleFightEnabled = false
local KillRange = 35

-- دالة تنظيف اسم البيضة
local function cleanEggName(name)
	local cleaned = name:gsub("Modelsforegg", ""):gsub("Model", ""):gsub("Egg", ""):gsub("Slot", ""):gsub("Area", ""):gsub("Client", ""):gsub("SpotBottom", ""):gsub("Forest", "")
	cleaned = cleaned:gsub("[0-9]", "")
	cleaned = cleaned:gsub("[_%.%-]", " ")
	cleaned = cleaned:match("^%s*(.-)%s*$")
	if cleaned == "" or #cleaned < 2 then
		return "Special Egg"
	end
	return cleaned
end

-- تليبرورت فوري للبيضة
local function teleportToEgg(targetPart)
	local char = LocalPlayer.Character
	local rootPart = char and char:FindFirstChild("HumanoidRootPart")
	if rootPart and targetPart then
		rootPart.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0)
		StatusLabel.Text = "الحالة: تم الانتقال للبيضة بنجاح! 🎯"
		StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
	end
end

-- زر التيلبرورت للسيف زون
SafeZoneButton.MouseButton1Click:Connect(function()
	local char = LocalPlayer.Character
	local rootPart = char and char:FindFirstChild("HumanoidRootPart")
	if not rootPart then return end

	local foundSafe = false
	for _, obj in ipairs(Workspace:GetDescendants()) do
		local nameLower = obj.Name:lower()
		if nameLower:find("spawn") or nameLower:find("safezone") or nameLower:find("lobby") then
			if obj:IsA("BasePart") then
				rootPart.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
				foundSafe = true
				break
			end
		end
	end

	if foundSafe then
		StatusLabel.Text = "الحالة: تم الانتقال إلى Safe Zone 🛡️"
		StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
	else
		rootPart.CFrame = CFrame.new(0, 50, 0)
		StatusLabel.Text = "الحالة: تم نقلك لمنطقة آمنة للأعلى"
		StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
	end
end)

-- تعبئة القائمة بالبيض النادر
local function populateFilteredEggs()
	for _, child in ipairs(DropdownFrame:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end

	local char = LocalPlayer.Character
	local myRoot = char and char:FindFirstChild("HumanoidRootPart")

	for _, obj in ipairs(Workspace:GetDescendants()) do
		local fullName = obj.Name
		local nameLower = fullName:lower()

		if not nameLower:find("treadmill") 
			and not nameLower:find("machine") 
			and not nameLower:find("fuse") 
			and not nameLower:find("player") 
			and not nameLower:find("plot") 
			and not nameLower:find("incubator") then

			if nameLower:find("egg") or nameLower:find("slot") then
				if nameLower:find("secret") or nameLower:find("eternal") or nameLower:find("divine") then
					if obj:IsA("BasePart") or obj:IsA("Model") then
						local primaryPart = obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) or obj
						
						if primaryPart then
							local eggName = cleanEggName(fullName)
							local dist = myRoot and math.floor((myRoot.Position - primaryPart.Position).Magnitude) or 0

							local eggBtn = Instance.new("TextButton", DropdownFrame)
							eggBtn.Size = UDim2.new(1, -10, 0, 35)
							eggBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
							eggBtn.Text = "💎 " .. eggName .. "  |  [" .. dist .. "m]"
							eggBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
							eggBtn.TextSize = 11
							eggBtn.Font = Enum.Font.GothamBold

							local btnCorner = Instance.new("UICorner", eggBtn)
							btnCorner.CornerRadius = UDim.new(0, 6)

							eggBtn.MouseButton1Click:Connect(function()
								DropdownFrame.Visible = false
								teleportToEgg(primaryPart)
							end)
						end
					end
				end
			end
		end
	end
end

MenuButton.MouseButton1Click:Connect(function()
	DropdownFrame.Visible = not DropdownFrame.Visible
	if DropdownFrame.Visible then 
		populateFilteredEggs() 
	end
end)

--==================================================
-- KILLAURA & SCRAMBLE SYSTEM
--==================================================

KillAuraButton.MouseButton1Click:Connect(function()
	KillAuraEnabled = not KillAuraEnabled
	if KillAuraEnabled then
		KillAuraButton.Text = "KILLAURA : ON"
		KillAuraButton.BackgroundColor3 = Color3.fromRGB(0, 140, 100)
	else
		KillAuraButton.Text = "KILLAURA : OFF"
		KillAuraButton.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
	end
end)

ScrambleButton.MouseButton1Click:Connect(function()
	ScrambleFightEnabled = not ScrambleFightEnabled
	if ScrambleFightEnabled then
		ScrambleButton.Text = "DR. SCRAMBLE : ON"
		ScrambleButton.BackgroundColor3 = Color3.fromRGB(0, 140, 100)
	else
		ScrambleButton.Text = "DR. SCRAMBLE : OFF"
		ScrambleButton.BackgroundColor3 = Color3.fromRGB(90, 40, 40)
	end
end)

RunService.RenderStepped:Connect(function()
	local char = LocalPlayer.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	local myRoot = char.HumanoidRootPart

	local targetToAttack = nil
	local shortestDistance = KillRange

	for _, target in ipairs(Workspace:GetDescendants()) do
		if target:IsA("Model") and target ~= char then
			local nameLower = target.Name:lower()
			local humanoid = target:FindFirstChildOfClass("Humanoid")
			local rootPart = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChild("Head")

			if humanoid and humanoid.Health > 0 and rootPart then
				if ScrambleFightEnabled and (nameLower:find("scramble") or nameLower:find("doctor")) then
					targetToAttack = rootPart
					CurrentTarget = target
					break
				elseif KillAuraEnabled then
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
		TargetButton.TextColor3 = Color3.fromRGB(150, 150, 180)
	end
end)

--==================================================
-- DRAG & MINIMIZE SYSTEM
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
			if child ~= TitleBar and not child:IsA("UICorner") and not child:IsA("UIStroke") then child.Visible = false end
		end
		DropdownFrame.Visible = false
		TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.fromOffset(320, 45)}):Play()
		Minimize.Text = "+"
	else
		TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.fromOffset(320, 420)}):Play()
		task.wait(0.2)
		for _, child in ipairs(Main:GetChildren()) do
			if not child:IsA("UICorner") and not child:IsA("UIStroke") then child.Visible = true end
		end
		Minimize.Text = "-"
	end
end)

print("[K7LE] Loaded successfully via CoreGui!")
