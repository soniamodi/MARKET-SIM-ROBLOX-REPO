

local timerLabel = script.Parent
local interval = 300 

while task.wait(1) do
	local currentTime = os.time()
	local timeUntilNext = interval - (currentTime % interval)

	local minutes = math.floor(timeUntilNext / 60)
	local seconds = timeUntilNext % 60

	timerLabel.Text = string.format("STOCK RESETS IN: %02d:%02d", minutes, seconds)
end
