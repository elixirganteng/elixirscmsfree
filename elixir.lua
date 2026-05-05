-- ============================================================
-- ELIXIR ( FREE SC ) v1.0
-- Deep Purple Theme | Auto Cook + Progress Bar + Start/Stop
-- ============================================================

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local vim = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

repeat task.wait() until player.Character

local playerGui = player:WaitForChild("PlayerGui")

-- ============================================================
-- STATE
-- ============================================================
local running = false

-- ============================================================
-- ANTI AFK
-- ============================================================
player.Idled:Connect(function()
	VirtualUser:CaptureController()
	VirtualUser:ClickButton2(Vector2.new())
end)

-- ============================================================
-- HELPERS
-- ============================================================
local function holdE(t)
	vim:SendKeyEvent(true, "E", false, game)
	task.wait(t)
	vim:SendKeyEvent(false, "E", false, game)
end

local function equip(name)
	local char = player.Character
	local tool = player.Backpack:FindFirstChild(name) or char:FindFirstChild(name)
	if tool then
		char.Humanoid:EquipTool(tool)
		task.wait(0.3)
		return true
	end
end

local function countItem(name)
	local total = 0
	for _, v in pairs(player.Backpack:GetChildren()) do
		if v.Name == name then total += 1 end
	end
	for _, v in pairs(player.Character:GetChildren()) do
		if v:IsA("Tool") and v.Name == name then total += 1 end
	end
	return total
end

-- ============================================================
-- COLOR PALETTE (sama persis ELIXIR 3.5)
-- ============================================================
local C = {
	bg        = Color3.fromRGB(8,   7,  14),
	surface   = Color3.fromRGB(14,  12, 24),
	panel     = Color3.fromRGB(18,  16, 30),
	card      = Color3.fromRGB(24,  21, 40),
	accent    = Color3.fromRGB(130, 60, 240),
	accentDim = Color3.fromRGB(75,  35, 140),
	accentGlow= Color3.fromRGB(175, 120, 255),
	accentSoft= Color3.fromRGB(100, 55, 190),
	text      = Color3.fromRGB(220, 215, 245),
	textMid   = Color3.fromRGB(145, 138, 175),
	textDim   = Color3.fromRGB(75,  68, 100),
	green     = Color3.fromRGB(55,  200, 110),
	red       = Color3.fromRGB(220, 60,  75),
	border    = Color3.fromRGB(38,  32,  62),
}

-- ============================================================
-- GUI SETUP
-- ============================================================
local gui = Instance.new("ScreenGui")
gui.Name = "ELIXIR_FREE_SC"
gui.Parent = playerGui
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ============================================================
-- NOTIFICATION SYSTEM (ringan, pojok kanan bawah)
-- ============================================================
local notifContainer = Instance.new("Frame", gui)
notifContainer.Size = UDim2.new(0, 260, 1, 0)
notifContainer.Position = UDim2.new(1, -270, 0, 0)
notifContainer.BackgroundTransparency = 1
notifContainer.ZIndex = 100

local notifLayout = Instance.new("UIListLayout", notifContainer)
notifLayout.Padding = UDim.new(0, 6)
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
notifLayout.SortOrder = Enum.SortOrder.LayoutOrder

local notifPad = Instance.new("UIPadding", notifContainer)
notifPad.PaddingBottom = UDim.new(0, 14)
notifPad.PaddingRight = UDim.new(0, 8)

