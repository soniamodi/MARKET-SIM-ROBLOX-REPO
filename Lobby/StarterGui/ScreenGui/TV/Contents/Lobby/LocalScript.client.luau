local RS = game:GetService("ReplicatedStorage")
local PartyEvent = RS:WaitForChild("PartyEvent")
local Parties = RS:WaitForChild("Parties")



local createPartyButton = script.Parent:WaitForChild("CreateParty")
local scrollingFrame = script.Parent:WaitForChild("SF")
local templateLobby = scrollingFrame:WaitForChild("TemplateLobby")
local templateFrame = templateLobby:WaitForChild("TemplateFrame")


local templateJoined = script.Parent:WaitForChild("TemplateJoined")
local JoinedFrame = templateJoined:WaitForChild("TemplateFrame")
local playButton = JoinedFrame:WaitForChild("Play")
local leaveButton = templateJoined:WaitForChild("LeaveParty")

local images = JoinedFrame:WaitForChild("Images")
local left = images:WaitForChild("Left")
local center = images:WaitForChild("Center")
local right = images:WaitForChild("Right")

local leftArr = images:WaitForChild("LeftArr")
local rightArr = images:WaitForChild("RightArr")
local TextLabel = images:WaitForChild("TextLabel")

local levelIndex = JoinedFrame:WaitForChild("levelIndex").Value


local levelNames = {"Load Slot 1", "Load Slot 2"}
local levelImages = {117921732400828, 135237083734237}
local levelIDs = {73093455814152, 110531665465016}

local function freezefunc(player)
	leaveButton.deactivated.Value = true
	playButton.deactivated.Value = true
	JoinedFrame.deactivated.Value = true
	JoinedFrame.Creater.Disband.deactivated.Value = true
	JoinedFrame.P2.Kick.deactivated.Value = true
	JoinedFrame.P3.Kick.deactivated.Value = true
	JoinedFrame.P4.Kick.deactivated.Value = true
	rightArr.deactivated.Value = true
	leftArr.deactivated.Value = true
end

leaveButton.MouseButton1Click:Connect(function()
	local db = false
	if db == false and leaveButton.deactivated.Value == false then
		db = true
		local player = game.Players.LocalPlayer
		local partyName = JoinedFrame.Creater.Text .. "'s Party"
		local party = Parties:FindFirstChild(partyName)

		if player.Name == party:GetAttribute("Leader") then
			print("disbanding")
			PartyEvent:FireServer("DisbandParty", partyName, player, player)
			print("disbanded")
		else
			PartyEvent:FireServer("KickPlayer", partyName, player,player)
		end
		
		task.wait(0.4)
		db = false
	end
end)

createPartyButton.MouseButton1Click:Connect(function()
	local db = false
	if db == false and createPartyButton.deactivated.Value == false then
		db = true
		local player = game.Players.LocalPlayer
		local partyName = player.Name .. "'s Party"
		PartyEvent:FireServer("CreateParty",partyName, player)
		
		task.wait(0.4)
		db = false
	end	
end)

playButton.MouseButton1Click:Connect(function()
	local db = false
	if db == false and playButton.deactivated.Value == false then
		db = true
		local player = game.Players.LocalPlayer
		local partyName = JoinedFrame.Creater.Text .. "'s Party"
		PartyEvent:FireServer("Play",partyName, player, levelIDs[levelIndex])
		
		local p1 = JoinedFrame.Creater.Text
		local p2 = JoinedFrame.P2.Text
		local p3 = JoinedFrame.P3.Text
		local p4 = JoinedFrame.P4.Text
		if player == p1 then
			freezefunc(p1)
			freezefunc(p2)
			freezefunc(p3)
			freezefunc(p4)
		end
		
		
		task.wait(0.4)
		db = false
	end
end)






local kickButtons = JoinedFrame:GetChildren()
for _, frame in ipairs(kickButtons) do
	local kickButton = frame:FindFirstChild("Kick")
	if kickButton then
		kickButton.MouseButton1Click:Connect(function()
			local db = false
			if db == false and kickButton.deactivated.Value == false then
				db = true
				local target = kickButton.Parent.Text 
				local partyName = JoinedFrame.Creater.Text .. "'s Party" 
				PartyEvent:FireServer("KickPlayer", partyName, target) 
				task.wait(0.4)
				db = false
			end
		end)
	end
end

rightArr.MouseButton1Click:Connect(function()
	local db = false
	if db == false  and rightArr.deactivated.Value == false then
		db = true
		local partyName = JoinedFrame.Creater.Text .. "'s Party"
		PartyEvent:FireServer("Right",partyName)
		task.wait(0.4)
		db = false
	end
end)

leftArr.MouseButton1Click:Connect(function()
	local db = false
	if db == false and leftArr.deactivated.Value == false then
		db = true
		local partyName = JoinedFrame.Creater.Text .. "'s Party"
		PartyEvent:FireServer("Left",partyName)
		task.wait(0.4)
		db = false
	end
end)


local dButton = JoinedFrame:WaitForChild("Creater").Disband
if dButton then
		dButton.MouseButton1Click:Connect(function()
			local db = false
		if db == false  and dButton.deactivated.Value == false then
				db = true
				local target = dButton.Parent.Text  
				local partyName = JoinedFrame.Creater.Text .. "'s Party" 
				PartyEvent:FireServer("DisbandParty", partyName, target)  
				task.wait(0.4)
				db = false
			end
			
		end)
end





scrollingFrame.ChildAdded:Connect(function(child)
	if child:IsA("Frame") then
		local joinButton = child:FindFirstChild("Join")
		if joinButton then
			joinButton.MouseButton1Click:Connect(function()
				local player = game.Players.LocalPlayer.Name
				local db = false
				if db == false and joinButton.deactivated.Value == false then
					db = true
					local partyName = child:FindFirstChild("title").Text
					PartyEvent:FireServer("JoinParty", partyName, player)
					task.wait(0.4)
					db = false
				end
				
			end)
		end
	end
end)

