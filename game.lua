module(..., package.seeall)

shooting_ball= audio.loadStream("shooting_ball.wav")
Sound_seahourse = audio.loadStream("seahourse.wav")
--audio.fadeOut({ channel=backgroundMusicChannel, time=5000 } )

--if options["music"] == 1 then	

-- play the background music on channel 1, loop infinitely, and fadein over 1 seconds
--backgroundMusicChannel = audio.play( backgroundMusic, { channel=1, loops=-1, fadein=1000 }  )

--end



function new()
updateMem()
local localGroup = display.newGroup()
refreshData()
physics.start()

print("Level: "..level)

local menuGroup
local pause
local restartButton
local resumeButton
local goToMenu

local tipsLvl
local fileTip
local linkString
local list
local gameIsOver = false
local paused = false

local physicsData = (require "Physics").physicsData(1)
local checkBall
local checkForCollsion
local layerMovement

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


local bubbles = {}
local bubblesGroup = display.newGroup()
localGroup:insert(bubblesGroup)
transitionStash.bubblesMove = {}
local function makeBubbles()
	for i = 1, 1 do
		local index = #bubbles+1
		bubbles[index] = display.newImage( bubblesSheet, math.random(1,6), true)
		bubblesGroup:insert(bubbles[index])
		bubbles[index].x = math.random(originx, originx+pixelwidth)
		bubbles[index].y = originy+pixelheight+10
		local function removeBubble()
			display.remove(bubbles[index])
			bubbles[index] = nil
		end
		transitionStash.bubblesMove[index] = transition.to(bubbles[index], {time=math.random(2000,10000), y = originy-100, onComplete = removeBubble})
	end
end
timerStash.createBubbles = timer.performWithDelay(1, makeBubbles, -1)
		
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
		

--[[local bubbles = {}
bubbles[1] = display.newImage(localGroup, "graphics/bubles.png", true)
bubbles[1].x = middlex-10
bubbles[1].y = middley
bubbles[2] = display.newImage(localGroup, "graphics/bubles.png", true)
bubbles[2].x = middlex-10
bubbles[2].y = bubbles[1].y+bubbles[1].contentHeight

local moveBubbles
function moveBubbles()
	bubbles[1].y = middley
	bubbles[2].y = bubbles[1].y+bubbles[1].contentHeight
	transitionStash.moveBubbles1 = transition.to(bubbles[1], {time = 10000, y = bubbles[1].y-bubbles[1].contentHeight, onComplete = moveBubbles})
	transitionStash.moveBubbles2 = transition.to(bubbles[2], {time = 10000, y = bubbles[2].y-bubbles[1].contentHeight})
end
moveBubbles()
local moveBubblesSide
function moveBubblesSide()
	local function moveBubblesSide2()
		transitionStash.moveBubbles1 = transition.to(bubbles[1], {time = 1000, x = bubbles[1].x - 20, onComplete = moveBubblesSide, transition=easing.inOutQuad})
		transitionStash.moveBubbles2 = transition.to(bubbles[2], {time = 1000, x = bubbles[1].x - 20, transition=easing.inOutQuad})
	end
	transitionStash.moveBubbles1 = transition.to(bubbles[1], {time = 1000, x = bubbles[1].x + 20, onComplete = moveBubblesSide2, transition=easing.inOutQuad})
	transitionStash.moveBubbles2 = transition.to(bubbles[2], {time = 1000, x = bubbles[1].x + 20, transition=easing.inOutQuad})
end
moveBubblesSide()]]
local touchBall
local gameOver
local touchScreen
local ball = {}
local numOfBalls = 2
local currentBall
local onLocalCollision
local pinsKnockedDown = 0
local ballsUsed = 0
local ballsLeft = numOfBalls

local gameObjectsGroup = display.newGroup()
localGroup:insert(gameObjectsGroup)
local followingBubblesGroup = display.newGroup()
localGroup:insert(followingBubblesGroup)

local charSequenceData = {
    name = "char",
	start = 1,
	count = 2,
}

local charImgSheet = graphics.newImageSheet("graphics/Char_Character.png", sheets.getSpriteSheetDataChar())
local char = display.newSprite(charImgSheet, charSequenceData )
char.hand = display.newImage( charImgSheet, 3, true)
localGroup:insert(char.hand)
localGroup:insert(char)
char.x = originx + 156
char.y = originy + pixelheight - 125

