
truck = { --constants
	groundUnit = true
}

function truck:new(planet, x, y, team, angle, vx, vy)
	local angle = angle or 0
	unit.new(self, planet, x, y, team, angle, vx, vy)
	table.insert(self.parents, truck)
	self.body:setLinearDamping(0.2) -- friction, yay
	self.steering = 0
	table.insert(planet.groundUnits, self)
	self.updateTime = math.random()*.25 --randomize update times so they don't all do updates of pathfinding and such at the same time
	self.targets = {}
	self.moveQue = {}
	if self.trailer then
		self.hasTrailer = true
		local trailerDef = self.trailer
		self.trailer = self.trailer.object:new(planet, x + math.sin(angle) * trailerDef.distance, y - math.cos(angle) * trailerDef.distance, team, angle, vx, vy,  trailerDef.number, self)
		love.physics.newRevoluteJoint( self.body, self.trailer.body, x + trailerDef.joint * math.sin(angle), y - trailerDef.joint * math.cos(angle ), true )
	end
	return self
end

function truck:increasePower(which)
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

function truck:fireEngines() -- called this for compatability with spaceShips...
	if utils.getDistance(self.body:getLinearVelocity()) > self.maxSpeed then return end
	local force = self.engineForce
	if self.backwards then
		force = self.brakingForce
	end
	force = force * .33--self.enginePowerPercent * (self.engineHealth/self.engineMaxHealth)
	local angle = -self.body:getAngle()
	local fx = -math.sin(angle) * force
	local fy = -math.cos(angle) * force
	self.body:applyForce(fx, fy)
end

function truck:reverseThrusters() -- these need to be based on direction of motion...
	if utils.getDistance(self.body:getLinearVelocity()) > self.maxSpeed then return end
	local force = self.brakingForce
	if self.backwards then
		force = self.engineForce
	end	
	force = force * .33--self.enginePowerPercent * (self.engineHealth/self.engineMaxHealth)
	local angle = -self.body:getAngle()
	local fx = math.sin(angle) * force
	local fy = math.cos(angle) * force
	self.body:applyForce(fx, fy)
end

function truck:leftThrusters()
end

function truck:rightThrusters()
end


function truck:turnRight()
	self.steering = 1
end

function truck:turnLeft()
	self.steering = -1
end

function truck:toggleDampeners()
	self.dampeners = not self.dampeners
end	

function truck:moveTo(x,y, angle, isAttackMove)
	self.moveQue = {{x,y, angle}}
	-- self:updatePathfinding(self.body:getX(), self.body:getY(), self.body:getAngle())
	self.isAttackMove = isAttackMove
end

-- function truck:target(ship)
	-- self.target = ship
-- end	

