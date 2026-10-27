local RS = game:GetService("ReplicatedStorage")
local updateInv = RS:WaitForChild("UpdateInventory")
local Workspace = game:GetService("Workspace")
local ServerStorage = game:GetService("ServerStorage")
local PathfindingService = game:GetService("PathfindingService")
local checkoutEvent = RS:WaitForChild("CheckoutCart")
local scanEvent = RS:WaitForChild("ItemScanned")
local WS = game:GetService("Workspace")
local customerWaypoints = WS:WaitForChild("CustomerWaypoints")
local spawnInterval = 5
local spawnChance = 0.5
local openEvent = RS:WaitForChild("ToggleOpen")
local Players = game:GetService("Players")

local arr = {}
local chances = {
	Beans = 0.8,
	Chips = 0.8,
	Chocolate = 0.7,
}
local sellFor = {
	Beans = 1.5,
	Chips = 5,
	Chocolate = 10
}

updateInv.Event:Connect(function(toDo, prod, slot)
	if toDo == "add" then
		table.insert(arr, {prod, false, slot})
		print("added:", prod.Name)
	elseif toDo == "remove" then
		for i, item in ipairs(arr) do
			if item[1] == prod then
				table.remove(arr, i)
				print("removed:", prod.Name)
				break
			end
		end
	end
end)




local function createList()
	local newList = {}
	for _, item in ipairs(arr) do
		local prod = item[1]
		local slot = item[3]
		local pos = slot.Position
		if item[2] == false and #newList < 5 and pos.X >= -50 and pos.X <= 50 and pos.Z >= -50 and pos.Z <= 50 then
			local chance = chances[prod.Name] or 0
			if math.random() <= chance then
				table.insert(newList, {prod, false, slot})
				item[2] = true
			end
		end
	end
	return newList
end

local function createWaypoint(slot)
	local distanceInFront = 2
	local position = slot.Position - slot.CFrame.LookVector * distanceInFront + Vector3.new(0, 0.5, 0)
	local waypoint = Instance.new("Part")
	waypoint.Size = Vector3.new(1, 1, 1)
	waypoint.Position = position
	waypoint.Anchored = true
	waypoint.CanCollide = false
	waypoint.Color = Color3.new(1, 0, 0)
	waypoint.Transparency = 1
	waypoint.Name = "Waypoint"
	waypoint.Parent = Workspace
	return waypoint
end

local function moveToWaypoint(humanoid, rootPart, waypoint,dont)
	local path = PathfindingService:CreatePath({
		AgentRadius = 2,
		AgentHeight = 5,
		AgentCanJump = true,
		AgentJumpHeight = 10,
		AgentMaxSlope = 45,
		PathfindingUseImprovedNavigation = true
	})
	path:ComputeAsync(rootPart.Position, waypoint.Position)
	if path.Status == Enum.PathStatus.Success then
		for _, waypointNode in ipairs(path:GetWaypoints()) do
			humanoid:MoveTo(waypointNode.Position)
			if waypointNode.Action == Enum.PathWaypointAction.Jump then
				humanoid.Jump = true
			end
			humanoid.MoveToFinished:Wait()
		end
		if waypoint and waypoint.Parent and not dont then
			waypoint:Destroy()
		end
	else
		print("failed find path to", waypoint.Name)
		if waypoint and waypoint.Parent then
			waypoint:Destroy()
		end
	end
end

local function moveThrough(humanoid,root)
	humanoid:MoveTo(customerWaypoints:FindFirstChild("Pos4").Position)
	humanoid.MoveToFinished:Wait()
	local waypointNames = {"Pos5", "Pos6","Pos7"}
	for _, wpName in ipairs(waypointNames) do
		local wpPart = customerWaypoints:FindFirstChild(wpName)
		if wpPart then
			moveToWaypoint(humanoid, root, wpPart,true)
		else
			warn("waypoint not found:", wpName)
		end
	end
end

local function findOpenRegisterSlot()
	local registersFolder = Workspace:FindFirstChild("Registers")
	if not registersFolder then
		warn("registers folder not found in workspace")
		return nil
	end

	for _, register in ipairs(registersFolder:GetChildren()) do
		for _, slot in ipairs(register:GetChildren()) do
			if slot.Name:match("^Slot%d+$") then 
				local valueObj = slot:FindFirstChild("Value")
				if valueObj and not valueObj.Value then
					print("going to slot:", register.Name, slot.Name)
					valueObj.Value = true
					return slot,register
				end
			end
		end
	end

	print("no available slots found.")
	return Workspace:WaitForChild("Exit"),nil
