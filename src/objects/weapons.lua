projectile = {}
--[[
handles missiles and  bullets and lasers

TODO:
clean up old missile table stuff; add new table maybe
look at PERFORMANCE
]]--
local smallProjectileImage = love.graphics.newImage("images/units/spaceShips/smallProjectile.png")
function projectile.new(x, y, vx, vy, angle, team, weapon) -- weapon = weapon who fired projectile
	local object = physicsObject.new()
	object.p[1] = x
	object.p[2] = y
	object.v[1] = vx
	object.v[2] = vy
	object.m = weapon.mass
	object.angle = angle
	local image = weapon.projectileImage or smallProjectileImage
	object.width = image:getWidth()
	object.height = image:getHeight()
	object.image = image
	object.impactSprite = weapon.collisionImage or smallImpact
	object.team = team
	object.damage = weapon.damage -- missile only (for now) \/
	object.shieldDamage = weapon.shieldDamage
	object.speed = weapon.velocity 
	object.turningSpeed = weapon.turningSpeed
	object.target = weapon.target
	object.health = 50
	object.parent = weapon.parent
	object.startX = x
	object.startY = y
	object.range = weapon.range
	if weapon.accel then --should just make this defined!
		object.weaponType = "missile"
		object.accel = weapon.accel
	else
		object.weaponType = "projectile"
	end	
	object.getHullDamage = function(self) return self.damage or physicsObject.getKineticEnergy(self) end
	object.getShieldDamage = function(self) return self.shieldDamage or physicsObject.getKineticEnergy(self) end
	setmetatable(object, { __index = physicsObject })
	return object
end

function projectile.draw(projectiles)
	for i=1, #projectiles do
		local p = projectiles[i]
		love.graphics.setColor(p.team.color)
		love.graphics.draw(p.image, p.p[x], p.p[y], p.angle + math.rad(90), 1, 1, p.width / 2, p.height / 2)
	end

end

function projectile.updatePhysics(planet, dt)
	local j = 1
	local p = planet.spaceProjectiles[j]
	while p do
		if projectile.updateProjectile(p, planet.spaceUnits, dt) or utils.getDistance(p.p[1], p.p[2], planet.x, planet.y) < planet.radius then
			table.remove(planet.spaceProjectiles, j)
		end
		j = j+1
		p = planet.spaceProjectiles[j]
	end
	j = 1
	p = planet.groundProjectiles[j]
	while p do
		if projectile.updateProjectile(p, planet.groundUnits, dt)  then
			table.remove(planet.groundProjectiles, j)
		elseif utils.getDistance(p.p[1], p.p[2], p.startX, p.startY) > p.range then
			effect.new(planet, p.p[1], p.p[2], p.impactSprite, false, false, p.angle)
			table.remove(planet.groundProjectiles, j)
		end
		j = j+1
		p = planet.groundProjectiles[j]
	end
	laser.updatePhysics(planet.spaceUnits, planet.spaceLasers, dt)
	laser.updatePhysics(planet.groundUnits, planet.groundLasers, dt)
end

function projectile.updateProjectile(p, ships, dt)
	if p.weaponType == "missile" then
		projectile.updateMissile(p, dt)
	end
	p:updatePhysics(dt)
	for i, k in pairs(ships) do 
		if not (p.team == k.team) then
			if shipToWeaponCollision(k, p) then
				return true
			end
		end
	end
end

function projectile.updateMissile(m, dt) -- turn missile towards target ( and apply accell)
	-- if m.target then
	local target = m.parent.targets[1]
	-- if target and not target.dead then
		-- local angle = utils.limitAngle(utils.getAngle(m.p[x] - target.body:getX(), m.p[y] - target.body:getY()))
		-- m.angle = limit(-m.turningSpeed *  dt, m.turningSpeed * dt, (angle - m.angle)+m.angle		
		local vel = utils.getDistance(m.v[x], m.v[y])
		m.v = {vel * math.cos(m.angle), vel * math.sin(m.angle)}
		m.a = {m.accel * math.cos(m.angle), m.accel * -math.sin(m.angle)}
	
	-- else
		-- m.a = {0,0}
	-- end
end

function projectile.remove(p, isMissile)
	local t = projectiles
	if isMissile then
		t = missiles
	end
	for i=1,#t do
		if t[i] == p then
			table.remove(t, i)
		end
	end
end



laser = {}
local lasers = {}
function laser.new(x, y, angle, power, color, team, fireTime)
	local object = {}
	object.m = power
	object.emitDistance = emitDistance
	object.power = power
	object.color = color
	object.time = 0
	object.fireTime = fireTime
	object.angle = angle
	object.startX = x
	object.weaponType = "laser"
	object.startY = y
	object.angle = angle
	object.width = power
	object.falloff = power * 100 --falloff is distance at witch laser power is 50%
	object.team = team
	object.dist = object.falloff * 5
	object.damage = 0
	object.impactSprite = tinyImpact
	object.getHullDamage = function(self) 
		return self.damage end
	object.getShieldDamage = function(self) return self.damage end
	object.getImpulse = function(self) return 0,0 end
	return object
end

function laser.draw(lasers)
	local oldColor = {love.graphics.getColor()}
	for i=1, #lasers do
		local p = lasers[i]
		love.graphics.setColor(p.color)
		--love.graphics.draw(p.image, p.p[x], p.p[y], p.angle + math.rad(90), 1, 1, p.width / 2, p.height / 2)
		love.graphics.setLinewidth(p.power/500)

		love.graphics.line(p.startX, p.startY, p.endX, p.endY)
	end
	love.graphics.setColor(oldColor)
end

function laser.updatePhysics(ships, lasers, dt)
	for j=1,#lasers do
		
		if lasers[j] then
			local l = lasers[j]
			l.time = l.time + dt
			if l.fireTime < l.time then
				table.remove(lasers, j)
			end
			l.endX = false
			l.endY = false
			local distX = 5*math.cos(l.angle)
			local distY = 5*math.sin(l.angle)
			l.p = {l.startX, l.startY}
			for h=1,l.falloff/4 do
				l.p = {l.p[x] + distX, l.p[y] + distY}
				local t = l.team
				for i=1,#missiles do
					local m = missiles[i]
					if not m.team == t then
						l.damage = l.power * dt
						if missileToWeaponCollision(m, l) then
							l.endX = l.p[x]
							l.endY = l.p[y]
							l.dist = utils.getDistance(l.endX, l.endY, l.startX, l.startY)
							return
						end
					end
				end
				for i, k in pairs(ships) do 
					if not (t == k.team) then
						l.damage = l.power * dt
						if shipToWeaponCollision(k, l) then
							l.endX = l.p[x]
							l.endY = l.p[y]
							l.dist = utils.getDistance(l.endX, l.endY, l.startX, l.startY)
							return
						end
					end
				end
				
				if l.endX then
					break
				end
				
			end
			l.endX = l.p[x]
			l.endY = l.p[y]
			l.dist = l.falloff * 5
		end
	end
end