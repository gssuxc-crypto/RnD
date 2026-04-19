local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
-- ===== UI =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MonsterWarning"
screenGui.Parent = player:WaitForChild("PlayerGui")

local warning = Instance.new("TextLabel")
warning.Size = UDim2.new(0, 220, 0, 60)
warning.Position = UDim2.new(0, 15, 0, 15)
warning.BackgroundTransparency = 1
warning.TextScaled = true
warning.Text = ""
warning.TextColor3 = Color3.fromRGB(255, 0, 0)
warning.Font = Enum.Font.GothamBlack
warning.Parent = screenGui

local subWarning = Instance.new("TextLabel")
subWarning.Size = UDim2.new(0, 220, 0, 40)
subWarning.Position = UDim2.new(0, 15, 0, 70)
subWarning.BackgroundTransparency = 1
subWarning.TextScaled = true
subWarning.Text = ""
subWarning.TextColor3 = Color3.fromRGB(0, 170, 255)
subWarning.Font = Enum.Font.GothamBold
subWarning.Parent = screenGui

-- ===== ХРАНИЛИЩА =====
local monsters = {}
local lockers = {}
local spirits = {}

-- ===== ПРОВЕРКА =====
local function isMonster(name)
	return string.sub(string.lower(name), 1, 7) == "monster"
end

-- ===== МОНСТР =====
local function setupMonster(monster)
	if not monster:IsA("BasePart") then return end
	
	local name = string.lower(monster.Name)

	if name == "monster2" then
		warning.Text = "A200 OR A120!!!"
		warning.TextColor3 = Color3.fromRGB(255, 255, 0)

		task.delay(2, function()
			if warning.Text == "A200 OR A120!!!" then
				warning.Text = ""
			end
		end)
	else
		warning.Text = "Entity..."
		warning.TextColor3 = Color3.fromRGB(255, 0, 0)
	end

	subWarning.Text = ""

	local highlight = Instance.new("Highlight")
	highlight.FillColor = Color3.fromRGB(255, 0, 0)
	highlight.OutlineColor = highlight.FillColor
	highlight.FillTransparency = 0.2
	highlight.Parent = monster

	local billboard = Instance.new("BillboardGui")
	billboard.Size = UDim2.new(0, 200, 0, 50)
	billboard.StudsOffset = Vector3.new(0, 3, 0)
	billboard.AlwaysOnTop = true
	billboard.Parent = monster

	local text = Instance.new("TextLabel")
	text.Size = UDim2.new(1, 0, 1, 0)
	text.BackgroundTransparency = 1
	text.TextScaled = true
	text.TextColor3 = Color3.fromRGB(255, 0, 0)
	text.Font = Enum.Font.GothamBold
	text.Parent = billboard

	local char = player.Character or player.CharacterAdded:Wait()
	local myHRP = char:WaitForChild("HumanoidRootPart")

	local att0 = Instance.new("Attachment", myHRP)
	local att1 = Instance.new("Attachment", monster)

	local beam = Instance.new("Beam")
	beam.Attachment0 = att0
	beam.Attachment1 = att1
	beam.Width0 = 0.25
	beam.Width1 = 0.25
	beam.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
	beam.FaceCamera = true
	beam.Parent = myHRP

	monsters[monster] = text
end

-- ===== SPIRIT =====
local function setupSpirit(spirit)
	subWarning.Text = "PNEVMA"

	local hl = Instance.new("Highlight")
	hl.FillColor = Color3.fromRGB(0, 170, 255)
	hl.OutlineColor = hl.FillColor
	hl.FillTransparency = 0.2
	hl.Parent = spirit

	local targetPart
	for _, tp in ipairs(spirit:GetChildren()) do
		targetPart = tp
	end

	if targetPart and not targetPart:FindFirstChild("SpiritLight") then
		local light = Instance.new("PointLight")
		light.Name = "SpiritLight"
		light.Color = Color3.fromRGB(0, 170, 255)
		light.Range = 20
		light.Brightness = 2
		light.Parent = targetPart
	end

	spirits[spirit] = true
end

-- ===== БАТАРЕЙКА =====
local function highlightBattery(obj)
	if obj:FindFirstChild("HL") then return end

	local hl = Instance.new("Highlight")
	hl.Name = "HL"
	hl.FillColor = Color3.fromRGB(0, 255, 0)
	hl.OutlineColor = hl.FillColor
	hl.FillTransparency = 0.2
	hl.Parent = obj

	local light = Instance.new("PointLight")
	light.Color = hl.FillColor
	light.Range = 20
	light.Brightness = 2
	light.Parent = obj
