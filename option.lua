module(..., package.seeall)

function new()
updateMem()
local localGroup = display.newGroup()

local optionTitle = display.newText("Options", 100, 0, native.systemFont, 40)
optionTitle:setTextColor(255, 255, 255)

local applyText = display.newText("Apply", 100, 0, native.systemFont, 20)
applyText:setTextColor(255, 255, 255)

localGroup:insert(optionTitle)
localGroup:insert(applyText)

return localGroup
end