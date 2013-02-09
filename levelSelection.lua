module(..., package.seeall)

function new()
updateMem()
local localGroup = display.newGroup()

local level1Button

local startGame = function(event)
	_G.level = event.target.level
	director:changeScene ("loading")
end

local myText = display.newText("Select your level!", 100, 0, native.systemFont, 40)
myText:setTextColor(255, 255, 255)

level1Button = display.newImage("graphics/level1Button.png")
level1Button.x = 150
level1Button.y = display.contentCenterY
level1Button.level = 1
level1Button:addEventListener("touch", startGame)


return localGroup
end