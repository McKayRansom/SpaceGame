tradingScene = {}
local white = {255,255,255}
local grey = {78, 78, 78}
local boxX = screenWidth * .25
local boxY = screenHeight * .25
local boxWidth = screenWidth * .5
local boxHeight = screenHeight * .5

function tradingScene.new(object)
	local self = {}
	self.entries = object.cargo
	self.scroll = 1
	self.length = 10
	if #self.entries < 10 then
		self.length = #self.entries
	end
	self.parents = {tradingScene}
	setmetatable(self, { __index = utils.checkParents })
	return self
end

function tradingScene:draw()
	love.graphics.setColor(grey)
	love.graphics.rectangle('fill', boxX, boxY, boxWidth, boxHeight)
	-- love.graphics.rectangle('fill', enginePower[1], enginePower[2], powerBarLength, powerBarHeight * player.enginePowerPercent)
	-- love.graphics.rectangle('fill', weaponPower[1], weaponPower[2], powerBarLength, powerBarHeight * player.weaponPowerPercent)
	love.graphics.setColor(white)
	local dist = 0
	-- for key, value in pairs(self.entries[1]) do
		-- love.graphics.print(key, boxX + 65 + dist, boxY + 50)
		-- dist = dist + 60
	-- end
	for name, entry in pairs(self.entries) do
		dist = 0
		for key, value in pairs(entry) do
			love.graphics.print(value, boxX + 56 + dist, boxY + 80 + ((i-self.scroll) * 18))
			dist = dist + 60
		end
		if self.entries[i].quantity > 0 then
		love.graphics.print("buy", boxX + 56 + dist, boxY + 80 + ((i-self.scroll) * 18))
	end
end

function tradingScene:update(dt)

end

function tradingScene:mousepressed(mx, my, button)
	if button == 1 then

	end
end

function tradingScene:keypressed(key, u)
	if key == "escape" then
		--exit
		return true
	end
end
