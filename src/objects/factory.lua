factory = {
	groundUnit = true,
	isProducer = true,
}

function factory:new(planet, x, y, team, angle, vx, vy)
	unit.new(self, planet, x, y, team, angle, vx, vy)
	table.insert(self.parents, factory)
	self.body:setType("static")
	table.insert(planet.groundUnits, self)
	self.isProducer = true
	self.isActive = false
	self.time = 0
	self.smoke = {}
	self.moveQue = {}
	self.smokeTime = 0
	self.currentSmokeStack = 1
	return self
end

-- compatability with other units :)
function factory:increasePower(which)end
function factory:fireEngines()end
function factory:reverseThrusters()end
function factory:leftThrusters()end
function factory:rightThrusters()end
function factory:turnRight()end
function factory:turnLeft()end
function factory:toggleDampeners()end	

function factory:moveTo(x,y, isAttackMove)
	self.rallyPoint = {x,y}
	self.isAttackMove = isAttackMove
end

function factory:updateSelf(dt)

	for i=1, #self.smoke do
		self:updateSmoke(dt, i)
	end
	if self.dead then return end
	if self.smokeImage and self.isActive then
		self.smokeTime = self.smokeTime + dt
		if self.smokeTime > self.smokeFrequency then
			self.smokeTime = 0
			for i=1, #self.smokeStacks do
				table.insert(self.smoke, {self.smokeStacks[i][2], self.smokeStacks[i][1], 1, 255})
				-- self.currentSmokeStack = self.currentSmokeStack + 1
				-- if #self.smokeStacks < self.currentSmokeStack then
					-- self.currentSmokeStack = 1
				-- end
			end
		end
		
	end
	if self.productionTime then
		self:updateProduction(dt)
	end
end

function factory:updateProduction(dt)
	if self.disabled then self.isActive = false return end
	if self.unitProducer and self.metal >=self.unitCost then
		self.time = self.time + dt
		self.isActive = true
		if self.time > self.productionTime then
			self.isActive = false
			self.time = 0
			self.metal = self.metal - self.unitCost
			self.metalExpectedAmount = self.metalExpectedAmount - self.unitCost
			local sx, sy = self.body:getPosition()
			local angle = self.body:getAngle()
			local newUnits = {}

			for i=1, self.formationSize do
				local x, y = utils.getActualCoords(sx, sy, angle, self.productionPoint[1] - (i-1) * 30 + (self.formationSize-1)/2 * 30, self.productionPoint[2])
				local newUnit  = self.productionUnit:new(self.planet, x, y, self.team, self.productionPoint[3] + angle)
				newUnits[i] = newUnit
			end
			local newFormation
			if self.formationSize == 1 then
				newFormation = newUnits[1]
			else
				newFormation = lineFormation.new(newUnits, self.productionPoint[3] + angle)
			end
			-- newFormation:moveTo(utils.getActualCoords(sx, sy, angle, 0, -600))
			if self.rallyPoint then
				newFormation:moveTo(self.rallyPoint[1], self.rallyPoint[2], false, true)
			end
		end
	elseif self.resourceProducer and self[self.cargo] < self[self.cargo.."Max"] then
		self.time = self.time + dt
		self.isActive = true
		if self.time > self.productionTime then
			self.isActive = false
			self.time = 0
			self[self.cargo] = self[self.cargo] + 1
			self[self.cargo.."ExpectedAmount"] = self[self.cargo.."ExpectedAmount"] + 1
		end
	elseif self.refinery then
		for product, amount in pairs(self.products) do
			if (self[product] + amount) > self[product.."Max"] then --we are all full
				return
			end
		end
		for item, amount in pairs(self.required) do -- we don't have the required resources
			if self[item] < amount then
				return
			end
		end
		self.isActive = true
		self.time = self.time + dt
		if self.time > self.productionTime then
			self.isActive = false
			self.time = 0
			--we can do the conversion
			for product, amount in pairs(self.products) do
				self[product] = self[product] + amount
				self[product.."ExpectedAmount"] = self[product.."ExpectedAmount"] + amount
			end
			for item, amount in pairs(self.required) do -- we don't have the required resources
				self[item] = self[item] - amount
				self[item.."ExpectedAmount"] = self[item.."ExpectedAmount"] - amount
			end
		end
	end	
end

function factory:updateSmoke(dt, i)
	if self.smoke[i] then
		local transparency = self.smoke[i][4] - self.smokeFade * dt
		local scale = self.smoke[i][3] + self.smokeDissipate * dt
		self.smoke[i] = {self.smoke[i][1]+ self.planet.wind[1] * dt, self.smoke[i][2] + self.planet.wind[2]* dt, scale, transparency}
		if transparency < 10 then
			table.remove(self.smoke, i)
			self:updateSmoke(dt, i)
		end
	end
end

function factory:drawSelf()
	if self.smokeImage then
		for i=1, #self.smoke do
			love.graphics.setColor(255, 255, 255, self.smoke[i][4])
			
			love.graphics.draw(self.smokeImage, self.smoke[i][1], self.smoke[i][2], 0, self.smoke[i][3], self.smoke[i][3], self.smokeImage:getWidth()/2, self.smokeImage:getHeight()/2)
		end
	end
end

function factory:dieSelf()
	utils.removeFromTable(self.planet.groundUnits, self)
	-- if self.node then self.node.built = false end --for ore mines, set the resource node they are on to be rebuildable
end