end

-- ===== ШКАФ =====
local function setupLocker(locker)
	local hl = Instance.new("Highlight")
	hl.FillColor = Color3.fromRGB(170, 0, 255)
	hl.OutlineColor = hl.FillColor
	hl.FillTransparency = 0.3
	hl.Parent = locker

	local hitbox = locker:FindFirstChild("hitbox", true)
	if hitbox and not hitbox:FindFirstChild("LockerLight") then
		local light = Instance.new("PointLight")
		light.Name = "LockerLight"
		light.Color = hl.FillColor
		light.Range = 15
		light.Brightness = 2
		light.Shadows = false
		light.Parent = hitbox
	end

	lockers[locker] = {
		highlight = hl,
		state = false
	}
end

-- ===== СТОЛ =====
local function setupTable(obj)
	if obj:FindFirstChildOfClass("Highlight") then return end

	local hl = Instance.new("Highlight")
	hl.FillColor = Color3.fromRGB(0, 255, 255)
	hl.OutlineColor = hl.FillColor
	hl.FillTransparency = 0.3
	hl.Parent = obj

	local spot = obj:FindFirstChild("spot", true)
	if spot and not spot:FindFirstChild("TableLight") then
		local light = Instance.new("PointLight")
		light.Name = "TableLight"
		light.Color = hl.FillColor
		light.Range = 15
		light.Brightness = 2
		light.Shadows = false
		light.Parent = spot
	end
end

-- ===== ПРОВЕРКА ОБЪЕКТА =====
local function checkObject(obj)
	local name = string.lower(obj.Name)

	if name == "battery" then
		highlightBattery(obj)
	elseif string.find(name, "hidelocker") then
		setupLocker(obj)
	elseif string.find(name, "table") then
		setupTable(obj)
	end
end

-- ===== КОМНАТЫ =====
local roomsFolder = workspace:WaitForChild("rooms")

local function scanRoom(room)
	for _, v in ipairs(room:GetDescendants()) do
		checkObject(v)
	end

	room.DescendantAdded:Connect(checkObject)
end

-- ===== ОБНОВЛЕНИЕ =====
local updateDelay = 0.1
local t = 0

RunService.Heartbeat:Connect(function(dt)
	t += dt
	if t < updateDelay then return end
	t = 0

	local char = player.Character
	if not char then return end

	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local hasAnyMonster = false

	for monster, text in pairs(monsters) do
		if not monster or not monster.Parent then
			monsters[monster] = nil
		else
			hasAnyMonster = true
			local dist = (hrp.Position - monster.Position).Magnitude
			text.Text = math.floor(dist) .. " studs"
		end
	end

	if not hasAnyMonster then
		warning.Text = ""
	end

	for locker, data in pairs(lockers) do
		if not locker or not locker.Parent then
			lockers[locker] = nil
		else
			local hasJack = locker:FindFirstChild("jack", true) ~= nil
			
			if hasJack ~= data.state then
				data.state = hasJack
				
				local color = hasJack and Color3.fromRGB(255,0,0) or Color3.fromRGB(170,0,255)
				
				TweenService:Create(data.highlight, TweenInfo.new(0.3), {
					FillColor = color,
					OutlineColor = color
				}):Play()
			end
		end
	end

	for spirit in pairs(spirits) do
		if not spirit or not spirit.Parent then
			spirits[spirit] = nil
			subWarning.Text = ""
		end
	end
end)

-- ===== ОТСЛЕЖИВАНИЕ =====
workspace.ChildAdded:Connect(function(child)
	if isMonster(child.Name) then
		setupMonster(child)
	elseif child.Name == "Spirit" then
		setupSpirit(child)
	end
end)

for _, v in ipairs(workspace:GetChildren()) do
	if isMonster(v.Name) then
		setupMonster(v)
	elseif v.Name == "Spirit" then
		setupSpirit(v)
	end
end

roomsFolder.ChildAdded:Connect(function(room)
	task.wait(0.2)
	scanRoom(room)
end)

for _, room in ipairs(roomsFolder:GetChildren()) do
	scanRoom(room)
end
