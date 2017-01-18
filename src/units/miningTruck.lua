miningTrailer = {
	image = love.graphics.newImage("images/units/trucks/miningTruckBed.png"),
	cargoOreImage = love.graphics.newImage("images/units/trucks/miningTruckCargoOre.png"),
	cargoMetalImage = love.graphics.newImage("images/units/trucks/miningTruckCargoMetal.png"),
	structuralMaxHealth = 5000,
		--generalStuffs
	height =20,
	width =23,
	collisionHeight = 20,
	collisionWidth = 23,
		--engineStuff
	deathAnim = tankDeath,
	isTrailer = true,
	trailer = {
		object = miningTrailer,
		joint = -10,
		distance = -27,
	},
}
miningTruck = {
	unitClass = "miningTruck",
	image = love.graphics.newImage("images/units/trucks/miningTruck.png"),
	height =20,
	width =33,
	--generalStuffs
	collisionHeight = 17,
	collisionWidth = 11,
	structuralMaxHealth = 5000,
	--engineStuff
	engineForce = 25,
	brakingForce = 40,
	maxSpeed = 30,
	tankDrive = false,
	steeringSpeed = 1,
	maxSteering = .35, --if we try to steer beyond this we will not (to not skid trailer
	deathAnim = tankDeath,
	trailer = {
		object = miningTrailer,
		joint = -10,
		distance = -22,
		number = 0,
	},
	cargoTruck = true,
	transferDistance = 30,
	pathfindingDistance = 50,
	timeout = 30,

}



function miningTruck:new(planet, x, y, team, angle, vx, vy, cargo)
	local cargo = cargo or "none"
	local o = {
		--other
		checkTime = 0,
		timeSinceAction = 0,
		--cargo stuff
		cargo = cargo,
		[cargo] = 0,
		[cargo.."Max"] = 1,
		
		
		findDemand = false,
		findSupply = true,
		parents = {miningTruck},
	}
	truck.new(o, planet, x, y, team, angle, vx, vy)
	return o
end



function miningTrailer:new(...)
	local o = {
		parents = {miningTrailer},
	}
	trailer.new(o, ...)
	return o
end

function miningTrailer:drawSelf()
	love.graphics.setColor(self.team.color)
	if self.cab[self.cab.cargo] > 0 then
		local image
		if self.cab.cargo == "ore" then
			image = self.cargoOreImage
		else
			image = self.cargoMetalImage
		end	
		 love.graphics.draw(image, 0, 0, -math.pi/2, 1, 1, self.width / 2, self.height / 2)
	end
	love.graphics.setColor(255,255,255,255)
end




