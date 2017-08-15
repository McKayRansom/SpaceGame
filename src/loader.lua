print("loadingFiles")
local requireList = {
"src/data/debug_settings",
"src/utility/utils",
"src/graphics/SpriteAnimation",
"src/objects/physicsObject",
"src/objects/unit",
"src/objects/truck",
"src/objects/trailer",
"src/objects/factory",
"src/objects/spaceShip",
"src/objects/spaceStation",
"src/objects/planet",
"src/units/jeep",
"src/units/tank",
"src/units/rocketTruck",
"src/units/ammoTruck",
"src/units/miningTruck",
"src/units/shuttle",
"src/units/buildings",
"src/units/lightCruiser",
"src/units/heavyCruiser",
"src/units/battleCruiser",
"src/units/W-Series/fighter",
"src/units/W-Series/fighterTurret",
"src/units/turrets/defaultTurret",
"src/units/turrets/missileLauncher",
"src/units/turrets/circularTurretSmall",
"src/units/turrets/squareTurretMedium",
"src/units/turrets/heavyCruiserTurret",
"src/units/turrets/tinyTurret",
"src/utility/collisions",
"src/utility/server",
"src/utility/client",
"src/objects/weapons",
"src/graphics/gui",
"src/graphics/guiDefs",
"src/graphics/effect",
"src/utility/input",
"src/scenes/game",
"src/scenes/mainMenu",
"src/objects/formation",
}
for i=1,#requireList do
	require(requireList[i])
end
print("finishedLoadingFiles")
function loadImages()
	print("loadingImages...")
	--I really don't think this is good. Just have each unit def load their own files! it just makes more sense


	--ground units
	-- jeepImage = love.graphics.newImage("images/units/jeep.png")
	-- tankImage = love.graphics.newImage("images/units/tankOutline.png")
	-- rocketTruckImage = love.graphics.newImage("images/units/rocketTruck.png")
	-- ammoTruckImage = love.graphics.newImage("images/units/ammoTruck.png")
	-- rocketTruckTurretImage = love.graphics.newImage("images/units/rocketTruckTurret.png")
	-- rocketTruckMissileImage = love.graphics.newImage("images/units/rocketTruckMissile.png")

	-- tankFactoryImage = love.graphics.newImage("images/units/tankFactoryOutline.png")
	-- resourceBuildingImage = love.graphics.newImage("images/units/resourceBuilding.png")
	-- resourceBuildingSmokeImage = love.graphics.newImage("images/units/resourceBuildingSmoke.png")
	-- tankFactoryOtherImage = love.graphics.newImage("images/units/tankFactoryOutlineOther.png")

	-- --spaceUnits
	-- shipyardImage = love.graphics.newImage("images/units/shipyard.png")
	-- battleCruiserImage = love.graphics.newImage("images/units/battleCrusier.png")
	-- tinyTurretImage = love.graphics.newImage("images/units/tinyTurret.png")
	-- tankTurretImage = love.graphics.newImage("images/units/tankOutlineTurret.png")
	-- squareTurretMediumImage = love.graphics.newImage("images/units/mediumSquareTurret.png")
	-- smallProjectileImage = love.graphics.newImage("images/units/smallProjectile.png")
	-- MGBulletImage = love.graphics.newImage("images/units/MGBullet.png")
	-- tankShellImage = love.graphics.newImage("images/units/tankShell.png")
	-- smallMissileImage = love.graphics.newImage("images/units/smallMissile.png")
	shieldImpact = SpriteAnimation:new("images/effects/smallShieldEffect.png",32,32,3,1,.15)
	tankDeath = SpriteAnimation:new("images/units/effects/tankDeath.png",27,27,10,1,.15)
	smallImpact = SpriteAnimation:new("images/effects/smalImpactEffect.png",32,32,5,1,.15)
	tinyImpact = SpriteAnimation:new("images/effects/tinyImpactEffect.png",16,16,5,1,.07)
	engineSprites = {
		medium =  SpriteAnimation:new("images/units/effects/engineEffectMeduim.png",45,20,2,1,.2),
		pixel = SpriteAnimation:new("images/units/effects/pixelEngineEffect.png",1,5,5,1,.2),
	}

	SpriteAnimation.load(shieldImpact, .15)
	smallImpact:load(.15)
	tinyImpact:load(.07)
	engineSprites.medium:load(.2)
	backgroundImage = love.graphics.newImage("images/stars.png")
	resourceDepositImage = love.graphics.newImage("images/resourceDeposit.png")
	testPlanet = love.graphics.newImage("images/planets/testPlanet.png")
	jumpNode = love.graphics.newImage("images/jumpNode.png")
	targetCursor = love.graphics.newImage("images/targetCursor.png")
	moveCursor = love.graphics.newImage("images/moveCursor.png")
	destinationIndicator = love.graphics.newImage("images/destinationIndicator.png")

	backgroundImageWidth = backgroundImage:getWidth()
	backgroundImageHeight = backgroundImage:getHeight()
	print("finished loading image")
end
