local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")

local toggleGo = RS:WaitForChild("ToggleGo")
local carsFolder = RS:WaitForChild("Cars") 
local spawnFolder = WS:WaitForChild("Cars")  
local car2Folder = RS:WaitForChild("Cars2")

local spawnInterval = 2

local go = true
toggleGo.Event:Connect(function()
	go = not go
end)

while true do
	task.wait(spawnInterval)
	if go then
		local carTemplates = carsFolder:GetChildren()
		if #carTemplates > 0 then
			local randomCar = carTemplates[math.random(1, #carTemplates)]:Clone()

			randomCar.Parent = spawnFolder
		end
		local carTemplates = car2Folder:GetChildren()
		if #carTemplates > 0 then
			local randomCar = carTemplates[math.random(1, #carTemplates)]:Clone()

			randomCar.Parent = spawnFolder
		end
	end
end
