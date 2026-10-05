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

Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderColor3 = Color3.fromRGB(0, 255, 0)
Frame.Size = UDim2.new(0, 260, 0, 220)
Frame.Position = UDim2.new(0, 15, 0, 15)
Frame.Active = true
Frame.Draggable = true

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 8)
frameCorner.Parent = Frame

Title.Text = "K7LE - Boss List"
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.TextColor3 = Color3.fromRGB(0, 255, 0)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 15
Title.BackgroundTransparency = 1

--// ==================== [ 3) زر التفعيل العام للكيل اورا ] ====================
local NL1 = Instance.new("TextLabel")
NL1.Size = UDim2.new(0, 100, 0, 20)
NL1.Position = UDim2.new(0, 10, 0, 30)
NL1.TextColor3 = Color3.fromRGB(0, 255, 0)
NL1.Font = Enum.Font.SourceSansBold
NL1.TextSize = 13
NL1.BackgroundTransparency = 1
NL1.Text = "تفعيل الكيل اورا"
NL1.Parent = Frame

local killAuraToggle = Instance.new("TextButton")
killAuraToggle.Size = UDim2.new(0, 40, 0, 18)
killAuraToggle.Position = UDim2.new(1, -50, 0, 31)
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

--// ==================== [ 4) حاوية قائمة الـ NPCs (تصفية الجدران) ] ====================
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, -20, 0, 145)
ScrollingFrame.Position = UDim2.new(0, 10, 0, 60)
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 255, 0)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
ScrollingFrame.ScrollBarThickness = 4
ScrollingFrame.Parent = Frame

local scrollCorner = Instance.new("UICorner")
scrollCorner.CornerRadius = UDim.new(0, 6)
scrollCorner.Parent = ScrollingFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.Parent = ScrollingFrame

--// ==================== [ 5) المتغيرات ونظام التحديد اليدوي والثابت (ESP) ] ====================
local killAuraOn = false
local selectedTargetModel = nil -- الهدف المختار يدوياً
local targetHighlight = Instance.new("Highlight")
targetHighlight.FillColor = Color3.fromRGB(0, 255, 0)
targetHighlight.OutlineColor = Color3.fromRGB(0, 255, 0)
targetHighlight.FillTransparency = 0.5 
targetHighlight.OutlineTransparency = 0 

local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

killAuraToggle.MouseButton1Click:Connect(function()
	killAuraOn = not killAuraOn
	local targetCirclePos = killAuraOn and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
	local targetBgColor = killAuraOn and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(180, 180, 180)

	TweenService:Create(circle1, tweenInfo, {Position = targetCirclePos}):Play()
	TweenService:Create(killAuraToggle, tweenInfo, {BackgroundColor3 = targetBgColor}):Play()
	
	if not killAuraOn then
		targetHighlight.Parent = nil
		selectedTargetModel = nil
	end
end)

