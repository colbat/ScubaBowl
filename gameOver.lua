module(..., package.seeall)

function new()
updateMem()
local localGroup = display.newGroup()

function displayLevelSelection()
	director:changeScene("levelSelection", "fade")
end

local gameOverTitle = display.newText("Game Over", display.contentCenterX, 0, native.systemFont, 60)
gameOverTitle:setTextColor(255, 255, 255)

local tryAgain = display.newText("Game Over", display.contentCenterX, 350, native.systemFont, 40)
tryAgain:setTextColor(255, 255, 255)
tryAgain:addEventListener("touch", displayLevelSelection)

localGroup:insert(gameOverTitle)
localGroup:insert(tryAgain)

return localGroup
end