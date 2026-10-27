local RS = game:GetService("ReplicatedStorage")
local toggleOpen = RS:WaitForChild("ToggleOpen")
local text = script.Parent
local gui = text.Parent
local part = gui.Parent
local prompt = part:WaitForChild("ProximityPrompt")

local open = false
prompt.Triggered:Connect(function(p)
	toggleOpen:Fire()
	open = not open
	if open then
		text.Text = "Open"
		text.TextColor3 = Color3.new(0, 0.666667, 0)
	else
		text.Text = "Closed"
		text.TextColor3 = Color3.new(170,0,0)
	end
end)