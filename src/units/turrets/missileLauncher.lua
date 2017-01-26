missileLauncher = {}

function missileLauncher.new(xpos, ypos, firingArc)
	local object = {
		[1] = xpos,
		[2]  = ypos,
		width = 21,
		group = 1,
		height = 17,
		vertex = {11.5,8.5},
		barrelDist = 10,
		velocity = 300,
		accel = 100,
		speed = 50,
		turningSpeed = 360,
		mass = .0005,
		weaponType = "projectile",
		damage = 500,
		shieldDamage = 500,
		angle = 0,
		reloadTime = 5,
		reload = math.random() * 4,
		readyToFire = false,
		image = love.graphics.newImage("images/units/spaceShips/mediumSquareTurret.png"),
		--projectileImage = rocketTruckMissileImage,
		collisionSize = 40,
		health = 200,
		maxHealth = 200,
		turnRate = .3
	}
	turret.init(object, firingArc)
	--setmetatable(object, { __index = circularTurretSmall })
	
	function object:pointTowards(...)
		return turret.pointTowards(self, true, ...)
	end
	
	
	return object
end
