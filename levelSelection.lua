module(..., package.seeall)

function new()
updateMem()
local localGroup = display.newGroup()

local startGame = function(self)
	_G.level = self.level
	director:changeScene ("game")
end

local myText = display.newText("Select your level!", 100, 0, native.systemFont, 40)
myText:setTextColor(255, 255, 255)
localGroup:insert(myText)

local level1Button = display.newImage("graphics/level1Button.png")
level1Button.x = 150
level1Button.y = display.contentCenterY
level1Button:addEventListener("touch", startGame)
level1Button.level = 1
localGroup:insert(level1Button)

return localGroup
end