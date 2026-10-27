local Lighting = game:GetService("Lighting")
local RS = game:GetService("ReplicatedStorage")
local DayRun = RS:WaitForChild("DayRun")

local dayLength = 300 
local dawnTime = 6 / 24 * dayLength

local unix = os.time()
local currentCycle = math.floor(unix / dayLength)
local timeInCycle = unix % dayLength

local lastCycle = (timeInCycle >= dawnTime) and currentCycle or (currentCycle - 1)

while task.wait(0.1) do
	unix = os.time()
	local cyclePos = (unix % dayLength) / dayLength
	local timeOfDay = cyclePos * 24
	Lighting.ClockTime = timeOfDay

	if timeOfDay >= 6 and timeOfDay < 18 then
		Lighting.Brightness = 2
		Lighting.OutdoorAmbient = Color3.fromRGB(180, 180, 180)
	else
		Lighting.Brightness = 0.5
		Lighting.OutdoorAmbient = Color3.fromRGB(40, 40, 80)
	end

	currentCycle = math.floor(unix / dayLength)
	timeInCycle = unix % dayLength

	if timeInCycle >= dawnTime and lastCycle ~= currentCycle then
		lastCycle = currentCycle
		DayRun:Fire()
	end
end
