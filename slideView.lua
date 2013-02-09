
-- slideView.lua
-- 
-- Version 1.0 
--
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of 
-- this software and associated documentation files (the "Software"), to deal in the 
-- Software without restriction, including without limitation the rights to use, copy, 
-- modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, 
-- and to permit persons to whom the Software is furnished to do so, subject to the 
-- following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all copies 
-- or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
-- DEALINGS IN THE SOFTWARE.

module(..., package.seeall)

local screenW, screenH = display.contentWidth, display.contentHeight
local viewableScreenW, viewableScreenH = display.viewableContentWidth, display.viewableContentHeight
local screenOffsetW, screenOffsetH = display.contentWidth -  display.viewableContentWidth, display.contentHeight - display.viewableContentHeight
local scalex = display.contentScaleX
local scaley = display.contentScaleY
local originx = display.screenOriginX
local originy = display.screenOriginY
local pixelwidth = math.round(display.pixelWidth*scalex)
local pixelheight = math.round(display.pixelHeight*scaley)


local imgNum = nil
local images = nil
local touchListener, nextImage, prevImage, cancelMove, initImage
local background
local imageNumberText, imageNumberTextShadow

local scrollBarImg = graphics.newImageSheet( "scrollbar.png", {width = 720, height = 32, numFrames = 1, sheetContentWidth = 720, sheetContentHeight = 32 })
local scrollBtnImg = graphics.newImageSheet( "button_xsmall.png", {width = 200, height = 180, numFrames = 1, sheetContentWidth = 200, sheetContentHeight = 180 })

