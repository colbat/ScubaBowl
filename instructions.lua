module(..., package.seeall)

function new()
updateMem()
local localGroup = display.newGroup()

native.showWebPopup( 10, 10, 300, 300, "test.html", {urlRequest=listener} )

return localGroup
end