char.hand.x = originx + 156
char.hand.y = originy + pixelheight - 150




for i = 1, numOfBalls do
ball[i] = display.newImage( gameObjectsSheet, 2, true)

if i == 1 then
	ball[i].x = originx + 60
	ball[i].y = originy + pixelheight - 60
else
	ball[i].x = originx + 262 + 25*(i-2)
	ball[i].y = originy + pixelheight - 60
end
ball[i]:setFillColor(255)
ball[i].myName = "ball"
ball[i].released = false
ball[i].stopped = false
ball[i].ready = false
end


--physics.addBody(ball, "kinematic", {radius = 30, friction = 10, bounce = 0.1})

local function initNewBall()
	for i = numOfBalls, 1, -1 do
		--print(i..". ball[i].released "..tostring(ball[i].released))
		if ball[i].released == false then
			currentBall = i
		end
	end
	--print("currentBall: "..currentBall)
	physics.addBody(ball[currentBall], "kinematic", physicsData:get("ball"))
	ball[currentBall].linearDamping = 0.75
	ball[currentBall].startingX = originx + 60
	ball[currentBall].startingY = originy + pixelheight - 60
	
	ball[currentBall].startX = originx + 156
	ball[currentBall].startY = originy + pixelheight - 150
	
	char:setFrame(2)
	char.hand.rotation = 45
	char.hand.x = originx + 156
	char.hand.y = originy + pixelheight - 150
	
	local function makeBallReady()
		touchScreen:addEventListener("touch", touchBall)
		ball[currentBall].collision = onLocalCollision
		ball[currentBall]:addEventListener( "collision", ball[currentBall] )
		ball[currentBall].ready = true
		ballsUsed = ballsUsed +1
		ballsLeft = ballsLeft -1
	end
	transitionStash.initBallTrans = transition.to(ball[currentBall], {time = 1000, x = ball[currentBall].startingX, y = ball[currentBall].startingY, onComplete = makeBallReady})
	transitionStash.initBallTrans = transition.to(char.hand, {time = 1000, x = ball[currentBall].startingX, y = ball[currentBall].startingY})
end
initNewBall()		

local floor = display.newRect(localGroup, 0, 0, pixelwidth, 10 )
floor.x = middlex
floor.y = originy + pixelheight - 10
floor:setFillColor(255,0)
physics.addBody(floor, "static", {bounce = 0.5, friction = 100})

--[[local rightWall = display.newRect(localGroup, 0, 0, 10, pixelheight )
rightWall.x = originx + pixelwidth - 5
rightWall.y = middley
rightWall:setFillColor(255)
physics.addBody(rightWall, "static", {bounce = 0.05, friction = 1})

local leftWall = display.newRect(localGroup, 0, 0, 10, pixelheight )
leftWall.x = originx + 5
leftWall.y = middley
leftWall:setFillColor(255)
physics.addBody(leftWall, "static", {bounce = 0.05, friction = 1})
]]

local function gameResume()
	menuGroup:removeSelf()
	paused = false
end

local function deleteListeners()
	print("delete listerners")
	Runtime:removeEventListener("enterFrame", checkBall)
	Runtime:removeEventListener("enterFrame", checkForCollsion)	
	Runtime:removeEventListener( "enterFrame", displayBubbleTips )
	Runtime:removeEventListener("enterFrame", layerMovement)
end

local function restartLink( event )
	if event.phase == "release" then
		print("restart link")
		deleteListeners()
		director:changeScene("game", "fade")
	end
end

local function resumeLink( event )
	if event.phase == "release" then
		print("resume link")
		gameResume()
	end
end

local function displayMainMenu( event )
	if event.phase == "release" then
		deleteListeners()
		print("menu link")
		director:changeScene("mainMenu", "fade")
	end
end

touchScreen = display.newRect(localGroup, originx, originy, pixelwidth, pixelheight)
touchScreen.alpha = 0
touchScreen.isHitTestable = true





