module(..., package.seeall)

function new()
updateMem()
local localGroup = display.newGroup()


local loadingImage
if system.getInfo("model") == "iPhone" then
	if display.pixelHeight > 960 then
		loadingImage = display.newImage("Default-568h@2x.png", true)
	end
elseif system.getInfo("model") == "iPad" then
	loadingImage = display.newImage("Default-Landscape.png", true)
end

if loadingImage == nil then
	loadingImage = display.newImage("Default.png", true)
end
localGroup:insert(loadingImage)
loadingImage.rotation = -90


loadingImage.x = middlex
loadingImage.y = middley


_G.sheets = require("sheets")
_G.widget = require("widget")
_G.socket = require("socket")
_G.http = require("socket.http")
_G.ltn12 = require("ltn12")
_G.lfs = require "lfs"
_G.physics = require("physics")
io.output():setvbuf('no') 		-- **debug: disable output buffering for Xcode Console
--_G.slideView = require "slideView"
_G.myWidget = require "myWidget"



-----------------
----Images
-----------------


-----------------
--Sounds-----
-----------------


backgroundMusic = audio.loadStream("backgroundold.wav")
backgroundMusicChannel = audio.play(backgroundMusic, { loops=-1, fadein=500 }  )

local loadMainMenu = function()
	director:changeScene ("mainMenu", "crossfade")
end
timerStash.loadMainMenu = timer.performWithDelay(100, loadMainMenu)

return localGroup
end