end

local function handleCheckout(humanoid, root, register, heldItems)
	print(register.Name)
	local start = register:FindFirstChild("End")
	local scan = register:FindFirstChild("Scan")
	if not start or not scan then
		warn("register missing start or scan part")
		return
	end

	local productsFolder = RS:WaitForChild("Products")
	local tempFolder = Instance.new("Folder")
	tempFolder.Name = "TempCheckoutItems"
	tempFolder.Parent = register

	local tired = false
	local checkoutFinished = false

	task.delay(60, function()
		if not checkoutFinished then
			tired = true
			print("dummy got tired waiting too long")
		end
	end)

	for i, prodName in ipairs(heldItems) do
		if tired then break end 

		local productTemplate = productsFolder:FindFirstChild(prodName)
		if not productTemplate then
			warn("product not found in ReplicatedStorage:", prodName)
			continue
		end

		local item = productTemplate:Clone()
		item.Parent = tempFolder
		item.CFrame = start.CFrame
		item.Anchored = false

		local checkedOut = false

		local connection
		connection = item.Touched:Connect(function(hit)
			if hit == scan then
				checkedOut = true
				print(prodName, "scanned and checked out.")
				connection:Disconnect()
				item:Destroy()
				scanEvent:Fire(register,prodName,sellFor[prodName])
			end
		end)

		local startTime = tick()
		while not checkedOut and not tired do
			task.wait(0.1)
		end

		if tired then
			break
		end
	end

	if tempFolder then
		tempFolder:Destroy()
	end

	local slot1 = register:FindFirstChild("Slot1")
	if slot1 and slot1:FindFirstChild("Value") then
		slot1.Value.Value = false
	end

	local exitPart = Workspace:WaitForChild("Exit")
	if exitPart then
		local waypoint = createWaypoint(exitPart)
		local sum = 0.0
		for _, prodName in ipairs(heldItems) do
			sum+=sellFor[prodName]
		end
		if tired then
			print("dummy dropped items bc tired and is leaving.")
			checkoutEvent:Fire(register,sum,"fail")
			local productsFolder = Workspace:FindFirstChild("Products")
			if not productsFolder then
				productsFolder = Instance.new("Folder")
				productsFolder.Name = "Products"
				productsFolder.Parent = Workspace
			end
			for _, prodName in ipairs(heldItems) do
				task.wait(0.1)
				local productTemplate = RS:WaitForChild("Products"):FindFirstChild(prodName)
				if productTemplate then
					local item = productTemplate:Clone()
					item.Parent = productsFolder
					item.CFrame = root.CFrame + Vector3.new(0, 0, 5)
					item.Anchored = false
				end
			end
		else
			print("dummy finished checkout, moving to exit.")
			checkoutFinished = true
			
			checkoutEvent:Fire(register,sum,"success")
		end

		task.spawn(function()
			moveThrough(humanoid, root)
			humanoid.Parent:Destroy()
		end)
	end
end

local function moveToSlot1EventDriven(humanoid, root, currentSlot, register, callback)
	local slotNumber = tonumber(currentSlot.Name:match("%d+"))
	if slotNumber == 1 then
		if callback then callback() end
		return
	end

	local nextSlot = register:FindFirstChild("Slot" .. (slotNumber - 1))
	if not nextSlot then
		if callback then callback() end
		return
	end

	local nextValue = nextSlot:FindFirstChild("Value")
	if not nextValue then
		if callback then callback() end
		return
	end

	if not nextValue.Value then
		currentSlot:FindFirstChild("Value").Value = false
		moveToWaypoint(humanoid, root, createWaypoint(nextSlot))
		nextValue.Value = true
		moveToSlot1EventDriven(humanoid, root, nextSlot, register, callback)
	else
		local conn
		conn = nextValue:GetPropertyChangedSignal("Value"):Connect(function()
			if not nextValue.Value then
				if conn then conn:Disconnect() end
				if humanoid.Parent then
					moveToSlot1EventDriven(humanoid, root, currentSlot, register, callback)
				end
			end
		end)
		humanoid.AncestryChanged:Connect(function(_, parent)
			if not parent then
				if conn then conn:Disconnect() end
			end
		end)
	end
end



