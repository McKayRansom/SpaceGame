
unit = {}
--local units = {}

function unit:new(planet, x, y, team, angle, vx, vy)
	self.parents = self.parents or {}
	table.insert(self.parents, unit)
	setmetatable(self, { __index = utils.checkParents })
	if not self.fighter then
		self:setPhysics(planet.world, x, y)
	else --we are a fighter so no collisions
		self.body = physicsObject.new()
		self.body.m = self.mass
		self.body.i = self.inertia
		self.body:setPosition(x, y)
	end

	self.effects = {}
	self.team = team
	self.planet = planet

	if self.maxShields then
		self.shieldPower = 0
		self.shieldPowerPercent = .33
		self.shieldRegen = self.shieldRegen or 0 --shield regen while up
		self.shieldRecharge = 0 --time it takes for shields to come back online
		self.shields =  self.maxShields
	end
	self.enginePowerPercent = .33
	self.health = self.maxHealth
	self.engineHealth = self.engineMaxHealth
	if debug_settings.healthMult then self.health = self.health * debug_settings.healthMult end -- DEBUG
	if debug_settings.noShields then self.shields = 0 end


	-- self.enginePower = 0
	-- self.enginePowerPercent = .33
	-- self.engineMaxHealth = self.engineHealth
	if not self.weapons then
		self.weapons = {}
	end
	for i=1, #self.weapons do
		self.weapons[i].parent = self
	end
	-- self.weaponPower = 0
	-- self.weaponPowerPercent = .33
	local angle = angle or 0
	self.body:setAngle(angle)


	if vx then
		self.body:setLinearVelocity(vx, vy)
	end
	if self.engineEffects then
		for i=1,#self.engineEffects[2] do
			local t = self.engineEffects[2][i]
			local dist = utils.getDistance(t[1], t[2])

			effect.new(self, -math.sin(angle) * dist + x, math.cos(angle) * dist + y, self.engineEffects[1], false, true, 0)
		end
	end

	table.insert(planet.units, self)
	table.insert(planet[team.name], self)
	return self
end

function unit:setPhysics(world, x, y)
	if self.fighter then return end
	--self.world = world
	if (self.body) then
		self.body:destroy();
	end
	self.body = love.physics.newBody(world, x or 0, y or 0, "dynamic")
	if self.shape then
		self.physicsShape = love.physics.newPolygonShape(unpack(self.shape))
	else
		self.physicsShape = love.physics.newRectangleShape(self.collisionWidth, self.collisionHeight)
	end
	self.fixture = love.physics.newFixture(self.body, self.physicsShape)
	assert(self.body, "new body call failed with x:"..(x or "none") .."and y:"..(y or "none"))
end

--packs a unit's data for stuff
function unit:pack()
	self.x, self.y = self.body:getPosition()
	self.angle = self.body:getAngle()
	self.vx, self.vy = self.body:getLinearVelocity()
	-- print("packing: "..x.." , "..y.." , "..angle)
	local str = ""
	for key, value in pairs(self) do
		if type(value) == "number" or type(value) == "boolean" or type(value) == "string" then
			str = str..key.."=("..tostring(value).."), "
		end
	end
	-- if self.moveQue then
		-- str = str.."moveQue=("
		-- for i=1, #self.moveQue do
			-- str = str..value
		-- end
		-- str = str.."), "
	-- end
	-- local str = "("..x.."),("..y.."),("..angle..")"
	-- print("packedStringIs: "..str)
	return str
end

--do the exact opposite of the above
function unit:unpack(subString)
	for key, value in string.gmatch(subString, "(%w+)=(%b())") do
		value = string.sub(value, 2, -2)
		if tonumber(value) then self[key] = tonumber(value)
		elseif value == "false" then self[key] = false
		elseif value == "true" then self[key] = true
		else self[key] = value end --assume it was a string
		-- print("gotParam: "..tostring(self[key]))
	end
	self.body:setPosition(self.x, self.y)
	self.body:setAngle(self.angle)
	self.body:setLinearVelocity(self.vx, self.vy)

end

function unit:increasePower(which)
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

