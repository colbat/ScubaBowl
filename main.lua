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

numOfLevels = 3



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
    levelData = json.decode(loadFile("levelData.txt"))
    if loadFile("levelData.txt") == "empty" then
        levelData = {}
		for i = 1, numOfLevels do
			levelData["lvl"..i] = {}
			levelData["lvl"..i]["stars"] = "locked"
			levelData["lvl"..i]["highscore"] = 0
		end
		levelData["lvl1"]["stars"] = 0
		saveFile("levelData.txt", json.encode(levelData))	
    end

	--saveFile("levelData.txt", "empty") ---Uncomment to clear Data
	print_table(levelData, "LevelData")
	options = json.decode(loadFile("options.txt"))
	optionsOriginalData = {learnMode = 1, sounds = 1, music = 1}
	--print(#options, #optionsOriginalData)
	if loadFile("options.txt") == "empty" then
        options = {}
		options["learnMode"] = 1
		options["music"] = 1
		options["sounds"] = 1
		saveFile("options.txt", json.encode(options))
	--[[elseif #options ~= #optionsOriginalData then
		print("ok")
		for i = 1, #optionsOriginalData do
			if table.indexOf( options, optionsOriginalData[i] ) == nil then
				options[#options +1] = optionsOriginalData[i]
			end
		end--]]
    end
	--saveFile("options.txt", "empty") ---Uncomment to clear Data
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

local loadGame = function()
	director:changeScene("loading")
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

	loadGame()
	
	return true
end



main()
