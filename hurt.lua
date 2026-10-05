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

-- إعدادات العنوان (الذي يخفي الواجهة)
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

--// ==================== [ 4) إعدادات التحديد الأخضر (ESP) ] ====================
local targetHighlight = Instance.new("Highlight")
targetHighlight.FillColor = Color3.fromRGB(0, 255, 0)
targetHighlight.OutlineColor = Color3.fromRGB(0, 255, 0)
targetHighlight.FillTransparency = 0.7 
targetHighlight.OutlineTransparency = 0 
local currentTargetChar = nil

--// ==================== [ 5) المتغيرات وأحداث الزر ] ====================
local killAuraOn = false
local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

killAuraToggle.MouseButton1Click:Connect(function()
	killAuraOn = not killAuraOn
	local targetCirclePos = killAuraOn and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
	local targetBgColor = killAuraOn and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(180, 180, 180)

	TweenService:Create(circle1, tweenInfo, {Position = targetCirclePos}):Play()
	TweenService:Create(killAuraToggle, tweenInfo, {BackgroundColor3 = targetBgColor}):Play()
	
	-- إخفاء الخط الأخضر فوراً إذا تم إطفاء الزر
	if not killAuraOn then
		targetHighlight.Parent = nil
		currentTargetChar = nil
	end
end)

--// ==================== [ 6) منطق الكيل اورا (مع تخطي الحماية) ] ====================
local RANGE = 25 
local DAMAGE = 25
local attackCooldownMin = 0.3 
local attackCooldownMax = 0.7 
local nextAttackTime = 0

-- دالة للتحقق من وجود جدار بين اللاعب والهدف (Wall Check Bypass)
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
	if currentTime >= nextAttackTime then
		-- توقيت عشوائي للضرب حتى لا يكتشف السيرفر التكرار الآلي (Humanized Cooldown)
		nextAttackTime = currentTime + (math.random(attackCooldownMin * 100, attackCooldownMax * 100) / 100)

		local char = player.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if not root or not hum or hum.Health <= 0 then return end

		local params = OverlapParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.FilterDescendantsInstances = {char}

		local best, bestHealth = nil, 0
		local seen = {}

		-- البحث عن الأعداء في النطاق
		for _, part in workspace:GetPartBoundsInRadius(root.Position, RANGE, params) do
			local model = part:FindFirstAncestorOfClass("Model")
			if model and not seen[model] then
				seen[model] = true
				local h = model:FindFirstChildOfClass("Humanoid")
				local enemyRoot = model:FindFirstChild("HumanoidRootPart")
				
				-- التأكد أن الهدف حي وليس لاعباً آخر
				if h and h.Health > 0 and enemyRoot and not Players:GetPlayerFromCharacter(model) then
					-- التحقق من الرؤية (Wall Check)
					if checkLineOfSight(root.Position, enemyRoot.Position, char) then
						-- اختيار الهدف اللي عنده أعلى دم
						if h.Health > bestHealth then
							best, bestHealth = h, h.Health
						end
					end
				end
			end
		end

		-- تنفيذ الضرر وتطبيق الخط الأخضر (ESP)
		if best then
			local enemyChar = best.Parent
			
			-- إذا تغير الهدف، ننقل الإضاءة الخضراء للهدف الجديد
			if currentTargetChar ~= enemyChar then
				targetHighlight.Parent = enemyChar
				currentTargetChar = enemyChar
			end
			
			best:TakeDamage(DAMAGE)
		else
			-- إذا ماكو أي هدف قريب مكشوف، نشيل التحديد
			if targetHighlight.Parent ~= nil then
				targetHighlight.Parent = nil
				currentTargetChar = nil
			end
		end
	end
end)

--// ==================== [ 7) انيميشن إخفاء/إظهار النافذة ] ====================
local info = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

Title.MouseButton1Click:Connect(function()
	local targetTrans = isVisible and 1 or 0
	isVisible = not isVisible

	TweenService:Create(Frame, info, {BackgroundTransparency = targetTrans}):Play()
	TweenService:Create(killAuraToggle, info, {BackgroundTransparency = targetTrans}):Play()
	TweenService:Create(circle1, info, {BackgroundTransparency = targetTrans}):Play()
	TweenService:Create(NL1, info, {TextTransparency = targetTrans}):Play()
end)

--// ==================== [ 8) الربط النهائي ] ====================
Title.Parent = Frame
Frame.Parent = ScreenGui
ScreenGui.Enabled = true
ScreenGui.Parent = player:WaitForChild("PlayerGui")