local function pressGamePause(event)
	if event.phase == "release" and paused == false and gameIsOver == false then
		paused = true
		menuGroup = display.newGroup()
		--if event.phase == "ended" then
			print("game paused")

			restartButton = myWidget.createButton("circle", "RESTART", restartLink)
			restartButton.xScale, restartButton.yScale  = 1, 1
			restartButton.x = originx + middlex
			restartButton.y = originy + display.contentCenterY
			localGroup:insert(restartButton)

			resumeButton = myWidget.createButton("circle", "CONTINUE", resumeLink)
			resumeButton.xScale, resumeButton.yScale  = 1, 1
			resumeButton.x = originx + middlex - 280
			resumeButton.y = originy + display.contentCenterY
			localGroup:insert(resumeButton)

			goToMenu = myWidget.createButton("circle", "MAIN MENU", displayMainMenu)
			goToMenu.xScale, goToMenu.yScale  = 1, 1
			goToMenu.x = originx + middlex + 280
			goToMenu.y = originy + display.contentCenterY
			localGroup:insert(goToMenu)


			menuGroup:insert(restartButton)
			menuGroup:insert(resumeButton)
			menuGroup:insert(goToMenu)
		--end
		return true
	end
end


local pauseBtn = myWidget.createButton("circle", "||", pressGamePause)
pauseBtn.xScale, pauseBtn.yScale  = 0.5, 0.5
pauseBtn.x = originx + 35
pauseBtn.y = originy + 35
localGroup:insert(pauseBtn)


local directionArrow = display.newGroup()
localGroup:insert(directionArrow)
local mainArrow = display.newImage(directionArrow, "graphics/arrowPlus.png", 0, 0, true)

local arrowHead = display.newImage(directionArrow, "graphics/arrow.png", 0, 0, true)
arrowHead.x = mainArrow.x + mainArrow.contentWidth/2+ arrowHead.contentWidth/2

directionArrow.alpha = 0
directionArrow.maxForce = 140
directionArrow:setReferencePoint(display.CenterReferencePoint)
for i = 1, numOfBalls do
	localGroup:insert(ball[i])
