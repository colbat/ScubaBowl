module(..., package.seeall)

function new()
updateMem()
local localGroup = display.newGroup()
refreshData()
physics.start()

print("Level: "..level)

local touchBall
local gameOver
local touchScreen
local ball = {}
local numOfBalls = 2
local currentBall
for i = 1, numOfBalls do
ball[i] = display.newCircle(localGroup, 0,0, 30 )
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
		print(i..". ball[i].released "..tostring(ball[i].released))
		if ball[i].released == false then
			currentBall = i
		end
	end
	print("currentBall: "..currentBall)
	physics.addBody(ball[currentBall], "kinematic", {radius = 30, friction = 10, bounce = 0.1})
	ball[currentBall].startX = originx + 200
	ball[currentBall].startY = originy + pixelheight - 200
	local function makeBallReady()
		touchScreen:addEventListener("touch", touchBall)
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
			directionArrow.width = math.sqrt(xDist^2+yDist^2)
			directionArrow.rotation = lineAngle
			directionArrow.x = ball[currentBall].startX - (ball[currentBall].startX-ball[currentBall].x)/2
			directionArrow.y = ball[currentBall].startY - (ball[currentBall].startY-ball[currentBall].y)/2
		else
			local excessDist = directionArrow.maxForce/(math.sqrt(xDist^2+yDist^2))
			--print(excessDist)
			ball[currentBall].x = ball[currentBall].startX - (ball[currentBall].startX-event.x) * excessDist
			ball[currentBall].y = ball[currentBall].startY - (ball[currentBall].startY-event.y) * excessDist
			xDist = ball[currentBall].startX-ball[currentBall].x; local yDist = ball[currentBall].startY-ball[currentBall].y
			lineAngle = math.deg( math.atan( yDist/xDist ) )
			directionArrow.width = math.sqrt(xDist^2+yDist^2)
			directionArrow.rotation = lineAngle
			directionArrow.x = ball[currentBall].startX - (ball[currentBall].startX-ball[currentBall].x)/2
			directionArrow.y = ball[currentBall].startY - (ball[currentBall].startY-ball[currentBall].y)/2
		end
			
		--print(directionArrow.width)
		directionArrow:setFillColor(0,255,0)
		directionArrow.alpha = 0.6
		--directionArrow:setFillColor(255*(directionArrow.width/directionArrow.maxForce),255*(1-directionArrow.width/directionArrow.maxForce),0)
		ball[currentBall].prevX = ball[currentBall].x
		ball[currentBall].prevY = ball[currentBall].y
	elseif event.phase == "ended" or event.phase == "cancelled" then
		ball[currentBall].bodyType = "dynamic"
		ball[currentBall]:applyLinearImpulse( (ball[currentBall].startX-ball[currentBall].x)/200, (ball[currentBall].startY-ball[currentBall].y)/200, ball[currentBall].x, ball[currentBall].y )
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



local pin1 = display.newRect(localGroup, 0, 0, 20, 50)
pin1.x = 502
pin1.y = 600
physics.addBody(pin1, "dynamic")
pin1.myName = "pin1"
local pin2 = display.newRect(localGroup, 0, 0, 20, 50)
pin2.x = 967
pin2.y = 600
physics.addBody(pin2, "dynamic")
pin2.myName = "pin2"
local pin3 = display.newRect(localGroup, 0, 0, 20, 50)
pin3.x = 568
pin3.y = 600
physics.addBody(pin3, "dynamic")
pin3.myName = "pin3"

local function onLocalCollision( self, event )
        if ( event.phase == "began" ) then
 
                --print( self.myName .. ": collision began with " .. event.other.myName )
 
        elseif ( event.phase == "ended" ) then
 
                --print( self.myName .. ": collision ended with " .. event.other.myName )
 
        end
end
 
ball[currentBall].collision = onLocalCollision
ball[currentBall]:addEventListener( "collision", ball[currentBall] )


local function onLocalPreCollision( self, event )
	if event.other.myName and event.other.myName == "ball[currentBall]" then
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

