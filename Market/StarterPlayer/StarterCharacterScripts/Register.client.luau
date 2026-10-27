local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local unanchorEvent = RS:WaitForChild("UnanchorRequest")
local mobileUI = RS:WaitForChild("MobileUIClick")


UIS.JumpRequest:Connect(function()
		unanchorEvent:FireServer()
end)


mobileUI.Event:Connect(function(key)
	if key=="interact" then
		unanchorEvent:FireServer()
	end
end)