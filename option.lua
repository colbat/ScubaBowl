module(..., package.seeall)

function new()
updateMem()
local localGroup = display.newGroup()
local widget = require("widget")
widget.setTheme("theme_ios")

-- Options
local learnMode = options["learnMode"]
local music = options["music"]
local sounds = options["sounds"]

function applyChanges()
	print "Changes applied"
	print("Learn Mode set : " .. learnMode)

	-- Apply options and save changes to file
 	options["learnMode"] = learnMode
 	options["music"] = music
 	options["sounds"] = sounds
 	saveFile("options.txt", json.encode(options))

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

local optionTitle = display.newText("Options", 100, 0, "Wasser", 40)
optionTitle:setTextColor(255, 255, 255)

local applyText = display.newText("Apply", 200, 600, "Wasser", 20)
applyText:setTextColor(0, 0, 0)
applyText:addEventListener("touch", applyChanges)

local backText = display.newText("Back", 80, 600, "Wasser", 20)
backText:setTextColor(0, 0, 0)
backText:addEventListener("touch", back)

local backgroundAlpha = display.newRect(50, 80, 700, 500)
backgroundAlpha:setFillColor(255, 255, 255)
backgroundAlpha.alpha = 0.5


-- Tools
local function toBoolean(number)
	if number == 0 then
		return false
	else
		return true
	end
end
-- END Tools


-- Switch LEARN MODE
local switchLearnModeLabel = display.newText("Learn mode", 80, 150, "Wasser", 25)
switchLearnModeLabel:setTextColor(0, 0, 0)

local function onSwitchLearnModePress( event )
	local switchLearnMode = event.target

	if switchLearnMode.isOn then
		learnMode = 1
	else
		learnMode = 0
	end

end

local onOffSwitchLearnMode = widget.newSwitch
{
   left = 350,
   top = 150,
   id = "learnModeSwitch",
   initialSwitchState = toBoolean(learnMode),
   onRelease = onSwitchLearnModePress
}
-- END Switch LEARN MODE


-- Switch MUSIC
local switchMusicLabel = display.newText("Music", 80, 250, "Wasser", 25)
switchMusicLabel:setTextColor(0, 0, 0)

local function onSwitchMusicPress( event )
	local switchMusic = event.target

	if switchMusic.isOn then
		music = 1
	else
		music = 0
	end

end

local onOffSwitchMusic = widget.newSwitch
{
   left = 350,
   top = 250,
   id = "musicSwitch",
   initialSwitchState = toBoolean(music),
   onRelease = onSwitchMusicPress
}
-- END Switch MUSIC



-- Switch SOUNDS
local switchSoundsLabel = display.newText("Sounds", 80, 350, "Wasser", 25)
switchSoundsLabel:setTextColor(0, 0, 0)

local function onSwitchSoundsPress( event )
	local switchSounds = event.target

	if switchSounds.isOn then
		sounds = 1
	else
		sounds = 0
	end

end

local onOffSwitchSoundsMusic = widget.newSwitch
{
   left = 350,
   top = 350,
   id = "musicSwitch",
   initialSwitchState = toBoolean(sounds),
   onRelease = onSwitchSoundsPress
}
-- END Switch SOUNDS



localGroup:insert(optionTitle)
localGroup:insert(applyText)
localGroup:insert(backText)
localGroup:insert(backgroundAlpha)
localGroup:insert(onOffSwitchLearnMode)
localGroup:insert(onOffSwitchMusic)
localGroup:insert(onOffSwitchSoundsMusic)

return localGroup
end