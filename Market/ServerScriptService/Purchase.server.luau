local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local SS = game:GetService("ServerStorage")
local balance = SS:WaitForChild("Balance")
local purchaseEvent = RS:WaitForChild("Purchase")
local boxesFile = RS:WaitForChild("Boxes")
local boxWS = WS:WaitForChild("Boxes")
local chachingEvent = RS:WaitForChild("chaching")
local serverPurchase = RS:WaitForChild("ServerPurchase")

purchaseEvent.OnServerEvent:Connect(function(p, file, id, bOrS,boxType,quantity, stockCount)
	local fold = RS:WaitForChild(file)
	local copyTo = WS:WaitForChild(file)
	local item = fold:WaitForChild(id)
	local price = item:WaitForChild("Price").Value
	if(bOrS == "B") then
		if(balance.Value - price >=0 and stockCount>0) then
			chachingEvent:FireClient(p, true)
			local boxToClone = boxesFile:WaitForChild(boxType)
			local toWS = boxToClone:Clone()
			toWS.File.Value = file
			toWS.ID.Value = id
			toWS.Quantity.Value = quantity
			local sticker = toWS:WaitForChild("Sticker")
			local Gui = sticker:WaitForChild("SurfaceGui")
			local frame = Gui:WaitForChild("Frame")
			local IDLabel = frame:WaitForChild("ID")
			local QuantityLabel = frame:WaitForChild("Quantity")
			IDLabel.Text = id
			QuantityLabel.Text = "x" .. quantity
			toWS.Parent = boxWS
			price = price*quantity
			balance.Value-=price
			print(balance.Value)
			purchaseEvent:FireAllClients(os.date("%Y-%m-%d"),item.Name, price, "B", balance.Value,file)
			serverPurchase:Fire(file, id, bOrS,boxType,quantity)
		else
			chachingEvent:FireClient(p, false)
		end
	end	
end)
