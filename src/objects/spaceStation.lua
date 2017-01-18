
--basic spaceStation thingy
--left over from trading ideas...
spaceStation = {}
local stationShape = {-100, -100, 0, -150, 100, -100, 150, 0, 100, 100, 0, 150, -100, 100, -100, -100}--, -100, -100}
function spaceStation:new(posX, posY, team, cargo)
	local object = {}
	object.parents = {spaceStation}
	object.shape = stationShape
	object.health = 5000
	spaceShip.new(object, posX, posY, 0, team)
	tradingObject.new(object, 500, cargo)
	
	setmetatable(object, { __index = utils.checkParents })
end

function spaceStation:draw() -- temp function should be merged with spaceShip at some point!!!
	love.graphics.push()
	love.graphics.translate(self.body:getX(), self.body:getY())
	love.graphics.rotate(self.body:getAngle())
	love.graphics.setColor(100, 100, 100)
	love.graphics.polygon("fill", 0, 0, unpack(stationShape))
	love.graphics.setColor(255, 255, 255)
	love.graphics.pop()
end

function spaceStation:destroy()

end