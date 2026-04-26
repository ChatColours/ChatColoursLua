-- SET UP
local owner = getgenv().Owner
local bots = getgenv().Bots
local prefix = getgenv().Prefix or ";"
local render = getgenv().render or true
local useAPI = getgenv().useAPI or false
local api = getgenv().API

if not owner or not bots or (useAPI and not api) then -- Make sure settings have been set up properly.
	warn([[
[CONFIG ERROR]
Some settings are not set up correctly.

Required:
- owner must be a string
- bots must be a table
- if useAPI is true, api must be a string
]])
end

-- SERVICES
local Services = {}

Services.Players = game:GetService("Players")
Services.RunService = game:GetService("RunService")
Services.ReplicatedStorage = game:GetService("ReplicatedStorage")
Services.TextChatService = game:GetService("TextChatService")
Services.Debris = game:GetService("Debris")
Services.HTTP = game:GetService("HttpService")
Services.UserInputService = game:GetService("UserInputService")

-- MAIN
local function CreateTag(User, Owner, Index)
	local Billboard = Instance.new("BillboardGui")
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
	Canvas.AbsolutePosition = Vector2.new(0.5, 0.5)
	Canvas.Position = UDim2.new(0.5, 0, 0.5, 0)
	UICorner.CornerRadius = UDim.new(0.05, 0)
	UIStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
	UIStroke.Thickness = 0.02
	UICorner2Frame.CornerRadius = UDim.new(1, 0)
	
	Own.AnchorPoint = Vector2.new(1,0)
	Own.Position = UDim2.new(1, 0, 0.013, 0)
	Own.Size = UDim2.new(0.95, 0, 0.219, 0)
	Own.BackgroundTransparency = 1
	Own.TextScaled = true
	Own.RichText = true
	Own.Text = Owner
	Ind.AnchorPoint = Vector2.new(1,0)
	Ind.Position = UDim2.new(1, 0, 0.211, 0)
	Ind.Size = UDim2.new(0.95, 0, 0.219, 0)
	Ind.BackgroundTransparency = 1
	Ind.TextScaled = true
	Ind.RichText = true
	Ind.Text = Index
	usr.AnchorPoint = Vector2.new(1,0)
	usr.Position = UDim2.new(1, 0, 0.429, 0)
	usr.Size = UDim2.new(0.95, 0, 0.4, 0)
	usr.BackgroundTransparency = 1
	usr.TextScaled = true
	usr.RichText = true
	usr.Text = User
	return Billboard
end

Services.RunService:Set3dRenderingEnabled(render)
local plr = Services.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()

if useAPI then
	local WS
	local succ, err = pcall(function()
		WS = WebSocket.connect(api)
	end)
	if not succ and not WS then -- Fallback in case err idk
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "ChatColours-Script",
			Text = "ERROR: Please check console",
			Duration = 5
		})
		warn(`ChatColours-Script:ERROR:WebSocket failed to connect to ({API}) Are you sure this is the right URL?`)
	elseif succ and WS then
		local data = {
			UserId = plr.UserId,
			Name = plr.Name,
			Owner = owner,
			BotsList = bots
		}
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "ChatColours-Script",
			Text = "Connected to API!",
			Duration = 5
		})
		WS:Send(Services.HTTP:JSONEncode(data)) -- Send message to API
		WS.OnMessage:Connect(function(msg)
			local data = Services.HTTP:JSONDecode(msg)
			if data then
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
end
