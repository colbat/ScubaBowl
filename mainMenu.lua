module(..., package.seeall)

function new()
updateMem()
local localGroup = display.newGroup()

local selectLevel = function()
	menuGroup:removeSelf()
	director:changeScene("levelSelection", "fade")
end

local displayOptions = function()
	menuGroup:removeSelf()
	director:changeScene("option", "fade")
end

local background = display.newImage(localGroup, "graphics/background.jpg", true)
background.x = middlex
background.y = middley
local layer2 = display.newImage(localGroup, "graphics/level-2.png", true)
layer2.x = middlex
layer2.y = middley
local fishGroup = display.newGroup()
localGroup:insert(fishGroup)
local layer1 = display.newImage(localGroup, "graphics/level-1.png", true)
layer1.x = middlex
layer1.y = middley

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

localGroup:insert(menuGroup)

newGameButton:addEventListener("touch", selectLevel)
optionsButton:addEventListener("touch", displayOptions)

return localGroup
end