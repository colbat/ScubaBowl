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

for i = 1, 3 do
	lvlButtons[i] = display.newImage("graphics/level1Button.png")
	lvlButtons[i].level = i
	lvlButtons[i].lvlText = display.newText("Level " .. i, 0, 0, "Wasser", 20)
	lvlButtons[i].lvlText:setTextColor(0, 0, 0)

	if levelData["lvl"..i]["stars"] == "locked" then
		lvlButtons[i].lvlTextLocked = display.newText("(Locked)", 0, 0, "Wasser", 15)
		lvlButtons[i].lvlTextLocked:setTextColor(0, 0, 0)
	else
		lvlButtons[i]:addEventListener("touch", startGame)

	end
	
	localGroup:insert(lvlButtons[i])
	localGroup:insert(lvlButtons[i].lvlText)
end

lvlButtons[1].x, lvlButtons[1].y = 150, display.contentCenterY
lvlButtons[2].x, lvlButtons[2].y = 450, display.contentCenterY
lvlButtons[3].x, lvlButtons[3].y = 750, display.contentCenterY

for i = 1, 3 do
	-- Level text
	lvlButtons[i].lvlText.x = lvlButtons[i].x
	lvlButtons[i].lvlText.y = lvlButtons[i].y

	-- Locked text
	if levelData["lvl"..i]["stars"] == "locked" then
		lvlButtons[i].lvlTextLocked.x = lvlButtons[i].x
		lvlButtons[i].lvlTextLocked.y = lvlButtons[i].y + 25
	end
end 



return localGroup
end