--// دالة لتحديث قائمة الـ NPCs والبوستات فقط (تجاهل الجدران والماب)
local function updateNPCList()
	-- تنظيف القائمة القديمة
	for _, child in ipairs(ScrollingFrame:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end

	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local RANGE = 3000
	local params = OverlapParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = {char}

	local seenModels = {}

	for _, part in workspace:GetPartBoundsInRadius(root.Position, RANGE, params) do
		local model = part.Parent
		-- التأكد أنه موديل حقيقي، ليس اللاعب، ويمتلك هيومانر أو رأس (لكي يكون NPC أو بوس حقيقي وليس جداراً)
		if model and model ~= workspace and not Players:GetPlayerFromCharacter(model) and not seenModels[model] then
			local hum = model:FindFirstChildOfClass("Humanoid")
			local hasHeadOrRoot = model:FindFirstChild("Head") or model:FindFirstChild("HumanoidRootPart")
			
			-- استبعاد العناصر البيئية والجدران بناءً على عدم وجود خصائص حية
			if hum or (hasHeadOrRoot and model:FindFirstChildWhichIsA("BasePart")) then
				seenModels[model] = true

				-- إنشاء تصميم العنصر في القائمة (صورة مصغرة / مربع اختيار واسم صغير)
				local itemFrame = Instance.new("Frame")
				itemFrame.Size = UDim2.new(1, -10, 0, 35)
				itemFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
				itemFrame.BorderSizePixel = 0
				itemFrame.Parent = ScrollingFrame

				local itemCorner = Instance.new("UICorner")
				itemCorner.CornerRadius = UDim.new(0, 4)
				itemCorner.Parent = itemFrame

				-- اسم الـ NPC بخط أصغر فوق العنصر
				local nameLabel = Instance.new("TextLabel")
				nameLabel.Size = UDim2.new(1, -45, 1, 0)
				nameLabel.Position = UDim2.new(0, 8, 0, 0)
				nameLabel.BackgroundTransparency = 1
				nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				nameLabel.Font = Enum.Font.SourceSansBold
				nameLabel.TextSize = 12
				nameLabel.Text = model.Name
				nameLabel.TextXAlignment = Enum.TextXAlignment.Left
				nameLabel.Parent = itemFrame

				-- مربع الاختيار (CheckBox) بجانب الاسم
				local checkBox = Instance.new("TextButton")
				checkBox.Size = UDim2.new(0, 22, 0, 22)
				checkBox.Position = UDim2.new(1, -28, 0.5, -11)
				checkBox.BackgroundColor3 = (selectedTargetModel == model) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(50, 50, 50)
				checkBox.BorderColor3 = Color3.fromRGB(0, 255, 0)
				checkBox.Text = (selectedTargetModel == model) and "✓" or ""
				checkBox.TextColor3 = Color3.fromRGB(0, 0, 0)
				checkBox.Font = Enum.Font.SourceSansBold
				checkBox.TextSize = 14
				checkBox.Parent = itemFrame

				local boxCorner = Instance.new("UICorner")
				boxCorner.CornerRadius = UDim.new(0, 4)
				boxCorner.Parent = checkBox

				-- الحدث عند الضغط على المربع لاختيار البووس وتثبيت الـ ESP عليه دائمًا
				checkBox.MouseButton1Click:Connect(function()
					if selectedTargetModel == model then
						selectedTargetModel = nil
						targetHighlight.Parent = nil
					else
						selectedTargetModel = model
						targetHighlight.Parent = model
					end
					updateNPCList()
				end)
			end
		end
	end
end

--// ==================== [ 6) منطق العمل المستمر (ضرب + فحص دائم لمنع الفصل) ] ====================
local DAMAGE = 25
local attackCooldown = 0.1
local lastAttack = 0
local updateClock = 0

RunService.RenderStepped:Connect(function(dt)
	updateClock = updateClock + dt
	-- تحديث القائمة تلقائياً كل ثانية لضمان ظهور البوسات الجديدة وعدم فصل السكريبت
	if updateClock >= 1 then
		updateClock = 0
		pcall(updateNPCList)
	end

	if not killAuraOn then return end

	local currentTime = tick()
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	-- إذا كان هناك هدف محدد يدوياً من القائمة
	if selectedTargetModel and selectedTargetModel.Parent then
		local enemyPart = selectedTargetModel:FindFirstChild("HumanoidRootPart") or selectedTargetModel:FindFirstChild("PrimaryPart") or selectedTargetModel:FindFirstChildWhichIsA("BasePart")
		local hum = selectedTargetModel:FindFirstChildOfClass("Humanoid")

		if enemyPart and (root.Position - enemyPart.Position).Magnitude <= 3000 then
			targetHighlight.Parent = selectedTargetModel -- إبقاء الـ ESP ثابت ودائم لا يختفي أبداً

			if currentTime - lastAttack >= attackCooldown then
				lastAttack = currentTime
				if hum and hum.Health > 0 then
					hum:TakeDamage(DAMAGE)
				else
					-- إذا مات الهدف، نلغي التحديد تلقائياً
					targetHighlight.Parent = nil
					selectedTargetModel = nil
				end
			end
			return
		else
			-- إذا ابتعد كثيراً، نوقف الـ ESP الخاص به
			targetHighlight.Parent = nil
		end
	end
end)

--// ==================== [ 7) تصغير الواجهة وإعادتها (شكل دائري) ] ====================
local info = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

Title.MouseButton1Click:Connect(function()
	isVisible = not isVisible

	if isVisible then
		TweenService:Create(Frame, info, {Size = UDim2.new(0, 260, 0, 220), BackgroundTransparency = 0}):Play()
		TweenService:Create(frameCorner, info, {CornerRadius = UDim.new(0, 8)}):Play()
		Title.Size = UDim2.new(1, 0, 0, 25)
		
		task.wait(0.1)
		killAuraToggle.Visible = true
		circle1.Visible = true
		NL1.Visible = true
		ScrollingFrame.Visible = true
	else
		killAuraToggle.Visible = false
		circle1.Visible = false
		NL1.Visible = false
		ScrollingFrame.Visible = false
		
		TweenService:Create(Frame, info, {Size = UDim2.new(0, 50, 0, 50), BackgroundTransparency = 0}):Play()
		TweenService:Create(frameCorner, info, {CornerRadius = UDim.new(1, 0)}):Play()
		Title.Size = UDim2.new(1, 0, 1, 0)
	end
end)

--// ==================== [ 8) الربط النهائي ] ====================
Title.Parent = Frame
Frame.Parent = ScreenGui
ScreenGui.Enabled = true
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- تشغيل أول تحديث فوري للقائمة عند التحميل
pcall(updateNPCList)
