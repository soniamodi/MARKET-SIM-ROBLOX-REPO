local gui = script.Parent

local TV = gui:WaitForChild("TV")

local contents = TV:WaitForChild("Contents")

local Lobby = contents:WaitForChild("Lobby")
local Credits = contents:WaitForChild("Credits")

local Selection = TV:WaitForChild("Selection")

local PB = Selection:WaitForChild("Play")
local CB = Selection:WaitForChild("Credits")

local PBa = PB:WaitForChild("Active")
local CBa = CB:WaitForChild("Active")

PB.MouseButton1Click:Connect(function()
	PBa.Value = true
	CBa.Value = false
	Lobby.Visible = true
	Credits.Visible = false
end)
CB.MouseButton1Click:Connect(function()
	PBa.Value = false
	CBa.Value = true

	Lobby.Visible = false
	Credits.Visible = true

end)

local UIS = game:GetService("UserInputService")

local sound = script:WaitForChild("Sound")

UIS.InputBegan:Connect(function(input, gameProcessed)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		sound:Play()
	end
end)