planets = {{}}

planet.new(planets[1], false, "Ezagon",{}, 13)

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
cameraX = 0
cameraY = 0
teams = {good, bad}
-- tank:new(100, 2000, 0, good, 0,0,true)
-- shipyard:new(100, 2300, 0, good, 0, 0)
-- metalFactoryTest = metalFactory:new(currentPlanet, 3500, 3000, good)
-- miningTruck:new(currentPlanet, 3000, 3000, good)
-- heavyCruiser:new(currentPlanet, -1000, 0, good, 0)
-- heavyCruiser:new(currentPlanet, 300, 0, bad, 0)
-- miningTruck:new(currentPlanet, 3025, 3000, good)
-- miningTruck:new(currentPlanet, 3050, 3000, good)
-- miningTruck:new(currentPlanet, 3075, 3000, good)
-- miningTruck:new(currentPlanet, 3100, 3000, good)
-- miningTruck:new(currentPlanet, 3125, 3000, good)
-- playerFormation = formation.new({}, player)
function scenarioUpdate(dt)

end