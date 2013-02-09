module(..., package.seeall)

function new()
updateMem()
local localGroup = display.newGroup()

local selectLevel = function()
	menuGroup:removeSelf()
	director:changeScene("levelSelection")
end

local displayOptions = function()
	menuGroup:removeSelf()
	director:changeScene("option")
end

menuGroup = display.newGroup()

local spaceBetweenButton = 10

-- Start Game Button
local newGameButton = display.newImage("graphics/startGameButton.png")
newGameButton.x = 0
newGameButton.y = 0
newGameButton.id = newGame
menuGroup:insert(newGameButton)

-- Options Button
local optionsButton = display.newImage("graphics/optionsButton.png")
optionsButton.x = 0
optionsButton.y = newGameButton.contentHeight + spaceBetweenButton
optionsButton.id = options
menuGroup:insert(optionsButton)

-- Main Menu group settings
menuGroup.y = 250
menuGroup.x = display.contentCenterX

newGameButton:addEventListener("touch", selectLevel)
optionsButton:addEventListener("touch", displayOptions)

return localGroup
end