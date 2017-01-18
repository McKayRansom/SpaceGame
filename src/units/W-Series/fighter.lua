fighter = {}

function fighter:new(...)
	--assert(id, "no spaceShip id for light Cruiser creation") 
	local o = {}
	--generalStuffs
	o.image = love.graphics.newImage("images/units/W-Series/waspFighter.png")
	o.fighter = true
	o.height =11
	o.width =10
	o.collisionHeight = 4
	o.collisionWidth = 5
	o.health = 500
	o.mass = 1
	o.inertia = 800
	--engineStuff
	o.engineForce = 300
	o.thrusterForce = 100
	o.engineHealth = 100
	o.engineEffects = {
		SpriteAnimation:new("images/units/effects/pixelEngineEffect.png",1,5,5,1,.05, 8, .5),
		{{0,5}}
	}
	--weapon stuff
	o.weapons = {
		[1] = fighterTurret.new(0,0, "all"),
	} 
	--ai stuff
	o.aiTurningSpeed = .5
	o.aiMaxRange = 700
	o.aiMinRange = 200
	o.broadside = false
	
	spaceShip.new(o, ...)
	return o
end