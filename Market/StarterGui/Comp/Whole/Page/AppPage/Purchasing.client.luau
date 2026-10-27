local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local pEvent = RS:WaitForChild("Purchase")
local restockEvent = RS:WaitForChild("Restock")
local page = script.Parent
local frame = page:WaitForChild("ScrollingFrame")


local items = {
	"Shelf1",
	"Register",
}

for _, itemName in ipairs(items) do
	local itemFrame = frame:WaitForChild(itemName)
	local button = itemFrame:WaitForChild("Buy")
	local stockCount = itemFrame:WaitForChild("Left")	
	local stockLabel = itemFrame:WaitForChild("Stock")
	
	local db = false
	button.MouseButton1Click:Connect(function()
		if db then return end
		db = true
		if stockCount.Value<1 then return end
		if itemName:match("^Shelf%d+$") then
			pEvent:FireServer("Shelves", itemName,"B", "LargeBox", 1, stockCount.Value)
		end
		if itemName:match("^Register%d+$") or itemName == "Register"  then
			pEvent:FireServer("Registers", itemName,"B", "LargeBox", 1, stockCount.Value)
		end
		
		task.wait(0.1)
		db = false
	end)



	stockCount:GetPropertyChangedSignal("Value"):Connect(function()
		local newValue = stockCount.Value
		local enabled = newValue > 0
		button.Active = enabled
		stockLabel.Text = newValue .. " LEFT!"
		button.TextColor3 = enabled and Color3.new(1,1,1) or Color3.fromRGB(128,128,128)
	end)

end

restockEvent.OnClientEvent:Connect(function(wallStock,productStock,applianceStock)
	print("restocking shelves")
	for name, quantity in pairs(applianceStock) do
		local itemFrame = frame:FindFirstChild(name)
		if itemFrame then
			local stockLabel = itemFrame:WaitForChild("Stock")
			stockLabel.Text = quantity .. " LEFT!"
			local stockCount = itemFrame:WaitForChild("Left")
			stockCount.Value = quantity
		end
	end
end)


pEvent.OnClientEvent:Connect(function(date,item, price, bOrS, newBalance,file)
	
	if(bOrS == "B") then
		if(file == "Shelves" or file == "Registers") then
			local Currframe = script.Parent.ScrollingFrame
			local item = Currframe:FindFirstChild(item)
			if(item) then
				local stockCount = item:WaitForChild("Left")
				stockCount.Value = stockCount.Value - 1
			end
		end
	end
end)