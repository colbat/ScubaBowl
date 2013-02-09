module(..., package.seeall)

function new()
updateMem()
local localGroup = display.newGroup()
refreshData()
physics.start()



local ball = display.newCircle(localGroup, 0,0, 30 )
ball.x = originx + 200
ball.y = originy + pixelheight - 200
ball.startX = ball.x
ball.startY = ball.y
ball:setFillColor(255)

physics.addBody(ball, "kinematic")

local floor = display.newRect(localGroup, 0, 0, pixelwidth, 10 )
floor.x = middlex
floor.y = originy + pixelheight - 5
floor:setFillColor(255)
physics.addBody(floor, "static", {bounce = 0.05, friction = 1})

local rightWall = display.newRect(localGroup, 0, 0, 10, pixelheight )
rightWall.x = originx + pixelwidth - 5
rightWall.y = middley
rightWall:setFillColor(255)
physics.addBody(rightWall, "static", {bounce = 0.05, friction = 1})

local leftWall = display.newRect(localGroup, 0, 0, 10, pixelheight )
leftWall.x = originx + 5
leftWall.y = middley
leftWall:setFillColor(255)
physics.addBody(leftWall, "static", {bounce = 0.05, friction = 1})

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
	elseif event.phase == "ended" then
		ball.bodyType = "dynamic"
		ball:applyLinearImpulse( (ball.startX-ball.x)/200, (ball.startY-ball.y)/200, ball.x, ball.y )
		display.remove(directionArrow)
		touchScreen:removeEventListener("touch", touchBall)
	end
end

touchScreen:addEventListener("touch", touchBall)



return localGroup
end

