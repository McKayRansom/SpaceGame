game = {}
zoom = 1
viewX = 0
viewY = 0
cameraX = 0
cameraY = 0
display = {} --global for easy debuging
local selecting = false
local selection = {}
local selectionStart = {0,0}
local mouseDown = false --later a table {0, 0, 0, 0, 0}
controlGroups = {} 
local socket = require("socket")
require "enet"

--[[
dump of thoughts for game after code review 8/7/16 (more -- = les priority
loading system and file structure in general :/
menu system at some point... add cool demo like EAW
--the whole power system needs to be rethought... maybe only large ships can do it? makes some sense for space units but not really for tanks and such...
-input handling in general is still pretty rough... very thrown together right now
-this file!!! it should either be all locals or all self.XXXXX the current hodgepoge is really weird.... could also make it a module, that would be cool in the final game we will need creating a new scene to reset everything
-move updateCargoTruck to unit. It is veeeery robust and awesome. should be easily usable for space shuttles too!
-the basic pathfinding raycasting could be improved. add more rays and greated distance ahead, not a priority though, it mostly works :)
---at some point we should try having bullets be love.physics objects and see if that has terrible performance... would make shields difficult though. worth looking into.
---clean up weapons systems, hasn't been looked at in a while. unit:fireWeapons and weapons.lua
-collision damage would be really cool, probably only for hostile units
-clean up effects system sprites are poorly implemented from someone else's code...
--add new effects while you're at it!
-planets should maybe be bigger. The current size is more like an asteroid...
check if love.physics meter is optimal
game really needs basic rts commands. Queing actions, double/ctrl-click on units that kind of thing
-figure out how line formations will work! need to select more than one...
a bunch of things should be moved from unit defs into the unit/truck/trailer objects if possible

what is the play space? solar system with stars+planets would be really cool. Or EAW style with just planets, possibly seperate space + ground, or AI War style with systems...

]]

-- function drawBackground()
	-- love.graphics.push()
	-- love.graphics.translate(-math.floor(viewX/backgroundImageWidth), -math.floor(viewY/backgroundImageHeight))
	-- for i=0,math.ceil((screenWidth/zoom)/backgroundImageWidth) + 1 do
		-- for j=0,8 do
			-- love.graphics.draw(backgroundImage, backgroundImageWidth * i, backgroundImageHeight * j)
		-- end
	-- end
	-- love.graphics.pop()
-- end


function game:setupKeyHandler()
	
	-- keyHandler.new("w", playerFormation.action, playerFormation, "fireEngines")
	-- keyHandler.new("d", playerFormation.action, playerFormation,"turnRight")
	-- keyHandler.new("a", playerFormation.action, playerFormation,"turnLeft")
	-- keyHandler.new("a", playerFormation.action, playerFormation,"leftThrusters")
	-- keyHandler.new("d", playerFormation.action, playerFormation,"rightThrusters")
	-- keyHandler.new("s", playerFormation.action, playerFormation,"reverseThrusters")
	
	
	-- keyHandler.new("1", playerFormation.action, playerFormation, "increasePower", "shields")
	-- keyHandler.new("2", playerFormation.action, playerFormation, "increasePower", "engines")
	-- keyHandler.new("3", playerFormation.action, playerFormation, "increasePower", "weapons")
end

function game:new(scenario, seed) --totdo: implement ship selection for each scene
	loadImages()
	gui.load()
	ships = {}
	love.graphics.setFont(love.graphics.newFont(20))
	if seed then
		self.seed = seed
		love.math.setRandomSeed(seed)
	else
		self.seed = love.math.getRandomSeed()
	end
	self.ore = 0
	zoom = 1
	viewX = 0
	viewY = 0
	cameraX = 0
	cameraY = 0
	require(scenario)
	self:setupKeyHandler()
	
	return self
end

function game:destroy()
	keyHandler.clear()
end
local serverActive
local clientActive