local notifCount = 0
local function notify(title, msg, ntype)
	notifCount += 1
	local color = ntype == "success" and C.green or ntype == "error" and C.red or C.accent

	local nc = Instance.new("Frame", notifContainer)
	nc.Size = UDim2.new(1, 0, 0, 54)
	nc.BackgroundColor3 = C.card
	nc.BorderSizePixel = 0
	nc.ClipsDescendants = true
	nc.ZIndex = 100
	nc.LayoutOrder = notifCount
	Instance.new("UICorner", nc).CornerRadius = UDim.new(0, 8)

	local st = Instance.new("UIStroke", nc)
	st.Color = color; st.Thickness = 1; st.Transparency = 0.5

	local bar = Instance.new("Frame", nc)
	bar.Size = UDim2.new(0, 3, 1, 0)
	bar.BackgroundColor3 = color; bar.BorderSizePixel = 0; bar.ZIndex = 101

	local t1 = Instance.new("TextLabel", nc)
	t1.Position = UDim2.new(0, 13, 0, 6); t1.Size = UDim2.new(1, -20, 0, 17)
	t1.BackgroundTransparency = 1; t1.Text = title
	t1.Font = Enum.Font.GothamBold; t1.TextSize = 12
	t1.TextColor3 = C.text; t1.TextXAlignment = Enum.TextXAlignment.Left; t1.ZIndex = 101

	local t2 = Instance.new("TextLabel", nc)
	t2.Position = UDim2.new(0, 13, 0, 24); t2.Size = UDim2.new(1, -20, 0, 24)
	t2.BackgroundTransparency = 1; t2.Text = msg
	t2.Font = Enum.Font.Gotham; t2.TextSize = 10
	t2.TextColor3 = C.textMid; t2.TextXAlignment = Enum.TextXAlignment.Left
	t2.TextWrapped = true; t2.ZIndex = 101

	local tb = Instance.new("Frame", nc)
	tb.Position = UDim2.new(0, 3, 1, -2); tb.Size = UDim2.new(1, -3, 0, 2)
	tb.BackgroundColor3 = color; tb.BorderSizePixel = 0; tb.ZIndex = 101

	nc.Position = UDim2.new(1, 16, 0, 0)
	TweenService:Create(nc, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Position = UDim2.new(0, 0, 0, 0)}):Play()
	TweenService:Create(tb, TweenInfo.new(3.5, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 3, 0, 2)}):Play()

	task.delay(3.5, function()
		TweenService:Create(nc, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {Position = UDim2.new(1, 16, 0, 0)}):Play()
		task.wait(0.3); nc:Destroy()
	end)
end

-- ============================================================
-- MAIN WINDOW
-- ============================================================
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 300, 0, 390)
main.Position = UDim2.new(0.5, -150, 0.5, -195)
main.BackgroundColor3 = C.bg
main.Active = true
main.Draggable = true
main.ClipsDescendants = false
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = C.border; mainStroke.Thickness = 1

local topGlow = Instance.new("Frame", main)
topGlow.Size = UDim2.new(1, 0, 0, 1)
topGlow.BackgroundColor3 = C.accentSoft
topGlow.BackgroundTransparency = 0.3
topGlow.BorderSizePixel = 0; topGlow.ZIndex = 5

-- ============================================================
-- TOP BAR
-- ============================================================
local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1, 0, 0, 46)
topBar.BackgroundColor3 = C.surface
topBar.ZIndex = 2
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 12)

-- Fix rounded corner bawah topbar
local topFix = Instance.new("Frame", topBar)
topFix.Size = UDim2.new(1, 0, 0, 12)
topFix.Position = UDim2.new(0, 0, 1, -12)
topFix.BackgroundColor3 = C.surface; topFix.BorderSizePixel = 0

local accentLine = Instance.new("Frame", topBar)
accentLine.Size = UDim2.new(1, 0, 0, 1)
accentLine.Position = UDim2.new(0, 0, 1, -1)
accentLine.BackgroundColor3 = C.border; accentLine.BorderSizePixel = 0

-- Garis aksen kiri
local sq = Instance.new("Frame", topBar)
sq.Size = UDim2.new(0, 3, 0, 18)
sq.Position = UDim2.new(0, 14, 0.5, -9)
sq.BackgroundColor3 = C.accent; sq.BorderSizePixel = 0
Instance.new("UICorner", sq).CornerRadius = UDim.new(0, 2)

