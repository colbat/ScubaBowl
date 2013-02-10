module(..., package.seeall)

function new()
updateMem()
local localGroup = display.newGroup()



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



local gameOverDimTop = display.newRect( localGroup, 0, originy, 610, pixelheight )
gameOverDimTop.x = middlex
gameOverDimTop:setFillColor(0)
gameOverDimTop.alpha = 0.44

local menuBanner = display.newImage( localGroup, "graphics/logo.png",0,0, true )
menuBanner.x = 480
menuBanner.y = 132

local function pressStoreBtn(event)
	if event.phase == "release" then
		return true
	end
end

local storeBtn = myWidget.createButton("circle", "STORE", pressStoreBtn)
storeBtn.xScale, storeBtn.yScale  = 1.2, 1.2
storeBtn.x = 350
storeBtn.y = 308
localGroup:insert(storeBtn)

local function pressSettingsBtn(event)
	if event.phase == "release" then
		director:changeScene("option", "fade")
		return true
	end
end

local settingsBtn = myWidget.createButton("circle", "SETTINGS", pressSettingsBtn)
settingsBtn.xScale, settingsBtn.yScale  = 1.2, 1.2
settingsBtn.x = 610
settingsBtn.y = 308
localGroup:insert(settingsBtn)

local function pressPlayBtn(event)
	if event.phase == "release" then
		director:changeScene("levelSelection", "fade")
		return true
	end
end

local playBtn = myWidget.createButton("circle", "PLAY", pressPlayBtn)
playBtn.xScale, playBtn.yScale  = 1.5, 1.5
playBtn.x = 480
playBtn.y = 488
localGroup:insert(playBtn)



return localGroup
end