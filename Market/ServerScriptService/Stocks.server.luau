local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local restockEvent = RS:WaitForChild("Restock")  

local wallChances = { Wall1 = {9000,10}, Wall2 = {8000,10}, WoodFloor = {9000,10}, RubberRoof = {9000,10}, Light1 = {8000,6}, Window = {7000,10} }
local productChances = { Beans = {9000,10}, Chips = {9000,7}, Chocolate = {8000,4} }
local applianceChances = { Shelf1 = {9000,10}, Register = {9000,10} }
local decoreChances = {Vase1 = {6000,2}}

local function generateStock(chanceList)
	local currentTime = os.time()
	local blockLength = 300
	local blockID = math.floor(currentTime / blockLength)
	local rng = Random.new(blockID)

	local stock = {}
	for name, chance in pairs(chanceList) do
		local count = 0
		for i = 1, chance[2] do
			if rng:NextInteger(1, 10000) <= chance[1] then
				count = count + 1
			end
		end
		stock[name] = count
	end
	return stock
end

local function sendRestock()
	local wallStock = generateStock(wallChances)
	local productStock = generateStock(productChances)
	local applianceStock = generateStock(applianceChances)
	local decoreStock = generateStock(decoreChances)
	restockEvent:FireAllClients(wallStock, productStock, applianceStock,decoreStock)
	print("restock sent to all clients")
end

Players.PlayerAdded:Connect(function(player)
	task.wait(3)
	sendRestock()
end)

while true do
	local currentTime = os.time()
	local secondsUntilNext = 300 - (currentTime % 300)
	wait(secondsUntilNext)
	sendRestock()
end