end
local ballTouchStarted = false
function touchBall(event)
	if ball[currentBall].ready == true then
	if event.phase == "began" and event.x >= ball[currentBall].x -200 and event.x <= ball[currentBall].x +200 and event.y >= ball[currentBall].y -200 and event.y <= ball[currentBall].y +200 then
		
		--directionArrow:setFillColor(0,255,0,255)
		directionArrow.x = ball[currentBall].startX
		directionArrow.y = ball[currentBall].startY
		directionArrow.alpha = 0
		ballTouchStarted = true
		floor.isSensor = true
	elseif event.phase == "moved" and ballTouchStarted == true then
		ball[currentBall].x = event.x
		ball[currentBall].y = event.y
		local xDist = ball[currentBall].startX-ball[currentBall].x; local yDist = ball[currentBall].startY-ball[currentBall].y
		local lineAngle = math.deg( math.atan( yDist/xDist ) )
		--print("line angle: ".. lineAngle)
		if ( event.x > ball[currentBall].startX ) then 
			lineAngle = lineAngle +180
		end
		if lineAngle == 90 or lineAngle == -90 then
			lineAngle = lineAngle+0.5
		end
		--print("line angle 2: ".. lineAngle)
		if math.sqrt(xDist^2+yDist^2) <= directionArrow.maxForce then
			mainArrow.width = math.sqrt(xDist^2+yDist^2) *3 - arrowHead.width
			directionArrow.rotation = lineAngle
			arrowHead.x = mainArrow.x + mainArrow.width/2
		else
			local excessDist = directionArrow.maxForce/(math.sqrt(xDist^2+yDist^2))
			--print(excessDist)
			ball[currentBall].x = ball[currentBall].startX - (ball[currentBall].startX-event.x) * excessDist
			ball[currentBall].y = ball[currentBall].startY - (ball[currentBall].startY-event.y) * excessDist
			xDist = ball[currentBall].startX-ball[currentBall].x; local yDist = ball[currentBall].startY-ball[currentBall].y
			lineAngle = math.deg( math.atan( yDist/xDist ) )

			if ( event.x > ball[currentBall].startX ) then 
				lineAngle = lineAngle +180
			end
			if lineAngle == 90 or lineAngle == -90 then
				lineAngle = lineAngle+0.5
			end
			mainArrow.width = math.sqrt(xDist^2+yDist^2) *3 - arrowHead.width
			directionArrow.rotation = lineAngle
			arrowHead.x = mainArrow.x + mainArrow.width/2
			--directionArrow.x = ball[currentBall].startX+(ball[currentBall].startX-event.x)
			--directionArrow.y = ball[currentBall].startY+(ball[currentBall].startY-event.y)
			--directionArrow.x = ball[currentBall].startX - (ball[currentBall].startX-ball[currentBall].x)/2
			--directionArrow.y = ball[currentBall].startY - (ball[currentBall].startY-ball[currentBall].y)/2
		end
		--print(directionArrow.width)
		--directionArrow:setFillColor(0,255,0)
		directionArrow.alpha = 1
		--directionArrow:setFillColor(255*(directionArrow.width/directionArrow.maxForce),255*(1-directionArrow.width/directionArrow.maxForce),0)
		ball[currentBall].prevX = ball[currentBall].x
		ball[currentBall].prevY = ball[currentBall].y
		char.hand.x = ball[currentBall].x
		char.hand.y = ball[currentBall].y
		--print(directionArrow.rotation+90)
		char.hand.rotation = directionArrow.rotation+90
		ball[currentBall].rotation = char.hand.rotation
		directionArrow.x = ball[currentBall].startX+(ball[currentBall].startX-ball[currentBall].x)/2
		directionArrow.y = ball[currentBall].startY+(ball[currentBall].startY-ball[currentBall].y)/2
		local forcePercent = ((directionArrow.width/3)/directionArrow.maxForce) *100
		if forcePercent < 51 then
			mainArrow:setFillColor(forcePercent/50*255, 255, 0)
			arrowHead:setFillColor(forcePercent/50*255, 255, 0)
		else mainArrow:setFillColor(255, 255-((forcePercent-50)/50)*255, 0)
			arrowHead:setFillColor(255, 255-((forcePercent-50)/50)*255, 0) end
	elseif (event.phase == "ended" or event.phase == "cancelled") and ballTouchStarted == true and directionArrow.alpha ~= 0 then
		ball[currentBall].bodyType = "dynamic"
		ball[currentBall]:applyLinearImpulse( (ball[currentBall].startX-ball[currentBall].x)*15, (ball[currentBall].startY-ball[currentBall].y)*15, ball[currentBall].x, ball[currentBall].y )
		directionArrow.alpha = 0
		
		
		touchScreen:removeEventListener("touch", touchBall)
		--print("Velocity: "..ball[currentBall]:getLinearVelocity() / 30 .." m/s")
		local vx, vy = ball[currentBall]:getLinearVelocity()
		print("X Velocity: "..math.abs(vx) / 30 .." m/s")
		print("Y Velocity: "..math.abs(vy) / 30 .." m/s")
		local velocity = math.round((math.sqrt((math.abs(vx) / 30)^2+(math.abs(vy) / 30)^2))*10)/10
		ball[currentBall].released = true
		
		local VelocityText = display.newText("Velocity: "..velocity.." m/s",0,0, "Wasser", 20 )
		VelocityText.rotation = directionArrow.rotation
		VelocityText.x = directionArrow.x+75
		VelocityText.y = directionArrow.y-75
		VelocityText:setTextColor(255,255,0)
		localGroup:insert(VelocityText)
		
		transitionStash.VelocityIn = transition.from(VelocityText, {time = 750, alpha = 0})
		transitionStash.VelocityOut = transition.to(VelocityText, {time = 750, alpha = 0, delay = 4000})
		
		narrationChannel = audio.play( shooting_ball, { duration=14000, onComplete=NarrationFinished } )


--		narrationChannel = audio.play( shooting_ball, { duration=1400, onComplete=NarrationFinished } )
	
--		if options["sounds"] == "1" then
--	
		
--	narrationChannel = audio.play( Sound_seahourse, { duration=1400, onComplete=NarrationFinished } )
--		end

		
		char:setFrame(1)
		transitionStash.initBallTrans = transition.to(char.hand, {time = 1000, x = originx + 156, y = originy + pixelheight - 150})
		ballTouchStarted = false
		timerStash.MakeFloor = timer.performWithDelay( 35, function() floor.isSensor = false end )
	end
	end
