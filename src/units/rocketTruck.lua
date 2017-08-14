

local rocketTruckTurret = {}
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
		velocity = 10,
		accel = 150,
		speed = 50,
		turningSpeed = 1,
		barrelDist = 1,
		verticalOffset = 0,
		range = 1500,
		mass = .0005,
		weaponType = "projectile",
		damage = 7000,
		shieldDamage = 5000,
		ammoObject = ammoObject,
		isAmmo = true,
		angle = -math.pi/2,
		reloadTime = 5,
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

rocketTruck = {
	--generalStuffs
	image = love.graphics.newImage("images/units/trucks/rocketTruck.png"),
	unitClass = "rocketTruck",
	height =20,
	width =30,
	collisionHeight = 20,
	collisionWidth = 30,
	maxHealth = 3000,
	--ammo stuff
	ammo = 4,
	maxCargo = 4,

		--shields stuff
	shieldRegen = 200,
	maxShields = 7000,
	shieldCycleTime = 4,
	--engineStuff
	engineForce = 35,
	brakingForce = 55,
	tankDrive = false,
	steeringSpeed = .5,
	engineHealth = 500,
	deathAnim = tankDeath,
	maxSpeed = 20,
	--o.engineEnd = 93 - 97/2
	--o.engineStart = 87 - 97/2
	engineY = -23,
	engineHeight = 5,
	engineWidth = 20,
	pathfindingDistance = 50,

}
function rocketTruck:new(...)
	local o = {}
	o.weapons = {
		[1] = rocketTruckTurret.new(0,3, "all", o),
	}
	o.parents = {rocketTruck}
	truck.new(o, ...)
	table.insert(ammoUsers, o)
	return o
end
