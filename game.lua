module(..., package.seeall)

function new()
updateMem()
local localGroup = display.newGroup()
refreshData()
physics.start()

print("Level: "..level)


local physicsData = (require "Physics").physicsData(1)

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
local sheets = require("sheets")
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
for i = 1, numOfBalls do
ball[i] = display.newImage( gameObjectsSheet, 2, true)
ball[i].x = originx + 25 + 25*i
ball[i].y = originy + pixelheight - 50
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
	ball[currentBall].startX = originx + 200
	ball[currentBall].startY = originy + pixelheight - 200
	local function makeBallReady()
		touchScreen:addEventListener("touch", touchBall)
		ball[currentBall].collision = onLocalCollision
		ball[currentBall]:addEventListener( "collision", ball[currentBall] )
		ball[currentBall].ready = true
	end
	transitionStash.initBallTrans = transition.to(ball[currentBall], {time = 1000, x = ball[currentBall].startX, y = ball[currentBall].startY, onComplete = makeBallReady})
	
end
initNewBall()		

local floor = display.newRect(localGroup, 0, 0, pixelwidth, 10 )
floor.x = middlex
floor.y = originy + pixelheight - 5
floor:setFillColor(255)
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
touchScreen = display.newRect(localGroup, originx, originy, pixelwidth, pixelheight)
touchScreen.alpha = 0
touchScreen.isHitTestable = true



local directionArrow = display.newRoundedRect( localGroup, 0, 0, 50, 10, 5 )
directionArrow:setFillColor(0,0,0,0)
directionArrow.maxForce = 200
for i = 1, numOfBalls do
	localGroup:insert(ball[i])
end
function touchBall(event)
	if ball[currentBall].ready == true then
	if event.phase == "began" then
		directionArrow:setFillColor(0,255,0,255)
		directionArrow.x = ball[currentBall].startX
		directionArrow.y = ball[currentBall].startY
		directionArrow.alpha = 0
		
	elseif event.phase == "moved" then
		ball[currentBall].x = event.x
		ball[currentBall].y = event.y
		local xDist = ball[currentBall].startX-ball[currentBall].x; local yDist = ball[currentBall].startY-ball[currentBall].y
		local lineAngle = math.deg( math.atan( yDist/xDist ) )
		if math.sqrt(xDist^2+yDist^2) < directionArrow.maxForce then
			directionArrow.width = math.sqrt(xDist^2+yDist^2) *2
			directionArrow.rotation = lineAngle
			directionArrow.x = ball[currentBall].startX
			directionArrow.y = ball[currentBall].startY
		else
			local excessDist = directionArrow.maxForce/(math.sqrt(xDist^2+yDist^2))
			--print(excessDist)
			ball[currentBall].x = ball[currentBall].startX - (ball[currentBall].startX-event.x) * excessDist
			ball[currentBall].y = ball[currentBall].startY - (ball[currentBall].startY-event.y) * excessDist
			xDist = ball[currentBall].startX-ball[currentBall].x; local yDist = ball[currentBall].startY-ball[currentBall].y
			lineAngle = math.deg( math.atan( yDist/xDist ) )
			directionArrow.width = math.sqrt(xDist^2+yDist^2) *2
			directionArrow.rotation = lineAngle
			--directionArrow.x = ball[currentBall].startX - (ball[currentBall].startX-ball[currentBall].x)/2
			--directionArrow.y = ball[currentBall].startY - (ball[currentBall].startY-ball[currentBall].y)/2
		end
			
		--print(directionArrow.width)
		directionArrow:setFillColor(0,255,0)
		directionArrow.alpha = 0.6
		--directionArrow:setFillColor(255*(directionArrow.width/directionArrow.maxForce),255*(1-directionArrow.width/directionArrow.maxForce),0)
		ball[currentBall].prevX = ball[currentBall].x
		ball[currentBall].prevY = ball[currentBall].y
	elseif event.phase == "ended" or event.phase == "cancelled" then
		ball[currentBall].bodyType = "dynamic"
		ball[currentBall]:applyLinearImpulse( (ball[currentBall].startX-ball[currentBall].x)*8, (ball[currentBall].startY-ball[currentBall].y)*8, ball[currentBall].x, ball[currentBall].y )
		directionArrow.alpha = 0
		touchScreen:removeEventListener("touch", touchBall)
		--print("Velocity: "..ball[currentBall]:getLinearVelocity() / 30 .." m/s")
		local vx, vy = ball[currentBall]:getLinearVelocity()
		print("X Velocity: "..math.abs(vx) / 30 .." m/s")
		print("Y Velocity: "..math.abs(vy) / 30 .." m/s")
		ball[currentBall].released = true
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
pin3.x = 568
pin3.y = 200
pin3.isDown = false
--pin3:setFillColor(0,255,0)
--physics.addBody(pin3, "dynamic", physicsData:get("seahorse"))
pin3.myName = "pin3"

function onLocalCollision( self, event )
        if ( event.phase == "began" ) then
 
                if event.other.myName then
					if event.other.myName == "pin1" then
						if pin1.isDown == false then
 							pin1.isDown = true
							pin1:setFillColor(255,0,0)
						end
					elseif event.other.myName == "pin2" then
						if pin2.isDown == false then
	 						pin2.isDown = true
							pin2:setFillColor(255,0,0)
						end
					elseif event.other.myName == "pin3" then
						if pin3.isDown == false then
	 						pin3.isDown = true
							pin3:setFillColor(255,0,0)
						end
					end
				end
        elseif ( event.phase == "ended" ) then
 
                --print( self.myName .. ": collision ended with " .. event.other.myName )
 
        end
end
 



local function onLocalPreCollision( self, event )
	if event.other.myName and event.other.myName == "ball" then
		print(self.myName.." with ball[currentBall] Force: "..event.force)
	end
end

pin1.postCollision = onLocalPreCollision
pin1:addEventListener( "postCollision", pin1 )
pin2.postCollision = onLocalPreCollision
pin2:addEventListener( "postCollision", pin2 )
pin3.postCollision = onLocalPreCollision
pin3:addEventListener( "postCollision", pin3 )

local try = 0
local function checkBall(event)
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
	end
end
end
Runtime:addEventListener("enterFrame", checkBall)


function gameOver()
	print("GAME OVER")
end


return localGroup
end

