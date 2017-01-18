heavyCruiserTurret = {}

function heavyCruiserTurret.new(xpos, ypos, firingArc)
	local object = {
		[1] = xpos,
		[2]  = ypos,
		width = 21,
		group = 1,
		height = 17,
		vertex = {7.5,8.5},
		barrelDist = 11,
		velocity = 400,
		mass = .005,
		weaponType = "projectile",
		angle = 0,
		reloadTime = 3,
		reload = math.random(1),
		readyToFire = false,
		image = love.graphics.newImage("images/units/spaceShips/heavyCruiserTurret.png"),
		collisionSize = 40,
		health = 400,
		maxHealth = 400,
		turnRate = .15
	}
	turret.init(object, firingArc)
	--setmetatable(object, { __index = circularTurretSmall })
	
	function object:pointTowards(...)
		return turret.pointTowards(self, true, ...)
	end
	
	
	return object
end
