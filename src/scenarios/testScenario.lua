planets = {{},{},{}}
planet.new(planets[1], 1000, 2000, false, "Ezagon",
	{
	{p = {6000, 6000}, destination = planets[2]},
	{p = {0, 0}, destination = planets[3]}
	}, 3)
planet.new(planets[2], 1500, 2000, false, "Casina Prime",
	{
	{p = {-1000, -1000}, destination = planets[1]}
	}, 3)
planet.new(planets[3], 1750, 1750, false, "Doengon",
	{
	{p = {6000, 6000}, destination = planets[1]},
	}, 3)
currentPlanet = planets[1]
planets[1].good = {};
planets[1].bad = {};
--planets[3].good = true
--planets[3].good = {};
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
teams = {good, bad}
local timer = false

shuttle:new(currentPlanet, 0, 1900, good, 0, 0, 0)
heavyCruiser:new(currentPlanet, 0, 2000, good, 0,0,0)
heavyCruiser:new(currentPlanet, -200, 2000, good, 0,0,0)
heavyCruiser:new(currentPlanet, -400, 2000, good, 0,0,0)
heavyCruiser:new(currentPlanet, -400, 2000, good, 0,0,0)
-- fighter:new(currentPlanet, -200, 2000, good, 0, 0,0)
-- fighter:new(currentPlanet, -400, 2500,good, 0, 0,0)
-- fighter:new(currentPlanet, -500, 2500, good, 0, 0,0)
-- fighter:new(currentPlanet, -600, 2500, good, 0, 0,0)
-- fighter:new(currentPlanet, -500, 2900, good, 0, 0,0)
-- fighter:new(currentPlanet, -100, 2900, good, 0, 0,0)
-- fighter:new(currentPlanet, -000, 2500, good, 0, 0,0)
-- fighter:new(currentPlanet, -50, 2500, good, 0, 0,0)
-- fighter:new(currentPlanet, -60, 2000, good, 0, 0,0)
-- fighter:new(currentPlanet, -75, 2000, good, 0, 0,0)
-- fighter:new(currentPlanet, -82, 1800, good, 0, 0,0)
-- fighter:new(currentPlanet, -300, 1800, good, 0, 0,0)
-- player = heavyCruiser:new(currentPlanet, 100, 2000, good, 0,0,0)
-- lightCruiser:new(100, 2500, 0, good, 0,0,false)
-- lightCruiser:new(currentPlanet, -250, 2500, bad, 0, 0,0)
-- lightCruiser:new(currentPlanet, -150, 2400, bad, 0, 0,0)
-- lightCruiser:new(currentPlanet, -250, 2300, bad, 0,0,0)
lightCruiser:new(currentPlanet, -150, 2600, bad, 0,0,0)
lightCruiser:new(currentPlanet, -250, 2700, bad, 0,0,0)
lightCruiser:new(currentPlanet, -150, 2700, bad, 0,0,0)
lightCruiser:new(currentPlanet, -250, 2700, bad, 0,0,0)
lightCruiser:new(currentPlanet, -150, 2700, bad, 0,0,0)
-- local a1 = resourceBuilding:new(currentPlanet, 3000, 2000, 0, good, 0, 0, false)
-- local a2 = resourceBuilding:new(currentPlanet, 2500, 2000, 0, good, 0, 0, false)
-- local a3 = resourceBuilding:new(currentPlanet, 2000, 2000, 0, good, 0, 0, false)
-- local b = tankFactory:new(2500, 2700, 0, good, 0, 0, false)
-- miningTruck:new(2950, 2800, 0, good, 0, 0, false, {a1}, {b})
-- miningTruck:new(2900, 2800, 0, good, 0, 0, false, {a2}, {b})
-- miningTruck:new(2850, 2800, 0, good, 0, 0, false, {a3}, {b})
-- lightCruiser:new(300, 1700, 0, "player", 0, 0, false)
-- lightCruiser:new(500, 1700, 0, "player", 0, 0, false)
-- lightCruiser:new(500, 800, math.pi/2, "enemy", 0, 0, false)
-- for j=1,1 do
-- lineFormation.new({}, -math.pi/2)
-- for i=1,15 do
	-- local dude = tank:new(3200, 2200 + (i*50), -math.pi/2, good, 0, 0, false)
	-- dude.formation = formations[1]
	-- table.insert(formations[1].units, dude)
	-- --dude.destination = {2600, 2800}
	-- --dude.isAttackMove = true
