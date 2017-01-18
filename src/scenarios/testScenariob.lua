--Test Scenario
physicsWorld = love.physics.newWorld(0, 0, true)

local f = {
-- lightCruiser:new(850, 300, 0, "player"),
-- lightCruiser:new(650, 300, 0, "player"),
}
player = jeep:new(900, 500, 0, "player", 0, -200, true)
for i=1,5 do
	tank:new(40, 300 + (i*10), 0, "enemy", 0, 0, false)
end

-- lightCruiser:new(700, 500, 0, "player")
playerFormation = formation.new(f, player)

function scenarioUpdate(dt)
	if player.body:getX() < 0 then
	display[2] = "WIN"
	print("WINWINWINWINWIN")
	end
end