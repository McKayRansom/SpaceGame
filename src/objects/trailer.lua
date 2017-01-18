trailer = {}

function trailer:new(planet, x, y, team, angle, vx, vy, number, cab)	
	self.groundUnit = true
	unit.new(self, planet, x, y, team, angle, vx, vy)
	self.cab = cab
	table.insert(self.parents, trailer)
	self.body:setLinearDamping(0.2)
	self.body:setAngularDamping(0.2)
	table.insert(planet.groundUnits, self)
	self.planet = planet
	self.isTrailer = true
	if self.trailer and number > 0 then
		local trailerDef = self.trailer
		self.trailer = self.trailer.object:new(planet, x + math.sin(angle) * self.trailer.distance, y + -math.cos(angle) * self.trailer.distance, team, angle, vx, vy, number - 1, cab)
		love.physics.newRevoluteJoint( self.body, self.trailer.body, x + trailerDef.joint * math.sin(angle), y + -trailerDef.joint * math.cos(angle ), true )
	end
	return self
end

function trailer:moveTo(x,y, isAttackMove)
	
end

function trailer:updateSelf(dt)
	local sx, sy = self.body:getPosition()
	local sa = self.body:getAngle()
	local vx, vy = self.body:getLinearVelocity()
	local vel = utils.getDistance(vx, vy)
	local velocityAngle = utils.limitAngle(utils.getAngle(vx, vy)  -math.pi/2)
	local offset = utils.limitAngle(velocityAngle - sa)
	if offset > .05 and offset < math.pi - .05 then	--correct for wheel friction i.e. not skid
		local force = self.body:getMass() * vel
		local angle = -self.body:getAngle() - math.rad(90)
		local fx = -math.sin(angle) * force
		local fy = -math.cos(angle) * force
		self.body:applyForce(fx, fy)
	elseif offset < -.05 and offset > -math.pi + .05 then
		local force = self.body:getMass() * vel
		local angle = -self.body:getAngle() + math.rad(90)
		local fx = -math.sin(angle) * force
		local fy = -math.cos(angle) * force
		self.body:applyForce(fx, fy)
	end

end

-- function trailer:drawSelf()
	-- if self.drawCargo then
		-- love.graphics.draw(self.cargoImage, 0, 0, -math.pi/2, 1, 1, self.width / 2, self.height / 2)
	-- end

-- end
function trailer:dieSelf()
	utils.removeFromTable(self.planet.groundUnits, self)
end