jeep = {}

function jeep:new(...)
	--assert(id, "no spaceShip id for light Cruiser creation") 
	local o = {}
	--generalStuffs
	o.image = jeepImage
	o.height =22
	o.width =23
	o.collisionHeight = 22
	o.collisionWidth = 21
	--o.shape = {-47.5, -47.5, 47.5, -47.5, 47.5, 47.5, -47.5, 47.5, -47.5, -47.5}
	--powerStuffs
	o.maxPower = 1000
	o.reactorHealth = 1000
	
	o.health = 10000
	
	o.bridgeHealth = 5000
	o.bridgeMaxHealth = 5000
	--engineStuff
	o.engineForce = 100
	o.engineHealth = 700
	o.engineMaxHealth = 1000
	--o.engineEnd = 93 - 97/2
	--o.engineStart = 87 - 97/2
	o.engineY = 0
	o.engineHeight = 5
	o.engineWidth = 20
	-- o.engineEffects = {
		-- SpriteAnimation:new("images/ships/effects/engineEffectCrusier.png",90,5,2,1,.1),
		-- {{0,46}}
	-- }
	
	--ai stuff
	o.aiTurningSpeed = .5
	o.aiMaxRange = 700
	o.aiMinRange = 200
	o.broadside = true
	
	truck.new(o, ...)
	return o
end





