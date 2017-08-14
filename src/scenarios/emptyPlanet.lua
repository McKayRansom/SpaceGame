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
function scenarioUpdate(dt)

end
