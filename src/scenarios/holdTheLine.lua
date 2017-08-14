planets = {{}}

planet.new(planets[1], 1000, 2000, false, "Ezagon",{}, 13)

currentPlanet = planets[1]
planets[1].good = {}
planets[1].bad = {}
local good = {
name = "good",
enimies = "bad",
color = {0, 0, 225},
}
local bad = {
name = "bad",
enimies = "good",
color = {225, 0, 0}
}
cameraX = 3500
cameraY = 3000
teams = {good, bad}
for i=1, 9 do
	-- lineFormation.new({
	-- for j = 1, 6 do
	tank:new(currentPlanet, 2000, 2000 + (i* 300), good, math.pi/2)
	tank:new(currentPlanet, 2000, 2000 + (i* 300) - 50, good, math.pi/2)
	tank:new(currentPlanet, 2000, 2000 + (i* 300) - 100, good, math.pi/2)
	tank:new(currentPlanet, 2000, 2000 + (i* 300)  - 150, good, math.pi/2)
	tank:new(currentPlanet, 2000, 2000 + (i* 300)  - 200, good, math.pi/2)
	tank:new(currentPlanet, 2000, 2000 + (i* 300)  - 250, good, math.pi/2)
	-- end
	-- }, math.pi/2)
end

for i=1, 9 do
	-- lineFormation.new({
	tank:new(currentPlanet, 1950, 2000 + (i* 300), good, math.pi/2)
	tank:new(currentPlanet, 1950, 2000 + (i* 300) - 50, good, math.pi/2)
	tank:new(currentPlanet, 1950, 2000 + (i* 300) - 100, good, math.pi/2)
	tank:new(currentPlanet, 1950, 2000 + (i* 300)  - 150, good, math.pi/2)
	tank:new(currentPlanet, 1950, 2000 + (i* 300)  - 200, good, math.pi/2)
	tank:new(currentPlanet, 1950, 2000 + (i* 300)  - 250, good, math.pi/2)
	-- }, math.pi/2)
end

for i=1, 9 do
	-- lineFormation.new({
	tank:new(currentPlanet, 1900, 2000 + (i* 300), good, math.pi/2)
	tank:new(currentPlanet, 1900, 2000 + (i* 300) - 50, good, math.pi/2)
	tank:new(currentPlanet, 1900, 2000 + (i* 300) - 100, good, math.pi/2)
	tank:new(currentPlanet, 1900, 2000 + (i* 300)  - 150, good, math.pi/2)
	tank:new(currentPlanet, 1900, 2000 + (i* 300)  - 200, good, math.pi/2)
	tank:new(currentPlanet, 1900, 2000 + (i* 300)  - 250, good, math.pi/2)
	-- }, math.pi/2)
end







-- for i=1, 3 do
	-- -- lineFormation.new({
	-- tank:new(currentPlanet, 1750, 2000 + (i* 300), good, math.pi/2)
	-- tank:new(currentPlanet, 1750, 2000 + (i* 300) - 50, good, math.pi/2)
	-- tank:new(currentPlanet, 1750, 2000 + (i* 300) - 100, good, math.pi/2)
	-- tank:new(currentPlanet, 1750, 2000 + (i* 300)  - 150, good, math.pi/2)
	-- tank:new(currentPlanet, 1750, 2000 + (i* 300)  - 200, good, math.pi/2)
	-- -- }, math.pi/2)
-- end

for i=2, 2 do
	lineFormation.new({
	rocketTruck:new(currentPlanet, 1700, 2000 + (i* 300), good, math.pi/2),
	rocketTruck:new(currentPlanet, 1700, 2000 + (i* 300) - 50, good, math.pi/2),
	rocketTruck:new(currentPlanet, 1700, 2000 + (i* 300) - 100, good, math.pi/2),
	rocketTruck:new(currentPlanet, 1700, 2000 + (i* 300)  - 150, good, math.pi/2),
	rocketTruck:new(currentPlanet, 1700, 2000 + (i* 300)  - 200, good, math.pi/2)
	}, math.pi/2)
end

-- for i=1, 3 do
	-- -- lineFormation.new({
	-- tank:new(currentPlanet, 1650, 2000 + (i* 300), good, math.pi/2)
	-- tank:new(currentPlanet, 1650, 2000 + (i* 300) - 50, good, math.pi/2)
	-- tank:new(currentPlanet, 1650, 2000 + (i* 300) - 100, good, math.pi/2)
	-- tank:new(currentPlanet, 1650, 2000 + (i* 300)  - 150, good, math.pi/2)
	-- tank:new(currentPlanet, 1650, 2000 + (i* 300)  - 200, good, math.pi/2)
	-- -- }, math.pi/2)
-- end


local spawned = 0
local spawnTime = -10
function scenarioUpdate(dt)
	spawnTime = spawnTime + dt
	if spawnTime > 3 and spawned < 180 then
		local i = math.random() * 9
		local f = lineFormation.new({
		tank:new(currentPlanet, 4000, 2000 + (i* 300), bad, -math.pi/2),
		tank:new(currentPlanet, 4000, 2000 + (i* 300) - 50, bad, -math.pi/2),
		tank:new(currentPlanet, 4000, 2000 + (i* 300) - 100, bad, -math.pi/2),
		tank:new(currentPlanet, 4000, 2000 + (i* 300)  - 150, bad, -math.pi/2),
		tank:new(currentPlanet, 4000, 2000 + (i* 300)  - 200, bad, -math.pi/2),
		tank:new(currentPlanet, 4000, 2000 + (i* 300)  - 250, bad, -math.pi/2),
		tank:new(currentPlanet, 4000, 2000 + (i* 300)  - 300, bad, -math.pi/2),
		tank:new(currentPlanet, 4000, 2000 + (i* 300)  - 350, bad, -math.pi/2),
		tank:new(currentPlanet, 4000, 2000 + (i* 300)  - 400, bad, -math.pi/2),
		tank:new(currentPlanet, 4000, 2000 + (i* 300)  - 450, bad, -math.pi/2)
		}, -math.pi/2)
		f:moveTo(0, 2600, false, true)
		spawnTime = 0
		spawned = spawned + 10
	end
end
