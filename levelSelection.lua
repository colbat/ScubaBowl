module(..., package.seeall)

function new()
updateMem()
local localGroup = display.newGroup()

local startGame = function(event)
	_G.level = event.target.level
	director:changeScene ("game", "fade")
end

local back = function()
director:changeScene ("mainMenu", "fade")
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

local selectLevelTitle = display.newText("Select your level!", 100, 0, "Wasser", 40)
selectLevelTitle:setTextColor(255, 255, 255)

local backText = display.newText("Back", 80, 600, "Wasser", 20)
backText:setTextColor(0, 0, 0)
backText:addEventListener("touch", back)

lvlButtons = {}

for i = 1, 4 do
	lvlButtons[i] = display.newImage("graphics/level1Button.png")
	lvlButtons[i].level = i
	lvlButtons[i].lvlText = display.newText("Level " .. i, 0, 0, "Wasser", 20)
	lvlButtons[i].lvlText:setTextColor(0, 0, 0)
	lvlButtons[i]:addEventListener("touch", startGame)
	localGroup:insert(lvlButtons[i])
	localGroup:insert(lvlButtons[i].lvlText)
end

lvlButtons[1].x, lvlButtons[1].y = 100, display.contentCenterY
lvlButtons[2].x, lvlButtons[2].y = 300, display.contentCenterY
lvlButtons[3].x, lvlButtons[3].y = 500, display.contentCenterY
lvlButtons[4].x, lvlButtons[4].y = 700, display.contentCenterY

for i = 1, 4 do
	lvlButtons[i].lvlText.x = lvlButtons[i].x
	lvlButtons[i].lvlText.y = lvlButtons[i].y
end 

return localGroup
end