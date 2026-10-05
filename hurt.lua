--// LocalScript
--// ==================== [ 1) الخدمات ] ====================
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local isVisible = true

--// ==================== [ 2) إنشاء الواجهة الأساسية (أعلى يسار الشاشة) ] ====================
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextButton")

-- إعدادات القائمة وتثبيتها أعلى اليسار
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderColor3 = Color3.fromRGB(0, 255, 0)
Frame.Size = UDim2.new(0, 240, 0, 180)
Frame.Position = UDim2.new(0, 15, 0, 15) -- أعلى يسار الشاشة
Frame.Active = true
Frame.Draggable = true

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 8)
frameCorner.Parent = Frame

-- العنوان وزر التصغير/الدائرة
Title.Text = "K7LE (Menu)"
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.TextColor3 = Color3.fromRGB(0, 255, 0)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.BackgroundTransparency = 1

--// ==================== [ 3) زر تفعيل الكيل اورا ] ====================
local NL1 = Instance.new("TextLabel")
NL1.Size = UDim2.new(0, 90, 0, 20)
NL1.Position = UDim2.new(0, 10, 0, 32)
NL1.TextColor3 = Color3.fromRGB(0, 255, 0)
NL1.Font = Enum.Font.SourceSansBold
NL1.TextSize = 14
NL1.BackgroundTransparency = 1
NL1.Text = "كيل اورا (3000)"
NL1.Parent = Frame

local killAuraToggle = Instance.new("TextButton")
killAuraToggle.Size = UDim2.new(0, 45, 0, 18)
killAuraToggle.Position = UDim2.new(1, -60, 0, 33)
killAuraToggle.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
killAuraToggle.Text = ""
killAuraToggle.Parent = Frame

local corner1 = Instance.new("UICorner")
corner1.CornerRadius = UDim.new(1, 0)
corner1.Parent = killAuraToggle

local circle1 = Instance.new("Frame")
circle1.Size = UDim2.new(0, 14, 0, 14)
circle1.Position = UDim2.new(0, 2, 0.5, -7)
circle1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
circle1.Parent = killAuraToggle

local cCorner1 = Instance.new("UICorner")
cCorner1.CornerRadius = UDim.new(1, 0)
cCorner1.Parent = circle1

--// ==================== [ 4) قائمة عرض الأعداء / الـ NPCs القريبين ] ====================
local TargetListTitle = Instance.new("TextLabel")
TargetListTitle.Size = UDim2.new(1, -20, 0, 15)
TargetListTitle.Position = UDim2.new(0, 10, 0, 55)
TargetListTitle.TextColor3 = Color3.fromRGB(255, 255, 0)
TargetListTitle.Font = Enum.Font.SourceSansBold
TargetListTitle.TextSize = 12
TargetListTitle.BackgroundTransparency = 1
TargetListTitle.Text = "الهدف الحالي / القريبون:"
TargetListTitle.TextXAlignment = Enum.TextXAlignment.Left
TargetListTitle.Parent = Frame

local TargetDisplayBox = Instance.new("TextLabel")
TargetDisplayBox.Size = UDim2.new(1, -20, 0, 85)
TargetDisplayBox.Position = UDim2.new(0, 10, 0, 75)
TargetDisplayBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TargetDisplayBox.BorderColor3 = Color3.fromRGB(0, 255, 0)
TargetDisplayBox.TextColor3 = Color3.fromRGB(0, 255, 0)
TargetDisplayBox.Font = Enum.Font.Code
TargetDisplayBox.TextSize = 11
TargetDisplayBox.TextWrapped = true
TargetDisplayBox.TextYAlignment = Enum.TextYAlignment.Top
TargetDisplayBox.TextXAlignment = Enum.TextXAlignment.Left
TargetDisplayBox.Text = "جاري البحث عن أعداء..."
TargetDisplayBox.Parent = Frame

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 6)
boxCorner.Parent = TargetDisplayBox

--// ==================== [ 5) إعدادات التحديد (ESP) الثابت ] ====================
local targetHighlight = Instance.new("Highlight")
targetHighlight.FillColor = Color3.fromRGB(0, 255, 0)
targetHighlight.OutlineColor = Color3.fromRGB(0, 255, 0)
targetHighlight.FillTransparency = 0.6 
targetHighlight.OutlineTransparency = 0 
local currentTargetModel = nil

--// ==================== [ 6) المتغيرات وأحداث الأزرار ] ====================
local killAuraOn = false
local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

killAuraToggle.MouseButton1Click:Connect(function()
	killAuraOn = not killAuraOn
	local targetCirclePos = killAuraOn and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
	local targetBgColor = killAuraOn and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(180, 180, 180)

	TweenService:Create(circle1, tweenInfo, {Position = targetCirclePos}):Play()
	TweenService:Create(killAuraToggle, tweenInfo, {BackgroundColor3 = targetBgColor}):Play()
	
	if not killAuraOn then
		targetHighlight.Parent = nil
		currentTargetModel = nil
		TargetDisplayBox.Text = "متوقف"
	end
end)

