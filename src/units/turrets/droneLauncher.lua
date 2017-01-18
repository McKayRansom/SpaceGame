missileLauncher = {} ---WIP TEMP COPY OF MISSILE LAUNCHER

function missileLauncher.new(xpos, ypos, firingArc)
	local object = {
		[1] = xpos,
		[2]  = ypos,
		width = 14,
		group = 1,
		height = 11,
		vertex = {5,5},
		velocity = 100,
		speed = 50,
		turningSpeed = 360,
		mass = .0005,
		weaponType = "missile",
		damage = 500,
		shieldDamage = 100,
		angle = 0,
		reloadTime = .5,
		reload = math.random(1),
		readyToFire = false,
		image = circularTurretSmallImage,
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
