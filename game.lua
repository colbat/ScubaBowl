module(..., package.seeall)

function new()
updateMem()
local localGroup = display.newGroup()
refreshData()
physics.start()

print("Level: "..level)

local ball = display.newCircle(localGroup, 0,0, 30 )
ball.x = originx + 200
ball.y = originy + pixelheight - 200
ball.startX = ball.x
ball.startY = ball.y
ball:setFillColor(255)
ball.myName = "ball"
ball.released = false

physics.addBody(ball, "kinematic", {radius = 30, friction = 10, bounce = 0.1})

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
local touchScreen = display.newRect(localGroup, originx, originy, pixelwidth, pixelheight)
touchScreen.alpha = 0
touchScreen.isHitTestable = true



local directionArrow = display.newRoundedRect( localGroup, 0, 0, 50, 10, 5 )
directionArrow:setFillColor(0,0,0,0)
directionArrow.maxForce = 200
localGroup:insert(ball)
local function touchBall(event)
	if event.phase == "began" then
		directionArrow:setFillColor(0,255,0,255)
		directionArrow.x = ball.startX
		directionArrow.y = ball.startY
		directionArrow.alpha = 0
		
	elseif event.phase == "moved" then
		ball.x = event.x
		ball.y = event.y
		local xDist = ball.startX-ball.x; local yDist = ball.startY-ball.y
		local lineAngle = math.deg( math.atan( yDist/xDist ) )
		if math.sqrt(xDist^2+yDist^2) < directionArrow.maxForce then
			directionArrow.width = math.sqrt(xDist^2+yDist^2)
			directionArrow.rotation = lineAngle
			directionArrow.x = ball.startX - (ball.startX-ball.x)/2
			directionArrow.y = ball.startY - (ball.startY-ball.y)/2
		else
			local excessDist = directionArrow.maxForce/(math.sqrt(xDist^2+yDist^2))
			--print(excessDist)
			ball.x = ball.startX - (ball.startX-event.x) * excessDist
			ball.y = ball.startY - (ball.startY-event.y) * excessDist
			xDist = ball.startX-ball.x; local yDist = ball.startY-ball.y
			lineAngle = math.deg( math.atan( yDist/xDist ) )
			directionArrow.width = math.sqrt(xDist^2+yDist^2)
			directionArrow.rotation = lineAngle
			directionArrow.x = ball.startX - (ball.startX-ball.x)/2
			directionArrow.y = ball.startY - (ball.startY-ball.y)/2
		end
			
		--print(directionArrow.width)
		directionArrow.alpha = 0.6
		--directionArrow:setFillColor(255*(directionArrow.width/directionArrow.maxForce),255*(1-directionArrow.width/directionArrow.maxForce),0)
		ball.prevX = ball.x
		ball.prevY = ball.y
	elseif event.phase == "ended" or event.phase == "cancelled" then
		ball.bodyType = "dynamic"
		ball:applyLinearImpulse( (ball.startX-ball.x)/200, (ball.startY-ball.y)/200, ball.x, ball.y )
		display.remove(directionArrow)
		touchScreen:removeEventListener("touch", touchBall)
		--print("Velocity: "..ball:getLinearVelocity() / 30 .." m/s")
		local vx, vy = ball:getLinearVelocity()
		print("X Velocity: "..math.abs(vx) / 30 .." m/s")
		print("Y Velocity: "..math.abs(vy) / 30 .." m/s")
		ball.released = true
	end
end

touchScreen:addEventListener("touch", touchBall)


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
 
ball.collision = onLocalCollision
ball:addEventListener( "collision", ball )
pin1.collision = onLocalCollision
pin1:addEventListener( "collision", pin1 )
pin2.collision = onLocalCollision
pin2:addEventListener( "collision", pin2 )
pin3.collision = onLocalCollision
pin3:addEventListener( "collision", pin3 )

local function onLocalPreCollision( self, event )
	if event.other.myName and event.other.myName == "ball" then
		print(self.myName.." with ball Force: "..event.force)
	end
end

pin1.postCollision = onLocalPreCollision
pin1:addEventListener( "postCollision", pin1 )
pin2.postCollision = onLocalPreCollision
pin2:addEventListener( "postCollision", pin2 )
pin3.postCollision = onLocalPreCollision
pin3:addEventListener( "postCollision", pin3 )

print("hi")

local function checkBall(event)
	if ball then
	local vx, vy = ball:getLinearVelocity()
	if (ball.released == true and (vx < 5 and vy < 5) ) or (ball.x > originx+pixelwidth or ball.x < originx) then
		print("Remove Ball")
		local function removeBallDelay()
			display.remove(ball)
			ball = nil
		end
		timerStash.removeBallTimer = timer.performWithDelay( 1000, removeBallDelay )
		
	end
end
end
Runtime:addEventListener("enterFrame", checkBall)





return localGroup
end

