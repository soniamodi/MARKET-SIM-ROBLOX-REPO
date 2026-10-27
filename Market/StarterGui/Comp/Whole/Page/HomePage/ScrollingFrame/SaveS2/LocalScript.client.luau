local RS = game:GetService("ReplicatedStorage")
local event = RS:WaitForChild("Save")

local button = script.Parent

button.MouseButton1Click:Connect(function(player)
	event:FireServer(2)
end)