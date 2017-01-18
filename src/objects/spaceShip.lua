spaceShip = {}

function spaceShip:new(planet, x, y, team, angle, vx, vy)
	self.spaceShip = true
	unit.new(self, planet, x, y, team, angle, vx, vy) 
	table.insert(self.parents, spaceShip)
	table.insert(planet.spaceUnits, self)
	self.targetUpdateTime = 0
	self.targets = {}
	self.moveQue = {}
	return self
end

function spaceShip:increasePower(which)
	local s = -.02
	if not (self.shieldPowerPercent >= .02) then s = -self.shieldPowerPercent end 
	local e = -.02
	if not (self.enginePowerPercent >= .02) then e = -self.enginePowerPercent end
	local w = -.02
	if not (self.weaponPowerPercent >= .02) then w = -self.weaponPowerPercent end
	if which == "shields" then s = -e-w
	elseif which == "engines" then e = -w-s
	elseif which == "weapons" then w = -e-s end
	self.shieldPowerPercent = self.shieldPowerPercent + s
	self.enginePowerPercent = self.enginePowerPercent  + e
	self.weaponPowerPercent = self.weaponPowerPercent + w
end

function spaceShip:fireEngines()
	local force = self.engineForce * self.enginePowerPercent * (self.engineHealth/self.engineMaxHealth)
	local angle = -self.body:getAngle()
	local fx = -math.sin(angle) * force
	local fy = -math.cos(angle) * force
	self.body:applyForce(fx, fy)
end

function spaceShip:reverseThrusters()
	local force = self.thrusterForce * self.enginePowerPercent * (self.engineHealth/self.engineMaxHealth)
	local angle = -self.body:getAngle()
	local fx = math.sin(angle) * force
	local fy = math.cos(angle) * force
	self.body:applyForce(fx, fy)
end

function spaceShip:leftThrusters()
	local force = self.thrusterForce * self.enginePowerPercent * (self.engineHealth/self.engineMaxHealth)
	local angle = -self.body:getAngle() + math.rad(90)
	local fx = -math.sin(angle) * force
	local fy = -math.cos(angle) * force
	self.body:applyForce(fx, fy)
end

function spaceShip:rightThrusters()
	local force = self.thrusterForce * self.enginePowerPercent * (self.engineHealth/self.engineMaxHealth)
	local angle = -self.body:getAngle() - math.rad(90)
	local fx = -math.sin(angle) * force
	local fy = -math.cos(angle) * force
	self.body:applyForce(fx, fy)
end


function spaceShip:turnRight()
	self.body:applyTorque(50 * self.thrusterForce * self.enginePowerPercent * (self.engineHealth/self.engineMaxHealth) )
end

function spaceShip:turnLeft()
	self.body:applyTorque( -50 * self.thrusterForce * self.enginePowerPercent * (self.engineHealth/self.engineMaxHealth))
end

function spaceShip:toggleDampeners()
	self.dampeners = not self.dampeners
end	

function spaceShip:landOn()
	if self.landingUnit then
		local planet = self.planet
		local sx, sy = self.body:getPosition()
		local planetX, planetY = planet.x, planet.y
		if utils.getDistance(planetX, planetY, sx, sy) < planet.radius + 100 then
			local angle = utils.getAngle(sx -planet.x, sy-planet.y)
			local pointX, pointY = (planet.radius - 50) * math.cos(angle) + planet.x, (planet.radius - 50) * math.sin(angle) + planet.y
			for i=1, self.landingQuantity do
				local unit = self.landingUnit:new(pointX, pointY, angle, self.team, 0, 0, self.player)
				if self.player then
					self.player = false
					player = unit
					playerFormation.flagship = player
				end				
			end
		end
	end
end

function spaceShip:jumpTo(planet)
	local x, y = self.body:getPosition()
	local vx, vy = self.body:getLinearVelocity()
	local angle = self.body:getAngle()
	local va = self.body:getAngularVelocity()
	self.body:destroy()
	for i=1, #planet.jumpNodes do
		if planet.jumpNodes[i].destination.name == self.planet.name then
			local p = planet.jumpNodes[i].p
			x, y = p[1] + 75, p[2] + 75
		end
	end
	self.body = love.physics.newBody(planet.world, x, y, "dynamic")
	if self.shape then
		self.physicsShape = love.physics.newPolygonShape(unpack(self.shape))
	else
		self.physicsShape = love.physics.newRectangleShape(self.collisionHeight, self.collisionWidth)
	end
	self.fixture = love.physics.newFixture(self.body, self.physicsShape)
	self.body:setLinearVelocity(vx,vy)
	self.body:setAngle(angle)
	self.body:setAngularVelocity(va)
	utils.removeFromTable(self.planet.units, self)
	utils.removeFromTable(self.planet.spaceUnits, self)
	table.insert(planet.units, self)
	table.insert(planet.spaceUnits, self)
	self.planet = planet
end

function spaceShip:moveTo(x,y, angle, isAttackMove)
	self.moveQue = {{x,y, angle}}
	self.moveState = false
	self.isAttackMove = isAttackMove
end

