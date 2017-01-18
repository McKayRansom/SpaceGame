function checkBoxCollision(px, py, angle, cx, cy, width, height)
	local dx = cx-px
	local dy = cy-py
	local ax, ay = utils.getRelativeCoords(dy,dx, angle)
	if (math.abs(ax) < width/2) and (math.abs(ay) < height/2) then
		return true
	else
		return false
	end
	return false
end

function checkOvalCollision(px, py, width, height, cx, cy)
	width = width/2
	height = height/2
	local minDist = math.sqrt(width^2 + height^2)
	local dx = px-cx
	local dy = py-cy
	local dist = math.sqrt(dx^2 + dy^2)
	if dist > minDist then
		return false
	else
		return true
	end
end

function shipToWeaponCollision(ship, w) --ship means ship w means weapon

	if not ship then
		return false
	end
	local shipX, shipY = ship.body:getX(), ship.body:getY()
	local shipAngle = ship.body:getAngle()
	if checkOvalCollision(shipX, shipY, ship.collisionWidth, ship.collisionHeight, w.p[x], w.p[y]) then
		if shipCollision(ship, w, shipX, shipY, shipAngle) then
			if not ship.body:isDestroyed() then
				local impulseX, impulseY = w:getImpulse()
				ship.body:applyLinearImpulse(impulseX, impulseY, w.p[x], w.p[y])
			end
			return true
		end
	end
	return false
	--essentially else
	--doOtherStuff
end

function shipCollision(ship, w, shipX, shipY, shipAngle)

	if ship.shields then
		printc = "shields"
		ship.shields = ship.shields - w:getShieldDamage()--getKineticEnergy()
		if ship.shields < 0 then
			ship.shields = 0 --temp thingy fix this!!
			ship.shieldRecharge = ship.shieldCycleTime
			ship.shieldsActive = false
		else
			effect.new(ship, w.p[x], w.p[y], shieldImpact, false)
			return true

		end
	end
	-- local dx = shipX - w.p[x]
	-- local dy = shipY - w.p[y]
	local ax, ay = utils.getRelativeCoords(shipX, shipY, w.p[1], w.p[2], shipAngle)
	if (math.abs(ax) < ship.collisionWidth/2) and (math.abs(ay) < ship.collisionHeight/2) then
		if ship.collisionExceptions then
			
			for i=1,#ship.collisionExceptions do
			local e = ship.collisionExceptions[i]
				if ((math.abs(e[1]) < math.abs(ax)) and (math.abs(ax) < math.abs(e[2]))) and
						((e[3] < ay) and (e[4] > ay)) then
					printc = "collisionException"
					return false
					
				
				end
			end
		end
		for i=1,#ship.weapons do
			local wep = ship.weapons[i]
			local x1,x2 = wep[x]-(wep.collisionSize/2),wep[x] + (wep.collisionSize/2)
			local y1,y2 = wep[y]-(wep.collisionSize/2),wep[y] + (wep.collisionSize/2)
			if (x1 < ax) and (ax < x2) and (y1 < ay) and (ay < y2) then
				printc = "weapons"
				wep.health = wep.health - w:getHullDamage()
				if wep.health < 0 then
					wep.health = 0
					wep.dead = true
				else
					effect.new(ship, w.p[x], w.p[y], w.impactSprite, true)
					return true
				end
			end
		end
		--check for collision with engines
		if ship.engineWidth then
			local x1,x2 = (-ship.engineWidth/2),(ship.engineWidth/2)
			local y1,y2 = ship.engineY-(ship.engineHeight/2),ship.engineY + (ship.engineHeight/2)
			if (x1 < ax) and (ax < x2) and (y1 < ay) and (ay < y2) then
				printc = "engines"
				ship.engineHealth = ship.engineHealth - w:getHullDamage()
				if ship.engineHealth < 0 then
						ship.engineHealth = 0
				else
					effect.new(ship, w.p[x], w.p[y], w.impactSprite, true)
					return true
				end
			end
		end
		ship.health = ship.health - w:getHullDamage()
		printc = "structure"
		if ship.health < 0  then
			ship.health = 0
			if not ship.dead then
				ship:startDeath()
				return true
			else
				return false
			end
		end

		effect.new(ship, w.p[x], w.p[y], w.impactSprite, true)
		return true
		
		
	end
end

function missileToWeaponCollision(missile, weapon)
	if checkOvalCollision(missile.p[x], missile.p[y], 3,7, weapon.p[x], weapon.p[y]) then
		missile.health = missile.health - weapon:getHullDamage()
		if missile.health < 0 then
			projectile.remove(missile, true)
		end
		return true
	end
	return false
end