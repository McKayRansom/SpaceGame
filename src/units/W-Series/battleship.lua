heavyCruiser = {}

function heavyCruiser:new(...)
	--assert(id, "no spaceShip id for light Cruiser creation") 
	local o = {}
	--generalStuffs
	o.image = love.graphics.newImage("images/units/heavyCruiser.png")
	-- o.otherImage = lightCruiserImageOther
	o.height =70
	o.width =120
	o.collisionHeight = 60
	o.collisionWidth = 119
	--o.shape = {-47.5, -47.5, 47.5, -47.5, 47.5, 47.5, -47.5, 47.5, -47.5, -47.5}
	--powerStuffs
	o.maxPower = 1000
	o.reactorHealth = 1000
	
	o.health = 2000
	o.landingUnit = tank
	o.landingQuantity = 2
	
	o.bridgeHealth = 5000
	o.bridgeMaxHealth = 5000
	--engineStuff
	o.engineForce = 1000
	o.thrusterForce = 300
	o.engineHealth = 700
	--o.engineEnd = 93 - 97/2
	--o.engineStart = 87 - 97/2
	o.engineY = 36
	o.engineHeight = 20
	o.engineWidth = 90
	o.engineEffects = {
		SpriteAnimation:new("images/units/effects/pixelEngineEffect.png",1,5,5,1,.05, 58, 1),
		{{0,60}}
	}
	--weapon stuff
	o.weapons = {
		[1] = heavyCruiserTurret.new(15,26, "right"),
		[2] = heavyCruiserTurret.new(15,8, "right"),
		[3] = heavyCruiserTurret.new(15,-10, "right"),
		[4] = circularTurretSmall.new(15, 45, "bottomRight"),
		[5] = circularTurretSmall.new(15,-33, "upperRight"),
		[6] = heavyCruiserTurret.new(-15,26, "left"),
		[7] = heavyCruiserTurret.new(-15,8, "left"),
		[8] = heavyCruiserTurret.new(-15,-10, "left"),
		[9] = circularTurretSmall.new(-15,45, "bottomLeft"),
		[10] = circularTurretSmall.new(-15,-33, "upperLeft"),
	} 
	
	--shields stuff
	o.shieldsActive = true

	o.shieldRegen = 500
	o.shields = 150000
	o.shieldCycleTime = 4
	
	--ai stuff
	o.aiTurningSpeed = .5
	o.aiMaxRange = 700
	o.aiMinRange = 200
	o.broadside = true
	
	spaceShip.new(o, ...)
	return o
end