function game:draw()
	love.graphics.scale(zoom, zoom)
	love.graphics.translate(viewX, viewY)
	local p = currentPlanet
	planet.draw(p)
	for i=1, #p.resources do
		love.graphics.draw(resourceDepositImage, p.resources[i][1], p.resources[i][2], 0, 1, 1, 25, 25)
	end
	--a different planet drawing method...
	--love.graphics.setColor(107, 65 ,0 , 255)
	--love.graphics.setLinewidth(10)
	--love.graphics.setLineStyle("rough")
	--love.graphics.circle("line", 3500, 3000, 1400, 45)
	love.graphics.setColor(255,255,255,255)
	-- drawBackground()
	
	for i=1, #p.jumpNodes do
		local n = p.jumpNodes[i]--node
		love.graphics.print(n.destination.name, n.p[x] + 10, n.p[y] - 25)
		love.graphics.draw(jumpNode, n.p[x], n.p[y])
	end
	--draw effects (engine effects and impact effects, basically any sprites)
	for i=1, #p.effects do
		local effect = p.effects[i]
		effect.sprite:start(effect.frame)
		effect.sprite:draw(effect[x], effect[y], effect.angle)
	end
	
	if selection[1] then
		for i=1,#selection do
			if not selection[i].body:isDestroyed() then
				if selection[i].moveQue[1] then -- it is 20x24
					love.graphics.draw(destinationIndicator, selection[i].moveQue[1][1], selection[i].moveQue[1][2], 0, 1, 1, 10, 12)
				end
				love.graphics.setColor(0,255, 0, 100)
				love.graphics.circle("fill", selection[i].body:getX(), selection[i].body:getY(), 20, 45)
				love.graphics.setColor(255,255,255,255)
			end
		end
		
		if selection[1].rayHistory then --debug draw pathfind rays and stuff
			love.graphics.setColor(0,255, 0, 100)
			for i=1, #selection[1].rayHistory do
				love.graphics.line(unpack(selection[1].rayHistory[i]))
			end
			love.graphics.setColor(255,255,255,255)
			love.graphics.setColor(255, 0, 255, 255)
			for i=1, #selection[1].triedPoints do
				
				love.graphics.draw(destinationIndicator, selection[1].triedPoints[i][2], selection[1].triedPoints[i][3], 0, 1, 1, 10, 12)
			end
			love.graphics.setColor(255, 255, 255, 255)
		end
	end
	for i,k in pairs(p.units) do
		k:draw()
	end
	love.graphics.setColor(255, 255, 255, 255)
	projectile.draw(p.spaceProjectiles)
	projectile.draw(p.groundProjectiles)
	laser.draw(p.groundLasers)
	-- laser.draw(p.groundLasers)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.origin()
	if selecting then
		love.graphics.setColor(0, 255, 0, 150)
		love.graphics.rectangle('fill', selectionStart[1], selectionStart[2], mx - selectionStart[1], my - selectionStart[2])
		love.graphics.setColor(255, 255, 255, 255)
	end
	
	gui.draw()
	if self.popup then
		self.popup:draw()
	end
	if love.keyboard.isDown("a") then
		love.graphics.draw(targetCursor, mx, my)
	else
		love.graphics.draw(moveCursor, mx, my)
	end
	if mouseDown and mouseDown[5] > 1 then
		love.graphics.setColor(0, 255, 0, 150)
		love.graphics.line(mx, my, mouseDown[1], mouseDown[2])
		love.graphics.setColor(255, 255, 255, 255)
	end

	--display[2] = (screenWidth*(1/zoom)) / (screenWidth/mx) - viewX this is how to ADJUST FOR ZOOM ON MOUSE
	display[2] = "Selecting: "..tostring(#selection)
	display[1] = "FPS: "..tostring(love.timer.getFPS())
	display[3] = printc
	for i=1, #display do
		love.graphics.print(tostring(display[i]), 2, (20 * i))
	end
	if serverActive then
		love.graphics.print("SERVER", screenWidth - 100, 20)
	end
	if clientActive then
		love.graphics.print("CLIENT", screenWidth - 100, 20)
	end
	-- playerFormation:draw() --debug drawing for player formation
end

function game:update(dt)
	if serverActive then
		server:update(dt)
	end
	if clientActive then
		client:update(dt)
	end
	local oldX, oldY = mx, my
	mx, my = love.mouse.getPosition() --global acess to mouse position should be removed at somepoint... used only by player ships for turret pointing (and by gui a lot)
	if not player then --update camera (rts mode)
		local dx, dy = 0, 0
		local d = 10 / zoom
		if love.keyboard.isDown("up") or my < 5 then dy = -d
		elseif love.keyboard.isDown("down") or my > screenHeight - 5 then dy = d end
		if love.keyboard.isDown("left") or mx < 5 then dx = -d
		elseif love.keyboard.isDown("right") or mx > screenWidth -5 then dx = d end
		cameraX = cameraX + dx
		cameraY = cameraY + dy
		viewX = -cameraX + ((screenWidth/2) * 1/(zoom))
		viewY = -cameraY + ((screenHeight/2) * 1/(zoom))
	end
	
	worldMX, worldMY = (screenWidth*(1/zoom)) / (screenWidth/mx) - viewX, (screenHeight*(1/zoom)) / (screenHeight/my) - viewY
	self.ore = 0
	if not (oldX == mx and oldY == my) then
		gui.mouseMoved()
	end
	if self.paused then return end --if paused don't update ships
	if selection[1] then --debug printing of economy infos
		display[3] = selection[1].cargo
		display[4] = not selection[1].disabled
		display[5] = selection[1].ore or selection[1].metal
		display[6] = selection[1].oreExpectedAmount or selection[1].metalExpectedAmount
		if selection[1].time then
			display[7] = math.floor(selection[1].time)
		end
	end
	if player then --we are controlling a vehicle
		keyHandler.update() --really should move this into a player file...
		local px, py = player.body:getX(), player.body:getY()
		screenX =  -px + (screenWidth/2)
		screenY =  -py + (screenHeight/2)
		viewX = -px + ((screenWidth/2) * 1/(zoom))
		viewY = -py + ((screenHeight/2) * 1/(zoom))
			--TODO: replace this with a callback
		
			if love.mouse.isDown("l")  then
				player:fireWeapons(1)
			end
			if love.mouse.isDown("r") then
				player:fireWeapons(2)
			end
		-- playerFormation:update()		
	end
	scenarioUpdate(dt)
	self:updateAllPlanets(dt)
	
	for i=1, #formations do -- updates line formations
		if formations[i] then
			formations[i]:update(dt)
		end
	end
	if mouseDown then
		mouseDown[5] = mouseDown[5] + dt
	end
end

function game:updateAllPlanets(dt)
	for i=1,#planets do
		local k=planets[i]
		k.world:update(dt)
		local j = 1
		while k.units[j] do
			k.units[j]:update(dt)
			j = j+1
		end
		projectile.updatePhysics(k, dt)
		unit.updateEffects(k, dt) --wow, this needs to be changed. we are using the unit updateEffects function for the planetwide effects (are there any?)
	end
end


--kinda want to change jumping to more StarWars esque
function game:checkJump() --se if selected units can jump (should be changed to a certain group of units when better stuff is added 
	for i=1,#selection do
		for j=1,#currentPlanet.jumpNodes do
			if utils.getDistance(selection[i].body:getX(), selection[i].body:getY(), currentPlanet.jumpNodes[j].p[1], currentPlanet.jumpNodes[j].p[2]) < 500 then
				selection[i]:jumpTo(currentPlanet.jumpNodes[j].destination)
				if selection[i].player then
					currentPlanet = currentPlanet.jumpNodes[j].destination
				end
				break
			end
		end
		
	end
end

function game:land() -- land ground troops on planet, should add shuttles and cooler stuff
	for i=1,#selection do
		selection[i]:landOn()
	end
end


--switch player vehicle. someday this should involve walking and/or shuttle :)
function game:switchPlayerVehicle()
	for i=1,#currentPlanet.units do
		local k = currentPlanet.units[i]
		if not (k == player)then
			local dist = utils.getDistance(k.body:getX(), k.body:getY(), player.body:getX(), player.body:getY())
			print("testing switch player with dist:"..tostring(dist))
			if dist < 100 then
				player.player = false
				player = k
				k.player = true
				playerFormation.flagship = k
				return
			end
		end
	end
end

--too all purpose. Make a bunch of these handled by keyhandler
function game:keypressed(key, u)
	if gui.keypressed(key, u) then return end
	-- if key == "lshift" then
		-- player:toggleDampeners() -- crashes the game :( needs to be re-implemented
	if key == "t" then
		local px, py = player.body:getPosition()
		for i=1, #tradingObjects do
			if tradingObjects[i]:isInTradingRange(px, py) then
				self.popup = tradingScene.new(tradingObjects[i])
				return
			end
		end
	elseif key == "j" then
		self:checkJump()
	elseif key == "l" then
		self:land()
	elseif key == "e" then
		self:switchPlayerVehicle()
	elseif key == "escape" then
		love.event.quit()
	elseif tonumber(key) then
		if love.keyboard.isDown("rctrl") or love.keyboard.isDown("lctrl") then
			controlGroups[key] = selection
		elseif controlGroups[key] then
			selection = controlGroups[key]
		end
	-- elseif key == "f1" then
		-- for i=1, #currentPlanet.resources do
			-- local node = currentPlanet.resources[i]
			-- if node.built == false then
				-- oreMine:new(currentPlanet, node,  teams[1])
				-- break
			-- end
		-- end
	elseif key == "f1" then
		metalFactory:new(currentPlanet, cameraX, cameraY, teams[1])
	elseif key == "f2" then
		miningTruck:new(currentPlanet, cameraX, cameraY, teams[1])
	elseif key == "f3" then
		tank:new(currentPlanet, cameraX, cameraY, teams[1])
	elseif key == "f4" then
		tankFactory:new(currentPlanet, cameraX, cameraY, teams[1])
	elseif key == "f5" then
		miningTruckFactory:new(currentPlanet, cameraX, cameraY, teams[1])
	elseif key == "f11" then
		server:new()
		serverActive = true
		print("startingServer")
		
	elseif key == "f12" then
		client:new()
		clientActive = true
		print("startingClient")
		
	elseif key == "r" then
		for i=1, #selection do
			selection[i]:payDebts()
			selection[i].findDestination = true
		end
	elseif key == "tab" then
		if player then
			playerFormation = false
			player = false
		elseif selection[1] then
			player = selection[1]
			playerFormation = formation.new({}, player)
		end
	elseif key == "o" then
		for i=1, #selection do
			selection[i].disabled = not selection[i].disabled
		end
	elseif key == "p" then
		self.paused = not self.paused
	end
	
end
function game:keyreleased(key, u)
	-- if key == "lshift" then
		-- player:toggleDampeners()
	-- end
end
--set the cargo of cargoTrucks
function game.setSelectionCargo(cargo)
	for i=1, #selection do
		if selection[i].cargoTruck then
			selection[i]:payDebts()
			selection[i].findSupply = true
			selection[i].findDemand = false
			selection[i].cargo = cargo
			selection[i][cargo] = 0
			selection[i][cargo.."Max"] = 1
		end
	end
end
--called by gui input map
function game:onButtonDown(action)
	if action =="metalIcon" then
		self:setSelectionCargo("metal")
	elseif action == "oreIcon" then
		self:setSelectionCargo("ore")
	end
end

function game:mousepressed(mx, my, button)
	if gui.mousepressed(mx, my, button) then return end
	if button == "l" then 
		selecting = true
		if not love.keyboard.isDown("lshift") then 
			selection = {}
		end
		selectionStart = {mx, my}
	elseif button == "r" then 
		mouseDown = {mx, my, (screenWidth*(1/zoom)) / (screenWidth/mx) - viewX, (screenHeight*(1/zoom)) / (screenHeight/my) - viewY, 0}
	elseif button == "wu" then-- and  zoom < 2 then FIX: replaced in love 0.10
		zoom = zoom  + .1
	elseif button == "wd" then
		zoom = zoom - .1
		if zoom < .1 then zoom = .05 end
	end
	
end

function game:mousereleased(mx, my, button)
	if button == "l" and selecting then
		ships = currentPlanet.units
		local startX, startY = (screenWidth*(1/zoom)) / (screenWidth/selectionStart[1]) - viewX, (screenHeight*(1/zoom)) / (screenHeight/selectionStart[2]) - viewY
		local endX, endY = (screenWidth*(1/zoom)) / (screenWidth/mx) - viewX, (screenHeight*(1/zoom)) / (screenHeight/my) - viewY
		for i=1, #ships do
			local s = ships[i]
			local x, y = s.body:getPosition()
			if (x > startX and x < endX) and ( y > startY and y < endY) and not s.isTrailer then
				
				-- if ships[i].formation then
					-- if selection[1] and selection[1].formation and love.keyboard.isDown("lshift") and not (selection[1].formation == ships[i].formation) then -- merge formations
						-- ships[i].formation:merge(selection[1].formation)
						-- selection = selection[1].formation.units
						-- break
					-- else
						-- selection = ships[i].formation.units
						-- break -- this needs fixing :( not sure how though...
					-- end
				-- end
				table.insert(selection, ships[i])
			end
		end
		selecting = false
		gui.updateSelection(selection)
	elseif button == "r" and mouseDown then
		if mouseDown[5] > 1 then
			self:moveSelectionTo(mx, my, mouseDown)
		else
			self:moveSelectionTo(mx, my)
		end
		mouseDown = false
	else
		gui.mousereleased(mx, my, button)
	end
end
	
function game:moveSelectionTo(mx, my, mouseDown)
	if not selection[1] then return end
	local mx, my = (screenWidth*(1/zoom)) / (screenWidth/mx) - viewX, (screenHeight*(1/zoom)) / (screenHeight/my) - viewY
	local destAngle
	if mouseDown then
		destAngle = utils.getAngle(mx-mouseDown[3], my - mouseDown[4])  +math.pi/2
		mx, my = mouseDown[3], mouseDown[4]
	end
	local isAttackMove = false
	if love.keyboard.isDown("a") then
		isAttackMove = true
	end
	if #selection > 1 then
		local f = lineFormation.new(selection)
		f:moveTo(mx, my, destAngle, isAttackMove)
	else
		selection[1]:moveTo(mx, my, destAngle, isAttackMove)
	end
	-- if selection[1].formation then
		-- selection[1].formation.moveQue = {}
		-- selection[1].formation:moveTo(mx, my, isAttackMove)
	-- else
	--copy this from formation!!!
	
		-- for i=1, #selection do
			-- selection[i]:moveTo(mx, my, isAttackMove)
		-- end
	-- end
	
end