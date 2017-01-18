shuttle = {
	image = love.graphics.newImage("images/units/W-Series/waspFighter.png")
	fighter = true
	height =11
	width =10
	collisionHeight = 4
	collisionWidth = 5
	health = 500
	mass = 1
	inertia = 800
	--engineStuff
	engineForce = 300
	thrusterForce = 100
	engineHealth = 100
	engineEffects = {
		SpriteAnimation:new("images/units/effects/pixelEngineEffect.png",1,5,5,1,.05, 8, .5),
		{{0,5}}
	}
	--weapon stuff
	weapons = {
		[1] = fighterTurret.new(0,0, "all"),
	} 
	--ai stuff
	aiTurningSpeed = .5
	aiMaxRange = 700
	aiMinRange = 200
	broadside = false
	
}

function shuttle:new(...)
	local o = {}
	--generalStuffs
	
	spaceShip.new(o, ...)
	return o
end