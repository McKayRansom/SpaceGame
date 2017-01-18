ammoTruck = {}
ammoUsers = {}
ammoDepots = {}

function ammoTruck:new(...)
	--assert(id, "no spaceShip id for light Cruiser creation") 
	local o = {}
	--generalStuffs
	o.image = ammoTruckImage
	o.height =20
	o.width =30
	o.collisionHeight = 20
	o.collisionWidth = 30
	o.ammo = 12
	o.maxCargo = 12
	o.checkTime = 0
	o.transferDistanceDestination = 40
	o.cargo = "ammo"
	o.cargoTruck = true
	o.dropOffBehind = true
	o.transferDistanceSource = 50
	o.findDestination = true
	o.findSource = false
	o.oneCargoTruckPerDestination = true
	o.destinations = ammoUsers
	o.sources = ammoDepots
	--o.shape = {-47.5, -47.5, 47.5, -47.5, 47.5, 47.5, -47.5, 47.5, -47.5, -47.5}
	--powerStuffs
	o.maxPower = 1000
	o.reactorHealth = 1000
	
	o.health = 4000
		--shields stuff
	o.shieldsActive = true

	o.shieldRegen = 200
	o.shields = 7000
	o.shieldCycleTime = 4
	--engineStuff
	o.engineForce = 55
	o.tankDrive = true
	o.steeringSpeed = 1
	o.engineHealth = 500
	o.deathAnim = tankDeath
	--o.engineEnd = 93 - 97/2
	--o.engineStart = 87 - 97/2
	o.engineY = -23
	o.engineHeight = 5
	o.enginewidth = 20
	o.weapons = {
	}
	truck.new(o, ...)
	o.updateSelf = ammoTruck.updateSelf
	return o
end

function ammoTruck:updateCargoTruck(dt) 	
	--state: look for destination
	if self.findDestination then
		for i=self.checkingDestinationsSpot or 1, #self.planet[self.team] do -- look for people who need cargo
			local d = self.planet[self.team][i]
			if d[self.cargo] and (d[self.cargo] < d.maxCargo) and (not d.cargoTruckOnTheWay) then --they need some
				self.destination = d
				self.checkingDestinationsSpot = i + 1
				self.findDestination = false
				self.user.cargoTruckOnTheWay = true
				break
			end
		end
	--state:looking for more cargo	
	elseif self.findSource then
		local list = {}
		local sources = {}
		local sx, sy = self.body:getPosition()
		for i=1, #self.planet[self.team] do -- look for people who have our cargo
			local s=self.planet[self.team][i]
			if s[self.cargo] and (s[self.cargo] > 0) then --they have some
				local distance = (sx- self.sources[i].body:getX())+ (sy-self.sources[i].body:getY())
				local bool = false
				for j=1, #sources do
					if distance < list[j] then --we are closer than this target
						table.insert(sources, j, self.sources[i])
						table.insert(list, j, distance)
						bool = true
						break
					end
				end
				if not bool then
					table.insert(sources, self.sources[i])
					table.insert(list, distance)
				end
			end
			
		end
		if sources[1] then
			self.source = sources[1]
			self.findSource = false
			local distance = -self.transferDistanceSource + 5 --distance away from depot to stop
			local tx, ty = self.source.body:getPosition()
			local angle = utils.getAngle(sx - tx, sy-ty)
			self.moveQue = {{tx - math.cos(angle) * distance, ty - math.sin(angle) * distance, false, false}}
		end
	elseif self.user then--we do have a job to do
		if self.user.body:isDestroyed() then self.findDestination = true end
		local distance = utils.getDistance(self.body:getX(), self.body:getY(), self.user.body:getX(), self.user.body:getY())
		if distance < self.transferDistanceDestination then
			if self.user[self.cargo] == self.user.maxCargo or self[self.cargo] == 0 then -- we are done refilling their ammo
				self.user.cargoTruckOnTheWay = nil
				self.user = false
				if self[self.cargo] > 0 then
					self.findDestination = true
				else
					self.findSource = true
				end
				return
			end
			self.user[self.cargo] = self.user[self.cargo] + 1
			self[self.cargo] = self[self.cargo]-1
		else
			if self.dropOffBehind then
				local x, y = utils.getActualCoords(self.user.body:getX(), self.user.body:getY(), (self.user.dropOffAngle or 0) + self.user.body:getAngle(), 0, -self.transferDistanceDestination + 5)
				self.moveQue = {{ x, y, false, false}}
			else
				local distance = -self.transferDistanceDestination + 5 --distance away from depot to stop
				local tx, ty = self.user.body:getPosition()
				local angle = utils.getAngle(self.body:getX() - tx, self.body:getY()-ty)
				self.moveQue = {{tx - math.cos(angle) * distance, ty - math.sin(angle) * distance, false, false}}
			end
		end
	elseif self.source then -- we are going back to ammo depot
		if self.source.dead then self.findSource = true return end
		if utils.getDistance(self.body:getX(), self.body:getY(), self.source.body:getX(), self.source.body:getY()) < self.transferDistanceSource then

			if self[self.cargo] == self.maxCargo or self.source[self.cargo] == 0 then -- we are done refilling their ammo
				self.source = false
				if self[self.cargo] > 0 then
					self.findDestination = true
				else
					self.findSource = true
				end
				return
			end
			self.source[self.cargo] = self.source[self.cargo] - 1
			self[self.cargo] = self[self.cargo] + 1
		end
	end
	
end


-- function ammoTruck:drawSelf()
	-- if self.drawCargo then
		-- love.graphics.draw(self.cargoImage, 0, 0, -math.pi/2, 1, 1, self.width / 2, self.height / 2)
	-- end
-- end