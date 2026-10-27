local s1 = script:WaitForChild("ChaChing")
local RS = game:GetService("ReplicatedStorage")
local event = RS:WaitForChild("chaching")
local s2 = script:WaitForChild("s2")
event.OnClientEvent:Connect(function(success)
	if success then
		s1:Play()
	else
		s2:Play()
	end
end)