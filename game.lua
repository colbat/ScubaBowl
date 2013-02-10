module(..., package.seeall)

if options["music"] == 1 then
	 -- play the background music on channel 1, loop infinitely, and fadein over 1 seconds
	backgroundMusicChannel = audio.play( backgroundMusic, { channel=1, loops=-1, fadein=1000 }  )
end

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
local pinsKnockedDown = 0
local onLocalCollision


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
end

local function deleteListeners()
	print("delete listerners")
	Runtime:removeEventListener("enterFrame", checkBall)
	Runtime:removeEventListener("enterFrame", checkForCollsion)	
	Runtime:removeEventListener( "enterFrame", displayBubbleTips )
	Runtime:removeEventListener("enterFrame", layerMovement)
end

local function restartLink( event )
	print("restart link")
	deleteListeners()
	director:changeScene("game", "fade")
end

local function resumeLink( event )
		print("resume link")
		gameResume()
end

local function displayMainMenu( event )
		deleteListeners()
		print("menu link")
		director:changeScene("mainMenu", "fade")
end

local function gamePause(event)
	menuGroup = display.newGroup()
	if event.phase == "ended" then
		print("game paused")
		restartButton = display.newImage("graphics/restartButton.png" )
		restartButton.y = display.contentCenterY
		restartButton.x = middlex
		restartButton:addEventListener("touch",restartLink)
		resumeButton = display.newImage("graphics/continueButton.png" )
		resumeButton.y = display.contentCenterY
		resumeButton.x = middlex - 280
		resumeButton:addEventListener("touch",resumeLink)
		goToMenu = display.newImage("graphics/menuButton.png" )
		goToMenu.y = display.contentCenterY
		goToMenu.x = middlex + 280
		goToMenu:addEventListener("touch",displayMainMenu)
		menuGroup:insert(restartButton)
		menuGroup:insert(resumeButton)
		menuGroup:insert(goToMenu)
	end
end


touchScreen = display.newRect(localGroup, originx + 50, originy, pixelwidth, pixelheight)
touchScreen.alpha = 0
touchScreen.isHitTestable = true

pause = display.newRect(localGroup, originx,originy, 30, 30 )
pause.strokeWidth = 3
pause:setFillColor(140, 140, 140)
pause:setStrokeColor(180, 180, 180)
pause:addEventListener("touch",gamePause)






local directionArrow = display.newRoundedRect( localGroup, 0, 0, 50, 10, 5 )
directionArrow:setFillColor(0,0,0,0)
directionArrow.maxForce = 140
for i = 1, numOfBalls do
	localGroup:insert(ball[i])
end
local ballTouchStarted = false
function touchBall(event)
	if ball[currentBall].ready == true then
	if event.phase == "began" and event.x >= ball[currentBall].x -100 and event.x <= ball[currentBall].x +100 and event.y >= ball[currentBall].y -100 and event.y <= ball[currentBall].y +100 then
		
		directionArrow:setFillColor(0,255,0,255)
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
		if ( event.x < ball[currentBall].startX ) then lineAngle = lineAngle else lineAngle = lineAngle +180 end
		if math.sqrt(xDist^2+yDist^2) <= directionArrow.maxForce then
			directionArrow.width = math.sqrt(xDist^2+yDist^2) *3
			directionArrow.rotation = lineAngle
		else
			local excessDist = directionArrow.maxForce/(math.sqrt(xDist^2+yDist^2))
			--print(excessDist)
			ball[currentBall].x = ball[currentBall].startX - (ball[currentBall].startX-event.x) * excessDist
			ball[currentBall].y = ball[currentBall].startY - (ball[currentBall].startY-event.y) * excessDist
			xDist = ball[currentBall].startX-ball[currentBall].x; local yDist = ball[currentBall].startY-ball[currentBall].y
			lineAngle = math.deg( math.atan( yDist/xDist ) )
			if ( event.x < ball[currentBall].startX ) then lineAngle = lineAngle else lineAngle = lineAngle +180 end
			directionArrow.width = math.sqrt(xDist^2+yDist^2) *3
			directionArrow.rotation = lineAngle
			--directionArrow.x = ball[currentBall].startX+(ball[currentBall].startX-event.x)
			--directionArrow.y = ball[currentBall].startY+(ball[currentBall].startY-event.y)
			--directionArrow.x = ball[currentBall].startX - (ball[currentBall].startX-ball[currentBall].x)/2
			--directionArrow.y = ball[currentBall].startY - (ball[currentBall].startY-ball[currentBall].y)/2
		end
		--print(directionArrow.width)
		directionArrow:setFillColor(0,255,0)
		directionArrow.alpha = 0.6
		--directionArrow:setFillColor(255*(directionArrow.width/directionArrow.maxForce),255*(1-directionArrow.width/directionArrow.maxForce),0)
		ball[currentBall].prevX = ball[currentBall].x
		ball[currentBall].prevY = ball[currentBall].y
		char.hand.x = ball[currentBall].x
		char.hand.y = ball[currentBall].y
		print(directionArrow.rotation+90)
		char.hand.rotation = directionArrow.rotation+90
		ball[currentBall].rotation = char.hand.rotation
		directionArrow.x = ball[currentBall].startX+(ball[currentBall].startX-ball[currentBall].x)/2
		directionArrow.y = ball[currentBall].startY+(ball[currentBall].startY-ball[currentBall].y)/2
	elseif (event.phase == "ended" or event.phase == "cancelled") and ballTouchStarted == true then
		ball[currentBall].bodyType = "dynamic"
		ball[currentBall]:applyLinearImpulse( (ball[currentBall].startX-ball[currentBall].x)*15, (ball[currentBall].startY-ball[currentBall].y)*15, ball[currentBall].x, ball[currentBall].y )
		directionArrow.alpha = 0
		touchScreen:removeEventListener("touch", touchBall)
		--print("Velocity: "..ball[currentBall]:getLinearVelocity() / 30 .." m/s")
		local vx, vy = ball[currentBall]:getLinearVelocity()
		print("X Velocity: "..math.abs(vx) / 30 .." m/s")
		print("Y Velocity: "..math.abs(vy) / 30 .." m/s")
		ball[currentBall].released = true
	
		if options["sounds"] == 1 then
			narrationChannel = audio.play( shooting_ball, { duration=30000, onComplete=NarrationFinished } )
		end
		
		char:setFrame(1)
		transitionStash.initBallTrans = transition.to(char.hand, {time = 1000, x = originx + 156, y = originy + pixelheight - 150})
		ballTouchStarted = false
		timerStash.MakeFloor = timer.performWithDelay( 35, function() floor.isSensor = false end )
	end
	end
