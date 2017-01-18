squareTurretMedium = {}

function squareTurretMedium.new(xpos, ypos, minA, maxA)
	local object = {
		[1] = xpos,
		[2]  = ypos,
	--	image = squareTurretMediumImage,
		width = 21,
		group = 2,
		weaponType = "laser",
		height = 27,
		vertex = {25/2,25/2},
		barrelDist = 11,
		emitDistance = 12,
		power = 400,
		color = {255,0,0},
		fireTime = .5,
		mass = .0008,
		angle = 0,
		reloadTime = 4,
		reload = 0,--math.random(6),
		readyToFire = false,
		image = love.graphics.newImage("images/units/mediumSquareTurret.png"),
		collisionSize = 50,
		health = 400,
		maxHealth = 400,
		turnRate = .2,
		maxAngle = maxA,
		minAngle = minA
	}
	--setmetatable(object, { __index = squareTurretMedium })
	turret.init(object, minA)
	
	function object:pointTowards(posx, posy, vx, vy, ox, oy, oangle)
		local dist = math.sqrt((self[x])^2 + (self[y])^2)
		-- local xdist = math.cos(angle) * dist
		-- local ydist = math.sin(angle) * dist
		
		local dx = -ox + posx
		local dy = -oy + posy
		local angle = utils.getAngle(self[x], self[y])
		--self.angle = angle
		angle = angle + oangle
		local ay = math.sin(angle) * dist
		local ax = math.cos(angle) * dist
		angle = utils.getAngle(dx-ax, dy-ay) - oangle
		--if (angle < self.maxAngle) and (angle > self.minAngle) then
			--self.angle = angle 
			if self.laser then
				angle = angle + oangle
				self.laser.angle = angle
				self.laser.startX = ax + ox + self.emitDistance * math.cos(angle)
				self.laser.startY = ay + oy + self.emitDistance * math.sin(angle)
			end
			self.readyToFire = true
		--end
		return turret.pointTowards(self, false, posx, posy, vx, vy, ox, oy, oangle)
	end
	
	
	
	return object
end
