local tutGui = script.Parent
local WS = game:GetService("Workspace")
local tutBlocks = WS:WaitForChild("Tutorial")
local UserInputService = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local mobileEvent = RS:WaitForChild("MobileUIClick")

local playerGuis = tutGui.Parent
local notifGui = playerGuis:WaitForChild("NotifGui")

local current = tutGui:WaitForChild("CurrentFrame")

local on = false

local frames = {}
local blocks = {}

for i = 1, 8 do
	frames[i] = tutGui:WaitForChild(tostring(i))
	blocks[i] = tutBlocks:WaitForChild("Tut" .. i)
end

local function hideAllFrames()
	for _, f in pairs(frames) do
		f.Visible = false
	end
end

local function showFrame(i)
	hideAllFrames()
	frames[i].Visible = true
	notifGui.Adornee = blocks[i]
end

mobileEvent.Event:Connect(function(button)
	local cur = current.Value
	if(button=="help") then
		if not on then
			on = true
			showFrame(cur)
			notifGui.Enabled = true
		else
			on = false
			hideAllFrames()
			notifGui.Enabled = false
		end
	end
	
	if not on then return end
	
	if(button == "right") then
		cur += 1
		if cur > 8 then
			cur = 1
		end
		current.Value = cur
		showFrame(cur)
	end
	
	if(button=="left") then
		cur -= 1
		if cur < 1 then
			cur = 8
		end
		current.Value = cur
		showFrame(cur)
	end
	
end)