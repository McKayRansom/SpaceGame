turret = {}

local angleChecks = {}
function angleChecks.all(angle)
	return true
end

function angleChecks.forward(angle)
	return (angle < (-math.pi * 1/8)) and (angle > (-math.pi * 7/8))	
end

function angleChecks.right(angle)
	return (angle > (-math.pi * 3/8)) and (angle < (math.pi * 3/8))	
end

function angleChecks.left(angle)
	return (angle > (math.pi * 5/8)) or (angle < (-math.pi * 5/8))	
end

function angleChecks.upperLeft(angle)
	return (angle < (-math.pi * 1/8)) or (angle > (math.pi * 5/8))
end

function angleChecks.upperRight(angle)
	return (angle > (-math.pi * 7/8)) and (angle < (math.pi * 3/8))
end

function angleChecks.bottomRight(angle)
	return (angle > (-math.pi * 3/8)) and (angle < (math.pi * 7/8))
end

function angleChecks.bottomLeft(angle)
	return (angle < (-math.pi * 5/8)) or (angle > (math.pi * 1/8))
end

function turret:init(firingArc)
	local firingArc = firingArc or "forward"
	self.angleCheck = angleChecks[firingArc]
	self.health = self.maxHealth
	self.angle = self.angle or  - math.pi/2
	self.readyToFire = false
end

function turret:pointTowards(ballistic, targetX, targetY, targetVX, targetVY, myShipX, myShipY, myShipAngle)
	local dist = math.sqrt((self[x])^2 + (self[y])^2)
	myShipAngle = utils.limitAngle(myShipAngle)
	local dx = -myShipX + targetX
	local dy = -myShipY + targetY
	if ballistic then
		local d = math.sqrt(dx^2 + dy^2)
		local t = d/self.velocity
		dx = dx + targetVX * t
		dy = dy + targetVY * t
	end
	local angle = utils.getAngle(self[x], self[y])
	angle = angle + myShipAngle
	local ay = math.sin(angle) * dist
	local ax = math.cos(angle) * dist
	angle = utils.limitAngle(utils.getAngle(dx-ax, dy-ay) - (myShipAngle))
	local da = utils.limitAngle((angle - self.angle))
	if self.angleCheck(angle) then
		if (da < -self.turnRate) then
			self.readyToFire = false
			self.angle = self.angle - self.turnRate
		elseif (da > self.turnRate) then
			self.readyToFire = false
			self.angle = self.angle + self.turnRate
		else
			self.readyToFire = true
			self.angle = angle
		end
		return true
	else
		self.readyToFire = false
		return false
	end

end