end


local pin1 = display.newImage( gameObjectsSheet, 3, true)

pin1.isDown = false
--physics.addBody(pin1, "dynamic", physicsData:get("seahorse"))
pin1.myName = "pin1"
--pin1:setFillColor(0,255,0)
local pin2 = display.newImage( gameObjectsSheet, 3, true)

pin2.isDown = false
--pin2:setFillColor(0,255,0)
--physics.addBody(pin2, "dynamic", physicsData:get("seahorse"))
pin2.myName = "pin2"
local pin3 = display.newImage( gameObjectsSheet, 3, true)

pin3.isDown = false
--pin3:setFillColor(0,255,0)
--physics.addBody(pin3, "dynamic", physicsData:get("seahorse"))
pin3.myName = "pin3"
gameObjectsGroup:insert(pin1)
gameObjectsGroup:insert(pin2)
gameObjectsGroup:insert(pin3)
if level == 1 then
	pin1.x = 502
	pin1.y = 510
	pin2.x = 870
	pin2.y = 600
	pin3.x = 668
	pin3.y = 450
elseif level == 2 then
	pin1.x = 634
	pin1.y = 434
	pin2.x = 400
	pin2.y = 554
	pin3.x = 573
	pin3.y = 532
elseif level == 3 then
	pin1.x = 400
	pin1.y = 234
	pin2.x = 323
	pin2.y = 309
	pin3.x = 525
	pin3.y = 500
end

local myAreaTipsWidth = pixelwidth / 3
local myAreaTipsHeight = pixelheight / 3
local bulleImg
local myTips
local animation
local myAreaTips = display.newRect(originx, 0, myAreaTipsWidth, myAreaTipsHeight)
myAreaTips.alpha = false
--myAreaTips.strokeWidth = 3
--myAreaTips:setFillColor( pink )
--myAreaTips:setStrokeColor(180, 180, 180)
local poofSequenceData = {
    name = "poof",
	start = 1,
	count = 6,
	time = 300,  --optional, in milliseconds; if not supplied, the sprite is frame-based
	loopCount = 1,
}

local poofSheet = graphics.newImageSheet("graphics/Poof_UntitledSheet_2.png", sheets.getSpriteSheetDataPoof())
local poofSprite = display.newSprite(poofSheet, poofSequenceData )
gameObjectsGroup:insert(poofSprite)
poofSprite:setFrame(6)

