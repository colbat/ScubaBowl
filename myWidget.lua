module(..., package.seeall)

local returnVariable


local buttonSheet = graphics.newImageSheet("graphics/Buttons.png", sheets.getSpriteSheetDataButtons())

function createButton( type, text, listener )
	local group = display.newGroup()
	if listener == nil then listener = text; text = nil end
	local button
	if type == "circle" then
		button = widget.newButton{
	    	sheet = buttonSheet,
	    	defaultIndex = 2,
	    	overIndex = 1,
			width = 134,
			height = 133,
			onEvent = listener,}
	--[[
	elseif type == "smallCircle" then
		button = widget.newButton{
	    	defaultIndex = "graphics/buttonPause.png",
	    	overIndex = "graphics/buttonPause_over.png",
			onEvent = listener,} 
			]]
	end
	group:insert(button)
	if text ~= nil then
		local Text = display.newText(text, 0, 0, "Wasser", 24)
		Text:setTextColor(255)
		Text.x = button.x
		Text.y = button.y 
		group:insert(Text)
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
		text[i] = display.newText(table[i], 0,0, "Wasser", font)
		text[i].y = (i-1)*text[i].contentHeight/2*3
		text[i].x = 0
		group:insert(text[i])
	end
	--text.x = 600;
	--text.y = 600;
	group:setReferencePoint(display.CenterReferencePoint)
	returnVariable = group
	group = nil
	return returnVariable
end
