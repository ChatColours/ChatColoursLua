local owner = getgenv().Owner
local bots = getgenv().Bots
local useapi = getgenv().useAPI or false -- if true, all commands will be sent to the server
local api = getgenv().API -- if u have an api plez put here or ask chatcolours for one

-- I fucking hate femboys
local HTTP = game:GetService("HttpService")
local plr = game.Players.LocalPlayer

if useapi == true and not api then
	warn([[
[CONFIG ERROR]
Some settings are not set up correctly.

UseApi is set as 'true', but API is nil.
]])	

end
print("11:18")
-- SERVICES
local Services = {}

Services.Players = game:GetService("Players")
Services.RunService = game:GetService("RunService")
Services.ReplicatedStorage = game:GetService("ReplicatedStorage")
Services.TextChatService = game:GetService("TextChatService")
Services.Debris = game:GetService("Debris")
Services.HTTP = game:GetService("HttpService")
Services.UserInputService = game:GetService("UserInputService")


local function CreateTag(User, Owner, Index)
	local Billboard = Instance.new("BillboardGui")
	Billboard.AlwaysOnTop = true
	local Canvas = Instance.new("CanvasGroup", Billboard)
	local Own = Instance.new("TextLabel", Canvas)
	local usr = Instance.new("TextLabel", Canvas)
	local Ind = Instance.new("TextLabel", Canvas)
	local Frame = Instance.new("Frame", Canvas)
	local UICorner = Instance.new("UICorner", Canvas)
	local UIStroke = Instance.new("UIStroke", Canvas)
	local UICorner2Frame = Instance.new("UICorner", Frame)
	-- PROPERTIES
	Billboard.Size = UDim2.new(5, 0, 2, 0)
	Billboard.StudsOffset = Vector3.new(0,3,0)
	Canvas.Size = UDim2.new(0.95, 0, 0.95, 0)
	Canvas.AnchorPoint = Vector2.new(0.5, 0.5)
	Canvas.Position = UDim2.new(0.5, 0, 0.5, 0)
	UICorner.CornerRadius = UDim.new(0.05, 0)
	UIStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
	UIStroke.Thickness = 0.02
	UICorner2Frame.CornerRadius = UDim.new(1, 0)
	Frame.BackgroundColor3 = Color3.new(0.5, 1, 0.9)
	Frame.AnchorPoint = Vector2.new(0,0.5)
	Frame.Position = UDim2.new(0,0,0.5,0)
	Frame.Size=UDim2.new(0.015, 0, 2, 0)
	Own.AnchorPoint = Vector2.new(1,0)
	Own.Position = UDim2.new(1, 0, 0.013, 0)
	Own.Size = UDim2.new(0.95, 0, 0.219, 0)
	Own.BackgroundTransparency = 1
	Own.TextScaled = true
	Own.RichText = true
	Own.Text = "Owner: ".. Owner
	Ind.AnchorPoint = Vector2.new(1,0)
	Ind.Position = UDim2.new(1, 0, 0.211, 0)
	Ind.Size = UDim2.new(0.95, 0, 0.219, 0)
	Ind.BackgroundTransparency = 1
	Ind.TextScaled = true
	Ind.RichText = true
	Ind.Text = "Bot index: ".. Index
	usr.AnchorPoint = Vector2.new(1,0)
	usr.Position = UDim2.new(1, 0, 0.429, 0)
	usr.Size = UDim2.new(0.95, 0, 0.4, 0)
	usr.BackgroundTransparency = 1
	usr.TextScaled = true
	usr.RichText = true
	usr.Text = User
	return Billboard
end

local WS
if useapi == true then
	local success, err = pcall(function()
		WS = WebSocket.connect(api)
	end)
	if not success then
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "ChatColours-Script",
			Text = "ERROR: Please check console",
			Duration = 5
		})
		warn(`ChatColours-Script:ERROR:WebSocket failed to connect to ({api}) Are you sure this is the right URL?`)
	end
end
if WS and useapi then
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "ChatColours-Script",
		Text = "Connected to API!",
		Duration = 5
	})
	
	WS.OnMessage:Connect(function(msg)
		local data = Services.HTTP:JSONDecode(msg)
		if data then
			print(data)
			if data.type == "userconnected" then
				local newBot = Services.Players:GetPlayerByUserId(data.data.BotUser)
				if newBot and table.find(bots, newBot.Name) then
					if newBot.Character then
						local newBillboard = CreateTag(newBot.Name, owner, table.find(bots, newBot.Name))

						newBillboard.Parent = newBot.Character
						local head = newBot.Character:WaitForChild("Head")
						if head then
							newBillboard.Adornee = head
						end
					end
					newBot.CharacterAdded:Connect(function(c)
						local newBillboard = CreateTag(newBot.Name, owner, table.find(bots, newBot.Name))

						newBillboard.Parent = newBot.Character
						local head = newBot.Character:WaitForChild("Head")
						if head then
							newBillboard.Adornee = head
						end
					end)
				end
			end
		else
			warn(`ChatColours-Script:ERROR:JSONDecode failed when receiving message from API ({api}), are you sure the API has sent a table?`)
		end
	end)
end
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
	Title = "Bot hub",
	Icon = "door-open", -- lucide icon
	Author = "By ChatColours, free & open-source",
	Folder = "ChatsBot",

	-- ↓ This all is Optional. You can remove it.
	Size = UDim2.fromOffset(580, 460),
	MinSize = Vector2.new(560, 350),
	MaxSize = Vector2.new(850, 560),
	ToggleKey = Enum.KeyCode.LeftShift,
	Transparent = true,
	Theme = "Dark",
	Resizable = true,
	SideBarWidth = 200,
	BackgroundImageTransparency = 0.42,
	HideSearchBar = true,
	ScrollBarEnabled = false,

	User = {
		Enabled = true,
		Anonymous = false,
		Callback = function()
			--print("clicked")
		end,
	},
})

local Tab = Window:Tab({
	Title = "API",
	Icon = "bird", -- optional
	Locked = not useapi,
})

local Button = Tab:Button({
	Title = "Get bot status",
	Desc = "Test Button",
	Locked = false,
	Callback = function()
		if WS then
			local data = {
				type = "status",
				user = owner
			}
			WS:SendMessage(HTTP:JSONEncode(data))
		end
	end
})
