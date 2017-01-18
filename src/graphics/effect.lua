-- for movable effects that play once (explosions etc)
effect = {}
--activEffects = {}
-- function effects.new(sprite, lingering)
	-- local object = physicsObject.new()
	-- object.currentFrame = 1
	-- object.numFrames = 
	-- object.sprite = sprite
	-- object.delta = 0
	-- object.delay = object.sprite.delay
	-- object.parents = {physicsObject, SpriteAnimation}
	-- --setmetatable(object, { __index = utils.checkParents })
	-- table.insert(activeEffects, object)
	-- return #activeEffects
-- end

function effect.new(ship, posX, posY, sprite, linger, loop, a)
	local object = {}
	assert(sprite, "no sprite for a new effect")
	object.sprite = sprite
	object.frame = 1
	object.dt = 0
	if ship.body then -- this is a ship
		local dx = ship.body:getX()-posX
		local dy = ship.body:getY()-posY
		local angle = utils.getAngle(dx, dy) + math.rad(90)
		object.linger = linger
		object.loop = loop
		local shipAngle = ship.body:getAngle()
		object.angle = a or (angle -shipAngle + math.rad(90))
		object[x], object[y] = utils.getRelativeCoords(ship.body:getX(), ship.body:getY(), posX, posY, shipAngle)
		table.insert(ship.effects, object)
		return object
	else -- this is a planet
		object.linger = linger
		object.loop = loop
		object.angle = a
		object[x], object[y] = posX, posY
		table.insert(ship.effects, object)
		return object
	end
	
end

-- function effects.draw()
	-- for i=1, #activeEffects do
		-- local o = activeEffects[i]
		-- o.sprite.currentFrame = o.currentFrame
		-- o.sprite:draw(o.p[x], o.p[y] , o.angle)
	-- end
-- end

-- function effects.update(dt)
	-- for i=1, #activeEffects do
		-- local o = activeEffects[i]
		-- if o then
		-- physicsObject.updatePhysics(o,dt)
		-- o.delta = o.delta + dt
		-- if o.delta > o.delay then
			-- o.currentFrame = o.currentFrame + 1
			-- o.delta = 0
		-- end
		-- if o.currentFrame> o.numFrames then
			-- table.remove(activeEffects, i)
		-- end
		-- end
	-- end
-- end