local titleLbl = Instance.new("TextLabel", topBar)
titleLbl.Position = UDim2.new(0, 24, 0, 0)
titleLbl.Size = UDim2.new(0, 160, 1, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "ELIXIR ( FREE SC )"
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.TextSize = 13
titleLbl.TextColor3 = C.text
titleLbl.TextXAlignment = Enum.TextXAlignment.Left

-- Close button
local closeBtn = Instance.new("TextButton", topBar)
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -34, 0.5, -13)
closeBtn.BackgroundColor3 = Color3.fromRGB(50, 15, 22)
closeBtn.Text = "x"; closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 11; closeBtn.TextColor3 = C.red
closeBtn.BorderSizePixel = 0
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

closeBtn.MouseButton1Click:Connect(function()
	running = false
	notify("ELIXIR ( FREE SC )", "Script dihentikan.", "error")
	task.wait(0.4); gui:Destroy()
end)

-- Minimize button
local minBtn = Instance.new("TextButton", topBar)
minBtn.Size = UDim2.new(0, 26, 0, 26)
minBtn.Position = UDim2.new(1, -64, 0.5, -13)
minBtn.BackgroundColor3 = C.card
minBtn.Text = "-"; minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 14; minBtn.TextColor3 = C.textMid
minBtn.BorderSizePixel = 0
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

-- ============================================================
-- CONTENT AREA
-- ============================================================
local content = Instance.new("ScrollingFrame", main)
content.Size = UDim2.new(1, 0, 1, -46)
content.Position = UDim2.new(0, 0, 0, 46)
content.BackgroundColor3 = C.panel
content.ScrollBarThickness = 3
content.ScrollBarImageColor3 = C.accentSoft
content.BorderSizePixel = 0
content.ClipsDescendants = true

local layout = Instance.new("UIListLayout", content)
layout.Padding = UDim.new(0, 7)
layout.SortOrder = Enum.SortOrder.LayoutOrder

local pad = Instance.new("UIPadding", content)
pad.PaddingTop = UDim.new(0, 14)
pad.PaddingLeft = UDim.new(0, 12)
pad.PaddingRight = UDim.new(0, 12)
pad.PaddingBottom = UDim.new(0, 14)

