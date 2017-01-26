circularTurretSmall = {}

function circularTurretSmall.new(xpos, ypos, firingArc)
	local object = {
		[1] = xpos,
		[2]  = ypos,
		image = love.graphics.newImage("images/units/spaceShips/circularTurretSmall.png"),
		barrelDist = 11,
		width = 21,
		group = 1,
		height = 17,
		vertex = {8.5,8.5},
		velocity = 1000,
		mass = .0005,
		weaponType = "projectile",
		angle = 0,
		reloadTime = .25,
		burst = 3,
		burstLeft = 1,
		burstReloadTime = 5,
		reload = math.random()*-10,
		readyToFire = false,
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
