local RS = game:GetService("ReplicatedStorage")
local statsEvent = RS:WaitForChild("IncrementStats")
local home = script.Parent
local SF = home:WaitForChild("ScrollingFrame")
local days = SF:WaitForChild("Days")
local customers = SF:WaitForChild("Customers")

local da = 0
local cu = 0
statsEvent.OnClientEvent:Connect(function(d,c)
	da += d
	cu += c
	days.Text = "Total Days: " ..da
	customers.Text = "Customers Served: " .. cu
end)