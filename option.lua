module(..., package.seeall)

function new()
updateMem()
local localGroup = display.newGroup()

function applyChanges()
	print "Changes applied"
	director:changeScene("mainMenu", "fade")
end

function back()
	director:changeScene("mainMenu", "fade")
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

local optionTitle = display.newText("Options", 100, 0, native.systemFont, 40)
optionTitle:setTextColor(255, 255, 255)

local applyText = display.newText("Apply", 200, 600, native.systemFont, 20)
applyText:setTextColor(0, 0, 0)
applyText:addEventListener("touch", applyChanges)

local backText = display.newText("Back", 80, 600, native.systemFont, 20)
backText:setTextColor(0, 0, 0)
backText:addEventListener("touch", back)

localGroup:insert(optionTitle)
localGroup:insert(applyText)
localGroup:insert(backText)

return localGroup
end