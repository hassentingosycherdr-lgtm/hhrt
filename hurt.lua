--// LocalScript
--// ==================== [ 1) الخدمات ] ====================
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local isVisible = true

--// ==================== [ 2) إنشاء العناصر الأساسية للواجهة ] ====================
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextButton")

-- إعدادات المربع الأسود 
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderColor3 = Color3.fromRGB(0, 255, 0)
Frame.Size = UDim2.new(0, 300, 0, 150)
Frame.Position = UDim2.new(0.5, -150, 0.5, -75)
Frame.Active = true
Frame.Draggable = true

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 8)
frameCorner.Parent = Frame

-- إعدادات العنوان (زر الفتح والإغلاق وشكل الدائرة)
Title.Text = "K7LE"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.TextColor3 = Color3.fromRGB(0, 255, 0)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 22
Title.BackgroundTransparency = 1

--// ==================== [ 3) زر: كيل اورا ] ====================
local NL1 = Instance.new("TextLabel")
NL1.Size = UDim2.new(0, 110, 0, 20)
NL1.Position = UDim2.new(1, -220, 0, 45)
NL1.TextColor3 = Color3.fromRGB(0, 255, 0)
NL1.Font = Enum.Font.SourceSansBold
NL1.TextSize = 16
NL1.BackgroundTransparency = 1
NL1.Text = "كيل اورا"
NL1.Parent = Frame

local killAuraToggle = Instance.new("TextButton")
killAuraToggle.Size = UDim2.new(0, 50, 0, 20)
killAuraToggle.Position = UDim2.new(1, -80, 0, 45)
killAuraToggle.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
killAuraToggle.Text = ""
killAuraToggle.Parent = Frame

local corner1 = Instance.new("UICorner")
corner1.CornerRadius = UDim.new(1, 0)
corner1.Parent = killAuraToggle

local circle1 = Instance.new("Frame")
circle1.Size = UDim2.new(0, 16, 0, 16)
circle1.Position = UDim2.new(0, 2, 0.5, -8)
circle1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
circle1.Parent = killAuraToggle

local cCorner1 = Instance.new("UICorner")
cCorner1.CornerRadius = UDim.new(1, 0)
cCorner1.Parent = circle1

--// ==================== [ 4) إعدادات التحديد الثابت (ESP) ] ====================
local targetHighlight = Instance.new("Highlight")
targetHighlight.FillColor = Color3.fromRGB(0, 255, 0)
targetHighlight.OutlineColor = Color3.fromRGB(0, 255, 0)
targetHighlight.FillTransparency = 0.7 
targetHighlight.OutlineTransparency = 0 
local currentTarget = nil

--// ==================== [ 5) المتغيرات وأحداث الزر ] ====================
local killAuraOn = false
local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

killAuraToggle.MouseButton1Click:Connect(function()
	killAuraOn = not killAuraOn
	local targetCirclePos = killAuraOn and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
	local targetBgColor = killAuraOn and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(180, 180, 180)

	TweenService:Create(circle1, tweenInfo, {Position = targetCirclePos}):Play()
	TweenService:Create(killAuraToggle, tweenInfo, {BackgroundColor3 = targetBgColor}):Play()
	
	if not killAuraOn then
		targetHighlight.Parent = nil
		currentTarget = nil
	end
end)

--// ==================== [ 6) منطق الكيل اورا (مدى 200 وسريع) ] ====================
local RANGE = 200 -- تم زيادة المدى إلى 200
local DAMAGE = 25
local attackCooldown = 0.15 
local lastAttack = 0

local function checkLineOfSight(startPos, endPos, character)
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = {character}
	
	local direction = (endPos - startPos)
	local result = workspace:Raycast(startPos, direction, raycastParams)
	
	if not result or (result.Instance and result.Instance.Parent:FindFirstChild("Humanoid")) then
		return true
	end
	return false
end

RunService.RenderStepped:Connect(function()
	if not killAuraOn then return end
	
	local currentTime = tick()
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not root or not hum or hum.Health <= 0 then return end

	-- التحقق من الهدف الحالي إذا كان لا يزال حياً وفي المدى الجديد (200)
	if currentTarget and currentTarget.Parent then
		local enemyRoot = currentTarget.Parent:FindFirstChild("HumanoidRootPart")
		if currentTarget.Health > 0 and enemyRoot and (root.Position - enemyRoot.Position).Magnitude <= RANGE then
			if currentTime - lastAttack >= attackCooldown then
				lastAttack = currentTime
				currentTarget:TakeDamage(DAMAGE)
			end
			return
		else
			targetHighlight.Parent = nil
			currentTarget = nil
		end
	end

	-- البحث عن هدف جديد ضمن مدى 200
	if currentTime - lastAttack >= attackCooldown then
		lastAttack = currentTime

		local params = OverlapParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.FilterDescendantsInstances = {char}

		local best, bestHealth = nil, 0
		local seen = {}

		for _, part in workspace:GetPartBoundsInRadius(root.Position, RANGE, params) do
			local model = part:FindFirstAncestorOfClass("Model")
			if model and not seen[model] then
				seen[model] = true
				local h = model:FindFirstChildOfClass("Humanoid")
				local enemyRoot = model:FindFirstChild("HumanoidRootPart")
				
				if h and h.Health > 0 and enemyRoot and not Players:GetPlayerFromCharacter(model) then
					if checkLineOfSight(root.Position, enemyRoot.Position, char) then
						if h.Health > bestHealth then
							best, bestHealth = h, h.Health
						end
					end
				end
			end
		end

		if best then
			currentTarget = best
			targetHighlight.Parent = best.Parent
			best:TakeDamage(DAMAGE)
		else
			targetHighlight.Parent = nil
			currentTarget = nil
		end
	end
end)

--// ==================== [ 7) تحويل الواجهة إلى دائرة عند الإغلاق ] ====================
local info = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

Title.MouseButton1Click:Connect(function()
	isVisible = not isVisible

	if isVisible then
		-- فتح الواجهة لوضعها الطبيعي
		TweenService:Create(Frame, info, {Size = UDim2.new(0, 300, 0, 150), BackgroundTransparency = 0}):Play()
		TweenService:Create(frameCorner, info, {CornerRadius = UDim.new(0, 8)}):Play()
		Title.Size = UDim2.new(1, 0, 0, 30)
		Title.Position = UDim2.new(0, 0, 0, 0)
		
		task.wait(0.1)
		killAuraToggle.Visible = true
		circle1.Visible = true
		NL1.Visible = true
	else
		-- إغلاق الواجهة وتحويلها إلى دائرة صغيرة في منتصفها اسم K7LE
		killAuraToggle.Visible = false
		circle1.Visible = false
		NL1.Visible = false
		
		TweenService:Create(Frame, info, {Size = UDim2.new(0, 70, 0, 70), BackgroundTransparency = 0}):Play()
		TweenService:Create(frameCorner, info, {CornerRadius = UDim.new(1, 0)}):Play()
		Title.Size = UDim2.new(1, 0, 1, 0)
		Title.Position = UDim2.new(0, 0, 0, 0)
	end
end)

--// ==================== [ 8) الربط النهائي ] ====================
Title.Parent = Frame
Frame.Parent = ScreenGui
ScreenGui.Enabled = true
ScreenGui.Parent = player:WaitForChild("PlayerGui")