--// ==================== [ 7) منطق الكيل اورا (مدى 3000 وثابت لا يفصل) ] ====================
local RANGE = 3000 
local DAMAGE = 25
local attackCooldown = 0.1 
local lastAttack = 0

RunService.RenderStepped:Connect(function()
	if not killAuraOn then return end
	
	local currentTime = tick()
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	-- التحقق من الهدف الحالي لضمان ثبات الـ ESP وعدم اختفائه عشوائياً
	if currentTargetModel and currentTargetModel.Parent then
		local enemyPart = currentTargetModel:FindFirstChild("HumanoidRootPart") or currentTargetModel:FindFirstChild("PrimaryPart") or currentTargetModel:FindFirstChildWhichIsA("BasePart")
		local hum = currentTargetModel:FindFirstChildOfClass("Humanoid")
		
		if enemyPart and (root.Position - enemyPart.Position).Magnitude <= RANGE then
			targetHighlight.Parent = currentTargetModel -- تثبيت الـ ESP باستمرار
			TargetDisplayBox.Text = "🎯 الهدف: " .. currentTargetModel.Name .. "\nالحالة: متصل ومصاب"
			
			if currentTime - lastAttack >= attackCooldown then
				lastAttack = currentTime
				if hum and hum.Health > 0 then
					hum:TakeDamage(DAMAGE)
				end
			end
			return
		else
			targetHighlight.Parent = nil
			currentTargetModel = nil
		end
	end

	-- البحث عن أهداف جديدة ضمن نطاق 3000
	if currentTime - lastAttack >= attackCooldown then
		lastAttack = currentTime

		local params = OverlapParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.FilterDescendantsInstances = {char}

		local bestModel, bestHealth = nil, -1
		local nearbyNames = ""

		for _, part in workspace:GetPartBoundsInRadius(root.Position, RANGE, params) do
			local model = part.Parent
			if model and model ~= workspace and not Players:GetPlayerFromCharacter(model) then
				local hum = model:FindFirstChildOfClass("Humanoid")
				local hasPart = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Head") or model:FindFirstChildWhichIsA("BasePart")
				
				if hasPart then
					local healthVal = hum and hum.Health or 500
					if hum and hum.Health > 0 then
						if healthVal > bestHealth then
							bestModel = model
							bestHealth = healthVal
						end
					elseif not hum and not bestModel then
						bestModel = model
					end
					
					-- إضافة الأعداء القريبين للقائمة المصغرة
					if not string.find(nearbyNames, model.Name) and #nearbyNames < 100 then
						nearbyNames = nearbyNames .. "• " .. model.Name .. "\n"
					end
				end
			end
		end

		if bestModel then
			currentTargetModel = bestModel
			targetHighlight.Parent = bestModel
			TargetDisplayBox.Text = "🎯 الهدف الرئيسي:\n" .. bestModel.Name .. "\n\n📋 القريبون:\n" .. nearbyNames
			
			local hum = bestModel:FindFirstChildOfClass("Humanoid")
			if hum and hum.Health > 0 then
				hum:TakeDamage(DAMAGE)
			end
		else
			targetHighlight.Parent = nil
			currentTargetModel = nil
			TargetDisplayBox.Text = "لا توجد أهداف قريبة ضمن المدى (3000)"
		end
	end
end)

--// ==================== [ 8) تحويل الواجهة لدائرة عند الإغلاق ] ====================
local info = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

Title.MouseButton1Click:Connect(function()
	isVisible = not isVisible

	if isVisible then
		TweenService:Create(Frame, info, {Size = UDim2.new(0, 240, 0, 180), BackgroundTransparency = 0}):Play()
		TweenService:Create(frameCorner, info, {CornerRadius = UDim.new(0, 8)}):Play()
		Title.Size = UDim2.new(1, 0, 0, 25)
		
		task.wait(0.1)
		killAuraToggle.Visible = true
		circle1.Visible = true
		NL1.Visible = true
		TargetListTitle.Visible = true
		TargetDisplayBox.Visible = true
	else
		killAuraToggle.Visible = false
		circle1.Visible = false
		NL1.Visible = false
		TargetListTitle.Visible = false
		TargetDisplayBox.Visible = false
		
		TweenService:Create(Frame, info, {Size = UDim2.new(0, 50, 0, 50), BackgroundTransparency = 0}):Play()
		TweenService:Create(frameCorner, info, {CornerRadius = UDim.new(1, 0)}):Play()
		Title.Size = UDim2.new(1, 0, 1, 0)
	end
end)

--// ==================== [ 9) الربط النهائي ] ====================
Title.Parent = Frame
Frame.Parent = ScreenGui
ScreenGui.Enabled = true
ScreenGui.Parent = player:WaitForChild("PlayerGui")