-- ============================================================
-- UI HELPERS
-- ============================================================
local function sectionLabel(text, order)
	local wrap = Instance.new("Frame", content)
	wrap.Size = UDim2.new(1, 0, 0, 20)
	wrap.BackgroundTransparency = 1
	wrap.LayoutOrder = order or 0

	local lbl = Instance.new("TextLabel", wrap)
	lbl.Size = UDim2.new(1, 0, 1, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = text:upper()
	lbl.Font = Enum.Font.GothamBold
	lbl.TextSize = 9
	lbl.TextColor3 = C.textDim
	lbl.TextXAlignment = Enum.TextXAlignment.Left

	local line = Instance.new("Frame", wrap)
	line.Size = UDim2.new(1, 0, 0, 1)
	line.Position = UDim2.new(0, 0, 1, -1)
	line.BackgroundColor3 = C.border; line.BorderSizePixel = 0
end

local function card(h, order)
	local f = Instance.new("Frame", content)
	f.Size = UDim2.new(1, 0, 0, h or 46)
	f.BackgroundColor3 = C.card
	f.BorderSizePixel = 0
	f.LayoutOrder = order or 0
	Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
	local s = Instance.new("UIStroke", f)
	s.Color = C.border; s.Thickness = 1
	return f
end

local function makeActionBtn(text, color, order)
	local f = Instance.new("TextButton", content)
	f.Size = UDim2.new(1, 0, 0, 36)
	f.BackgroundColor3 = color or C.accentDim
	f.Font = Enum.Font.GothamBold
	f.TextSize = 12
	f.TextColor3 = C.text
	f.Text = text
	f.BorderSizePixel = 0
	f.LayoutOrder = order or 0
	Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
	local s = Instance.new("UIStroke", f)
	s.Color = C.border; s.Thickness = 1

	f.MouseEnter:Connect(function()
		TweenService:Create(f, TweenInfo.new(0.12), {BackgroundColor3 = C.accent}):Play()
	end)
	f.MouseLeave:Connect(function()
		TweenService:Create(f, TweenInfo.new(0.12), {BackgroundColor3 = color or C.accentDim}):Play()
	end)
	return f
end

local function makeStatusRow(label, order)
	local f = card(30, order)

	local lbl = Instance.new("TextLabel", f)
	lbl.Position = UDim2.new(0, 12, 0, 0)
	lbl.Size = UDim2.new(0.6, 0, 1, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = label
	lbl.Font = Enum.Font.GothamSemibold
	lbl.TextSize = 11
	lbl.TextColor3 = C.textMid
	lbl.TextXAlignment = Enum.TextXAlignment.Left

	local val = Instance.new("TextLabel", f)
	val.Position = UDim2.new(0.6, 0, 0, 0)
	val.Size = UDim2.new(0.4, -10, 1, 0)
	val.BackgroundTransparency = 1
	val.Text = "0"
	val.Font = Enum.Font.GothamBold
	val.TextSize = 12
	val.TextColor3 = C.accentGlow
	val.TextXAlignment = Enum.TextXAlignment.Right

	return val
end

local function makeProgressCard(label, order)
	local f = card(34, order)

	local lbl = Instance.new("TextLabel", f)
	lbl.Position = UDim2.new(0, 10, 0, 5)
	lbl.Size = UDim2.new(0.7, 0, 0, 13)
	lbl.BackgroundTransparency = 1
	lbl.Text = label
	lbl.Font = Enum.Font.GothamSemibold
	lbl.TextSize = 10
	lbl.TextColor3 = C.textMid
	lbl.TextXAlignment = Enum.TextXAlignment.Left

	local bg = Instance.new("Frame", f)
	bg.Position = UDim2.new(0, 10, 0, 22)
	bg.Size = UDim2.new(1, -20, 0, 5)
	bg.BackgroundColor3 = C.border
	bg.BorderSizePixel = 0
	Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

	local bar = Instance.new("Frame", bg)
	bar.Size = UDim2.new(0, 0, 1, 0)
	bar.BackgroundColor3 = C.accent
	bar.BorderSizePixel = 0
	Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

	return bar
end

local function fill(bar, time)
	bar.Size = UDim2.new(0, 0, 1, 0)
	bar:TweenSize(UDim2.new(1, 0, 1, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, time, true)
	task.delay(time, function() bar.Size = UDim2.new(0, 0, 1, 0) end)
end

-- ============================================================
-- UI ELEMENTS
-- ============================================================

-- STATUS
sectionLabel("Status", 1)
local statusCard = card(36, 2)
local statusLabel = Instance.new("TextLabel", statusCard)
statusLabel.Size = UDim2.new(1, -20, 1, 0)
statusLabel.Position = UDim2.new(0, 12, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "IDLE"
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextSize = 12
statusLabel.TextColor3 = C.textMid
statusLabel.TextXAlignment = Enum.TextXAlignment.Left

-- INVENTORY
sectionLabel("Inventory", 3)
local waterVal   = makeStatusRow("Water",           4)
local sugarVal   = makeStatusRow("Sugar Block Bag", 5)
local gelatinVal = makeStatusRow("Gelatin",         6)
local bagVal     = makeStatusRow("Empty Bag",       7)

-- CONTROLS
sectionLabel("Controls", 8)
local farmToggleBtn = makeActionBtn("START COOK", C.accentDim, 9)

-- PROGRESS BARS
sectionLabel("Cook Progress", 10)
local waterBar   = makeProgressCard("Water (20s)",  11)
local sugarBar   = makeProgressCard("Sugar (1s)",   12)
local gelatinBar = makeProgressCard("Gelatin (1s)", 13)
local bagBar     = makeProgressCard("Bag (45s)",    14)

-- ============================================================
-- COOK LOGIC (persis dari ELIXIR 3.5 tab FARM)
-- ============================================================
local function cook()
	while running do
		if equip("Water") then
			statusLabel.Text = "Cooking Water..."
			statusLabel.TextColor3 = C.accentGlow
			fill(waterBar, 20)
			holdE(0.7)
			task.wait(20)
		end
		if not running then break end
		if equip("Sugar Block Bag") then
			statusLabel.Text = "Cooking Sugar..."
			statusLabel.TextColor3 = C.text
			fill(sugarBar, 1)
			holdE(0.7)
			task.wait(1)
		end
		if not running then break end
		if equip("Gelatin") then
			statusLabel.Text = "Cooking Gelatin..."
			fill(gelatinBar, 1)
			holdE(0.7)
			task.wait(1)
		end
		if not running then break end
		statusLabel.Text = "Waiting Marshmallow..."
		statusLabel.TextColor3 = C.textMid
		fill(bagBar, 45)
		task.wait(45)
		if not running then break end
		if equip("Empty Bag") then
			statusLabel.Text = "Collecting..."
			holdE(0.7)
			task.wait(1)
		end
	end
	statusLabel.Text = "IDLE"
	statusLabel.TextColor3 = C.textMid
end

-- ============================================================
-- TOGGLE BUTTON LOGIC
-- ============================================================
farmToggleBtn.MouseButton1Click:Connect(function()
	running = not running
	if running then
		farmToggleBtn.Text = "STOP COOK"
		TweenService:Create(farmToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = C.red}):Play()
		farmToggleBtn.MouseLeave:Connect(function()
			if running then
				TweenService:Create(farmToggleBtn, TweenInfo.new(0.12), {BackgroundColor3 = C.red}):Play()
			end
		end)
		notify("Cook", "Auto cook dimulai!", "success")
		task.spawn(cook)
	else
		farmToggleBtn.Text = "START COOK"
		TweenService:Create(farmToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = C.accentDim}):Play()
		notify("Cook", "Auto cook dihentikan.", "error")
	end
end)

-- ============================================================
-- STATUS LOOP (update inventory setiap 0.5s)
-- ============================================================
task.spawn(function()
	while gui and gui.Parent do
		local w  = countItem("Water")
		local sg = countItem("Sugar Block Bag")
		local ge = countItem("Gelatin")
		local bg = countItem("Empty Bag")

		waterVal.Text   = tostring(w)
		sugarVal.Text   = tostring(sg)
		gelatinVal.Text = tostring(ge)
		bagVal.Text     = tostring(bg)

		task.wait(0.5)
	end
end)

-- ============================================================
-- MINIMIZE
-- ============================================================
local bodyVisible = true
minBtn.MouseButton1Click:Connect(function()
	bodyVisible = not bodyVisible
	content.Visible = bodyVisible
	if bodyVisible then
		TweenService:Create(main, TweenInfo.new(0.22, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 300, 0, 390)}):Play()
	else
		TweenService:Create(main, TweenInfo.new(0.22, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 300, 0, 46)}):Play()
	end
end)

-- ============================================================
-- HIDE BUTTON (tombol "E" mobile-friendly di pinggir layar)
-- ============================================================
local hideBtn = Instance.new("TextButton", gui)
hideBtn.Size = UDim2.new(0, 38, 0, 38)
hideBtn.Position = UDim2.new(1, -48, 0.5, -19)
hideBtn.Text = "E"
hideBtn.Font = Enum.Font.GothamBlack
hideBtn.TextSize = 14
hideBtn.BackgroundColor3 = C.accent
hideBtn.TextColor3 = Color3.new(1, 1, 1)
hideBtn.Active = true
hideBtn.Draggable = true
hideBtn.BorderSizePixel = 0
Instance.new("UICorner", hideBtn).CornerRadius = UDim.new(0, 9)

hideBtn.MouseButton1Click:Connect(function()
	main.Visible = not main.Visible
end)

-- ============================================================
-- STARTUP
-- ============================================================
notify("ELIXIR ( FREE SC )", "Script berhasil diload!", "success")
