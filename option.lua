module(..., package.seeall)

function new()
updateMem()
local localGroup = display.newGroup()

local myText = display.newText("Options", 100, 0, native.systemFont, 40)
myText:setTextColor(255, 255, 255)
localGroup:insert(myText)

return localGroup
end