local RS = game:GetService("ReplicatedStorage")
local checkoutEvent = RS:WaitForChild("CheckoutCart") 
local scanEvent = RS:WaitForChild("ItemScanned")      
local beep = script:WaitForChild("Sound")
local GUI = script.Parent
local screen = GUI.Parent
local comp = screen.Parent
local reg = comp.Parent
local holdingVal = reg:WaitForChild("Holding")

local p1Frame = GUI:WaitForChild("p1Frame")
local p2Frame = GUI:WaitForChild("p2Frame")
local p3Frame = GUI:WaitForChild("p3Frame")
local p4Frame = GUI:WaitForChild("p4Frame")
local p5Frame = GUI:WaitForChild("p5Frame")

local p1Name, p1Price = p1Frame:WaitForChild("Name"), p1Frame:WaitForChild("Price")
local p2Name, p2Price = p2Frame:WaitForChild("Name"), p2Frame:WaitForChild("Price")
local p3Name, p3Price = p3Frame:WaitForChild("Name"), p3Frame:WaitForChild("Price")
local p4Name, p4Price = p4Frame:WaitForChild("Name"), p4Frame:WaitForChild("Price")
local p5Name, p5Price = p5Frame:WaitForChild("Name"), p5Frame:WaitForChild("Price")

local total = GUI:WaitForChild("Total")
local holdingText = total:WaitForChild("Holding")
local currText = total:WaitForChild("Current")

local slots = {
	{p1Name, p1Price},
	{p2Name, p2Price},
	{p3Name, p3Price},
	{p4Name, p4Price},
	{p5Name, p5Price}
}

local function getNextEmptySlot()
	for _, slot in ipairs(slots) do
		if slot[1].Text == "" then
			return slot[1], slot[2]
		end
	end
	return nil
end

local currVal = 0

scanEvent.Event:Connect(function(registerFired, prodName, price)
	if registerFired ~= reg then return end
	beep:Play()
	local nameLabel, priceLabel = getNextEmptySlot()
	if nameLabel and priceLabel then
		nameLabel.Text = prodName
		priceLabel.Text = string.format("+$%.2f", price)
	else
		warn("all product slots full")
	end

	currVal += price
	holdingVal.Value += price

	currText.Text = string.format("+$%.2f", currVal)
	holdingText.Text = string.format("Holding: $%.2f", holdingVal.Value)
end)

checkoutEvent.Event:Connect(function(registerFired, sum, sOrF)
	if registerFired ~= reg then return end

	for _, slot in ipairs(slots) do
		slot[1].Text = ""
		slot[2].Text = ""
	end
	
	if sOrF == "fail" then
		holdingVal.Value -= currVal
	end
	
	currVal = 0
	currText.Text = ""
	holdingText.Text = string.format("Holding: $%.2f", holdingVal.Value)
end)
