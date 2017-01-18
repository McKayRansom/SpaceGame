--Test Scenario
physicsWorld = love.physics.newWorld(0, 0, true)
local timer = false
local f = {
-- lightCruiser:new(850, 300, 0, "player"),
-- lightCruiser:new(650, 300, 0, "player"),
}
player = lightCruiser:new(900, 1700, 0, "player", 0, 0, true)
player.cargo = {}
player.money = 1000
station1 = spaceStation:new(1000, 1900, "player", {{name = "food", price = 100, amount = 10}, {name = "guns", price = 200, amount = 0}})
station2 = spaceStation:new(0, 0, "player", {{name = "food", price = 200, amount = 0}, {name = "guns", price = 100, amount = 20}})


-- lightCruiser:new(700, 500, 0, "player")
playerFormation = formation.new(f, player)
function scenarioUpdate(dt)

end