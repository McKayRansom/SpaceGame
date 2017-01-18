function love.load()
	love.window.setMode(1366,768)
	screenResolution = {1366,768}
	screenHeight = 768
	screenWidth = 1366
	love.mouse.setRelativeMode(true)
	love.window.setFullscreen(true)
	screenWidth = love.window.getWidth()
	screenHeight = love.window.getHeight()
	love.graphics.setDefaultFilter("nearest", "nearest", 1)
	require("src/loader")
	
	--implement ship selecction for each scene

	scene = game:new("src/scenarios/holdTheLine", 1713)
	
end

function love.update(dt)
	scene:update(dt)

end

function love.draw()
	scene:draw()
end

function love.mousepressed(mx,my,button)
	scene:mousepressed(mx, my, button)
end

function love.mousereleased(mx,my,button)
	scene:mousereleased(mx, my, button)
end

function love.keypressed(key, u)
   --Debug
   -- if key == "rctrl" then
      -- debug.debug() -- freezes game and does not allow alt+tab (needs to be windowed!!!)
   -- end
   scene:keypressed(key, u)
end

function love.keyreleased(key, u)
	scene:keyreleased(key, u)
end