function unit:draw()
	love.graphics.push()
	love.graphics.translate(self.body:getX(), self.body:getY())
	love.graphics.rotate(self.body:getAngle())
	assert(self.image, "image for space ship doesn't exist")
	love.graphics.setColor(self.team.color)
	love.graphics.draw(self.image, 0, 0, -math.pi/2, 1, 1, self.width / 2, self.height / 2)
	if self.otherImage then -- drawing a non-team colorAtized image, cool feature, not very used right now
		love.graphics.setColor(255, 255, 255,255)
		love.graphics.draw(self.otherImage, 0, 0, -math.pi/2, 1, 1, self.width / 2, self.height / 2)
		love.graphics.setColor(self.team.color)
	end
	if not self.fighter then
		for i=1,#self.weapons do
			if not self.weapons[i].dead then
				assert(self.weapons[i].image, "no image for turret draw: "..i)
				love.graphics.draw(self.weapons[i].image, self.weapons[i][x], self.weapons[i][y], self.weapons[i].angle, 1, 1, self.weapons[i].vertex[x], self.weapons[i].vertex[y])
				if self.weapons[i].customDraw then --for rocket turrets mostly
					self.weapons[i]:customDraw()
				end
			end
		end
	end
	love.graphics.setColor(255, 255, 255,255)
	for i=1, #self.effects do
		local effect = self.effects[i]
		effect.sprite:start(effect.frame)
		assert(effect.frame <= effect.sprite.numRows, "too many effect frames:"..effect.frame.."is not"..effect.sprite.numRows)
		if effect.deathAnim then love.graphics.setColor(self.team.color) else 	love.graphics.setColor(255, 255, 255,255) end --death sprite is teamcolor, weapon impact sprites aren't
		effect.sprite:draw(effect[x], effect[y], effect.angle)
	end
	if self.drawSelf then self:drawSelf() end

	--debug engine polygon, cool!
	-- local height = self.engineHeight/2
	-- local width = self.engineWidth/2
	-- love.graphics.polygon('line', width, self.engineY - height,   width,self.engineY + height,  -width,self.engineY + height, -width,  self.engineY - height)--, self.engineY + self.engineHeight/2, -self.enginewidth/2)
	love.graphics.pop()
end



