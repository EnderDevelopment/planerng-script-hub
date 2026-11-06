-- PlaneRNG Companion Hub
-- Place this LocalScript in StarterPlayer > StarterPlayerScripts.

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local existing = playerGui:FindFirstChild("PlaneRNGCompanionHub")
if existing then
	existing:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PlaneRNGCompanionHub"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = false
screenGui.DisplayOrder = 20
screenGui.Parent = playerGui

local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.AnchorPoint = Vector2.new(0, 0.5)
panel.Position = UDim2.new(0, 20, 0.5, 0)
panel.Size = UDim2.fromOffset(280, 300)
panel.BackgroundColor3 = Color3.fromRGB(22, 25, 35)
panel.BorderSizePixel = 0
panel.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = panel

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(80, 142, 255)
stroke.Thickness = 1.5
stroke.Parent = panel

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Position = UDim2.fromOffset(16, 12)
title.Size = UDim2.new(1, -32, 0, 32)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = "PlaneRNG Companion"
title.TextColor3 = Color3.fromRGB(245, 247, 255)
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = panel

local subtitle = Instance.new("TextLabel")
subtitle.Position = UDim2.fromOffset(16, 44)
subtitle.Size = UDim2.new(1, -32, 0, 22)
subtitle.BackgroundTransparency = 1
subtitle.Font = Enum.Font.Gotham
subtitle.Text = "Personal display preferences"
subtitle.TextColor3 = Color3.fromRGB(165, 174, 195)
subtitle.TextSize = 13
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = panel

local content = Instance.new("Frame")
content.Position = UDim2.fromOffset(16, 82)
content.Size = UDim2.new(1, -32, 1, -96)
content.BackgroundTransparency = 1
content.Parent = panel

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 10)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = content

local function makeButton(text, order, callback)
	local button = Instance.new("TextButton")
	button.Name = text:gsub("%W", "")
	button.LayoutOrder = order
	button.Size = UDim2.new(1, 0, 0, 42)
	button.BackgroundColor3 = Color3.fromRGB(39, 46, 63)
	button.BorderSizePixel = 0
	button.AutoButtonColor = true
	button.Font = Enum.Font.GothamMedium
	button.Text = text
	button.TextColor3 = Color3.fromRGB(235, 239, 249)
	button.TextSize = 14
	button.Parent = content

	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = UDim.new(0, 8)
	buttonCorner.Parent = button
	button.Activated:Connect(callback)
	return button
end

local function setFov(value)
	local camera = workspace.CurrentCamera
	if camera then
		camera.FieldOfView = value
	end
end

makeButton("Camera view: 70°", 1, function()
	setFov(70)
end)
makeButton("Camera view: 85°", 2, function()
	setFov(85)
end)
makeButton("Camera view: 55°", 3, function()
	setFov(55)
end)

local scale = 1
local scaleButton
scaleButton = makeButton("UI size: 100%", 4, function()
	if scale == 1 then
		scale = 1.15
	elseif scale == 1.15 then
		scale = 0.9
	else
		scale = 1
	end
	panel.Size = UDim2.fromOffset(280 * scale, 300 * scale)
	scaleButton.Text = string.format("UI size: %d%%", math.floor(scale * 100 + 0.5))
end)

makeButton("Hide companion (RightShift)", 5, function()
	panel.Visible = false
end)

local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed or input.KeyCode ~= Enum.KeyCode.RightShift then
		return
	end
	panel.Visible = not panel.Visible
end)

player.CharacterAdded:Connect(function()
	task.defer(function()
		local camera = workspace.CurrentCamera
		if camera then
			camera.FieldOfView = 70
		end
	end)
end)
