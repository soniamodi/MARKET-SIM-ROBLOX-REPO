local clickDetector = script.Parent
local button = script.Parent.Parent
local sound = script:WaitForChild("Sound")
local RS = game:GetService("ReplicatedStorage")
local truck = RS:WaitForChild("Truck1")
local WS = game:GetService("Workspace")

db= false
clickDetector.MouseClick:Connect(function()
	if not db then
		db = true
		button.Position -= Vector3.new(0,0.2,0)
		sound:Play()
		local toDestroy = WS:FindFirstChild("Truck1")
		if toDestroy == nil then
			local toMove = truck:Clone()
			toMove.Parent = WS
			task.wait(0.1)

			button.Position += Vector3.new(0,0.2,0)
			db=false
		else
			toDestroy:Destroy()
			local toMove = truck:Clone()
			toMove.Parent = WS
			task.wait(0.1)

			button.Position += Vector3.new(0,0.2,0)
			db=false
		end
		
	end
	
end)