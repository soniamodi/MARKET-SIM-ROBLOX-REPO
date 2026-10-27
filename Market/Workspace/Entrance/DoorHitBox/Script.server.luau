local door1 = script.Parent.Parent:WaitForChild("Door1")
local door2 = script.Parent.Parent:WaitForChild("Door2")
local sound = script:WaitForChild("Sound")

local debounce = false

local hitBox = script.Parent

hitBox.Touched:Connect(function(hit)
	local character = hit.Parent
	local humanoid = character:FindFirstChild("Humanoid")
	if humanoid then
		if not debounce then
			debounce = true
			sound:Play()
			while(door1.Size.X>0.1) do
				door1.Size = door1.Size - Vector3.new(0.1,0,0)
				door2.Size = door2.Size - Vector3.new(0.1,0,0)
				door1.Position = door1.Position - Vector3.new(0.05,0,0)
				door2.Position = door2.Position + Vector3.new(0.05,0,0)
				task.wait(0.01)
			end
			task.wait(1)
			while(door1.Size.X<4) do
				door1.Size = door1.Size + Vector3.new(0.1,0,0)
				door2.Size = door2.Size + Vector3.new(0.1,0,0)
				door1.Position = door1.Position + Vector3.new(0.05,0,0)
				door2.Position = door2.Position - Vector3.new(0.05,0,0)
				task.wait(0.01)
			end
			debounce = false
		end
	end
end)