function truck:updateSelf(dt)
	local sx, sy = self.body:getPosition()
	local sa = self.body:getAngle()
	local vx, vy = self.body:getLinearVelocity()
	local aVel = self.body:getAngularVelocity()
	local vel = utils.getDistance(vx, vy)
	local velocityAngle = utils.limitAngle(utils.getAngle(vx, vy)  -math.pi/2)

	self:updateAntiSkid(sa, vel, velocityAngle)
	local trailerAngle
	local steeringTowardsCenter
	if self.hasTrailer then
		trailerAngle = utils.limitAngle(self.trailer.body:getAngle() - sa)
		steeringTowardsCenter = (self.steering > 0 and trailerAngle > 0) or (self.steering < 0 and trailerAngle < 0) 
	end
	-- display[3] = trailerAngle
	-- display[4] = self.steering
	if not self.maxSteering or (not self.trailer.body:isDestroyed() and (self.maxSteering > math.abs(trailerAngle)) or steeringTowardsCenter) then
		if not self.tankDrive then --Steering for non tank drive
			if math.abs(vel) > 20 then
				self.body:setAngularVelocity(self.steering * self.steeringSpeed)
			else
				self.body:setAngularVelocity(self.steering * .05 * vel * self.steeringSpeed)
			end
		else 					--Basic tank drive steering
			self.body:setAngularVelocity(self.steering * (self.steeringSpeed or 1) * .5)
		end
	end
	self.steering = 0
	--THIS IS SUPER BAD ON PERFORMANCE :( Multithreading? also add target prorities at some point...

	self.updateTime = self.updateTime + dt
	if self.updateTime > .25 then
		self.updateTime = 0
		if self.weapons[1] then
			self:updateTargets(sx, sy)
		end
		if self.moveQue[1] then
			self:updatePathfinding(sx, sy, sa, vel)
		end
		if self.cargoTruck then
		self.checkTime = self.checkTime + 1
		if self.checkTime > 2 then
			self:updateCargo(.5)
			self.checkTime = 0
		end
	end
	end

	if self.brake and vel > .1 then
		local force = self.brakingForce *.33--* self.enginePowerPercent * (self.engineHealth/self.engineMaxHealth)
		local angle = -velocityAngle
		local fx = -math.sin(angle) * force
		local fy = -math.cos(angle) * force
		self.body:applyForce(fx, fy)
	end
	if self.player then --update player movements and weapons (move somewhere else?)
		if self.reverse and not love.keyboard.isDown("r") and vel < 1 then self.reverse = false end
		if not self.reverse and love.keyboard.isDown("r") and vel < 1 then self.reverse = true end
		local a, b = worldMX, worldMY
		for i=1,#self.weapons do
			self.weapons[i]:pointTowards(a,b, 0,0, sx, sy, self.body:getAngle())
			if self.weapons[i].reload < self.weapons[i].reloadTime then
				self.weapons[i].reload = self.weapons[i].reload + dt
			end
		end
	elseif self.targets[1] and self.weapons[1] then --ai ship targeting
		if debug_settings.noAI then --like this, need more of this sort of thing...
			return
		end
		--AI weapon firing
		
		for i=1,#self.weapons do
			if self.weapons[i].reload < self.weapons[i].reloadTime then
				self.weapons[i].reload = self.weapons[i].reload + dt
			end
			local j = 1
			while self.targets[j] do
				if self.targets[j].dead then 
					table.remove(self.targets, j)
				else
					local a, b = self.targets[j].body:getPosition()
					local c, d = self.targets[j].body:getLinearVelocity()
					local bool = self.weapons[i]:pointTowards(a,b, c , d, sx, sy, self.body:getAngle()) or false -- add c - vx and d-vy to re-add self velocity adding (wasn't working on ground)
					if bool ==true then
						self.weapons[i].target = self.targets[j]
						break
					end
				end
				j = j+1
			end
		end
		self:fireWeapons()
	end
	local destination = self.moveQue[0] or self.moveQue[1] --moveQue[0] is for pathfinding/avoidence of stuff (we go there first but it isn't an actual destination)
	if destination and not (self.isAttackMove and self.targets[1]) then --movement/destination stuff
		self.brake = false
		local dx = sx - destination[1]
		local dy = sy - destination[2]
		local angle = utils.getAngle(dx, dy)
		local dist = utils.getDistance(dx, dy)
		if math.abs(dx) < 5 and math.abs(dy) < 5 then --we are at destination
			self.brake = true
			if (not destination[3]) or (self:turnTowards(sa, destination[3] - math.pi)) or not self.tankDrive then -- turn towards destination angle
				table.remove(self.moveQue, 1)
			end
		elseif self:turnTowards(sa, angle, dist) then -- or turn towards destination
			
			
			local force = self.brakingForce *.33--* self.enginePowerPercent * (self.engineHealth/self.engineMaxHealth)
			local dir = -1
			local mass = self.body:getMass()
			if self.trailer then
				mass = mass + self.trailer.body:getMass()
			end
			if dist > (vel^2)/(2 * (force/mass)) then -- get closer to target TODO: add max DIST? if tankDrive don't drive until pointing right
				if self.maxSpeed < vel then
					return
				end
				force = force * -1
			else
				force = self.engineForce * .33
			end
			
			if self.backwards then
				force = force * -1
			end
			local angle = -self.body:getAngle()
			local fx = math.sin(angle) * force
			local fy = math.cos(angle) * force
			self.body:applyForce(fx, fy)
		else
			if self.tankDrive then
				self.brake = true
			end
		end
	elseif not self.player then --brake when standing still/at destination
		self.brake = true
	end 
end
function truck:updateAntiSkid(sa, vel, velocityAngle)
	local offset = utils.limitAngle(velocityAngle - sa)
	local angle
	if offset > .05 and offset < math.pi - .05 then	--correct for wheel friction i.e. not skid
		angle = -sa - math.rad(90)
	elseif offset < -.05 and offset > -math.pi + .05 then
		angle = -sa + math.rad(90)
	else
		return
	end
	local force = self.body:getMass() * vel
	local fx = -math.sin(angle) * force
	local fy = -math.cos(angle) * force
	self.body:applyForce(fx, fy)
end


local callingUnit
function truck.rayCastCallback(fixture, x, y, xn, yn, fraction)
	if fixture == callingUnit.fixture then return 1 end
	if (callingUnit.trailer and callingUnit.trailer.fixture == fixture) or (callingUnit.destination and fixture == callingUnit.destination.fixture)then 
		return 1 
	else
		table.insert(callingUnit.rayCollides, {fraction, x, y, fixture})
		table.insert(callingUnit.triedPoints, {fraction, x, y, fixture})
	end
	return 1
end

--ToDo: add two raycastings at least sometimes on either side of the vehicle to better detect when we are going to hit something
function truck:updatePathfinding(sx, sy, sa, vel)
	callingUnit = self --for the rayCastCallback
	self.rayCollides = {} --for the rayCastCallback
	self.rayHistory = {} --purely for debugging
	self.triedPoints = {} --also purely for debugging
	local dest = self.moveQue[1]
	local dx = sx - dest[1]
	local dy = sy - dest[2]
	local startAngle = utils.getAngle(dx, dy)
	local distanceToTarget = utils.getDistance(dx, dy)
	local distance = math.min(self.pathfindingDistance, distanceToTarget + self.height/2)
	local right = startAngle + math.pi/2
	local width = self.collisionWidth/2
	local rightX, rightY = math.cos(right) * width, math.sin(right) * width
	local isClearRight, rayCollide, distanceTo = self:rayCastInDirection(sx + rightX, sy + rightY, startAngle, distance)
	local isClearLeft, rayCollide, distanceTo = self:rayCastInDirection(sx - rightX, sy - rightY, startAngle, distance)
	local angleDiff = -math.pi/6
	if isClearRight and isClearLeft then
		if self.moveQue[0] then --we have a pathfinding move still
			self.moveQue[0] = false
		end
		return
	else --there is something in the way
		if isClearLeft then angleDiff = angleDiff * -1 end
		
		for i=1, 7 do
			self.rayCollides = {}
			local angle = startAngle + (angleDiff * i) -- alternating direction
			local isClear, rayCollide, distanceTo = self:rayCastInDirection(sx, sy, angle, distance)
			if isClear then -- we don't hit anything
				self.moveQue[0] = {sx - math.cos(angle) * distance,  sy - math.sin(angle) * distance} --change (or create) the pathfinding move
				return
			end
			local angle = startAngle + (angleDiff * i * -1)
			local isClear, rayCollide, distanceTo = self:rayCastInDirection(sx, sy, angle, distance)
			if isClear then -- we don't hit anything
				self.moveQue[0] = {sx - math.cos(angle) * distance,  sy - math.sin(angle) * distance} --change (or create) the pathfinding move
				return
			end
		end
		--we didn't find any routes out
		self.moveQue[0] = false --just try to go towards our destination :(
	end
end

function truck:rayCastInDirection(sx, sy, angle, distance)
	return self:rayCast(sx, sy, sx - math.cos(angle) * distance, sy - math.sin(angle) * distance)
end

function truck:rayCast(x1, y1, x2, y2) --returns bool isClear, closest rayCollideObject and distance to closest object
	self.rayCollides = {}
	table.insert(self.rayHistory, {x1, y1, x2, y2})
	self.world:rayCast( x1, y1, x2, y2, self.rayCastCallback)
	if not self.rayCollides[1] then
		return true, false, false
	else
		-- local closestCollision = self.rayCollides[1]
		-- local distance = self.rayCollides[1][1]
		-- if #self.rayCollides > 1 then --there are more than one peoples
			-- for i=2, #self.rayCollides do
				-- if self.rayCollides[i][1] < distance then --new closest collision
					-- closestCollision = self.rayCollides[i]
					-- distance = self.rayCollides[i][1]
				-- end
			-- end
		-- end
		return false, false, false-- closestCollision, distance
	end
end

function truck:updateTargets(sx, sy) -- performance sucks!!!
	self.targets = {}
	local distances = {}
	for i=1,#self.planet[self.team.enimies] do
		local k = self.planet[self.team.enimies][i]
		if not k.dead then
			local distance = utils.getDistance(sx,sy, k.body:getX(), k.body:getY())
			if distance < self.weapons[1].range then
				local bool = false
				for i=1, #self.targets do
					if distance < distances[i] then --we are closer than this target
						table.insert(self.targets, i, k)
						table.insert(distances, i, distance)
						bool = true
						break
					end
				end
				if not bool then
					table.insert(self.targets, k)
					table.insert(distances, distance)
				end
			end
		end
	end
end
function truck:turnTowards(sa, angle, dist --[[only for trailer people]]) --utility function for ship ai stuff
	if not angle then return true end
	local angleDiff = utils.limitAngle(angle - sa - (math.pi/2))
	if angleDiff > 0 then --turn towards target
		self.steering = 1
	else
		self.steering = -1
	end
	angleDiff = math.abs(angleDiff)
	if self.tankDrive then
		self.backwards = false
		if angleDiff > math.pi/2 + .15 then
			self.steering = self.steering * -1
			self.backwards = true
		end
		if angleDiff < .05 or angleDiff > math.pi - .05 then
			self.steering = self.steering * .25
			return true
		end
	elseif not self.hasTrailer then --normal wheeled drive
		if (angleDiff > math.pi/3) then -- do a back and turn
			--self.steering = self.steering * -1
			self:reverseThrusters()
		elseif angleDiff > .15 then
			self:fireEngines()
		elseif angleDiff > .05 then
			self.steering = self.steering * .25
			self:fireEngines()
		else
			self.steering = self.steering * .15
			return true
		end
	else --trailer people
		if angleDiff > math.pi/3 then--and dist < 100 then -- do a back and turn
			self.steering = self.steering * -2
			self:reverseThrusters()
		elseif angleDiff > .15 then
			self:fireEngines()
		elseif angleDiff > .05 then
			self.steering = self.steering * .25
			self:fireEngines()
		else -- angleDIff <.05
			self.steering = self.steering * .15
			return true
		end
	end
	return false
end


function truck:dieSelf()
	utils.removeFromTable(self.planet.groundUnits, self)
	if self.payDebts then self:payDebts() end
end
