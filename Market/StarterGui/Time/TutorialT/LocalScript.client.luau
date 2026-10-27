local UserInputService = game:GetService("UserInputService")

local text = script.Parent

local notMobile = UserInputService.KeyboardEnabled and not UserInputService.TouchEnabled

if not notMobile then
	text.Visible = false
end