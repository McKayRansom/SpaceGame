local tankTurret = {
	--turretProperties
	image = love.graphics.newImage("images/units/trucks/tankTurret.png"),
	width = 35,
	group = 1,
	height = 20,
	vertex = {11,10},
	barrelDist = 13,
	verticalOffset = 0,
	weaponType = "projectile",
	reloadTime = 5,
	projectileImage = love.graphics.newImage("images/units/trucks/tankShell.png"),
	collisionSize = 6,
	maxHealth = 1000,
	turnRate = .1,
	--projectile properties
	velocity = 600,--600,--2000,
	accuracy = .01,
	range = 700,
	mass = .01,
}

function tankTurret.new(xpos, ypos, firingArc)
	local object = {
		[1] = xpos,
		[2]  = ypos,
		reload = math.random(5),
	}
	setmetatable(object, { __index = tankTurret })
	turret.init(object, firingArc)
	
	
	function object:pointTowards(...)
		return turret.pointTowards(self, true, ...)
	end
	return object
end
tank = {
	image = love.graphics.newImage("images/units/trucks/tank.png"),
	unitClass = "tank",
	height =20,
	width =22,
	collisionHeight = 20,
	collisionWidth = 22,
	maxHealth = 5000,
	deathAnim = tankDeath,	
	--shields stuff
	shieldRegen = 200,
	maxShields = 10000,
	shieldCycleTime = 4,
	--engineStuff
	engineForce = 15,
	brakingForce = 55,
	maxSpeed = 30,
	tankDrive = true,
	engineHealth = 500,
	engineY = -23,
	engineHeight = 5,
	engineWidth = 20,
	steeringSpeed = 1,
	pathfindingDistance = 50,
	--weapons
	
}
function tank:new(...)
	local o = {
		weapons = {
			-- [1] = tinyTurret.new(7-27/2,6-27/2, "upperLeft"),
			-- [2] = tinyTurret.new(19-27/2,6-27/2, "upperRight"),
			[1] = tankTurret.new(0,0, "all"),
		},
	}
	o.parents = {tank}	
	truck.new(o, ...)
	return o
end