function unit:fireWeapons(which)
	for i=1, #self.weapons do
		if (not which) or (which == self.weapons[i].group) then
		if (self.weapons[i].health > 10) and (self.weapons[i].readyToFire) and (self.weapons[i].reload >= self.weapons[i].reloadTime) then
			local weapon = self.weapons[i]
			local ship = self
			local weaponType = weapon.weaponType
			if weaponType == "projectile" or weaponType == "missile" then
				if not (weapon.isAmmo) or weapon.ammoObject.ammo > 0 then
					if weapon.isAmmo then weapon.ammoObject.ammo = weapon.ammoObject.ammo-1 end
					local tx = weapon[x]
					local ty = weapon[y]
					local angle = utils.getAngle(weapon[x], weapon[y])
					angle = angle + ship.body:getAngle()
					local dist = math.sqrt(weapon[x]^2 + weapon[y]^2)
					local vx, vy= ship.body:getLinearVelocity()
					local turretFacing = weapon.angle + ship.body:getAngle()
					local velocity = weapon.velocity-- * ship.weaponPowerPercent * (weapon.health/weapon.maxHealth)
					--TEMP DISABLED:
					vx = 0
					vy = 0
					local inaccuracy = 0--math.random(-weapon.accuracy, weapon.accuracy) DISABLED
					vx = vx + math.cos(turretFacing + inaccuracy) * velocity
					vy = vy + math.sin(turretFacing + inaccuracy) * velocity
					local x = math.cos(angle) * dist + ship.body:getX() + math.cos(turretFacing) * (weapon.barrelDist or 0) - math.sin(turretFacing) * (weapon.verticalOffset or 1)
					local y = math.sin(angle) * dist + ship.body:getY() + math.sin(turretFacing) * (weapon.barrelDist or 0) + math.cos(turretFacing) * (weapon.verticalOffset or 1)
					local p = projectile.new(x, y, vx,vy, turretFacing, ship.team, weapon)
					if self.spaceShip then
						table.insert(self.planet.spaceProjectiles, p)
					else
						table.insert(self.planet.groundProjectiles, p)
					end
					weapon.readyToFire = false
					weapon.reload = 0
					if weapon.burst then
						weapon.burstLeft = weapon.burstLeft-1
						if weapon.burstLeft == 0 then
							weapon.burstLeft = weapon.burst
							weapon.reload = -weapon.burstReloadTime
						end
					end
				end
			elseif weaponType == "laser" then
				local tx = weapon[x]
				local ty = weapon[y]
				local angle = utils.getAngle(weapon[x], weapon[y])
				angle = angle + ship.body:getAngle()
				local dist = math.sqrt(weapon[x]^2 + weapon[y]^2)
				local turretFacing = weapon.angle + ship.body:getAngle()
				local power = weapon.power * ship.weaponPowerPercent * (weapon.health/weapon.maxHealth)
				weapon.laser = laser.new(math.cos(angle) * dist + ship.body:getX(), math.sin(angle) * dist + ship.body:getY(), weapon.angle + ship.body:getAngle(), power, weapon.color, ship.team, weapon.fireTime)
				if self.spaceShip then
					table.insert(self.planet.spaceProjectiles, weapon.laser)
				else
					table.insert(self.planet.groundProjectiles, weapon.laser)
				end
				weapon.readyToFire = false
				weapon.reload = 0
			elseif weaponType == "drone" then -- WIP NOT DONE use some of the fighter work. that was done after this temp stuff
				local tx = weapon[x]
				local ty = weapon[y]
				local angle = utils.getAngle(weapon[x], weapon[y])
				angle = angle + ship.body:getAngle()
				local dist = math.sqrt(weapon[x]^2 + weapon[y]^2)
				local vx, vy= ship.body:getLinearVelocity()
				local turretFacing = weapon.angle + ship.body:getAngle()
				local velocity = weapon.velocity * ship.weaponPowerPercent * (weapon.health/weapon.maxHealth)
				vx = vx + math.cos(turretFacing) * velocity-- + ship.v[x
				vy = vy + math.sin(turretFacing) * velocity
				drone.new(math.cos(angle) * dist + ship.body:getX(), math.sin(angle) * dist + ship.body:getY(), vx,vy, turretFacing, weapon.mass, smallProjectileImage, ship.team)
				weapon.readyToFire = false
				weapon.reload = 0
			end
		end
		end
	end
end

function unit:updateEffects(dt)
	for i=1, #self.effects do
		if self.effects[i] then
			local effect = self.effects[i]
			effect.dt = effect.dt + dt
			if effect.dt > effect.sprite.delay then
				effect.frame = effect.frame + 1
				effect.dt = 0
				if effect.frame > effect.sprite.numRows then
					effect.frame = 1
					if effect.linger then
						effect.dt = -9999
						effect.frame = effect.sprite.numRows
						if effect.deathAnim then
							self:endDeath()
						end
					elseif effect.loop then
						effect.dt = 0
						effect.frame = 1
					else
						table.remove(self.effects, i)
					end
				end
			end
		end
	end
end

function unit:updateShields(dt)
	if self.shields < self.maxShields then
		if self.shieldsActive then
			self.shields = self.shields + (self.shieldRegen * self.shieldPowerPercent * dt)
		end
	end
	if not self.shieldsActive then
		self.shieldRecharge = self.shieldRecharge - dt
		if self.shieldRecharge < 0 then
			self.shield = .05 * self.maxShields
			self.shieldRecharge = 0
			self.shieldsActive = true
		end
	end
end

function unit:update(dt)
	if self.fighter then
		self.body:updatePhysics(dt)
	end
	self:updateEffects(dt)
	if self.dead then
		return
	end
	if self.shields then
		self:updateShields(dt)
	end
	for i=1, #self.weapons do
		if self.weapons[i].customUpdate then self.weapons[i]:customUpdate(dt) end
	end
	if self.updateSelf then self:updateSelf(dt) end
end


function unit:setCargo(newCargo)
	self.cargo = newCargo
	self[newCargo] = self[newCargo] or 0 --in case we have already carried this cargo...
	self[newCargo.."Max"] = 1
end

function unit:payDebts()
	if self.cargoDebt then -- we said we were going to pickup/deliver this much cargo can be more then we could possibly
		if self.destination then
			self.destination[self.cargo.."ExpectedAmount"] = self.destination[self.cargo.."ExpectedAmount"] - self.cargoDebt
		end
	end
end

function unit:updateCargo(dt) --if we are a cargoTruck ing truck
	if self.disabled then return end
	local cargo = self.cargo
	local maxCargo = cargo.."Max"
	local expectedAmount = cargo.."ExpectedAmount"
	self.timeSinceAction = self.timeSinceAction + dt
	if self.timeSinceAction > self.timeout then --we are probably stuck
		self.timeSinceAction = 0
		self:payDebts()
		if self.destination then
			self.destination = false
			self.findDemand = true
		else
			-- assert(false, "cargo truck timed out for no reason!!!")
		end
		print("CargoTruckTimedOut!!")
	end
	--state: look for destination
	if self.findDemand then
		self.timeSinceAction = 0 --reset timeout
		for i=self.checkingDemandSpot or 1, #self.planet[self.team.name] do -- look buildings that need what we have
			local d = self.planet[self.team.name][i]
			if d[cargo.."Demand"] and (d[expectedAmount] < d[maxCargo]) then --they need some
				self.destination = d
				self.transferDirection = 1
				self.checkingDemandSpot = i + 1
				self.findDemand = false
				local originalAmount = d[expectedAmount]
				d[expectedAmount] =  originalAmount + self[cargo]--set their expected Amount to be what we think we will give them
				self.cargoDebt = d[expectedAmount] - originalAmount

				return
			end
		end
		--we didn't find anyone
		self.checkingDemandSpot = false
	--state:looking for more cargo
	elseif self.findSupply then
		self.timeSinceAction = 0 --reset timeout
		local list = {}
		local sources = {}
		local sx, sy = self.body:getPosition()
		for i=1, #self.planet[self.team.name] do -- look for people who have our cargo
			local s=self.planet[self.team.name][i]
			if s[cargo.."Supply"] and (s[expectedAmount] > 0) then --they have some
				local distance = utils.getDistance(sx, sy, s.body:getX(), s.body:getY())
				local bool = false
				for j=1, #sources do
					if distance < list[j] then --we are closer than this target
						table.insert(sources, j, s)
						table.insert(list, j, distance)
						bool = true
						break
					end
				end
				if not bool then
					table.insert(sources, s)
					table.insert(list, distance)
				end
			end
		end
		if sources[1] then
			self.destination = sources[1]
			local d = self.destination
			self.transferDirection = -1
			local originalAmount = d[expectedAmount]
			d[expectedAmount] = math.max(originalAmount - (self[maxCargo] - self[cargo]), 0)
			self.cargoDebt = -(originalAmount - d[expectedAmount])
			self.findSupply = false
		end
	elseif self.destination then--we do have a destination
		local d = self.destination
		if utils.withinRectangle(self.body:getX(), self.body:getY(), d.body:getX(), d.body:getY(), d.collisionWidth/2 + self.transferDistance, d.collisionHeight/2 + self.transferDistance) then
			self.timeSinceAction = 0 --prevent timeout while delivering cargo
			self.brake = true
			if (self.transferDirection == 1 and (d[cargo] >= d[maxCargo] or self[cargo] == 0)) or (self.transferDirection == -1 and (self[cargo] >= self[maxCargo] or d[cargo] == 0)) then -- we are done transfering cargo
				self.moveQue = {}
				if self[cargo] > 0 then
					self.findDemand = true
				else
					self.findSupply = true
				end
				self:payDebts()
				self.destination = false
				return
			end
			self.destination[cargo] = self.destination[cargo] + self.transferDirection
			self[cargo] = self[cargo] - self.transferDirection
			self.cargoDebt = self.cargoDebt - self.transferDirection
		else --recalculateDestination
			local distance = self.transferDistance + d.width/2 --distance away from depot to stop
			local tx, ty = d.body:getPosition()
			local sx, sy = self.body:getPosition()
			local angle = utils.getAngle(sx - tx, sy-ty)
			self.moveQue[1] = {tx + math.cos(angle) * distance, ty + math.sin(angle) * distance, false, false}
		end
	else
		self:payDebts()
		if self[cargo] > 0 then
			self.findDemand = true
		else
			self.findSupply = true
		end
	end

end


function unit:startDeath()
	self.dead = true
	self.body:setLinearDamping(.9)
	local anim = effect.new(self, self.body:getX(), self.body:getY(), self.deathAnim or smallImpact, true)
	anim.deathAnim = true
	-- table.remove(self.effects, 1) --remove engine effect
end

function unit:endDeath()
	utils.removeFromTable(self.planet.units, self)
	utils.removeFromTable(self.planet[self.team.name], self)
	self:dieSelf()
	--table.insert(globalgame.effects, self.effects[num])-- leave a body. cool idea, should add sometime
	self.body:destroy()
	self = false
	-- if self.player then -- todo: this really should be added at some point
		-- onPlayerDeath()
	-- end
end