local function spawnAndMove(rig,spawnPosition, listOfItems)
	

	local humanoid = rig:FindFirstChildOfClass("Humanoid")
	local root = rig.PrimaryPart
	if not humanoid or not root then
		warn("dummy must have humanoid and PrimaryPart")
		return
	end

	print("dummy spawned at", root.Position)

	local waypoints = {}
	for _, item in ipairs(listOfItems) do
		local waypoint = createWaypoint(item[3])
		table.insert(waypoints, {waypoint = waypoint, prod = item[1]})
	end

	local holding = {}

	for _, wpData in ipairs(waypoints) do
		local waypoint = wpData.waypoint
		local prod = wpData.prod

		moveToWaypoint(humanoid, root, waypoint)

		local productsFolder = Workspace:FindFirstChild("Products")
		if productsFolder then
			for _, product in ipairs(productsFolder:GetChildren()) do
				if product.Name == prod.Name and (product.Position - root.Position).Magnitude <= 5 then
					table.insert(holding, product.Name)
					print("picked up:", product.Name)
					local touchingParts = product:GetTouchingParts()
					for _, part in ipairs(touchingParts) do
						if part.Parent.Name == "Slots" then
							local valObj = part:FindFirstChild("Value")
							if valObj then
								valObj.Value = nil
							end
						end
					end
					task.wait(0.1)
					product:Destroy()
					break
				end
			end
		end
	end

	if #holding == 0 then
		local exitPart = Workspace:WaitForChild("Exit")
		local waypoint = createWaypoint(exitPart)
		moveToWaypoint(humanoid, root, waypoint,true)
		task.spawn(function()
			moveThrough(humanoid, root)
			rig:Destroy()
		end)

		print("dummy has no items, going to exit.")
		return
	end

	local slot, register = findOpenRegisterSlot()
	if slot.Name ~= "Exit" then
		moveToWaypoint(humanoid, root, createWaypoint(slot))

		moveToSlot1EventDriven(humanoid, root, slot, register, function()

			handleCheckout(humanoid, root, register, holding)
		end)


		
	else

		local productsFolder = Workspace:FindFirstChild("Products")
		if not productsFolder then
			productsFolder = Instance.new("Folder")
			productsFolder.Name = "Products"
			productsFolder.Parent = Workspace
		end
		task.wait(1)
		for _, prodName in ipairs(holding) do
			task.wait(0.3)
			local productTemplate = RS:WaitForChild("Products"):FindFirstChild(prodName)
			if productTemplate then
				local item = productTemplate:Clone()
				item.Parent = productsFolder
				item.CFrame = root.CFrame + Vector3.new(0,0,5)
				item.Anchored = false
			end
		end
		print("dummy reached exit and dropped items:", table.concat(holding, ", "))
		moveToWaypoint(humanoid, root, slot,true)
		task.spawn(function()
			moveThrough(humanoid, root)
			rig:Destroy()
		end)

	end
end








local function spawnCustomer()
	if math.random() > spawnChance then
		return
	end

	local dummyTemplate = ServerStorage:WaitForChild("Dummy")
	local rig = dummyTemplate:Clone()
	rig.Parent = Workspace
	local spawnPart = customerWaypoints:WaitForChild("Spawn")
	rig:SetPrimaryPartCFrame(spawnPart.CFrame + Vector3.new(0, 3, 0))
	rig.PrimaryPart.Anchored = false

	local humanoid = rig:FindFirstChildOfClass("Humanoid")
	local root = rig.PrimaryPart
	if not humanoid or not root then
		warn("dummy missing humanoid or PrimaryPart")
		return
	end
	
	local allPlayers = Players:GetPlayers()
	if #allPlayers > 0 then
		local randomPlayer = allPlayers[math.random(1, #allPlayers)]
		local userId = randomPlayer.UserId
		local success, description = pcall(function()
			return Players:GetHumanoidDescriptionFromUserId(userId)
		end)
		if success and description then
			humanoid:ApplyDescription(description)
		else
			warn("failed to get description for player:", randomPlayer.Name)
		end
	end
	
	local waypointNames = {"Pos1", "Pos2", "Pos3"}
	for _, wpName in ipairs(waypointNames) do
		local wpPart = customerWaypoints:FindFirstChild(wpName)
		if wpPart then
			moveToWaypoint(humanoid, root, wpPart,true)
		else
			warn("waypoint not found:", wpName)
		end
	end
	humanoid:MoveTo(customerWaypoints:FindFirstChild("Exit").Position)
	humanoid.MoveToFinished:Wait()

	local items = createList()

	spawnAndMove(rig,Vector3.new(0,0,0),items)
end


local open = false
openEvent.Event:Connect(function()
	print("opening or closing")
	open = not open
end)

while task.wait() do
	if open then
		task.wait(spawnInterval)
		task.spawn(function()
			spawnCustomer()
		end)
	end
end
