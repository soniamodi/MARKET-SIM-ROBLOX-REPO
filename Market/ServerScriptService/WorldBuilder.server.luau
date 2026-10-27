local Players = game:GetService("Players")
local teleportData
local leaderName
local loadSlot
local RS = game:GetService("ReplicatedStorage")
local saveEvent = RS:WaitForChild("Save")

local wallsBaseFolder = RS:WaitForChild("Walls")
local boxBaseFolder = RS:WaitForChild("Boxes")
local productsBaseFolder = RS:WaitForChild("Products")
local shelvesBaseFolder = RS:WaitForChild("Shelves")
local registersBaseFolder = RS:WaitForChild("Registers")
local decoreBaseFolder = RS:WaitForChild("Decore")

local WS = game:GetService("Workspace")
local wallFolder = WS:WaitForChild("Walls")
local boxFolder = WS:WaitForChild("Boxes")
local productsFolder = WS:WaitForChild("Products")
local shelvesFolder = WS:WaitForChild("Shelves")
local registersFolder = WS:WaitForChild("Registers")
local decoreFolder = WS:WaitForChild("Decore")

local purchaseEvent = RS:WaitForChild("Purchase")
local purchaseServerEvent = RS:WaitForChild("ServerPurchase")
local SS = game:GetService("ServerStorage")
local currentBalance = SS:WaitForChild("Balance")
local clearSlotEvent = RS:WaitForChild("ClearSlot")
local DataStoreService = game:GetService("DataStoreService")
local depositEvent = RS:WaitForChild("Deposit")
local depositServerEvent = RS:WaitForChild("ServerDeposit")
local dayEvent = RS:WaitForChild("DayRun")
local checkOutEvent = RS:WaitForChild("CheckoutCart")
local incrementStatsEvent= RS:WaitForChild("IncrementStats")

clearSlotEvent.OnServerEvent:Connect(function(p, slot)
	local boxes = DataStoreService:GetDataStore("Slot"..slot, "Boxes")
	local walls = DataStoreService:GetDataStore("Slot"..slot, "Walls")
	local transactions = DataStoreService:GetDataStore("Slot"..slot, "TransactionHistory")
	local products = DataStoreService:GetDataStore("Slot"..slot, "Products")
	local money = DataStoreService:GetDataStore("Slot"..slot, "Money")
	local shelves = DataStoreService:GetDataStore("Slot"..slot, "Shelves")
	local registers = DataStoreService:GetDataStore("Slot"..slot, "Registers") 
	local stat = DataStoreService:GetDataStore("Slot"..slot, "Stats") 
	local decore = DataStoreService:GetDataStore("Slot"..slot, "Decore")
	boxes:RemoveAsync(p.UserId)
	walls:RemoveAsync(p.UserId)
	transactions:RemoveAsync(p.UserId)
	money:RemoveAsync(p.UserId)
	shelves:RemoveAsync(p.UserId)
	stat:RemoveAsync(p.UserId)
	registers:RemoveAsync(p.UserId)
	products:RemoveAsync(p.UserId)
	decore:RemoveAsync(p.UserId)
	print("cleared " .. slot)
end)


local transactionHistory = {}

purchaseServerEvent.Event:Connect(function(file, id, bOrS,boxType, quantity)
	local price = RS:WaitForChild(file):WaitForChild(id):WaitForChild("Price").Value
	if(bOrS == "S") then
		price = price*0.75
	else
		price = price*quantity
	end
	local toBeAddedToArray = {os.date("%Y-%m-%d"),id,price,bOrS,file}
	table.insert(transactionHistory,toBeAddedToArray)
	
end)

depositServerEvent.Event:Connect(function(date,item,price,newBalance,file) 
	print("Deposit saved:", item, price)
	local toBeAddedToArray = {os.date("%Y-%m-%d"),item,price,"S","ATM"}
	table.insert(transactionHistory,toBeAddedToArray)
	print("Deposit saved:", (toBeAddedToArray[2]), (toBeAddedToArray[3]))
end)

