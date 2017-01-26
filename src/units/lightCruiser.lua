lightCruiser = {}

function lightCruiser:new(...)
	--assert(id, "no spaceShip id for light Cruiser creation") 
	local o = {}
	--generalStuffs
	o.image = love.graphics.newImage("images/units/spaceShips/testShipOutline.png")
	-- o.otherImage = lightCruiserImageOther
	o.height =91
	o.width =91
	o.collisionHeight = 91
	o.collisionWidth = 91
	--o.shape = {-47.5, -47.5, 47.5, -47.5, 47.5, 47.5, -47.5, 47.5, -47.5, -47.5}
	--powerStuffs
	o.maxPower = 1000
	o.reactorHealth = 1000
	
	o.maxHealth = 10000
	
	o.bridgeHealth = 5000
	o.bridgeMaxHealth = 5000
	--engineStuff
	o.engineForce = 1500
	o.thrusterForce = 200
	o.engineMaxHealth = 700
	--o.engineEnd = 93 - 97/2
	--o.engineStart = 87 - 97/2
	o.engineY = 36
	o.engineHeight = 20
	o.engineWidth = 90
	o.engineEffects = {
		SpriteAnimation:new("images/units/effects/pixelEngineEffect.png",1,5,5,1,.05, 90, 1),
		{{0,48}}
	}
	--weapon stuff
	o.weapons = {
		[1] = circularTurretSmall.new(33,31, "bottomRight"),
		[2] = circularTurretSmall.new(-33,31, "bottomLeft"),
		[3] = circularTurretSmall.new(-33,-22, "upperLeft"),
		[4] = circularTurretSmall.new(33,-22, "upperRight"),
		-- [5] = squareTurretMedium.new(-30, 0, "left"),
		-- [6] = squareTurretMedium.new(30, 0, "right"),
		[5] = missileLauncher.new(-33,0,"left"),
		[6] = missileLauncher.new(-33,15,"left"),
		-- [7] = missileLauncher.new(-30,15,"left"),
		[7] = missileLauncher.new(33,15,"right"),
		[8] = missileLauncher.new(33,0,"right"),
		-- [10] = missileLauncher.new(30,15,"right")
	} 
	
	--shields stuff
	o.shieldsActive = true

	o.shieldRegen = 200
	o.maxShields = 20000
	o.shieldCycleTime = 4
	
	--ai stuff
	o.aiTurningSpeed = .5
	o.aiMaxRange = 700
	o.aiMinRange = 200
	o.broadside = true
	
	spaceShip.new(o, ...)
	return o
end





