module(..., package.seeall)

function new()
updateMem()
local localGroup = display.newGroup()







_G.widget = require("widget")
_G.socket = require("socket")
_G.http = require("socket.http")
_G.ltn12 = require("ltn12")
_G.lfs = require "lfs"
_G.physics = require("physics")
io.output():setvbuf('no') 		-- **debug: disable output buffering for Xcode Console
--_G.slideView = require "slideView"



-----------------
----Images
-----------------


-----------------
--Sounds-----
-----------------

--




local loadMainMenu = function()
	director:changeScene ("mainMenu", "crossfade")
end
timerStash.loadMainMenu = timer.performWithDelay(100, loadMainMenu)

return localGroup
end