local statHistory = {0,0}
dayEvent.Event:Connect(function()
	statHistory[1]+=1
	incrementStatsEvent:FireAllClients(statHistory[1],statHistory[2])
	print("Days/Customeres: ", statHistory[1],statHistory[2])
end)
checkOutEvent.Event:Connect(function(r,s,sOrF)
	if sOrF == "success" then
		statHistory[2]+=1
		incrementStatsEvent:FireAllClients(statHistory[1],statHistory[2])
	end
end)

local function buildStatsHistory(historyToBuild)
	if not historyToBuild then return end
	print("D/C: ", historyToBuild[1],historyToBuild[0])
	task.wait(2)
	statHistory = historyToBuild
	incrementStatsEvent:FireAllClients(statHistory[1],statHistory[2])
end

local function buildTransactionHistory(historyToBuild)
	if not historyToBuild then return end
	task.wait(2)
	for _, transactionInfo in ipairs(historyToBuild) do
		local date = transactionInfo[1]
		local name = transactionInfo[2]
		local price = transactionInfo[3]
		local bOrS = transactionInfo[4]
		local file = transactionInfo[5]
		if file == "ATM" then
			local depositItem = transactionInfo[2]  
			local depositPrice = transactionInfo[3] 
			print("Deposit loaded:", (transactionInfo[2]), (transactionInfo[3]))
			depositEvent:FireAllClients(date, depositItem, depositPrice, currentBalance.Value, false)
		else
			print("the file is"..file)
			purchaseEvent:FireAllClients(date, name, price, bOrS, currentBalance.Value, file,false)
		end
	end
end

local function buildWalls(wallsToBuild)
	if not wallsToBuild then return end
	for _, wallInfo in ipairs(wallsToBuild) do
		local wallID = wallInfo.Name or wallInfo[1]
		local cfTable = wallInfo.CFrame or wallInfo[2]
		local anchored = wallInfo.Anchored

		if wallID and cfTable and type(cfTable) == "table" then
			local wallToClone = wallsBaseFolder:FindFirstChild(wallID)
			if wallToClone then
				wallToClone = wallToClone:Clone()
				wallToClone.CFrame = CFrame.new(table.unpack(cfTable))
				wallToClone.Anchored = anchored == true 
				wallToClone.Parent = wallFolder
			else
				warn("wall not found in base folder:", wallID)
			end
		else
			warn("invalid wallInfo format:", wallInfo)
		end
	end
end

local function buildDecore(decoreToBuild)
	if not decoreToBuild then return end
	for _, decoreInfo in ipairs(decoreToBuild) do
		local decoreID = decoreInfo.Name or decoreInfo[1]
		local cfTable = decoreInfo.CFrame or decoreInfo[2]
		local anchored = decoreInfo.Anchored

		if decoreID and cfTable and type(cfTable) == "table" then
			local decoreToClone = decoreBaseFolder:FindFirstChild(decoreID)
			if decoreToClone then
				decoreToClone = decoreToClone:Clone()
				decoreToClone.CFrame = CFrame.new(table.unpack(cfTable))
				decoreToClone.Anchored = anchored == true 
				decoreToClone.Parent = decoreFolder
			else
				warn("decore not found in base folder:", decoreID)
			end
		else
			warn("invalid decoreInfo format:", decoreInfo)
		end
	end
end

local function buildShelves(shelvesToBuild)
	if not shelvesToBuild then return end
	for _, shelfInfo in ipairs(shelvesToBuild) do
		local shelfID = shelfInfo.Name or shelfInfo[1]
		local cfTable = shelfInfo.CFrame or shelfInfo[2]
		local anchored = shelfInfo.Anchored

		if shelfID and cfTable and type(cfTable) == "table" then
			local shelfToClone = shelvesBaseFolder:FindFirstChild(shelfID)
			if shelfToClone then
				shelfToClone = shelfToClone:Clone()
				shelfToClone.CFrame = CFrame.new(table.unpack(cfTable))
				shelfToClone.Anchored = anchored == true 
				shelfToClone.Parent = shelvesFolder
			else
				warn("shelf not found in base folder:", shelfID)
			end
		else
			warn("invalid shelfInfo format:", shelfInfo)
		end
	end
