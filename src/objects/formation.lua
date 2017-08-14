--a formation that follows the player
formation = {}

function formation.new(ships, flagship)
	local o = {}
	o.leftShips = {}
	o.rightShips = {}
	o.relativeLefts = {}
	o.relativeRights = {}
	o.flagship = flagship
	local alternate = true
	local leftSpacing = flagship.width
	local rightSpacing = leftSpacing
	for i=1,#ships do
		ships[i].formation = true
		if alternate then --RIGHT
			table.insert(o.rightShips, ships[i])
			local dist = rightSpacing + ships[i].width
			rightSpacing = ships[i].width + dist
			table.insert(o.relativeRights, { -dist, 0 })
			alternate = false
		else	--LEFT
			table.insert(o.leftShips, ships[i])
			local dist = leftSpacing + ships[i].width
			leftSpacing = ships[i].width + dist
			table.insert(o.relativeLefts, {dist, 0})
			alternate = true
		end
	end
	setmetatable(o, { __index = formation })
	o:update()
	return o
	--table.insert(formations, self) --do I want this? not sure could be handled by the game scene or by here...
end

function formation:update()
	local angle = utils.limitAngle(self.flagship.body:getAngle())
	local cosine = math.cos(angle)
	local sine = math.sin(angle)
	local flagshipX, flagshipY = self.flagship.body:getPosition()
	local vx, vy = self.flagship.body:getLinearVelocity()
	for i=1, #self.rightShips do
		self.rightShips[i].formationX, self.rightShips[i].formationY = utils.getActualCoords(flagshipX, flagshipY, angle, self.relativeRights[i][1], self.relativeRights[i][2])
		self.rightShips[i].formationVX, self.rightShips[i].formationVY = vx, vy
	end
	for i=1, #self.leftShips do
		self.leftShips[i].formationX, self.leftShips[i].formationY = utils.getActualCoords(flagshipX, flagshipY, angle, self.relativeLefts[i][1], self.relativeLefts[i][2])
		self.leftShips[i].formationVX, self.leftShips[i].formationVY = vx, vy
	end
end

function formation:draw() --debug function!!
	for i=1,#self.rightShips do
		love.graphics.print("R"..i, self.rightShips[i].formationX, self.rightShips[i].formationY)
	end
	for i=1,#self.leftShips do
		love.graphics.print("L"..i, self.leftShips[i].formationX, self.leftShips[i].formationY)
	end
end


function formation:action(action, ...)
	self.flagship[action](self.flagship, ...)
	for i=1, #self.rightShips do
		self.rightShips[i][action](self.rightShips[i], ...)
	end
	for i=1, #self.leftShips do
		self.leftShips[i][action](self.leftShips[i], ...)
	end
end


-- a formation that is controlled by move commands
lineFormation = {}
formations = {} -- table of all formations... temp?
function lineFormation.new(units, angle)
	local o = {}
	o.backwards = false
	o.units = units
	-- o.angle = angle
	o.moveQue = {}
	setmetatable(o, { __index = lineFormation })
	table.insert(formations, o)
	for i=1, #units do
		units[i].formation = o
	end
	return o
end

function lineFormation:update(dt)
	for i=1, #self.units do
		if self.units[i].moveQue[1] and not self.units[i].dead then return end
	end
	if self.moveQue[1] then
		if self.moveQue[1][4] then -- this was put here to do a turning then moving
			self:goTo(unpack(self.moveQue[1]))
			-- self.angle = self.destination[3] + self.angle
			table.remove(self.moveQue, 1)
		else --some other object told us to go somewhere next
			self:moveTo(unpack(self.moveQue[1]))
			table.remove(self.moveQue, 1)
		end
	else -- we are finished
		for i=1, #self.units do
			self.units[i].formation = false
		end
		utils.removeFromTable(formations, self)
	end
end

function lineFormation:moveTo(mx, my, angle, isAttackMove)
	local i=1
	for i=#self.units, 1, -1 do
		if not self.units[i] then
			table.remove(self.units, i)
		elseif self.units[i].dead or self.units[i].body:isDestroyed() then
			table.remove(self.units, i)
		end
	end
	--move self.units to line
	local sumX, sumY = 0,0
	for i=1, #self.units do
		sumX = sumX + self.units[i].body:getX()
		sumY = sumY + self.units[i].body:getY()
	end
	local avgX, avgY = sumX/#self.units, sumY/#self.units
	local angleToDest = utils.limitAngle(utils.getAngle(mx-avgX, my-avgY) +math.pi/2)
	-- display[3] = "angle to destination: "..(angle) * 180/math.pi
	-- local angleChange = utils.limitAngle(angle-self.angle)
	-- display[4] = "change in angle: ".. angleChange* 180/math.pi
	-- display[5] = "FormationAngle: "..self.angle* 180/math.pi
	-- display[6] = "our unit's angle: "..self.units[1].body:getAngle()* 180/math.pi
	-- angleChange = math.abs(angleChange)
	-- if angleChange > math.pi/2 then
		-- self.backwards = true
		-- self.angle = utils.limitAngle(angle - math.pi)
	-- else
		-- self.angle = angle
	-- end
	-- display[7] = self.backwards
	-- if angleChange > math.pi/8 and not (angleChange > 7*math.pi/8) then
		-- table.insert(self.moveQue, 1, {mx, my, self.angle, self.backwards, isAttackMove})
		-- self:goTo(avgX, avgY, self.angle, self.backwards, isAttackMove)
	-- else
		self:goTo(mx, my, angleToDest, isAttackMove, angle)
	-- end
end


function lineFormation:goTo(x, y, angle, isAttackMove, targetAngle)
	local currentRowHeight = 0
	local currentShip = 2
	local spacingConstant = 50
	if self.units[1].spaceShip then
		spacingConstant = 80
	end
	local points = {}
	if backwards then
		-- spacingConstant = spacingConstant * -1
	end

	--sort units so they are in order
	local distances = {}
	local objects = {}
	for i=1, #self.units do
		local distance, _y = utils.getRelativeCoords(x, y, self.units[i].body:getX(), self.units[i].body:getY(), angle)
		--print("addingDistance: "..distance)
		local added = false
		for j=1, #distances do
			if distances[j] < distance then
				table.insert(distances, j, distance)
				table.insert(objects, j, self.units[i])
				added = true
				break
			end
		end
		if not added then
			table.insert(distances, distance)
			table.insert(objects, self.units[i])
		end
	end
	--print("formationMovingTo: "..math.deg(angle))
	-- for i=1, #objects do
	-- 	print("movingUnit: "..tostring(objects[i]).." distance: "..distances[i])
	-- end
	-- if angle < 0 then
		-- spacingConstant = spacingConstant * -1
	-- end
	angle = targetAngle or angle
	for i=1, 1 do--math.ceil(math.sqrt(#self.units)) do -- in cube shape
		local radius = -spacingConstant * (#self.units-1)/2
		for i=1 ,#objects do--math.ceil(math.sqrt(#self.units)) do
			local x, y = utils.getActualCoords(x, y, angle - math.pi/2, currentRowHeight, radius)
			points[#points + 1] = {x,y}
			radius = radius + spacingConstant
		end
	end
	for i=1, #objects do
		objects[i]:moveTo(points[i][1], points[i][2], angle + math.pi/2, isAttackMove)
	end

end

function lineFormation:merge(finalFormation)
	for i=1, #self.units do
		print(i)
		table.insert(finalFormation.units, self.units[i])
		self.units[i].formation = finalFormation
	end
	for i=1, #finalFormation.units do
		print(finalFormation.units[i].id)
	end
	utils.removeFromTable(formations, self)
end
