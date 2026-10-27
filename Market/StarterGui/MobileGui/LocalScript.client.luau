local UserInputService = game:GetService("UserInputService")

local gui = script.Parent

local notMobile = UserInputService.KeyboardEnabled and not UserInputService.TouchEnabled

if notMobile then
	gui.Enabled = false
end

