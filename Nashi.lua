local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "RuoixV4"
gui.ResetOnSpawn = false

-- Toggle Button (RBX ICON + ไม่วงกลม)
local Toggle = Instance.new("ImageButton", gui)
Toggle.Size = UDim2.new(0,50,0,50)
Toggle.Position = UDim2.new(0,10,0,10)
Toggle.Image = "rbxassetid://73966622627771" -- เปลี่ยนได้
Toggle.BackgroundColor3 = Color3.fromRGB(25,25,25)
Toggle.BorderSizePixel = 0

local corner = Instance.new("UICorner", Toggle)
corner.CornerRadius = UDim.new(0,8)

-- Main UI (ไม่ล้นจอ)
local Main = Instance.new("Frame", gui)
Main.Size = UDim2.new(0.75,0,0.85,0)
Main.Position = UDim2.new(0.125,0,0.075,0)
Main.BackgroundColor3 = Color3.fromRGB(20,24,30)
Main.BackgroundTransparency = 0.1
Main.Visible = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,8)

-- Topbar
local Top = Instance.new("Frame", Main)
Top.Size = UDim2.new(1,0,0,40)
Top.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", Top)
Title.Text = "project Nashi"
Title.Size = UDim2.new(1,0,1,0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.new(1,1,1)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Position = UDim2.new(0,10,0,0)

-- Sidebar
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0.22,0,1,-40)
Sidebar.Position = UDim2.new(0,0,0,40)
Sidebar.BackgroundColor3 = Color3.fromRGB(18,18,18)

local SideList = Instance.new("UIListLayout", Sidebar)
SideList.Padding = UDim.new(0,4)

-- Content Scroll (มือถือเลื่อนได้)
local Content = Instance.new("ScrollingFrame", Main)
Content.Size = UDim2.new(0.78,0,1,-40)
Content.Position = UDim2.new(0.22,0,0,40)
Content.CanvasSize = UDim2.new(0,0,2,0)
Content.ScrollBarThickness = 4
Content.BackgroundTransparency = 1

local ContentList = Instance.new("UIListLayout", Content)
ContentList.Padding = UDim.new(0,6)

-- Tabs
local Tabs = {}

function CreateTab(name)
	local btn = Instance.new("TextButton", Sidebar)
	btn.Size = UDim2.new(1,0,0,35)
	btn.Text = name
	btn.TextColor3 = Color3.fromRGB(200,200,200)
	btn.BackgroundColor3 = Color3.fromRGB(25,25,25)
	Instance.new("UICorner", btn)

	local frame = Instance.new("Frame", Content)
	frame.Size = UDim2.new(1,0,0,0)
	frame.BackgroundTransparency = 1
	frame.Visible = false

	local layout = Instance.new("UIListLayout", frame)
	layout.Padding = UDim.new(0,6)

	Tabs[name] = frame

	btn.MouseButton1Click:Connect(function()
		for i,v in pairs(Tabs) do v.Visible = false end
		frame.Visible = true
	end)

	return frame
end

-- Create Many Tabs
local MainTab = CreateTab("Main")
local FarmTab = CreateTab("Farm")
local PlayerTab = CreateTab("Player")
local VisualTab = CreateTab("Visual")
local MiscTab = CreateTab("Misc")
local SettingsTab = CreateTab("Settings")

Tabs["Main"].Visible = true

-- Card + Toggle
function CreateToggle(parent, text, callback)
	local card = Instance.new("Frame", parent)
	card.Size = UDim2.new(1,0,0,60)
	card.BackgroundColor3 = Color3.fromRGB(30,35,40)
	Instance.new("UICorner", card)

	local label = Instance.new("TextLabel", card)
	label.Text = text
	label.Size = UDim2.new(0.7,0,1,0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.new(1,1,1)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Position = UDim2.new(0,10,0,0)

	local toggle = Instance.new("TextButton", card)
	toggle.Size = UDim2.new(0,50,0,25)
	toggle.Position = UDim2.new(1,-60,0.5,-12)
	toggle.BackgroundColor3 = Color3.fromRGB(60,60,60)
	toggle.Text = ""
	Instance.new("UICorner", toggle).CornerRadius = UDim.new(1,0)

	local dot = Instance.new("Frame", toggle)
	dot.Size = UDim2.new(0,20,0,20)
	dot.Position = UDim2.new(0,2,0.5,-10)
	dot.BackgroundColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)

	local state = false
	toggle.MouseButton1Click:Connect(function()
		state = not state
		dot:TweenPosition(state and UDim2.new(1,-22,0.5,-10) or UDim2.new(0,2,0.5,-10), "Out","Quad",0.2,true)
		toggle.BackgroundColor3 = state and Color3.fromRGB(0,170,255) or Color3.fromRGB(60,60,60)
		callback(state)
	end)
end

-- Add Lots of Toggles
CreateToggle(MainTab, "Auto Farm", function(v) print(v) end)
CreateToggle(MainTab, "Auto Quest", function(v) end)

CreateToggle(PlayerTab, "Speed Boost", function(v)
	local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	if hum then hum.WalkSpeed = v and 50 or 16 end
end)

CreateToggle(PlayerTab, "Infinite Jump", function(v)
	getgenv().infJump = v
end)

UIS.JumpRequest:Connect(function()
	if getgenv().infJump then
		local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
		if hum then hum:ChangeState("Jumping") end
	end
end)

-- Toggle UI
Toggle.MouseButton1Click:Connect(function()
	Main.Visible = not Main.Visible
end)

-- Drag (มือถือใช้ได้)
local dragging, start, pos
Main.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		start = i.Position
		pos = Main.Position
	end
end)

UIS.InputChanged:Connect(function(i)
	if dragging and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement) then
		local delta = i.Position - start
		Main.Position = UDim2.new(
			pos.X.Scale, pos.X.Offset + delta.X,
			pos.Y.Scale, pos.Y.Offset + delta.Y
		)
	end
end)
