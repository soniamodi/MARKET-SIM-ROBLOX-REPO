local camera = workspace.CurrentCamera

local fold = game.Workspace:WaitForChild("Cam Pos.")
local part = fold:WaitForChild("cameraPos")

camera.CameraType = Enum.CameraType.Scriptable

camera.CFrame = part.CFrame