function checkForCollsion()
	if pin1.isDown == false then
		if math.abs(ball[currentBall].x - pin1.x) < 30 + pin1.contentWidth/2 and math.abs(ball[currentBall].y - pin1.y) < 30 + pin1.contentHeight/2 then
		
		
		narrationChannel = audio.play( Sound_seahourse, { duration=400, onComplete=NarrationFinished } )
	--		if options["sounds"] == "1" then
			
	--			narrationChannel = audio.play( Sound_seahourse, { duration=4000 } )
	--		end
			
			print("Pin1 Down")
			pin1:setFillColor(255,0,0)
			pin1.isDown = true
			pinsKnockedDown = pinsKnockedDown +1
			poofSprite.x = pin1.x
			poofSprite.y = pin1.y
			poofSprite:setFrame(1)
			poofSprite:play()
			pin1.isVisible = false
			local scoreAddText = display.newText("10000", 0, 0, "Wasser", 24)
			scoreAddText:setTextColor(255, 255, 0)
			scoreAddText.x = pin1.x
			scoreAddText.y = pin1.y
			gameObjectsGroup:insert(scoreAddText)
			gameObjectsGroup:insert(poofSprite)
			local function scoreAddTextEnd(event)
				display.remove(scoreAddText)
			end
			transition.to( scoreAddText, {time=1000, y = scoreAddText.y-100, onComplete = scoreAddTextEnd})
			transition.to( scoreAddText, {time=250, alpha = 0, delay = 750})
			
		end
	end
	if pin2.isDown == false then
		if math.abs(ball[currentBall].x - pin2.x) < 30 + pin2.contentWidth/2 and math.abs(ball[currentBall].y - pin2.y) < 30 + pin2.contentHeight/2 then
		
		narrationChannel = audio.play( Sound_seahourse, { duration=400, onComplete=NarrationFinished } )
		if options["sounds"] == "1" then
			narrationChannel = audio.play( Sound_seahourse, { duration=4000 } )
		end
		
			print("Pin2 Down")
			pin2:setFillColor(255,0,0)
			pin2.isDown = true
			pinsKnockedDown = pinsKnockedDown +1
			poofSprite.x = pin2.x
			poofSprite.y = pin2.y
			poofSprite:setFrame(1)
			poofSprite:play()
			pin2.isVisible = false
			local scoreAddText = display.newText("10000", 0, 0, "Wasser", 24)
			scoreAddText:setTextColor(255, 255, 0)
			scoreAddText.x = pin2.x
			scoreAddText.y = pin2.y
			gameObjectsGroup:insert(scoreAddText)
			gameObjectsGroup:insert(poofSprite)
			local function scoreAddTextEnd(event)
				display.remove(scoreAddText)
			end
			transition.to( scoreAddText, {time=1000, y = scoreAddText.y-100, onComplete = scoreAddTextEnd})
			transition.to( scoreAddText, {time=250, alpha = 0, delay = 750})
		end
	end
	if pin3.isDown == false then
		if math.abs(ball[currentBall].x - pin3.x) < 30 + pin3.contentWidth/2 and math.abs(ball[currentBall].y - pin3.y) < 30 + pin3.contentHeight/2 then
	narrationChannel = audio.play( Sound_seahourse, { duration=400, onComplete=NarrationFinished } )
		if options["sounds"] == "1" then
			narrationChannel = audio.play(Sound_seahourse, { duration=14000} )
		end
		
			print("Pin3 Down")
			pin3:setFillColor(255,0,0)
			pin3.isDown = true
			pinsKnockedDown = pinsKnockedDown +1
			poofSprite.x = pin3.x
			poofSprite.y = pin3.y
			poofSprite:setFrame(1)
			poofSprite:play()
			pin3.isVisible = false
			local scoreAddText = display.newText("10000", 0, 0, "Wasser", 24)
			scoreAddText:setTextColor(255, 255, 0)
			scoreAddText.x = pin3.x
			scoreAddText.y = pin3.y
			gameObjectsGroup:insert(scoreAddText)
			gameObjectsGroup:insert(poofSprite)
			local function scoreAddTextEnd(event)
				display.remove(scoreAddText)
			end
			transition.to( scoreAddText, {time=1000, y = scoreAddText.y-100, onComplete = scoreAddTextEnd})
			transition.to( scoreAddText, {time=250, alpha = 0, delay = 750})
		end
	end
	if pin1.isDown == true and pin2.isDown == true and pin3.isDown == true then
		gameOver()
	end
end
Runtime:addEventListener("enterFrame", checkForCollsion)

local try = 0
local bubbleFrame = 0
local followingBubbles = {}
transitionStash.followingBubbles = {}
function checkBall(event)
	if ball[currentBall] then
	local vx, vy = ball[currentBall]:getLinearVelocity()
	if ball[currentBall].stopped == false and ball[currentBall].released == true and ((math.abs(vx) < 5 and math.abs(vy) < 5)  or ball[currentBall].x > originx+pixelwidth or ball[currentBall].x < originx) then

		if try == 30 then
		print("Remove Ball")
		ball[currentBall]:removeEventListener( "collision", ball[currentBall] )
		ball[currentBall].stopped = true
		local oldBall = currentBall
		local function removeBallDelay()
			display.remove(ball[oldBall])
			ball[oldBall] = nil
		end
		timerStash.removeBallTimer = timer.performWithDelay( 1000, removeBallDelay )
		if currentBall == numOfBalls then
			gameOver()
		else
			initNewBall()
		end
		try = 0
		else try = try+1
		end
	else try = 0
		bubbleFrame = bubbleFrame + 1
		if bubbleFrame >= 3 and ball[currentBall].released == true then
			bubbleFrame = 0
			local index = #followingBubbles+1
			followingBubbles[index] = display.newImage( bubblesSheet, math.random(7,10), true)
			followingBubblesGroup:insert(followingBubbles[index])
			followingBubbles[index].x = ball[currentBall].x
			followingBubbles[index].y = ball[currentBall].y
			local function removeBubble()
				display.remove(followingBubbles[index])
				followingBubbles[index] = nil
			end
			transitionStash.followingBubbles[index] = transition.to(followingBubbles[index], {time=200, alpha = 0, delay = 2000, onComplete = removeBubble})
		end
	end
