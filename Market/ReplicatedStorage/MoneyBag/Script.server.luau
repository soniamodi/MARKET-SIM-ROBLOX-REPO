local RS = game:GetService("ReplicatedStorage")
local bag = script.Parent
local val = bag:WaitForChild("Money")
local bgui = bag:WaitForChild("BillboardGui")
local mText = bgui:WaitForChild("TextLabel")
local deposit = RS:WaitForChild("Deposit")
local SS = game:GetService("ServerStorage")
local balance = SS:WaitForChild("Balance")
local serverDeposit = RS:WaitForChild("ServerDeposit")

db = false
bag.Touched:Connect(function(hit)
	if(hit.Name == "Register") then
		if not db then
			db = true
			local holding = hit:WaitForChild("Holding")
			val.Value+=holding.Value
			holding.Value = 0.00
			mText.Text = "$"..val.Value
			local comp = hit:WaitForChild("Comp")
			local screen = comp:WaitForChild("Screen")
			local gui = screen:WaitForChild("SurfaceGui")
			local total = gui:WaitForChild("Total")
			local hold = total:WaitForChild("Holding")
			hold.Text = "$"..holding.Value
			task.wait(1)
			db = false
		end	
	else if(hit.Name=="ATM")then
			if not db then
				db = true
				local screen = hit:WaitForChild("Screen")
				local gui = screen:WaitForChild("SurfaceGui")
				local text = gui:WaitForChild("TextLabel")
				text.Visible = true
				balance.Value+=val.Value
				deposit:FireAllClients(os.date("%Y-%m-%d"),"Deposit", val.Value, balance.Value)
				serverDeposit:Fire(os.date("%Y-%m-%d"),"Deposit",val.Value,balance.Value,"ATM")
				val.Value = 0.00
				mText.Text = "$"..val.Value
				task.wait(2)
				text.Visible = false
				db = false
			end	
		end
	end
end)