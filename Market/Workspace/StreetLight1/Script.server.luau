local RS = game:GetService("ReplicatedStorage")
local light = script.Parent
local green = light:WaitForChild("Green")
local yellow = light:WaitForChild("Yellow")
local red = light:WaitForChild("Red")
local toggleGo = RS:WaitForChild("ToggleGo")
local go = true
while true do
	if go then
		task.wait(60)
	else
		task.wait(30)
	end
	toggleGo:Fire()
	print("Toggled GO")
	go = not go
	if(go) then
		red.Material = Enum.Material.SmoothPlastic
		yellow.Material = Enum.Material.Neon
		task.wait(2)
		yellow.Material = Enum.Material.SmoothPlastic
		green.Material = Enum.Material.Neon
	else
		green.Material = Enum.Material.SmoothPlastic
		yellow.Material = Enum.Material.Neon
		task.wait(2)
		yellow.Material = Enum.Material.SmoothPlastic
		red.Material = Enum.Material.Neon
	end
end