end

local function buildRegisters(registersToBuild)
	if not registersToBuild then return end
	for _, registerInfo in ipairs(registersToBuild) do
		local registerID = registerInfo.Name or registerInfo[1]
		local cfTable = registerInfo.CFrame or registerInfo[2]
		local anchored = registerInfo.Anchored

		if registerID and cfTable and type(cfTable) == "table" then
			local registerToClone = registersBaseFolder:FindFirstChild(registerID)
			if registerToClone then
				registerToClone = registerToClone:Clone()
				registerToClone.CFrame = CFrame.new(table.unpack(cfTable))
				registerToClone.Anchored = anchored == true 
				registerToClone.Parent = registersFolder
			else
				warn("register not found in base folder:", registerID)
			end
		else
			warn("invalid shelfInfo format:", registerInfo)
		end
	end
end

local function buildProducts(productsToBuild)
	if not productsToBuild then return end
	for _, productInfo in ipairs(productsToBuild) do
		local productID = productInfo.Name or productInfo[1]
		local cfTable = productInfo.CFrame or productInfo[2]
		
		if productID and cfTable and type(cfTable) == "table" then
			local productToClone = productsBaseFolder:FindFirstChild(productID)
			if productToClone then
				productToClone = productToClone:Clone()
				productToClone.CFrame = CFrame.new(table.unpack(cfTable))
				productToClone.Parent = productsFolder
			else
				warn("product not found in base folder:", productID)
			end
		else
			warn("invalid product format:", productInfo)
		end
	end
end

local function buildBoxes(boxesToBuild)
	if not boxesToBuild then return end
	for _, boxInfo in ipairs(boxesToBuild) do
		local boxType = boxInfo.TypeOfBox
		local boxFile = boxInfo.FileName
		local boxID = boxInfo.ID
		local boxQuant = boxInfo.Quantity
		local cfTable = boxInfo.CFrame

		if boxType and cfTable and type(cfTable) == "table" then
			local boxToClone = boxBaseFolder:FindFirstChild(boxType)
			if boxToClone then
				boxToClone = boxToClone:Clone()
				local Parts = boxToClone:WaitForChild("Parts")
				local part = Parts:WaitForChild("Part")
				part.CFrame = CFrame.new(table.unpack(cfTable))
				boxToClone.File.Value = boxFile
				boxToClone.ID.Value = boxID
				boxToClone.Quantity.Value = boxQuant
				local sticker = boxToClone:WaitForChild("Sticker")
				local Gui = sticker:WaitForChild("SurfaceGui")
				local frame = Gui:WaitForChild("Frame")
				local IDLabel = frame:WaitForChild("ID")
				local QuantityLabel = frame:WaitForChild("Quantity")
				IDLabel.Text = boxID
				QuantityLabel.Text = "x" .. boxQuant
				boxToClone.Parent = boxFolder
			else
				warn("box not found in base folder:", boxType)
			end
		else
			warn("invalid boxInfo format:", boxInfo)
		end
	end
end

local leader
local DataStoreService = game:GetService("DataStoreService")
local Slot1 = DataStoreService:GetDataStore("Slot1")
local Slot2 = DataStoreService:GetDataStore("Slot2")
local Walls
local TransactionSave
local MoneySave
local BoxSave
local ProductsSave
local ShelfSave
local RegisterSave
local StatsSave
local DecoreSave