-- end
-- local c = enemySpawner:new(6000, 2500, math.pi/2, bad, 0, 0, false)
-- c.destination = {2500, 2700}
-- end

-- for j=1, 2 do
	-- lineFormation.new({}, -math.pi/2)
-- for i=1, 20 do
	-- local dude = tank:new(5400 + 100 * j, 2500 + (i*50), -math.pi/2, good, 0, 0, false)
	-- dude.formation = formations[j]
	-- table.insert(formations[j].units, dude)
-- end
-- end
-- for j=3, 4 do
	-- lineFormation.new({}, math.pi/2)
-- for i=1, 20 do
	-- local dude = tank:new(3000 + 100 * j, 3600 - (i*50), math.pi/2, bad, 0, 0, false)
	-- dude.formation = formations[j]
	-- table.insert(formations[j].units, dude)
-- end
-- end
-- local f = {
 -- -- tank:new(5700, 3100, -math.pi/2, good, 0, 0, false),
 -- -- tank:new(5700, 2900, -math.pi/2, good, 0, 0, false)
-- }
-- miningTruck:new(5800, 2775, 0, good, 0, 0, true)
-- controlGroups["1"] = formations[3].units
-- controlGroups["2"] = formations[4].units
-- controlGroups["3"] = {}
-- lineFormation.new({
-- rocketTruck:new(5650, 2800, -math.pi/2, good, 0, 0, false)
-- rocketTruck:new(5650, 2850, -math.pi/2, good, 0, 0, false)
-- rocketTruck:new(5650, 2900, -math.pi/2, good, 0, 0, false)
-- rocketTruck:new(5650, 2950, -math.pi/2, good, 0, 0, false)
-- }, -math.pi/2)
-- -- tankFactory:new(5500, 2200, math.pi/2, good, 0, 0, true)
-- -- lightCruiser:new(6500, 2200, -math.pi/2, bad, 0, 0, true)
-- ammo1 = ammoTruck:new(5700, 2800, -math.pi/2, good, 0, 0, false)
-- ammo1.destinations = {ammoUsers[1]}
-- ammo2 = ammoTruck:new(5700, 2850, -math.pi/2, good, 0, 0, false)
-- ammo2.destinations = {ammoUsers[2]}
-- ammo3 = ammoTruck:new(5700, 2900, -math.pi/2, good, 0, 0, false)
-- ammo3.destinations = {ammoUsers[3]}
-- ammo4 = ammoTruck:new(5700, 2950, -math.pi/2, good, 0, 0, false)
-- ammo4.destinations = {ammoUsers[4]}

-- player = lightCruiser:new(6500, 3000, -math.pi/2, good, 0, 0, true)
-- player = lightCruiser:new(7000, 3000, math.pi/2, bad, 0, 0, true)
-- for j=5, 5 do
	-- lineFormation.new({}, math.pi/2)
-- for i=1, 5 do
	-- local dude = lightCruiser:new(7000, 4200 - (i*200), math.pi/2, bad, 0, 0, false)
	-- dude.formation = formations[j]
	-- table.insert(formations[j].units, dude)
-- end
-- end

-- playerFormation = formation.new({}, player)
function scenarioUpdate(dt)
	-- if objective.dead and not timer then
		-- display[4] = "WIN"
		-- print("WINWINWINWINWIN")
		-- timer = 10
	-- end
	-- display[4] = tostring(timer)
	-- if timer then
		-- timer  = timer-dt
		-- if timer < 0 then
			-- print("newSCENE: SCENARIOB")
			-- scene:destroy()
			-- physicsWorld:destroy()
			-- scene = gameScene:new("src/scenarios/testScenariob")
		-- end
	-- end
end
