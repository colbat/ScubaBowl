-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local launchArgs = ...
json = require("json")



--Hide status bar
display.setStatusBar( display.HiddenStatusBar )

--Never dim the screen
--system.setIdleTimer( false)
director = require ("director")
director:changeFxTime(135)
scalex = display.contentScaleX
scaley = display.contentScaleY
originx = display.screenOriginX
originy = display.screenOriginY
pixelwidth = math.round(display.pixelHeight*scalex)
pixelheight = math.round(display.pixelWidth*scaley)
middlex = display.contentWidth/2
middley = display.contentHeight/2
testVersion = false
ego = require "ego"
saveFile = ego.saveFile
loadFile = ego.loadFile
--gameNetwork = require "gameNetwork"
crypto = require "crypto"




local function monitorMem()          
        local memUsed = collectgarbage("count") / 1000
        local texUsed = system.getInfo( "textureMemoryUsed" ) / 1000000
        
        print("\n---------MEMORY USAGE INFORMATION---------")
    print("System Memory Used:", string.format("%.03f", memUsed), "Mb")
        print("Texture Memory Used:", string.format("%.03f", texUsed), "Mb")
    print("------------------------------------------\n")
    
    return true
end

--timer.performWithDelay(500, monitorMem, -1 )

local function onMemoryWarning()
	collectgarbage()
    local textMem = system.getInfo( "textureMemoryUsed" ) / 1000000
	native.showAlert("Warning", "MemUsage: " .. collectgarbage("count").. "/n TexMem:   " .. textMem , {"Ok"})
end
if testVersion == true then
	Runtime:addEventListener( "memoryWarning", onMemoryWarning )
end

local function onSystemEvent( event ) 
    if event.type == "applicationStart" or event.type == "applicationResume" then
        --gameNetwork.init( "gamecenter" )
        return true
	elseif event.type == "applicationSuspend" then
    end
end
Runtime:addEventListener( "system", onSystemEvent )

timerStash = {}
transitionStash = {}
soundsStash = {}

function cancelAllSounds()
    local k, v

    for k,v in pairs(soundsStash) do
        audio.stop( v )
        v = nil; k = nil
    end

    soundsStash = nil
    soundsStash = {}
end

function cancelAllTimers()
    local k, v

    for k,v in pairs(timerStash) do
        timer.cancel( v )
        v = nil; k = nil
    end

    timerStash = nil
    timerStash = {}
end

function cancelAllTransitions()
    local k, v

    for k,v in pairs(transitionStash) do
        transition.cancel( v )
        v = nil; k = nil
    end

    transitionStash = nil
    transitionStash = {}
end

print_table = function (t, name, indent)
	local tableList = {}
	function table_r (t, name, indent, full)
		local serial=string.len(full) == 0 and name or type(name)~="number" and '["'..tostring(name)..'"]' or '['..name..']'
		io.write(indent,serial,' = ') 
		if type(t) == "table" then
			if tableList[t] ~= nil then
				io.write('{}; -- ',tableList[t],' (self reference)\n')
			else
				tableList[t]=full..serial
				if next(t) then -- Table not empty
					io.write('{\n')
					for key,value in pairs(t) do table_r(value,key,indent..'\t',full..serial) end 
					io.write(indent,'};\n')
				else io.write('{};\n') end
			end
		else
			io.write(type(t)~="number" and type(t)~="boolean" and '"'..tostring(t)..'"' or tostring(t),';\n') 
		end
	end
	table_r(t,name or '__unnamed__',indent or '','')
end

function printTimers()
	--print_table(timerStash, "timerStash")
	--print_table(transitionStash, "transitionStash")
	local k, v
	local numOfTimers = 0
	local numOfTransitions = 0
    for k,v in pairs(transitionStash) do
        numOfTransitions = numOfTransitions +1
        v = nil; k = nil
    end
	for k,v in pairs(timerStash) do
    	numOfTimers = numOfTimers +1
        v = nil; k = nil
    end
	print("Number Of Timers: ".. numOfTimers)
	print("Number Of Transitions: ".. numOfTransitions)
end
--timer.performWithDelay(500, printTimers, -1)

function internetConnection()
	if http.request( "http://www.google.com" ) ~= nil then
		return true
	else
		return false
	end
end

function refreshData()
    
end
refreshData()





gameNetwork = require "gameNetwork"
local deviceID = ""
deviceID = system.getInfo("deviceID")
encryptedDeviceID = crypto.digest( crypto.md5, deviceID )
--> Imports director

local mainGroup = display.newGroup()
local itunesID = ""	--> set this if you want users to be able to rate your app
local googlePlayID = ""


local selectLevel = function()
	menuGroup:removeSelf()
	director:changeScene ("levelSelection")
end


local function loadMainMenu()

	menuGroup = display.newGroup()

	local spaceBetweenButton = 10
	
	-- Start Game Button
	local newGameButton = display.newImage("graphics/startGameButton.png")
	newGameButton.x = 0
	newGameButton.y = 0
	newGameButton.id = newGame
	menuGroup:insert(newGameButton)

	-- Options Button
	local optionsButton = display.newImage("graphics/optionsButton.png")
	optionsButton.x = 0
	optionsButton.y = newGameButton.contentHeight + spaceBetweenButton
	optionsButton.id = options
	menuGroup:insert(optionsButton)

    -- Main Menu group settings
	menuGroup.y = 250
	menuGroup.x = display.contentCenterX

	print("Group content center X " .. display.contentCenterX)
	print("Button X " .. newGameButton.x)

	newGameButton:addEventListener("touch", selectLevel)

end

local function main()
	mainGroup:insert(director.directorView)
	if testVersion == true then
	local SystemMemoryStart = 0
	local TextureMemoryStart = 0
	local SystemMemory = display.newText(mainGroup, "System Memory Used", middlex-300, originy + pixelheight-200, nil, 50)
	local TextureMemory = display.newText(mainGroup, "Texture Memory Used", middlex-300, originy + pixelheight-100, nil, 50)
	local function monitorMem()          
	    local memUsed = collectgarbage("count") / 1000
	    local texUsed = system.getInfo( "textureMemoryUsed" ) / 1000000
		SystemMemory.text = "System Memory: "..string.format("%.03f", memUsed).." Mb ("..SystemMemoryStart..")"
		TextureMemory.text = "Texture Memory: "..string.format("%.03f", texUsed).." Mb ("..TextureMemoryStart..")"
		
	    return true
	end
	function _G.updateMem()
		local memUsed = collectgarbage("count") / 1000
		local texUsed = system.getInfo( "textureMemoryUsed" ) / 1000000
		SystemMemoryStart = string.format("%.03f", memUsed)
		TextureMemoryStart = string.format("%.03f", texUsed)
	end
	updateMem()
	timer.performWithDelay(500, monitorMem, -1 )
	else
		function updateMem() end
	end

	loadMainMenu()
	
	return true
end



main()
