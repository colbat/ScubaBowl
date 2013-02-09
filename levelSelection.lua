module(..., package.seeall)

function new()
updateMem()
local localGroup = display.newGroup()

local startGame = function(event)
	_G.level = event.target.level
	director:changeScene ("game")
end

local myText = display.newText("Select your level!", 100, 0, native.systemFont, 40)
myText:setTextColor(255, 255, 255)
localGroup:insert(myText)

level1Button = display.newImage("graphics/level1Button.png")
level1Button.x = 150
level1Button.y = display.contentCenterY
level1Button.level = 1
level1Button:addEventListener("touch", startGame)

level2Button = display.newImage("graphics/level2Button.png")
level2Button.x = 350
level2Button.y = display.contentCenterY
level2Button.level = 2
level2Button:addEventListener("touch", startGame)

localGroup:insert(level1Button)
localGroup:insert(level2Button)

return localGroup
end