Players.PlayerAdded:Connect(function(player)
	if not teleportData then
		local joinData = player:GetJoinData()
		teleportData = joinData.TeleportData
		leaderName = teleportData.leader
		loadSlot = teleportData.loadSlot
		print("Received TeleportData:", teleportData)
		if(loadSlot == 1) then
			Walls = DataStoreService:GetDataStore("Slot1", "Walls")
			TransactionSave = DataStoreService:GetDataStore("Slot1", "TransactionHistory")
			MoneySave = DataStoreService:GetDataStore("Slot1", "Money")
			BoxSave = DataStoreService:GetDataStore("Slot1", "Boxes")
			ProductsSave = DataStoreService:GetDataStore("Slot1", "Products")
			ShelfSave = DataStoreService:GetDataStore("Slot1", "Shelves")
			DecoreSave = DataStoreService:GetDataStore("Slot1", "Decore")
			RegisterSave = DataStoreService:GetDataStore("Slot1", "Registers")
			StatsSave = DataStoreService:GetDataStore("Slot1", "Stats")
		elseif loadSlot == 2 then
			Walls = DataStoreService:GetDataStore("Slot2", "Walls")
			TransactionSave = DataStoreService:GetDataStore("Slot2", "TransactionHistory")
			MoneySave = DataStoreService:GetDataStore("Slot2", "Money")
			BoxSave = DataStoreService:GetDataStore("Slot2", "Boxes")
			ProductsSave = DataStoreService:GetDataStore("Slot2", "Products")
			ShelfSave = DataStoreService:GetDataStore("Slot2", "Shelves")
			RegisterSave = DataStoreService:GetDataStore("Slot2", "Registers")
			StatsSave = DataStoreService:GetDataStore("Slot2", "Stats")
			DecoreSave = DataStoreService:GetDataStore("Slot2", "Decore")
		end
	end
	if(player.Name == leaderName) then
		leader = player
	end
	local needStarter = true
	if player.Name == leaderName then
		local success, wallsToBuild = pcall(function()
			return Walls:GetAsync(player.UserId)
		end)
		if success and wallsToBuild then
			print("Loaded walls data for player:", player.Name, wallsToBuild)
			needStarter = false
			buildWalls(wallsToBuild)
		else
			print("No walls data found or error loading for", player.Name)
		end
		
		local success, decoreToBuild = pcall(function()
			return DecoreSave:GetAsync(player.UserId)
		end)
		if success and decoreToBuild then
			print("loaded decore data for player:", player.Name, decoreToBuild)
			needStarter = false
			buildDecore(decoreToBuild)
		else
			print("no decore data found or error loading for", player.Name)
		end
		
		local success, moneyToBuild = pcall(function()
			return MoneySave:GetAsync(player.UserId)
		end)
		if success and moneyToBuild then
			print("loaded money for player:", player.Name)
			needStarter = false
			currentBalance.Value = moneyToBuild
			print(currentBalance.Value)
		else
			print("no money or error loading for ", player.Name)
			currentBalance.Value = 900
		end
		
		local success, statsToBuild = pcall(function()
			return StatsSave:GetAsync(player.UserId)
		end)
		if success and statsToBuild then
			print("loaded stats for player:", player.Name)
			
			buildStatsHistory(statsToBuild)
		else
			print("no stats or error loading for ", player.Name)
		end
		
		local success, shelvesToBuild = pcall(function()
			return ShelfSave:GetAsync(player.UserId)
		end)
		if success and shelvesToBuild then
			needStarter = false
			print("loaded shelf data for player:", player.Name, shelvesToBuild)
			buildShelves(shelvesToBuild)
		else
			print("no shelf data found or error loading for", player.Name)
		end
		
		local success, registersToBuild = pcall(function()
			return RegisterSave:GetAsync(player.UserId)
		end)
		if success and registersToBuild then
			needStarter = false
			print("loaded register data for player:", player.Name, registersToBuild)
			buildRegisters(registersToBuild)
		else
			print("no register data found or error loading for", player.Name)
		end
		
		local success, productsToBuild = pcall(function()
			return ProductsSave:GetAsync(player.UserId)
		end)
		if success and productsToBuild then
			needStarter = false
			print("loaded product data for player:", player.Name, productsToBuild)
			buildProducts(productsToBuild)
		else
			print("no product data found or error loading for", player.Name)
		end
		
		local success, historyToBuild = pcall(function()
			return TransactionSave:GetAsync(player.UserId)
		end)
		
		if success and historyToBuild then
			needStarter = false
			print("loaded history for player:", player.Name)
			transactionHistory = historyToBuild
			buildTransactionHistory(historyToBuild)
		else
			print("no history or error loading for ", player.Name)
		end
		
		local success, boxesToBuild = pcall(function()
			return BoxSave:GetAsync(player.UserId)
		end)
		if success and boxesToBuild then
			needStarter = false
			print("loaded box data for player:", player.Name, boxesToBuild)
			buildBoxes(boxesToBuild)
		else
			print("no box data found or error loading for", player.Name)
		end
		
		if needStarter then
			local StarterFolder = RS:WaitForChild("StarterWalls")
			for i, starterItem in ipairs(StarterFolder:GetChildren()) do
				local cloned = starterItem:Clone()
				cloned.Parent = wallFolder
			end

		end
		
	else
		print("NOT THE RIGHT PLAYER")
	end
end)









