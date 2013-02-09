module(..., package.seeall)

local returnVariable



function createText(text, font, params )
	local group = display.newGroup()
	text = checkText(text)
	if params == nil then
		params = {}
	end
	
	local lowerText = display.newText(text, 0, 0, univFont, font*fontDiff)
	lowerText:setTextColor(0)
	local upperText = display.newText(text, 0, 0, univFont, font*fontDiff)
	upperText:setTextColor(255)
	if params.color == "white" then lowerText.isVisible = false 
	elseif params.color == "black" then upperText.isVisible = false end
	lowerText.x = lowerText.x + 8
	lowerText.y = lowerText.y + 8-- + 18
	--upperText.y = upperText.y + 10
	group:insert(lowerText)
	group:insert(upperText)
	group.changeText = function(text2)
		text2 = checkText(text2)
		lowerText.text = text2
		upperText.text = text2
	end
	--[[local bg = display.newRect( 0, 0, group.contentWidth, group.contentHeight )
	bg.alpha = 0.7
	bg:setFillColor(0)
	group:insert(bg)
	group:insert(lowerText)
	group:insert(upperText)]]
	group:setReferencePoint(display.CenterReferencePoint)
	returnVariable = group
	group = nil
	return returnVariable
end

function createButton( type, text, listener )
	local group = display.newGroup()
	if listener == nil then listener = text; text = nil end
	local button
	text = checkText(text)
	if type == "large" then
		button = widget.newButton{
	    	sheet = buttonSheet,
	    	defaultIndex = 2,
	    	overIndex = 1,
			width = 888,
			height = 172,
			onEvent = listener,
		}
	elseif type == "medium" then
		button = widget.newButton{
			sheet = buttonSheet,
	    	defaultIndex = 4,
	    	overIndex = 3,
			width = 668,
			height = 172,
			onEvent = listener
		}
	elseif type == "small" then
		button = widget.newButton{
	    	sheet = buttonSheet,
	    	defaultIndex = 6,
	    	overIndex = 7,
			width = 392,
			height = 172,
			onEvent = listener
		}
	elseif type == "circle" then
		button = widget.newButton{
	    	sheet = buttonSheet,
	    	defaultIndex = 9,
	    	overIndex = 8,	
			width = 220,
			height = 220,
			onEvent = listener
		}
	elseif type == "facebook" then
		button = widget.newButton{
	    	sheet = buttonSheet,
	    	defaultIndex = 17,
	    	overIndex = 16,	
			width = 160,
			height = 160,
			onEvent = listener
		}
	elseif type == "twitter" then
		button = widget.newButton{
	    	sheet = buttonSheet,
	    	defaultIndex = 15,
	    	overIndex = 18,	
			width = 160,
			height = 160,
			onEvent = listener
		}
	elseif type == "pause" then
		button = widget.newButton{
	    	sheet = buttonSheet,
	    	defaultIndex = 13,
	    	overIndex = 12,
			width = 282,
			height = 124,
			onEvent = listener
		}
	elseif type == "restart" then
		button = widget.newButton{
	    	sheet = buttonSheet,
	    	defaultIndex = 22,
	    	overIndex = 21,
			width = 124,
			height = 124,
			onEvent = listener
		}
	end
	group:insert(button)
	if type ~= "facebook" and type ~= "twitter" and type ~= "pause" and type ~= "restart" then
		button.alpha = 0.9
	end
	if type == "circle" then 
		local arrow = display.newImage(buttonSheet, 20, true)
		arrow.x = button.x
		arrow.y = button.y
		group:insert(arrow)
	else
	if type == "small" and (text == "music" or text == "sounds") then
		local icon
		if text == "music" then
			icon = display.newImage(buttonSheet, 19, true)
		elseif text == "sounds" then
			icon = display.newImage(buttonSheet, 14, true)
		end
		icon.x = button.x
		icon.y = button.y
		group:insert(icon)
		local xBtn = display.newImage(buttonSheet, 23, true)
		xBtn.x = 278
		xBtn.y = 120
		group:insert(xBtn)
	elseif type == "small" and (text == "achievements" or text == "leaderboards") then
		local icon
		if text == "achievements" then
			icon = display.newImage(buttonSheet, 11, true)
		elseif text == "leaderboards" then
			icon = display.newImage(buttonSheet, 10, true)
		end
		icon.x = button.x
		icon.y = button.y
		group:insert(icon)
	elseif text ~= nil then
	local lowerText = display.newText(text, 0, 0, univFont, 160*fontDiff)
	lowerText:setTextColor(0)
	local upperText = display.newText(text, 0, 0, univFont, 160*fontDiff)
	upperText:setTextColor(255)
	lowerText.x = button.x + 8
	lowerText.y = button.y + 8
	upperText.x = button.x
	upperText.y = button.y 
	group:insert(lowerText)
	group:insert(upperText)
	end
	end
	group:setReferencePoint(display.CenterReferencePoint)
	returnVariable = group
	group = nil
	return returnVariable
end







function createMultLines(table, font, options)
	--myWidget.createMultLines({"hi", "bye"}, 160, {color = "white", arrow = "right"})
	if options == nil then options = {} end
	local color = options.color
	local group = display.newGroup()
	local text = {}
	for i = 1, #table do
		text[i] = createText(table[i], font)
		text[i].y = (i-1)*text[i].contentHeight/2*1.25
		text[i].x = 0
		if color == "white" then
			text[i][1].isVisible = false
		elseif color == "black" then
			text[i][2].isVisible = false
		elseif type(color) == "table" then
			text[i][1].isVisible = false
			text[i][2]:setTextColor(color[1], color[2], color[3])
		end
		group:insert(text[i])
	end
	group:setReferencePoint(display.CenterReferencePoint)
	returnVariable = group
	group = nil
	return returnVariable
end
