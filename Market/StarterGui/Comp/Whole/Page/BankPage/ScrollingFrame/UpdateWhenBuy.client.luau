local RS = game:GetService("ReplicatedStorage")
local buyEvent = RS:WaitForChild("Purchase")
local Frame = script.Parent
local historyFrame = Frame:WaitForChild("Transaction History")
local balanceText = Frame:WaitForChild("balanceDisplay")
local frameNumber = historyFrame:WaitForChild("FrameNumber")
local frameTemplate = historyFrame:WaitForChild("TemplateEntry")
local depositEvent = RS:WaitForChild("Deposit")


local function updatePurchaseFrame(date, item, price, bOrS, newBalance)
	
	
	
	local newFrame = frameTemplate:Clone()
	newFrame.Parent = historyFrame
	newFrame.Name = "Frame" .. frameNumber.Value
	newFrame.Position = UDim2.new(0,0,0,0)
	frameNumber.Value += 25
	newFrame:WaitForChild("Date").Text = date
	newFrame:WaitForChild("Name").Text = item
	if(bOrS == "B") then
		newFrame:WaitForChild("Money").Text = "-" .. price
		newFrame:WaitForChild("Money").TextColor3 = Color3.fromRGB(255,0,0)
	elseif(bOrS == "S") then
		newFrame:WaitForChild("Money").Text = "+" .. price
		newFrame:WaitForChild("Money").TextColor3 = Color3.fromRGB(0,255,0)
	end
	for _, child in ipairs(historyFrame:GetChildren()) do
		if child:IsA("Frame") and child ~= newFrame and child.Name ~= "TemplateEntry" then
			child.Position = child.Position + UDim2.new(0, 0, 0, 25)
		end
	end
	newFrame.Visible = true
	historyFrame.CanvasSize += UDim2.new(0,0,0,25)
	balanceText.Text = "Balance: $" .. newBalance
end


buyEvent.OnClientEvent:Connect(function(date,item, price, bOrS, newBalance,file,sendToServ)
	if sendToServ == nil then sendToServ = true end
	if(sendToServ) then
		if(bOrS == "S") then
			buyEvent:FireServer(file, item, bOrS,"",1)
		end
	end
	updatePurchaseFrame(date,item,price,bOrS,newBalance)
end)

depositEvent.OnClientEvent:Connect(function(date,item,price,newBalance,sendToServ)
	if sendToServ == nil then sendToServ = true end
	updatePurchaseFrame(date,item,price,"S",newBalance)
	if(sendToServ) then
		print("deposit Saved:",item,price)
		depositEvent:FireServer(date,item,price,newBalance,"ATM")
	end
end)