local function updateLevel(party,levelIndex)
	local playerC = game.Players.LocalPlayer.Name
	local p1 = party:GetAttribute("Leader")
	local p2 = party:GetAttribute("P2")
	local p3 = party:GetAttribute("P3")
	local p4 = party:GetAttribute("P4")
	if(playerC == p1 or playerC == p2 or playerC == p3 or playerC == p4) then
		if levelIndex == 1 then
			center.Image = "https://www.roblox.com/asset/?id=" .. levelImages[levelIndex]
			left.Image = "https://www.roblox.com/asset/?id=" .. levelImages[#levelNames]
			right.Image = "https://www.roblox.com/asset/?id=" .. levelImages[levelIndex+1]
		elseif levelIndex == #levelNames then
			center.Image = "https://www.roblox.com/asset/?id=" .. levelImages[levelIndex]
			left.Image = "https://www.roblox.com/asset/?id=" .. levelImages[levelIndex-1]
			right.Image = "https://www.roblox.com/asset/?id=" .. levelImages[1]
		else
			center.Image = "https://www.roblox.com/asset/?id=" .. levelImages[levelIndex]
			left.Image = "https://www.roblox.com/asset/?id=" .. levelImages[levelIndex-1]
			right.Image = "https://www.roblox.com/asset/?id=" .. levelImages[levelIndex+1]
		end
		
		
		TextLabel.Text = levelNames[levelIndex]
	end
end



local function updatePartyList()
	for _, child in ipairs(scrollingFrame:GetChildren()) do
		if child:IsA("Frame") and child ~= templateFrame then
			child:Destroy()
		end
	end
	
	for _, party in ipairs(Parties:GetChildren()) do
		local newFrame = templateFrame:Clone()
		newFrame.Visible = true
		newFrame.Parent = scrollingFrame
		
		newFrame:FindFirstChild("title").Text = party.Name
		newFrame:FindFirstChild("playerCount").Text = party:GetAttribute("PlayerCount") .. "/4"
		
		local frameHeight = templateFrame.Size.Y.Offset
		local visibleFrames = #scrollingFrame:GetChildren()-1
		newFrame.Position = UDim2.new(0,0,0,frameHeight*(visibleFrames-1))
	end
	
	local totalFrames = #scrollingFrame:GetChildren() -1
	local frameHeight = templateFrame.Size.Y.Offset
	scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, frameHeight*totalFrames)

end




local function showJoin(party,player)
	local playerC = game.Players.LocalPlayer.Name
	if(party:GetAttribute("Leader")==playerC or party:GetAttribute("P2")==playerC or party:GetAttribute("P3")==playerC or party:GetAttribute("P4")==playerC) then
		scrollingFrame.Visible=false
		JoinedFrame.Visible=true
		JoinedFrame.Creater.Text = party:GetAttribute("Leader")
		JoinedFrame.P2.Text = party:GetAttribute("P2")
		JoinedFrame.P3.Text = party:GetAttribute("P3")
		JoinedFrame.P4.Text = party:GetAttribute("P4")
		createPartyButton.Visible = false
		if player == party:GetAttribute("Leader") and player == playerC then
			print(player .. "has been activated")
			JoinedFrame.Creater.Disband.Visible = true
			JoinedFrame.P2.Kick.Visible = true
			JoinedFrame.P3.Kick.Visible = true
			JoinedFrame.P4.Kick.Visible = true
			JoinedFrame.Play.deactivated.Value = false
			rightArr.deactivated.Value = false
			leftArr.deactivated.Value = false
			leaveButton.Visible = true
		elseif player == playerC and (player == party:GetAttribute("P2") or player == party:GetAttribute("P3") or player == party:GetAttribute("P4")) then
			print("joined")
			print(player .. "has been deactivated")
			JoinedFrame.Creater.Disband.Visible = false
			JoinedFrame.P2.Kick.Visible = false
			rightArr.deactivated.Value = true
			leftArr.deactivated.Value = true
			JoinedFrame.P3.Kick.Visible = false
			JoinedFrame.P4.Kick.Visible = false
			JoinedFrame.Play.deactivated.Value = true
			leaveButton.Visible = true
		end
	end
	
end

local function kickPlayer(target, party)
	local playerC = game.Players.LocalPlayer.Name
	if(target == playerC) then
		scrollingFrame.Visible = true
		JoinedFrame.Visible = false
		createPartyButton.Visible = true
		leaveButton.Visible = false
	end
end

local function disband(party)
	local p1 = party:GetAttribute("Leader")
	local p2 = party:GetAttribute("P2")
	local p3 = party:GetAttribute("P3")
	local p4 = party:GetAttribute("P4")
	kickPlayer(p1, party)
	kickPlayer(p2, party)
	kickPlayer(p3, party)
	kickPlayer(p4, party)
end



PartyEvent.OnClientEvent:Connect(function(action,party,player,target,levelIndex)
	if action == "UpdateParties" then
		showJoin(party,player)
		updateLevel(party,levelIndex)
		updatePartyList()
	elseif action == "JoinParty" then
		showJoin(party,player)
		updateLevel(party,levelIndex)
		updatePartyList()
	elseif action == "KickPlayer" then
		showJoin(party,player)	
		kickPlayer(target, party)
		updatePartyList()
	elseif action == "DisbandParty" then
		showJoin(party,player)
		disband(party)
		
	elseif action =="updateONLY" then
		updatePartyList()
	elseif action == "updateLevel" then
		updateLevel(party,levelIndex)	
	end
	
end)

updatePartyList()