end


local pin1 = display.newImage( gameObjectsSheet, 3, true)
pin1.x = 502
pin1.y = 510
pin1.isDown = false
--physics.addBody(pin1, "dynamic", physicsData:get("seahorse"))
pin1.myName = "pin1"
--pin1:setFillColor(0,255,0)
local pin2 = display.newImage( gameObjectsSheet, 3, true)
pin2.x = 967
pin2.y = 600
pin2.isDown = false
--pin2:setFillColor(0,255,0)
--physics.addBody(pin2, "dynamic", physicsData:get("seahorse"))
pin2.myName = "pin2"
local pin3 = display.newImage( gameObjectsSheet, 3, true)
pin3.x = 668
pin3.y = 450
pin3.isDown = false
--pin3:setFillColor(0,255,0)
--physics.addBody(pin3, "dynamic", physicsData:get("seahorse"))
pin3.myName = "pin3"

local myAreaTipsWidth = pixelwidth / 2
local myAreaTipsHeight = pixelheight / 2
local bulleImg
local myTips
local animation
local myAreaTips = display.newRect(originx, 0, myAreaTipsWidth, myAreaTipsHeight)
myAreaTips.alpha = false
--myAreaTips.strokeWidth = 3
--myAreaTips:setFillColor( pink )
--myAreaTips:setStrokeColor(180, 180, 180)

function checkForCollsion()
	if pin1.isDown == false then
		if ball[currentBall].x and ball[currentBall].x then
			if math.abs(ball[currentBall].x - pin1.x) < 30 + pin1.contentWidth/2 and math.abs(ball[currentBall].y - pin1.y) < 30 + pin1.contentHeight/2 then
				print("Pin1 Down")
				pin1:setFillColor(255,0,0)
				pin1.isDown = true
			end
		end
	end
	if pin2.isDown == false then
		if ball[currentBall].x and ball[currentBall].x then
			if math.abs(ball[currentBall].x - pin2.x) < 30 + pin2.contentWidth/2 and math.abs(ball[currentBall].y - pin2.y) < 30 + pin2.contentHeight/2 then
				print("Pin2 Down")
				pin2:setFillColor(255,0,0)
				pin2.isDown = true
			end
		end
	end
	if pin3.isDown == false then
		if ball[currentBall].x and ball[currentBall].x then
			if math.abs(ball[currentBall].x - pin3.x) < 30 + pin3.contentWidth/2 and math.abs(ball[currentBall].y - pin3.y) < 30 + pin3.contentHeight/2 then
				print("Pin3 Down")
				pin3:setFillColor(255,0,0)
				pin3.isDown = true
			end
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

local function displayPopUpTips(event)
	physics.pause()
	--list = widget.newTableView( listOptions )
	--tips = display.newText("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean et erat a quam vehicula tincidunt. Sed at tellus et sem condimentum tempor. Vestibulum placerat vulputate luctus.",bulleImg.x - 30, bulleImg.y, native.systemFont, 12)
end

local function deleteBubbleTips()
	display.remove(myTips)
	display.remove(bulleImg)
	myTips = nil
	bulleImg = nil
end

local function displayBubbleTips(event)
	if ball[currentBall] and ball[currentBall].y and ball[currentBall].x then
		if myTips == nil and ball[currentBall].y < myAreaTipsHeight and ball[currentBall].x < myAreaTipsWidth then
			bulleImg = display.newImage( "graphics/bullesbleue.png" )
			bulleImg.alpha = 0.2
			bulleImg.x = originx + 200
			bulleImg.y = originy + 200
			
			myTips = display.newText("Tips",bulleImg.x - 30, bulleImg.y, native.systemFont, 12)
			myTips:setTextColor( gray )
			myTips.size = 24
			animation = display.newGroup()
			animation.x, animation.y = 100, 100
			animation:insert( bulleImg )
			animation:insert( myTips )
			animation:addEventListener("touch", displayPopUpTips)
			localGroup:insert(animation)
			transitionStash.trans = transition.to( animation, { time=4000, delay=2500, alpha=0,x=(animation.x+50), y=(animation.x-200), onComplete=deleteBubbleTips } )
		end
	end
end

Runtime:addEventListener("enterFrame", checkBall)
Runtime:addEventListener( "enterFrame", displayBubbleTips )

function gameOver()
	--physics.stop()
	print("GAME OVER")
	Runtime:removeEventListener("enterFrame", checkBall)
	Runtime:removeEventListener("enterFrame", checkForCollsion)
	
	local function pressButton(event)
		if event.phase == "release" then
			return true
		end
	end
	local newButton = myWidget.createButton("circle", "TEXT", pressButton)
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