end
end


local function deleteBubbleTips()
	display.remove(myTips)
	display.remove(bulleImg)
	myTips = nil
	bulleImg = nil
end

local fileTip
local function showTipPopup()
	display.remove(animation)
	animation = nil
	local options =
	{
	    hasBackground=true,
	    baseUrl=system.DocumentsDirectory,
	    urlRequest=listener
	}
	--native.showWebPopup(middlex, middley, , height, "url"[, options])( fileTip, options )
end


local function displayBubbleTips(event)
	if ball[currentBall] and ball[currentBall].y and ball[currentBall].x then
		if myTips == nil and ball[currentBall].y < myAreaTipsHeight and ball[currentBall].x < myAreaTipsWidth then

			bulleImg = display.newImage( "graphics/bigbubble.png" )
			bulleImg.alpha = 0.5
			bulleImg.x = originx + 200
			bulleImg.y = originy + 100

			linkString = "[Learn more]"
			if(level == 1) then
				fileTip = "html/tips1.html"
				--tipsLvl = "Viscosity causes the path to be asymmetric."
				myTips = myWidget.createMultLines({"Viscosity causes the path", " to be asymmetric."}, 28,{})
				myTips.x = bulleImg.x
				myTips.y = bulleImg.y
			elseif(level == 2) then
				fileTip = "html/tips2.html"
				--tipsLvl = "Due to upthrust the ball feels lighter in water."
				myTips = myWidget.createMultLines({"Due to upthrust the ball", " feels lighter in water."}, 28,{})
				myTips.x = bulleImg.x
				myTips.y = bulleImg.y
			elseif(level == 3) then
				fileTip = "html/tips3.html"
				--tipsLvl = "Viscosity causes the path to be asymmetric."
				myTips = myWidget.createMultLines({"Viscosity causes the path", " to be asymmetric."}, 28,{})
				myTips.x = bulleImg.x
				myTips.y = bulleImg.y
			end

			--myTips = display.newText(tipsLvl,bulleImg.x - 200, bulleImg.y, "Wasser", 18)
			link = display.newText(linkString, bulleImg.x , bulleImg.y + 75, "Wasser", 18)
			--myTips:setTextColor( gray )
			--link:setTextColor( gray )

			animation = display.newGroup()
			animation.x, animation.y = 100, 100
			animation:insert( bulleImg )
			animation:insert( myTips )
			animation:insert( link )
			animation:addEventListener("touch", showTipPopup)

			localGroup:insert(animation)
			transitionStash.trans = transition.to( animation, { time=4000, delay=2500, alpha=0,x=(animation.x+50), y=(animation.x-200), onComplete=deleteBubbleTips } )
		end
	end
end

Runtime:addEventListener("enterFrame", checkBall)
Runtime:addEventListener( "enterFrame", displayBubbleTips )

