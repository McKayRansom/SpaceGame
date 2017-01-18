keyHandler = {}
local list = {}

function keyHandler.update()
	for k,v in pairs(list) do
		if love.keyboard.isDown(k) then
		list[k].func(unpack(list[k].arguments))
		end
	end
end

function keyHandler.new(keycode, f, ...)
	list[keycode] = {func = f, arguments = {...}}
end

function keyHandler.clear()
	list = {}
end

clickHandler = {}

local buttons = {}

function clickHandler.mousepressed(mx, my)
	-- display[4] = mx display[5] = my
	for i=1, #buttons do
		local b = buttons[i]
		if (b[1] < mx and mx < b[3]) and (b[2] < my and my < b[4]) then --the click was within this button
			b.callback(unpack(b.args))
			return true
		end
	end
	return false
end

function clickHandler.addInputMap(inputMap, callback)
	for i=1, #inputMap do
		clickHandler.add(inputMap[i][1], inputMap[i][2], inputMap[i][3], inputMap[i][4], callback.onButtonDown, {callback, inputMap[i][5]})
	end
end
function clickHandler.add(x1, y1, x2, y2, callback, args)
	buttons[#buttons+ 1] = {x1, y1, x2, y2, callback = callback, args = args}
end