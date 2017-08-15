screenHeight = 768
screenWidth = 1366

function love.load()
	love.window.setMode(1366, 768)
	screenResolution = {1366,768}

	love.mouse.setRelativeMode(true)
	love.window.setFullscreen(true)
	screenWidth, screenHeight = love.window.getMode();
	love.graphics.setDefaultFilter("nearest", "nearest", 1)
	require("src/loader")

	--implement ship selection for each scene

	scene = game:new("src/scenarios/testScenario", 8888)

end

function love.update(dt)
	scene:update(dt)

end

function love.draw()
	scene:draw()
end

function love.mousepressed(mx,my,button, isTouch)
	scene:mousepressed(mx, my, button)
end

function love.mousereleased(mx,my,button, isTouch)
	scene:mousereleased(mx, my, button)
end

function love.mousemoved(mx, my, dx, dy, isTouch)
	scene:mousemoved(mx, my, dx, dy, isTouch);
end

function love.wheelmoved( x, y )
	if scene.wheelmoved then
		scene:wheelmoved(x, y);
	end
end

function love.keypressed(key, u)
   --Debug
   -- if key == "rctrl" then
      -- debug.debug() -- freezes game and does not allow alt+tab (needs to be windowed!!!)
   -- end
   scene:keypressed(key, u)
end

function love.textinput(text)
	scene:textinput(text);
end

function love.keyreleased(key, u)
	scene:keyreleased(key, u)
end
