local owner = getgenv().Owner
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
		local data = HTTP:JSONDecode(msg)

		if data.type == "userconnected" then
			print("user connected message receieved!!!")
			for _, user in ipairs(data.data) do
				print(user.Name, user.Owner, user.UserId)
			end
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
