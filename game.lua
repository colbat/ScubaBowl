module(..., package.seeall)

function new()
updateMem()
local localGroup = display.newGroup()
refreshData()
physics.start()



local ball = display.newCircle(localGroup, 0,0, 30 )
ball.x = originx + 200
ball.y = originy + pixelheight - 100
ball.startX = ball.x
ball.startY = ball.y
ball:setFillColor(255)

physics.addBody(ball, "kinematic")

local floor = display.newRect(localGroup, 0, 0, pixelwidth, 1 )
floor.x = middlex
floor.y = originy + pixelheight - 10
floor:setFillColor(0,0,0,0)

physics.addBody(floor, "static")
local function touchBall(event)
	if event.phase == "began" then
		
	elseif event.phase == "moved" then
		ball.x = event.x
		ball.y = event.y
	elseif event.phase == "ended" then
		ball.bodyType = "dynamic"
		ball:applyLinearImpulse( (ball.startX-ball.x)/100, (ball.startY-ball.y)/100, ball.x, ball.y )
	end
end

ball:addEventListener("touch", touchBall)



return localGroup
end

