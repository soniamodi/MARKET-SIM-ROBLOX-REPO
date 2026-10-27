local Lighting = game:GetService("Lighting")
local timerLabel = script.Parent
local dayLength = 300 

while task.wait(1) do
	local unix = os.time()
	local cyclePos = (unix % dayLength) / dayLength
	local timeOfDay = cyclePos * 24 

	local hour = math.floor(timeOfDay)
	local minute = math.floor((timeOfDay % 1) * 60)

	local suffix = "AM"
	if hour >= 12 then
		suffix = "PM"
	end

	if hour == 0 then
		hour = 12
	elseif hour > 12 then
		hour = hour - 12
	end

	timerLabel.Text = string.format("TIME: %02d:%02d %s", hour, minute, suffix)
end
