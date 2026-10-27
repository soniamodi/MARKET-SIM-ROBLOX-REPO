local tabGroup = script.Parent

local appButton = tabGroup:WaitForChild("Apps")
local bankButton = tabGroup:WaitForChild("Bank")
local decoreButton = tabGroup:WaitForChild("Decore")
local supplyButton = tabGroup:WaitForChild("Supply")
local homeButton = tabGroup:WaitForChild("Home")
local wallButton = tabGroup:WaitForChild("Walls")

local GUI = tabGroup.Parent

local page = GUI:WaitForChild("Page")

local appPage = page:WaitForChild("AppPage")
local decorePage = page:WaitForChild("DecorePage")
local supplyPage = page:WaitForChild("SupplyPage")
local wallPage = page:WaitForChild("WallPage")
local bankPage = page:WaitForChild("BankPage")
local homePage = page:WaitForChild("HomePage")

appButton.MouseButton1Click:Connect(function()
	if not appPage.Visible then
		homePage.Visible = false
		decorePage.Visible = false
		supplyPage.Visible = false
		wallPage.Visible = false
		bankPage.Visible = false
		appPage.Visible = true
		
		homeButton.BackgroundColor3 = Color3.fromRGB(75,75,75)
		decoreButton.BackgroundColor3 = Color3.fromRGB(75,75,75)
		supplyButton.BackgroundColor3 = Color3.fromRGB(75,75,75)
		wallButton.BackgroundColor3 = Color3.fromRGB(75,75,75)
		bankButton.BackgroundColor3 = Color3.fromRGB(75,75,75)
		appButton.BackgroundColor3 = Color3.fromRGB(129, 129, 129)
	end
end)

decoreButton.MouseButton1Click:Connect(function()
	if not decorePage.Visible then
		homePage.Visible = false
		decorePage.Visible = true
		supplyPage.Visible = false
		wallPage.Visible = false
		bankPage.Visible = false
		appPage.Visible = false

		homeButton.BackgroundColor3 = Color3.fromRGB(75,75,75)
		decoreButton.BackgroundColor3 = Color3.fromRGB(129,129,129)
		supplyButton.BackgroundColor3 = Color3.fromRGB(75,75,75)
		wallButton.BackgroundColor3 = Color3.fromRGB(75,75,75)
		bankButton.BackgroundColor3 = Color3.fromRGB(75,75,75)
		appButton.BackgroundColor3 = Color3.fromRGB(75,75,75)
	end
end)

homeButton.MouseButton1Click:Connect(function()
	if not homePage.Visible then
		homePage.Visible = true
		decorePage.Visible = false
		supplyPage.Visible = false
		wallPage.Visible = false
		bankPage.Visible = false
		appPage.Visible = false

		homeButton.BackgroundColor3 = Color3.fromRGB(129,129,129)
		decoreButton.BackgroundColor3 = Color3.fromRGB(75,75,75)
		supplyButton.BackgroundColor3 = Color3.fromRGB(75,75,75)
		wallButton.BackgroundColor3 = Color3.fromRGB(75,75,75)
		bankButton.BackgroundColor3 = Color3.fromRGB(75,75,75)
		appButton.BackgroundColor3 = Color3.fromRGB(75,75,75)
	end
end)

supplyButton.MouseButton1Click:Connect(function()
	if not supplyPage.Visible then
		homePage.Visible = false
		decorePage.Visible = false
		supplyPage.Visible = true
		wallPage.Visible = false
		bankPage.Visible = false
		appPage.Visible = false

		homeButton.BackgroundColor3 = Color3.fromRGB(75,75,75)
		decoreButton.BackgroundColor3 = Color3.fromRGB(75,75,75)
		supplyButton.BackgroundColor3 = Color3.fromRGB(129,129,129)
		wallButton.BackgroundColor3 = Color3.fromRGB(75,75,75)
		bankButton.BackgroundColor3 = Color3.fromRGB(75,75,75)
		appButton.BackgroundColor3 = Color3.fromRGB(75,75,75)
	end
end)

wallButton.MouseButton1Click:Connect(function()
	if not wallPage.Visible then
		homePage.Visible = false
		decorePage.Visible = false
		supplyPage.Visible = false
		wallPage.Visible = true
		bankPage.Visible = false
		appPage.Visible = false

		homeButton.BackgroundColor3 = Color3.fromRGB(75,75,75)
		decoreButton.BackgroundColor3 = Color3.fromRGB(75,75,75)
		supplyButton.BackgroundColor3 = Color3.fromRGB(75,75,75)
		wallButton.BackgroundColor3 = Color3.fromRGB(129,129,129)
		bankButton.BackgroundColor3 = Color3.fromRGB(75,75,75)
		appButton.BackgroundColor3 = Color3.fromRGB(75,75,75)
	end
end)

bankButton.MouseButton1Click:Connect(function()
	if not bankPage.Visible then
		homePage.Visible = false
		decorePage.Visible = false
		supplyPage.Visible = false
		wallPage.Visible = false
		bankPage.Visible = true
		appPage.Visible = false

		homeButton.BackgroundColor3 = Color3.fromRGB(75,75,75)
		decoreButton.BackgroundColor3 = Color3.fromRGB(75,75,75)
		supplyButton.BackgroundColor3 = Color3.fromRGB(75,75,75)
		wallButton.BackgroundColor3 = Color3.fromRGB(75,75,75)
		bankButton.BackgroundColor3 = Color3.fromRGB(129,129,129)
		appButton.BackgroundColor3 = Color3.fromRGB(75,75,75)
	end
end)