building = {}
tankFactory = {
	unitClass = "tankFactory",
	width = 140,
	height = 140,
	collisionHeight = 140,
	collisionWidth = 140,
	health = 50000,
	productionTime = 60,
	productionUnit = tank,
	unitProducer = true,
	unitCost = 12,
	formationSize = 6,
	metalDemand = true,
	metalMax = 24,
	productionPoint = {0,-85, math.pi}
}
tankFactory.image = love.graphics.newImage("images/units/buildings/tankFactory.png")
local metalFactoryImage = love.graphics.newImage("images/units/buildings/metalFactory.png")
local metalFactorySmokeImage = love.graphics.newImage("images/units/buildings/metalFactorySmoke.png")
function tankFactory:new(...)
	local unitDef = {
		metal = 0,
		metalExpectedAmount = 0,
		parents = {tankFactory},
	}
	factory.new(unitDef, ...)
	return unitDef
end
miningTruckFactory = {
	unitName = "miningTruckFactory",
	width = 105,
	height = 105
}
miningTruckFactory.image = love.graphics.newImage("images/units/buildings/miningTruckFactory.png")
function miningTruckFactory:new(...)
	local o = {}
	--generalStuffs
	o.image = miningTruckFactory.image
	o.height =105
	o.width = 105
	o.collisionHeight = 105
	o.collisionWidth = 105
	o.health = 50000
	o.productionTime = 10
	o.productionUnit = miningTruck
	o.productionPoint = {0,-85, math.pi}
	o.unitProducer = true
	o.unitCost = 2
	o.formationSize = 1
	o.metal = 0
	o.metalExpectedAmount = 0
	o.metalDemand = true
	o.metalMax = 12
	o.parents = {miningTruckFactory}
	factory.new(o, ...)
	return o
end

metalFactory = {
	unitClass = "metalFactory",
	image = metalFactoryImage,
	height =140,
	width = 140,
	collisionHeight = 140,
	collisionWidth = 140,
	smokeImage = metalFactorySmokeImage,
	smokeFrequency = 1,
	smokeFade = 20, -- reduction every sec
	smokeDissipate = .2, -- increase in scale every sec
	smokeStacks = {{39-82, 28-70}, {76-82, 28-70}, {113-82, 28-70}, 		{38-82, 114-70}, {75-82, 114-70}, {112-82, 114-70}},
	health = 50000,
	productionTime = 10,
	refinery = true,
	required = { ore = 5},
	products = { metal = 2},
}
function metalFactory:new(planet, x, y, team, angle, vx, vy)
	local o = {}
	--generalStuffs
	o.ore = 5
	o.oreMax = 12
	o.oreExpectedAmount = 5
	o.oreDemand = true
	o.metal = 0
	o.metalExpectedAmount = 0
	o.metalMax = 12
	o.metalSupply = true
	o.parents = {metalFactory}
	factory.new(o, planet, x, y, team, angle, vx, vy)
	return o
end
shipyard = {}
function shipyard:new(...)
	local o = {}
	--generalStuffs
	o.image = shipyardImage
	o.height =195
	o.width = 281
	o.collisionHeight = 279
	o.collisionWidth = 193
	o.shape = { 4, 4, 187, 7, 187,187, 4, 191, 275,191, 275,3, 4, 4}
	for i=1, #o.shape, 2 do
		o.shape[i] = o.shape[i]-96.5
		o.shape[i+1] = o.shape[i+1] - 140.5
	end
	o.health = 50000
	o.productionTime = 10
	o.productionUnit = heavyCruiser
	o.productionPoint = {-40, 0, math.pi}
	o.unitProducer = true
	o.unitCost = 0
	o.formationSize = 1
	o.rocks = 0
	o.cargo = "rocks"
	o.maxCargo = 12
	factory.new(o, ...)
	return o
end



enemySpawner = {}
function enemySpawner:new(...)
	local o = {}
	--generalStuffs
	o.image = tankFactoryImage
	o.otherImage = tankFactoryOtherImage
	o.height =140
	o.width = 140
	o.collisionHeight = 140
	o.collisionWidth = 140
	-- o.shape = {0, 0, 140, 0, 140, 94, 79, 94, 79, 140, 0, 140, 0 ,0}
	o.health = 50000
	o.productionTime = 15
	o.productionUnit = tank
	o.productionPoint = {0,-85, math.pi}
	o.unitProducer = true
	o.unitCost = 1
	o.formationSize = 6
	o.rocks = 6
	o.cargo = "rocks"
	o.maxCargo = 12
	factory.new(o, ...)
	return o
end

local resourceBuildingSmokeImage = love.graphics.newImage("images/units/buildings/resourceBuildingSmoke.png")
oreMine = {
	unitClass = "oreMine",
	image =  love.graphics.newImage("images/units/buildings/resourceBuilding.png"),
	smokeImage = resourceBuildingSmokeImage,
	width = 50,
	height = 50,
	resourceProducer = true,
	smokeFrequency = 2,
	smokeFade = 25, -- reduction every sec
	smokeDissipate = .14, -- increase in scale every sec
	smokeStacks = {{15-25, 17-25}, {34-25, 17-25}},
	oreSupply = true,
	oreMax = 5,
	collisionHeight = 48,
	collisionWidth = 48,
	productionTime = 30,
	structuralMaxHealth = 5000,
	cargo = "ore",
	resourceProducer = true,
}

function oreMine:new(...)
	-- node.built = true
	local o = {}
	o.node = node
	o.ore = 1
	o.oreExpectedAmount = 1
	o.parents = {oreMine}
	factory.new(o, ...)
	return o
end

