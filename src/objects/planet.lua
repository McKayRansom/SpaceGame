planet = {}
local shader = love.graphics.newShader[[
		extern number zoom;
		extern number radius;
		extern number innerRadius;
		extern vec2 view;
		extern vec2 center;
		extern vec2 screenSize;
		vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
		{
			screen_coords.y = screenSize.y-screen_coords.y;
			screen_coords = (screen_coords/zoom)-view;
			color *= (sqrt(pow(screen_coords.x-center.x, 2) + pow(screen_coords.y-center.y, 2))-innerRadius)/radius;
			return color;
		}
	
	
	]]
function planet.new(object, image, name, jumpNodes, resources)
	object.image = image or testPlanet
	object.name = name or"defaultPlanet"
	object.units = {}
	object.spaceUnits = {}
	object.groundUnits = {}
	object.effects = {}
	object.spaceProjectiles = {}
	object.groundProjectiles = {}
	object.spaceLasers = {}
	object.groundLasers = {}
	object.world = love.physics.newWorld(0, 0, true)
	object.planetBody = love.physics.newBody(object.world, 3500, 3000, "static")
	object.x = 3500
	object.y = 3000
	object.radius = 1400 * 2
	object.resources = {} -- ore nodes
	object.wind = {0, -5} -- blows smoke in a certain direction :)
	local angle = 0
	local dist = object.radius/2  
	local da = (2*math.pi)/resources
	for i=1, resources do
		table.insert(object.resources, {
				object.x + math.cos(angle) * dist + love.math.random(-1000, 1000), 
				object.y + math.sin(angle) * dist + love.math.random(-1000, 1000),
				["built"] = false
			})
		angle = angle + da
	end
		
	--make a approximated physics shape. For both space and ground to collide on (increase the 45 to have better accuracy but potentially worse performance... no idea
	-- object.planetShape = love.physics.newCircleShape(3000)
	--	love.graphics.circle("fill", 3500, 3000, 1400, 45)
	local points = {}
	local angle = 0
	local r = 1400 * 2--1400
	local x = 0--3500
	local y = 0--3000
	for i=1, 45 do
		points[#points + 1] = x + math.cos(angle) * r
		points[#points + 1] = y + math.sin(angle) * r
		angle = angle + (math.pi * 2)/45
	end
	object.planetShape = love.physics.newChainShape(true, points)
	object.planetFixture = love.physics.newFixture(object.planetBody, object.planetShape)
	
	object.jumpNodes = jumpNodes or {}
	object.shader = shader
end

function planet:pack()

end

function planet:unpack()

end

function planet:draw()
	love.graphics.setColor(92, 56 ,0 , 255)
	self.shader:send("radius", 1000 * 6)
	self.shader:send("innerRadius", -200 * 4)
	self.shader:send("center", {self.x, self.y})
	self.shader:send("view", {viewX, viewY})
	self.shader:send("zoom", zoom)
	self.shader:send("screenSize", {screenWidth, screenHeight})
	love.graphics.setShader(self.shader)
	love.graphics.circle("fill", self.x, self.y, 1400 * 2, 45)
	love.graphics.setShader()
end