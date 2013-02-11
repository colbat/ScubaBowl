module(..., package.seeall)

function new()
updateMem()
local localGroup = display.newGroup()

local startGame = function(event)
	_G.level = event.target.level
	director:changeScene ("game", "fade")
end

local back = function()
director:changeScene ("mainMenu", "fade")
end

local background = display.newImage(localGroup, "graphics/background.jpg", true)
background.x = middlex
background.y = middley

local layer3a = display.newImage(localGroup, "graphics/level-3-light-1.png", true)
layer3a.x = middlex
layer3a.y = middley
local layer3b = display.newImage(localGroup, "graphics/level-3-light-2.png", true)
layer3b.x = middlex
layer3b.y = middley
layer3b.alpha = 0
local layer2 = display.newImage(localGroup, "graphics/level-2.png", true)
layer2.x = middlex
layer2.y = middley
local fishGroup = display.newGroup()
localGroup:insert(fishGroup)
local layer1 = display.newImage(localGroup, "graphics/level-1.png", true)
layer1.x = middlex
layer1.y = middley
local bubblesSheet = graphics.newImageSheet( "graphics/Bubbles_UntitledSheet.png", sheets.getSpriteSheetDataBubbles() )
local gameObjectsSheet = graphics.newImageSheet( "graphics/GameObjects_UntitledSheet.png", sheets.getSpriteSheetDataGameObjects() )
local FishSheet = graphics.newImageSheet( "graphics/Fish_Fish.png", sheets.getSpriteSheetDataFish() )

local changeLight
function changeLight()
	local function changeLight2()
		transitionStash.changeLight2a = transition.to(layer3a, {time = 1000, alpha = 1, onComplete = changeLight})
		transitionStash.changeLight2b = transition.to(layer3b, {time = 1000, alpha = 0})
	end
	transitionStash.changeLight1a = transition.to(layer3a, {time = 1000, alpha = 0, onComplete = changeLight2})
	transitionStash.changeLight1b = transition.to(layer3b, {time = 1000, alpha = 1})
end

changeLight()
		
local fishes = {}

transitionStash.fishMove = {}
local function makeFish()
		local index = #fishes+1
		fishes[index] = display.newImage( FishSheet, math.random(1,4), true)
		fishGroup:insert(fishes[index])
		local side = math.random(0,1)
		if side == 0 then side = -1 end
		fishes[index].x = side * (originx+pixelwidth) + side*200
		fishes[index].y = math.random(originy, originy+pixelheight)
		fishes[index].xScale = side
		local function removeBubble()
			display.remove(fishes[index])
			fishes[index] = nil
		end
		transitionStash.fishMove[index] = transition.to(fishes[index], {time=math.random(5000,20000), x = -fishes[index].x, onComplete = removeBubble})

		local rotate1
		function rotate1()
			local function rotate2()
				transition.to(fishes[index], {time = 1500, rotation = -3, onComplete = rotate1, transition=easing.inOutQuad})
			end
			transition.to(fishes[index], {time = 1500, rotation = 3, onComplete = rotate2, transition=easing.inOutQuad})
		end
		rotate1()
end
timerStash.createFish = timer.performWithDelay(2000, makeFish, -1)
local selectLevelTitle = display.newText("Select your level!", 100, 0, "Wasser", 40)
selectLevelTitle:setTextColor(255, 255, 255)

local backText = display.newText("Back", 80, 600, "Wasser", 20)
backText:setTextColor(0, 0, 0)
backText:addEventListener("touch", back)

lvlButtons = {}

for i = 1, 3 do
	lvlButtons[i] = display.newImage("graphics/button.png")
	lvlButtons[i].xScale = 1.8
	lvlButtons[i].yScale = 1.8
	lvlButtons[i].stars = {}
	lvlButtons[i].level = i
	lvlButtons[i].lvlText = display.newText("Level " .. i, 0, 0, "Wasser", 30)
	lvlButtons[i].lvlText:setTextColor(0, 0, 0)

	if levelData["lvl"..i]["stars"] == "locked" then
		lvlButtons[i].lvlTextLocked = display.newText("(Locked)", 0, 0, "Wasser", 15)
		lvlButtons[i].lvlTextLocked:setTextColor(0, 0, 0)
	else
		-- Add not filled stars under the level text
		for j = 1, 3 do
			lvlButtons[i].stars[j] = display.newImage("graphics/star.png")
			lvlButtons[i].stars[j].xScale = 0.5
			lvlButtons[i].stars[j].yScale = 0.5
			lvlButtons[i].stars[j].alpha = 0.5
		end

		-- Filled stars depending on the score
		for k = 1, levelData["lvl"..i]["stars"] do
			lvlButtons[i].stars[k].image = "graphics/star.png"
			lvlButtons[i].stars[k].xScale = 0.5
			lvlButtons[i].stars[k].yScale = 0.5
			lvlButtons[i].stars[k].alpha = 1
		end

		lvlButtons[i]:addEventListener("touch", startGame)
	end
	
	localGroup:insert(lvlButtons[i])
	localGroup:insert(lvlButtons[i].lvlText)
end

lvlButtons[1].x, lvlButtons[1].y = 150, display.contentCenterY
lvlButtons[2].x, lvlButtons[2].y = 450, display.contentCenterY
lvlButtons[3].x, lvlButtons[3].y = 750, display.contentCenterY

for i = 1, 3 do
	-- Level text
	lvlButtons[i].lvlText.x = lvlButtons[i].x
	lvlButtons[i].lvlText.y = lvlButtons[i].y

	-- Locked text
	if levelData["lvl"..i]["stars"] == "locked" then
		lvlButtons[i].lvlTextLocked.x = lvlButtons[i].x
		lvlButtons[i].lvlTextLocked.y = lvlButtons[i].y + 25
	end

	-- Stars if unlocked
	if levelData["lvl"..i]["stars"] ~= "locked" then
		lvlButtons[i].stars[1].x = lvlButtons[i].x - 70
		lvlButtons[i].stars[1].y = lvlButtons[i].y + 150

		lvlButtons[i].stars[2].x = lvlButtons[i].x + 5
		lvlButtons[i].stars[2].y = lvlButtons[i].y + 150

		lvlButtons[i].stars[3].x = lvlButtons[i].x + 75
		lvlButtons[i].stars[3].y = lvlButtons[i].y + 150
	end
end 



return localGroup
end