saveEvent.OnServerEvent:Connect(function(player, Slot)
	local walls = {}

	for _, child in ipairs(wallFolder:GetChildren()) do
		if child:IsA("Part") or child:IsA("MeshPart") or child:IsA("Model") or child:IsA("UnionOperation") then
			table.insert(walls, {
				Name = child.Name,
				CFrame = {child.CFrame:GetComponents()}, 
				Anchored = child.Anchored
			})
		end
	end
	
	local decores = {}

	for _, child in ipairs(decoreFolder:GetChildren()) do
		if child:IsA("Part") or child:IsA("MeshPart") or child:IsA("Model") or child:IsA("UnionOperation") then
			table.insert(decores, {
				Name = child.Name,
				CFrame = {child.CFrame:GetComponents()}, 
				Anchored = child.Anchored
			})
		end
	end
	
	local shelves = {}

	for _, child in ipairs(shelvesFolder:GetChildren()) do
		if child:IsA("Part") or child:IsA("MeshPart") or child:IsA("Model") or child:IsA("UnionOperation") then
			table.insert(shelves, {
				Name = child.Name,
				CFrame = {child.CFrame:GetComponents()},
				Anchored = child.Anchored
			})
		end
	end

	local registers = {}

	for _, child in ipairs(registersFolder:GetChildren()) do
		if child:IsA("Part") or child:IsA("MeshPart") or child:IsA("Model") or child:IsA("UnionOperation") then
			table.insert(registers, {
				Name = child.Name,
				CFrame = {child.CFrame:GetComponents()}, 
				Anchored = child.Anchored
			})
		end
	end
	
	local products = {}

	for _, child in ipairs(productsFolder:GetChildren()) do
		if child:IsA("MeshPart") or child:IsA("Part") or child:IsA("Model") or child:IsA("UnionOperation") then
			table.insert(products, {
				Name = child.Name,
				CFrame = {child.CFrame:GetComponents()}, 
			})
		end
	end
	
	local boxes = {}
	for _, child in ipairs(boxFolder:GetChildren()) do
		if child:IsA("MeshPart") or child:IsA("Part") or child:IsA("Model") or child:IsA("UnionOperation") then
			local Parts = child:WaitForChild("Parts")
			local part = Parts:WaitForChild("Part")
			table.insert(boxes, {
				TypeOfBox = child.Name,
				FileName = child.File.Value,
				ID = child.ID.Value,
				Quantity = child.Quantity.Value,
				CFrame = {part.CFrame:GetComponents()}
			})
		end
	end
	
	local SlotToSaveTo
	if(Slot == 1) then
		SlotToSaveTo = "Slot1"
	elseif(Slot == 2) then
		SlotToSaveTo = "Slot2"
	end
	
	
	local BoxesToSaveTo = DataStoreService:GetDataStore(SlotToSaveTo, "Boxes")
	local success, result = pcall(function()
		return BoxesToSaveTo:UpdateAsync(player.UserId, function(oldData)
			return boxes
		end)
	end)

	if success then
		print("boxes updated for", player.Name, BoxesToSaveTo)
	else
		warn("failed to update boxes for", player.Name, result)
	end
	
	
	--saving walls
	local WallsToSaveTo = DataStoreService:GetDataStore(SlotToSaveTo, "Walls")
	local success, result = pcall(function()
		return WallsToSaveTo:UpdateAsync(player.UserId, function(oldData)
			return walls
		end)
	end)

	if success then
		print("walls updated for", player.Name, WallsToSaveTo)
	else
		warn("failed to update walls for", player.Name, result)
	end
	
	local DecoreToSaveTo = DataStoreService:GetDataStore(SlotToSaveTo, "Decore")
	local success, result = pcall(function()
		return DecoreToSaveTo:UpdateAsync(player.UserId, function(oldData)
			return decores
		end)
	end)

	if success then
		print("decore updated for", player.Name, DecoreToSaveTo)
	else
		warn("failed to update decore for", player.Name, result)
	end
	
	--saving shelves
	local ShelvesToSaveTo = DataStoreService:GetDataStore(SlotToSaveTo, "Shelves")
	local success, result = pcall(function()
		return ShelvesToSaveTo:UpdateAsync(player.UserId, function(oldData)
			return shelves
		end)
	end)

	if success then
		print("shelves updated for", player.Name, ShelvesToSaveTo)
	else
		warn("failed to update shelves for", player.Name, result)
	end
	
	--saving registers
	local RegistersToSaveTo = DataStoreService:GetDataStore(SlotToSaveTo, "Registers")
	local success, result = pcall(function()
		return RegistersToSaveTo:UpdateAsync(player.UserId, function(oldData)
			return registers
		end)
	end)

	if success then
		print("registers updated for", player.Name, RegistersToSaveTo)
	else
		warn("failed to update registers for", player.Name, result)
	end
	
	local ProductsToSaveTo = DataStoreService:GetDataStore(SlotToSaveTo, "Products")
	local success, result = pcall(function()
		return ProductsToSaveTo:UpdateAsync(player.UserId, function(oldData)
			return products
		end)
	end)

	if success then
		print("products updated for", player.Name, WallsToSaveTo)
	else
		warn("failed to update products for", player.Name, result)
	end
	
	local transactionToSaveTo = DataStoreService:GetDataStore(SlotToSaveTo, "TransactionHistory")
	local success, result = pcall(function()
		return transactionToSaveTo:UpdateAsync(player.UserId, function(oldData)
			return transactionHistory
		end)
	end)
	if success then
		print("history updated for", player.Name)
	else
		warn("failed to update history for", player.Name, result)
	end
	
	local statsToSaveTo = DataStoreService:GetDataStore(SlotToSaveTo, "Stats")
	local success, result = pcall(function()
		return statsToSaveTo:UpdateAsync(player.UserId, function(oldData)
			return statHistory
		end)
	end)
	if success then
		print("stats updated for", player.Name)
	else
		warn("failed to update stats for", player.Name, result)
	end
	
	--saving current money
	local moneyToSaveTo = DataStoreService:GetDataStore(SlotToSaveTo, "Money")
	local success, result = pcall(function()
		return moneyToSaveTo:UpdateAsync(player.UserId, function(oldData)
			return currentBalance.Value
		end)
	end)
	if success then
		print("money updated for", player.Name)
	else
		warn("failed to update money for", player.Name, result)
	end
end)
