tinyTurret = {}

function tinyTurret.new(xpos, ypos, firingArc)
	local object = {
		[1] = xpos,
		[2]  = ypos,
		width = 6,
		group = 2,
		height = 5,
		vertex = {1.5,2},
		velocity = 1800,
		mass = .00005,
		weaponType = "projectile",
		angle = 0,
		reloadTime = .04,
		burstLeft = 10,
		burst = 4,
		burstReloadTime = 5,
		reload = math.random(.25),
		projectileImage = MGBulletImage,
		collisionImage = tinyImpact,
		readyToFire = false,
		image = tinyTurretImage,
		collisionSize = 10,
		health = 20,
		maxHealth = 20,
		turnRate = .3
	}
	turret.init(object, firingArc)
	--setmetatable(object, { __index = tinyTurret })
	
	function object:pointTowards(...)
		return turret.pointTowards(self, true, ...)
	end
	
	
	return object
end