function gameOver()
	--physics.stop()
	for i = 1, numOfBalls do
		if ball[i] and ball[i].released == false then
			local scoreAddText = display.newText("7500", 0, 0, "Wasser", 24)
			scoreAddText:setTextColor(255, 255, 0)
			scoreAddText.x = ball[i].x
			scoreAddText.y = ball[i].y
			gameObjectsGroup:insert(scoreAddText)
			local function scoreAddTextEnd(event)
				display.remove(scoreAddText)
			end
			transition.to( scoreAddText, {time=1000, y = scoreAddText.y-100, onComplete = scoreAddTextEnd})
			transition.to( scoreAddText, {time=250, alpha = 0, delay = 750})
		end
	end
		
	
	
	local gameOverGroup = display.newGroup()
	gameIsOver = true
	localGroup:insert(gameOverGroup)
	print("GAME OVER")
	--Runtime:removeEventListener("enterFrame", checkBall)
	--Runtime:removeEventListener("enterFrame", checkForCollsion)
	deleteListeners()
	local gameOverDimBtm = display.newRect( gameOverGroup, originx, originy, pixelwidth, pixelheight )
	gameOverDimBtm:setFillColor(0)
	gameOverDimBtm.alpha = 0.44
	local gameOverDimTop = display.newRect( gameOverGroup, 0, originy, 610, pixelheight )
	gameOverDimTop.x = middlex
	gameOverDimTop:setFillColor(0)
	gameOverDimTop.alpha = 0.44
	
	
	local gameOverStars = {}
	local howManyStars = pinsKnockedDown
	if ballsLeft == 0 then
		howManyStars = howManyStars-1
	end
	for i = 1, 3 do
		gameOverStars[i] = display.newImage( gameOverGroup, "graphics/star-1.png", 0, 0, true)
		if howManyStars < i then
			gameOverStars[i].alpha = 0.3
		end
		gameOverStars[i].y = 190
		gameOverStars[i].x = 310 + (i-1)*170
	end
	
	local progressText = display.newText(gameOverGroup, ".", 0, 0, "Wasser", 36)
	if howManyStars > 0 then
		progressText.text = "Level Cleared!"
	else progressText.text = "Level Failed!"
	end
	progressText.x = 480
	progressText.y = 74
	
	local score
	score = pinsKnockedDown*10000 + ballsLeft*7500
	local scoreText = display.newText(gameOverGroup, "Score: "..score, 0, 0, "Wasser", 36)
	scoreText.x = 480
	scoreText.y = 328
	
	local function pressMenuBtn(event)
		if event.phase == "release" then
			director:changeScene("mainMenu", "fade")
			return true
		end
	end
	
	local menuBtn = myWidget.createButton("circle", "MENU", pressMenuBtn)
	menuBtn.x = 260
	menuBtn.y = 440
	gameOverGroup:insert(menuBtn)
	
	local function pressReplayBtn(event)
		if event.phase == "release" then
			director:changeScene("game", "fade")
			return true
		end
	end
	
	local replayBtn = myWidget.createButton("circle", "REPLAY", pressReplayBtn)
	replayBtn.x = 410
	replayBtn.y = 440
	gameOverGroup:insert(replayBtn)
	
	local function pressNextBtn(event)
		if event.phase == "release" then
			_G.level = level+1
			director:changeScene("game", "fade")
			return true
		end
	end
	
	local nextBtn = myWidget.createButton("circle", "NEXT", pressNextBtn)
	nextBtn.x = 560
	nextBtn.y = 440
	gameOverGroup:insert(nextBtn)
	nextBtn.isVisible = false
	if level < numOfLevels and howManyStars > 0 then
		levelData["lvl"..level+1]["stars"] = 0
		nextBtn.isVisible = true
	end
	local function pressLearnBtn(event)
		if event.phase == "release" then
			return true
		end
	end
	
	local learnBtn = myWidget.createButton("circle", "LEARN", pressLearnBtn)
	learnBtn.x = 710
	learnBtn.y = 440
	gameOverGroup:insert(learnBtn)
	
	if tonumber(levelData["lvl"..level]["stars"]) < howManyStars then
		levelData["lvl"..level]["stars"] = howManyStars
	end
	if tonumber(levelData["lvl"..level]["highscore"]) < score then
		levelData["lvl"..level]["highscore"] = score
	end
	saveFile("levelData.txt", json.encode(levelData))
	
	gameOverGroup.alpha = 0
	
	transitionStash.gameOvertrans = transition.to(gameOverGroup, {time = 1000, alpha = 1, delay = 1000})
end

function layerMovement (event)
if ball[currentBall] then
if layer2 then
	
	layer2.x = middlex +  ((-ball[currentBall].x+middlex)/middlex)*42
	if layer2.x > middlex + 42 then
		layer2.x = middlex + 42
	elseif layer2.x < middlex - 42 then
		layer2.x = middlex - 42
	end
end
if layer1 then
	layer1.x = middlex +  ((-ball[currentBall].x+middlex)/middlex)*102
	if layer1.x > middlex + 102 then
		layer1.x = middlex + 102
	elseif layer1.x < middlex - 102 then
		layer1.x = middlex - 102
	end
end
end
end
Runtime:addEventListener("enterFrame", layerMovement)

return localGroup
end

