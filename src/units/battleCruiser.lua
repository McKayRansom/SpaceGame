battleCruiser = {}

function battleCruiser:new(...)
	--assert(id, "no spaceShip id for light Cruiser creation") 
	local o = {}
	--generalStuffs
	o.image = battleCruiserImage
	o.height =200
	o.width =200
	o.collisionHeight = 190
	o.collisionWidth = 195
	o.collisionExceptions = {
		--{-100, -80, -50,50},
		{80, 100, -50, 50}
	}
	--powerStuffs
	o.maxPower = 1000
	o.reactorHealth = 1000
	
	o.health = 7000
	
	o.bridgeHealth = 5000
	o.bridgeMaxHealth = 5000
	--engineStuff
	o.engineForce = 4000
	o.thrusterForce = 1500
	o.engineHealth = 1000
	o.engineEffects  = {engineSprites.medium, -- relative to upper left
	{{-72,107}, {0,107}, {72,107}}
	}
	--o.engineEnd = 93 - 97/2
	--o.engineStart = 87 - 97/2
	o.engineY = 80
	o.engineHeight = 23
	o.enginewidth = 190

	--weapon stuff
	o.weapons = {
		squareTurretMedium.new(-71,-32, "left"), --left lasers
		squareTurretMedium.new(-71,-9, "left"),
		squareTurretMedium.new(-71,15, "left"),
		squareTurretMedium.new(-71,38, "left"),
		squareTurretMedium.new(71,-32, "right"), --right lasers
		squareTurretMedium.new(71,-9, "right"),
		squareTurretMedium.new(71,15, "right"),
		squareTurretMedium.new(71,38, "right"),
		circularTurretSmall.new(-88, -82, "upperLeft"), --upper left turrets
		circularTurretSmall.new(-88, -69, "left"),
		circularTurretSmall.new(-75, -82, "forward"),
		circularTurretSmall.new(-62, -82, "forward"),
		circularTurretSmall.new(-88, -56, "left"),
		
		
		circularTurretSmall.new(88, -82, "upperRight"), --upper right turrets
		circularTurretSmall.new(88, -69, "right"),
		circularTurretSmall.new(75, -82, "forward"),
		circularTurretSmall.new(62, -82, "forward"),
		circularTurretSmall.new(88, -56, "right"),
		
		circularTurretSmall.new(88, 86, "bottomRight"), --bottom right turrets
		circularTurretSmall.new(88, 74, "right"),
		circularTurretSmall.new(88, 62, "right"),
		
		circularTurretSmall.new(-88, 86, "bottomLeft"), --bottom left turrets
		circularTurretSmall.new(-88, 74, "left"),
		circularTurretSmall.new(-88, 62, "left"),
		--circulatTurretSmall.new(
	} 
	--shields stuff
	o.shieldsActive = true

	o.shieldRegen = 200
	o.shields = 4000
	o.shieldCycleTime = 1
	
	--ai stuff
	o.aiTurningSpeed = .5
	o.aiMaxRange = 700
	o.aiMinRange = 200
	o.broadside = true
	
	spaceShip.new(o, ...)
	return o
end





