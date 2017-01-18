fighterTurret = {}

function fighterTurret.new(xpos, ypos, firingArc)
	local object = {
		[1] = xpos,
		[2]  = ypos,
		-- image = love.graphics.newImage("images/units/circularTurretSmall.png"),
		barrelDist = 3,
		width = 21,
		group = 1,
		height = 17,
		vertex = {0,0},
		velocity = 1200,
		mass = .0003,
		weaponType = "projectile",
		angle = 0,
		reloadTime = .25,
		burst = 3,
		burstLeft = 2,
		burstReloadTime = 3,
		reload = math.random(1),
		readyToFire = false,
		collisionSize = 40,
		health = 20,
		maxHealth = 20,
		turnRate = .3
	}
	turret.init(object, firingArc)
	--setmetatable(object, { __index = circularTurretSmall })
	
	function object:pointTowards(...)
		return turret.pointTowards(self, true, ...)
	end
	
	
	return object
end
