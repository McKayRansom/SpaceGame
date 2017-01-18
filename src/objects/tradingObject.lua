tradingObject = {}
tradingObjects = {}

function tradingObject:new(tradingDistance, cargo) --assumes attached to a physics body
	self.tradingDistance = tradingDistance
	self.cargo = cargo
	self.parents = self.parents or {}
	self.parents[#self.parents + 1] = tradingObject
	table.insert(tradingObjects, self)
end

function tradingObject:destroy()

end

function tradingObject:isInTradingRange(posX, posY)
	local dist = utils.getDistance(posX, posY, self.body:getX(), self.body:getY())
	if dist < self.tradingDistance then
		print("inTradingRange")
		return true
	else
		print("notInTradingRange")
		return false
	end
end