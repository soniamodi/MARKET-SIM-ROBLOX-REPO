local car = script.Parent
local RS = game:GetService("ReplicatedStorage")
local toggleGo = RS:WaitForChild("ToggleGo")

local maxSpeed = 100
local minSpeed = 0
local maxDistance = 550
local continueThreshold = 250
local accel = 50
local decel = 50

local go = true
local currentSpeed = maxSpeed
local traveled = 0

local initialCFrame = car.CFrame
local forward = initialCFrame.LookVector 
car.Anchored = true 

toggleGo.Event:Connect(function()
	go = not go
end)

while true do
	local dt = task.wait()
	if not car.Parent then return end

	local targetSpeed
	if go then
		targetSpeed = maxSpeed
	else
		if traveled >= continueThreshold then
			targetSpeed = maxSpeed
		else
			targetSpeed = minSpeed
		end
	end

	if currentSpeed < targetSpeed then
		currentSpeed = math.min(currentSpeed + accel * dt, targetSpeed)
	else
		currentSpeed = math.max(currentSpeed - decel * dt, targetSpeed)
	end

	traveled += currentSpeed * dt
	if traveled >= maxDistance then
		car:Destroy()
		break
	end

	local newPos = initialCFrame.Position + forward * traveled
	car.CFrame = CFrame.new(newPos, newPos + forward)
end
