rocketTruck = {}
local rocketTruckImage = love.graphics.newImage("images/units/trucks/rocketTruck.png")
function rocketTruck:new(...)
	local o = {}
	--generalStuffs
	o.image = rocketTruckImage
	o.height =20
	o.width =30
	o.collisionHeight = 20
	o.collisionWidth = 30
	--o.shape = {-47.5, -47.5, 47.5, -47.5, 47.5, 47.5, -47.5, 47.5, -47.5, -47.5}
	--powerStuffs
	o.maxPower = 1000
	o.reactorHealth = 1000
	--ammo stuff
	o.ammo = 4
	o.maxCargo = 4
	o.structuralMaxHealth = 4000
		--shields stuff
	o.shieldsActive = true
	o.unitClass = "rocketTruck"
	o.shieldRegen = 200
	o.maxShields = 7000
	o.shieldCycleTime = 4
	--engineStuff
	o.engineForce = 35
	o.brakingForce = 55
	o.tankDrive = false
	o.steeringSpeed = .5
	o.engineHealth = 500
	o.deathAnim = tankDeath
	--o.engineEnd = 93 - 97/2
	--o.engineStart = 87 - 97/2
	o.engineY = -23
	o.engineHeight = 5
	o.engineWidth = 20
	o.weapons = {
		[1] = rocketTruckTurret.new(0,3, "all", o),
	}
	truck.new(o, ...)
	table.insert(ammoUsers, o)
	return o
end

rocketTruckTurret = {}
local rocketTruckTurretImage = love.graphics.newImage("images/units/trucks/rocketTruckTurret.png")
local rocketTruckMissileImage = love.graphics.newImage("images/units/trucks/rocketTruckMissile.png")


function rocketTruckTurret.new(xpos, ypos, firingArc, ammoObject)
	local object = {
		[1] = xpos,
		[2]  = ypos,
		width = 14,
		group = 1,
		height = 11,
		vertex = {7,10},
		velocity = 50,
		accel = 650,
		turningSpeed = 1,
		barrelDist = 1,
		verticalOffset = 0,
		range = 700,
		mass = .0005,
		weaponType = "missile",
		damage = 7000,
		shieldDamage = 5000,
		ammoObject = ammoObject,
		isAmmo = true,
		angle = -math.pi/2,
		reloadTime = 2,
		reload = math.random() *10,
		-- burst = 4,
		-- burstLeft = 4,
		-- burstReloadTime = 10,
		readyToFire = false,
		image = rocketTruckTurretImage,
		projectileImage = rocketTruckMissileImage,
		-- collisionImage = mediumImpact,
		collisionSize = 10,
		health = 200,
		maxHealth = 200,
		turnRate = .05
	}
	turret.init(object, firingArc)
	--setmetatable(object, { __index = circularTurretSmall })
	
	function object:pointTowards(...)
		return turret.pointTowards(self, false, ...)
	end
	
	function object:customDraw()
		for i=1,self.ammoObject.ammo do
			love.graphics.draw(rocketTruckMissileImage, self[x], self[y], self.angle + math.pi/2, 1, 1, self.vertex[x]+ 5 - i * 4, self.vertex[y] -3 )
		end
	end

	function object:customUpdate()
		if self.ammoObject.ammo == 4 then
			self.verticalOffset = 6
		elseif self.ammoObject.ammo == 3 then
			self.verticalOffset = 2
		elseif self.ammoObject.ammo ==2 then
			self.verticalOffset = -2
		elseif self.ammoObject.ammo == 1 then
			self.verticalOffset = -6
		end
	end
	
	return object
end




