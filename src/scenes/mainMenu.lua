mainMenu = {}

function mainMenu:new()
	loadImages()
	gui.load("mainMenuElements")
	love.graphics.setFont(love.graphics.newFont(20))
	self.mx, self.my = love.mouse.getPosition()
	return self
end

function mainMenu:destroy()
end
function mainMenu:draw()

	love.graphics.origin()


	gui.draw()
	if self.popup then
		self.popup:draw()
	end

	love.graphics.draw(moveCursor, self.mx, self.my)

	--display[1] = "FPS: "..tostring(love.timer.getFPS())
	--for i=1, #display do
--		love.graphics.print(tostring(display[i]), 2, (20 * i))
--	end
end

function mainMenu:update(dt)
	self.mx, self.my = love.mouse.getPosition()
end

--too all purpose. Make a bunch of these handled by keyhandler
function mainMenu:keypressed(key, u)
	if key == "escape" then
		love.event.quit()
	elseif gui.keypressed(key, u) then
		return
	end
end

function mainMenu:textinput(text)
	gui.textinput(text)
end

function mainMenu:keyreleased(key, u)

end

function mainMenu:mousepressed(mx, my, button)
	if gui.mousepressed(mx, my, button) then return end

end

function mainMenu:mousereleased(mx, my, button)
	gui.mousereleased(mx, my, button)
end

function mainMenu:mousemoved(mx, my, dx, dy, isTouch)
	gui.mouseMoved(mx, my);
end