function spaceShip:stopTurning(force)
	local rotationalVelocity = self.body:getAngularVelocity()
	if rotationalVelocity > 0 then
		self:turnLeft()
	elseif rotationalVelocity < 0 then
		self:turnRight()
	end
end

function spaceShip:drawSelf()

end

function spaceShip:updateSelf(dt)
	
	
	local sx, sy = self.body:getPosition()
	local sa = self.body:getAngle()
	local vx, vy = self.body:getLinearVelocity()
	local force = self.thrusterForce * self.enginePowerPercent * (self.engineHealth/self.engineMaxHealth)
	
	
	if self.weapons[1] then
		self.targetUpdateTime = self.targetUpdateTime + dt
		if self.targetUpdateTime > .25 then
			self.targetUpdateTime = 0
			self.targets = {}
			for i=1,#self.planet.spaceUnits do
				local k = self.planet.spaceUnits[i]
				if (math.abs(utils.getDistance(sx,sy,k.body:getX(), k.body:getY())) < 1000) and(not (k.team == self.team)) and (not k.dead) and (k.body) then
					self.targets[#self.targets + 1] =  k
				end
			end
		end
	end
	 if self.player then
		if self.dampeners then
			self:stopTurning()
			
			if math.abs(vx) < .15 and math.abs(vy) < .15 then
				self.moveState = false
				self.moveQue = {}
			end
			local fx = -force * vx/math.abs(vx)
			local fy = -force * vy/math.abs(vy)
			self.body:applyForce(fx, fy)
		end
		self:dampenMovement(sa, vx, vy)
		local a, b =  worldMX, worldMY
		for i=1,#self.weapons do
			if not self.weapons[i]:pointTowards(a,b, 0,0, sx, sy, self.body:getAngle()) then
				for j=1,#self.targets do
					local a, b = self.targets[j].body:getPosition()
					local c, d = self.targets[j].body:getLinearVelocity()
					local bool = self.weapons[i]:pointTowards(a,b, c, d, sx, sy, self.body:getAngle()) or false
					if bool ==true then
						self.weapons[i].target = self.targets[j]
						break
					end
				end
			else
				self.weapons[i].target = self.targets[1] -- TEMP MISSILE TEST
			end
			if self.weapons[i].reload < self.weapons[i].reloadTime then
				self.weapons[i].reload = self.weapons[i].reload + dt
			end
		end
	end
		
		-- -- if player.angularA == 0 then
			-- -- player.angularV = player.angularV * (1-(dt * .3) )
		-- -- end
	if self.targets[1] then --ai ship
		if debug_settings.noAI then
			return
		end
		--AI weapon firing
		for i=1,#self.weapons do
			if self.weapons[i].reload < self.weapons[i].reloadTime then
				self.weapons[i].reload = self.weapons[i].reload + dt
			end
			for j=1,#self.targets do
				local a, b = self.targets[j].body:getPosition()
				local c, d = self.targets[j].body:getLinearVelocity()
				local bool = self.weapons[i]:pointTowards(a,b, c - vx, d - vy, sx, sy, self.body:getAngle()) or false
				if bool ==true then
					self.weapons[i].target = self.targets[j]
					break
				end
			end
		end
		self:fireWeapons()
	end
	

	-- if self.formation then -- UNFINISHED :(
		-- local dx, dy = sx - self.formationX, sy - self.formationY
		-- local angle = utils.getAngle(dx, dy)
		-- local dist = utils.getDistance(dx, dy)
		-- local dvx, dvy = vx - self.formationVX, vy - self.formationVY
		-- --local 
		-- local fy = -math.sin(angle) * force
		-- local fx = -math.cos(angle) * force
		-- self.body:applyForce(fx, fy)
	if self.moveQue[1] then--and not (self.isAttackMove and targets[1]) then
		local dx = sx - self.moveQue[1][1]
		local dy = sy - self.moveQue[1][2]
		local angle = utils.getAngle(dx, dy)
		local dist = utils.getDistance(dx, dy)
		local velocity = utils.getDistance(vx, vy)
		if not self.moveState then
			-- if dist < 1000 then
				self.moveState = "shortA"
				-- self.halfway = dist/2
			-- else -- dist > 1000f
				-- self.moveState = "faceTowards"
			-- end
		else
			-- display[2] = self.moveState
			if self.moveState == "shortA" then
				local dir = 1
				if dist < (velocity^2)/(2 * (force/self.body:getMass())) then -- dist < stopping distance
					dir = -1
					if dist < 10 then
						self.moveState = "STOP"
					end
				end
				local fy = -math.sin(sa + math.pi/2) * force * dir
				local fx = -math.cos(sa + math.pi/2) * force * dir
				self.body:applyForce(fx, fy)
				self:dampenMovement(sa, vx, vy)
				self:turnTowards(angle, sa, force)
			elseif self.moveState == "STOP" then
				if math.abs(vx) < .15 and math.abs(vy) < .15 then
					self.moveState = false
					self.moveQue = {}
				end
				angle = utils.getAngle(vx, vy)
				local fx = -force * vx/math.abs(vx)
				local fy = -force * vy/math.abs(vy)
				self.body:applyForce(fx, fy)
				self:stopTurning()
			end
			-- if self.moveState == "faceTowards" then
				-- local rotVel = self.body:getAngularVelocity()
				-- local t = angle/rotVel
				-- local a = self.body:getInertia()/(force * 10)
				-- local stopDist = (force*10)*
				-- if angle/rotVel > 
				-- angle = utils.getAngle(vx, vy)
				-- local fy = math.sin(angle) * force
				-- local fx = math.cos(angle) * force
				-- self.body:applyForce(fx, fy)
		end
	elseif self.targets[1] and not self.player then
		
		--movement AI
		assert(self.targets[1].body, "there is no body")
		assert(self.targets[1].body.getX, "there is no getX function")
		local dx = sx - self.targets[1].body:getX()
		local dy = sy - self.targets[1].body:getY()
		local angle = utils.getAngle(dx, dy)
		local velocity = utils.getDistance(vx, vy)
		
		local velX, velY = self.targets[1].body:getLinearVelocity()
		local targetVelocity = utils.getDistance(velX, velY)
		local dir = 0
		if not self.broadside then
			angle = angle - math.pi/2
		end
		local da = utils.limitAngle(sa-angle)
		if da > 0 then
			dir = -1
		else -- angle < sa
			dir = 1
		end
		-- display[3] = da
		local rotationalVelocity = self.body:getAngularVelocity()
		if math.abs(da) > (rotationalVelocity^2)/(2 * ((force*50)/self.body:getInertia())) then
			self.body:applyTorque(force * dir * 50)
		else --slow rotation because we're facing target
			self:stopTurning()
		end
		local dist = utils.getDistance(dx, dy)
		if not self.fighter then
			if dist > 700 + velocity + targetVelocity  then -- get closer to target TODO: add max DIST?
				local fy = -math.sin(angle) * force
				local fx = -math.cos(angle) * force
				self.body:applyForce(fx, fy)
			else--if dist < 500 then --match target velocity
				self:dampenMovement(sa, vx, vy)
				-- local fy = vy-velY
				-- local fx = vx-velX
				-- local angle = utils.getAngle(fx, fy)
				-- fy = -math.sin(angle) * force
				-- fx = -math.cos(angle) * force
				-- self.body:applyForce(fx, fy)
			end
		else
			if dist > 500 then
				self:fireEngines()
			else
				self:reverseThrusters()
				self:leftThrusters()
			end
			self:dampenMovement(sa, vx, vy)
		end
	end
	

end

function spaceShip:dieSelf()
	utils.removeFromTable(self.planet.spaceUnits, self)
end

local function updateTurning(self) --old? doesn't seem to be used
	local px, py = self.body:getPosition()
	local tx, ty = self.target.body:getPosition()
	local dx, dy = px-tx, py-ty
	local targetAngle = utils.getAngle(dx, dy)
	local dist = utils.getDistance(dx, dy)
	targetAngle = targetAngle + self.targetAngle
	local shipAngle = self.body:getAngle()
	if self.turnState == "accel" then
		if self.body:getAngularVelocity() < self.aiTurningSpeed then
		
		end
	else
		--start a new turn
		--shipAngle - tarutils.getAngle
		
	end
end

function spaceShip:turnTowards(angle, sa, force)
	da = utils.limitAngle(sa - angle + math.pi/2)
	local va = self.body:getAngularVelocity()
	local dir = -da/math.abs(da)
	if math.abs(da) > .01 then --turn towards target
		local angleToStop = (va^2)/(2*((force*50)/self.body:getInertia()))
		-- display[2] = "dir:"..tostring(dir)
		-- display[3] = "angularV:"..tostring(va)
		-- display[4] = "da:"..tostring(da)
		-- display[5] = "angleToStop:"..tostring(angleToStop)
		-- display[6] = "inertia:"..tostring(self.body:getInertia())
		-- display[7] = "force:"..tostring(force*50)
		if not ((dir * va) > 0 and math.abs(da) < angleToStop) then -- we are not turning going fast enough
			self.body:applyTorque(force * dir * 50)
		else
			self.body:applyTorque(force * -dir * 50)
		end
	else --slow rotation because we're facing target
		
		if va > 0 then
			self.body:applyTorque(-force * 50)
		else
			self.body:applyTorque(force * 50)
		end
	end
end

function spaceShip:dampenMovement(sa, vx, vy) -- eliminate l/r stuffs
	--sx, xy, vx, vy, velocity, dist, dx, dy, sa
	
	local velocityAngle = utils.limitAngle(utils.getAngle(vx, vy)  -math.pi/2)
	-- display[2] = velocityAngle
	local offset = utils.limitAngle(velocityAngle - sa)
	-- display[3] = offset
	-- if math.abs(offset) < math.pi/2 then -- go backwards
		-- offset = - offset
	-- end
	if offset > .05 and offset < math.pi - .05 then
		self:rightThrusters()
		-- display[4] = "right"
	elseif offset < -.05 and offset > -math.pi + .05 then
		self:leftThrusters()
		-- display[4] = "left"
	end
end
	