function new( images, params )	
	local pad = 20
	if params == nil then params = {} end
	local g = display.newGroup()
	
	background = display.newRect( originx, originy, pixelwidth, pixelheight )
	background:setFillColor(0, 0, 0, 0)
	background.isHitTestable = true
	
	print("images[1].x: "..images[1].x)
	
	for i = 1,#images do
		g:insert(images[i])
	    
		if (i > 1) then
			images[i].x = images[i].x + pixelwidth
		end

	end
	
	g:insert(background)

	imgNum = 1
	
	local scrollBar
	local barStart
	local barWidth
	local barEnd
	local barPoints
	local barPointsDist
	local currentPoint
	local scrollBtn
	
	if params.scrollBar == true then
	scrollBar = display.newImage(scrollBarImg, 1, true)
	scrollBar.x = 682
	scrollBar.y = originy + pixelheight - 122
	g:insert(scrollBar)
	
	barStart = scrollBar.x - scrollBar.contentWidth/2
	barWidth = scrollBar.contentWidth
	barEnd = barStart + barWidth
	barPoints = {}
	barPoints[1] = 0
	for i = 2, #images do
		barPoints[i] = barWidth/(#images-1)*(i-1)
	end
	barPointsDist = barWidth/(#images-1)
	print("barPointsDist "..barPointsDist)
	currentPoint = 1 
	
	scrollBtn = display.newImage(scrollBtnImg, 1, true)
	scrollBtn.x = barStart
	scrollBtn.y = originy + pixelheight - 122
	g:insert(scrollBtn)
	
	function touchListener2 (self, touch) 
		local phase = touch.phase
		--print("slides", phase)
		if ( phase == "began" ) then
            -- Subsequent touch events will target button even if they are outside the contentBounds of button
            display.getCurrentStage():setFocus( self )
            self.isFocus = true

			startPos = touch.x
			prevPos = touch.x
									
        elseif( self.isFocus ) then
        
			if ( phase == "moved" ) then
				display.getCurrentStage():setFocus( self )
						
				if tween then 
					for i = 1, #tween do
						if tween[i] then
							transition.cancel(tween[i])
						end
					end
					tween = nil
				end
				
				--print(tostring(tween))
				--print(imgNum)
				     
				
				
				if touch.x > barStart and touch.x < barEnd then
					scrollBtn.x = touch.x
				elseif touch.x < barStart then
					scrollBtn.x = barStart
				elseif touch.x > barEnd then
					scrollBtn.x = barEnd 
				end
				
				local delta = pixelwidth * ((scrollBtn.x - prevPos)/barPointsDist)
				prevPos = scrollBtn.x
				
				images[imgNum].x = images[imgNum].x - delta
				
				if (images[imgNum-1]) then
					images[imgNum-1].x = images[imgNum].x - pixelwidth
				end
				
				if (images[imgNum+1]) then  
					images[imgNum+1].x = images[imgNum].x + pixelwidth
				end
				
				if scrollBtn.x > barPoints[imgNum] and barPoints[imgNum+1] then
					if scrollBtn.x >= barStart+barPoints[imgNum+1] then
						imgNum = imgNum + 1
						print("nextImageBar")
						g:dispatchEvent( { name = "slide", type = "left", transtime = 1000, nextSlide = imgNum } )
						
					end
				end
				
				if scrollBtn.x < barPoints[imgNum] and barPoints[imgNum-1] then
					if scrollBtn.x <= barStart+barPoints[imgNum-1] then
						imgNum = imgNum - 1
						print("prevImageBar")
						g:dispatchEvent( { name = "slide", type = "right", transtime = 1000, nextSlide = imgNum } )
						
					end
				end

			elseif ( phase == "ended" or phase == "cancelled" ) then
				
				dragDistance = touch.x - startPos
				--print("dragDistance: " .. dragDistance)
				
				if barPoints[imgNum+1] and (touch.x-barStart > barPoints[imgNum] + (barPoints[imgNum+1] - barPoints[imgNum])/2 and imgNum < #images) then  
					nextImage()
					print("nextImage")
					print("imgNum "..imgNum)
				elseif barPoints[imgNum-1] and (touch.x-barStart < barPoints[imgNum] + (barPoints[imgNum-1] - barPoints[imgNum])/2 and imgNum > 1) then
					prevImage()  
					print("prevImage")
					print("imgNum "..imgNum)
				else
					cancelMove()
					print("cancelMove")
					print("imgNum "..imgNum)
				end
									
				if ( phase == "cancelled" ) then		
					cancelMove()
				end

                -- Allow touch events to be sent normally to the objects they "hit"
                display.getCurrentStage():setFocus( nil )
                self.isFocus = false
														
			end
		end
					
		return true
		
	end
	
	scrollBtn.touch = touchListener2
	scrollBtn:addEventListener( "touch", scrollBtn )
	
	end
	
	function touchListener (self, touch) 
		local phase = touch.phase
		--print("slides", phase)
		if ( phase == "began" ) then
            -- Subsequent touch events will target button even if they are outside the contentBounds of button
            --display.getCurrentStage():setFocus( self )
            self.isFocus = true

			startPos = touch.x
			prevPos = touch.x
									
        elseif( self.isFocus ) then
        
			if ( phase == "moved" ) then
				display.getCurrentStage():setFocus( self )
						
				if tween then 
					if tween[i] then
						transition.cancel(tween[i])
					end
					tween = nil
				end
				
				--print(tostring(tween))
				--print(imgNum)
				
				local delta = touch.x - prevPos
				prevPos = touch.x
				
				
				
				images[imgNum].x = images[imgNum].x + delta
				
				if (images[imgNum-1]) then
					images[imgNum-1].x = images[imgNum].x - pixelwidth
				end
				
				if (images[imgNum+1]) then
					images[imgNum+1].x = images[imgNum].x + pixelwidth
				end

			elseif ( phase == "ended" or phase == "cancelled" ) then
				
				dragDistance = touch.x - startPos
				--print("dragDistance: " .. dragDistance)
				
				if (dragDistance < -40 and imgNum < #images) then
					nextImage()
				elseif (dragDistance > 40 and imgNum > 1) then
					prevImage()
				else
					cancelMove()
				end
									
				if ( phase == "cancelled" ) then		
					cancelMove()
				end

                -- Allow touch events to be sent normally to the objects they "hit"
                display.getCurrentStage():setFocus( nil )
                self.isFocus = false
														
			end
		end
					
		return true
		
	end
	

	
	function cancelTween()
		if prevTween then 
			for i = 1, #prevTween do
				transition.cancel(prevTween[i])
			end
			prevTween = nil
		end
		prevTween = tween 
	end
	
	function nextImage()
		tween = {}
		tween[1] = transition.to( images[imgNum], {time=(pixelwidth-math.abs(dragDistance))*2, x=-pixelwidth, transition=easing.outExpo } )
		tween[2] = transition.to( images[imgNum+1], {time=(pixelwidth-math.abs(dragDistance))*2, x=0, transition=easing.outExpo } )
		if barPoints then
			tween[3] = transition.to( scrollBtn, {time=(pixelwidth-math.abs(dragDistance))*2, x=barStart + barPoints[imgNum+1], transition=easing.outExpo } )
		end
		g:dispatchEvent( { name = "slide", type = "left", transtime = (pixelwidth-math.abs(dragDistance))*2, nextSlide = imgNum+1 } )
		imgNum = imgNum + 1
		initImage(imgNum)
	end
	
	function prevImage()
		tween = {}
		tween[1] = transition.to( images[imgNum], {time=(pixelwidth-math.abs(dragDistance))*2, x=pixelwidth, transition=easing.outExpo } )
		tween[2] = transition.to( images[imgNum-1], {time=(pixelwidth-math.abs(dragDistance))*2, x=0, transition=easing.outExpo } )
		if barPoints then
			tween[3] = transition.to( scrollBtn, {time=(pixelwidth-math.abs(dragDistance))*2, x=barStart + barPoints[imgNum-1], transition=easing.outExpo } )
		end
		g:dispatchEvent( { name = "slide", type = "right", transtime = (pixelwidth-math.abs(dragDistance))*2, nextSlide = imgNum-1 } )
		imgNum = imgNum - 1
		initImage(imgNum)
	end
	
	function cancelMove()
		tween = {}
		tween[1] = transition.to( images[imgNum], {time=400, x=0, transition=easing.outExpo } )
		tween[2] = transition.to( images[imgNum-1], {time=400, x=-pixelwidth, transition=easing.outExpo } )
		tween[3] = transition.to( images[imgNum+1], {time=400, x=pixelwidth, transition=easing.outExpo } )
		if barPoints then
			tween[4] = transition.to( scrollBtn, {time=400, x=barStart + barPoints[imgNum], transition=easing.outExpo } )
		end
	end
	
	function initImage(num)
		if (num < #images) then
			images[num+1].x = pixelwidth
		end
		if (num > 1) then
			images[num-1].x = -pixelwidth
		end
	end

	g.touch = touchListener
	if params.touchScroll ~= false then
		g:addEventListener( "touch", g )
	end

	------------------------
	-- Define public methods
	
	function g:jumpToImage(num)
		local i
		if num == nil then
			return true
		end
		print("jumpToImage")
		print("#images", #images)
		for i = 1, #images do
			if i < num then
				images[i].x = -pixelwidth
			elseif i > num then
				images[i].x = pixelwidth
			else
				images[i].x = 0
			end
		end
		imgNum = num
		if barPoints then
			scrollBtn.x = barStart + barPoints[imgNum]
		end
		initImage(imgNum)
	end

	function g:cleanUp()
		print("slides cleanUp")
		g:removeEventListener("touch", touchListener)
	end
	
	function g:getIndex()
		print("Index = "..imgNum)
		return imgNum
	end

	return g	
end

