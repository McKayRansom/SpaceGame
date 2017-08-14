local utf8 = require("utf8")

gui = {}
-- local playerGui = {
	-- {color = blue, draw = "rectangle", percent = "shields", length = powerBarLength, height = powerBarHeight, x = 346, y = 156},
	-- {color = blue, draw = "rectangle", percent = "shields", length = powerBarLength, height = powerBarHeight, x = 346, y = 156},

-- }
-- local rtsGui = {
-- }

local powerX
local powerY
local shieldPower = {594, 153}
local enginePower = {622,153}
local weaponPower = {650, 153}
local arrow = {506,102}
local healthBarWidth = 33
local healthBarHeight = -111
local shields = {346,156}
local structure = {379,156}
local powerBarLength = 12
local powerBarHeight = -122
local metalIconPos = {349, 83}
local oreIconPos = { 349, 49}

local powerImage, dashboardImage, arrowImage, minimapImage, instrumentsImage
local metalIcon, oreIcon
local scaleX, scaleY

local elements = {};

local inputMap = {
{349, 83, 349+60, 83+30, "metalIcon"},
{349, 49, 349+60, 49+30,  "oreIcon"},
}
function gui.load(which)
	elements = gui[which];
	powerImage = love.graphics.newImage("images/gui/uiPower.png")
	dashboardImage = love.graphics.newImage("images/gui/dashboard.png")
	instrumentsImage = love.graphics.newImage("images/gui/instruments.png")
	arrowImage = love.graphics.newImage("images/gui/arrow.png")
	minimapImage = love.graphics.newImage("images/gui/minimap.png")
	metalIcon = love.graphics.newImage("images/gui/metalIcon.png")
	oreIcon = love.graphics.newImage("images/gui/oreIcon.png")

	powerX = screenWidth - powerImage:getWidth()
	powerY = screenHeight - powerImage:getHeight()

	-- gui.resize()
	clickHandler.addInputMap(inputMap, game)
end

-- function gui.resize()
	-- scaleX = screenResolution[x]/1920
	-- scaleY = screenResolution[y]/1080
	-- for i=1, #inputMap do
		-- for j=1, 4, 2 do
			-- inputMap[i][j] = inputMap[i][j] * scaleX
			-- inputMap[i][j+1] = (inputMap[i][j+1] + screenHeight -180) * scaleY
		-- end
	-- end
-- end
function gui.mainMenu()
	--goto main menu screen
end
--set the cargo of cargoTrucks
function gui.setSelectionCargo(cargo)
	game.setSelectionCargo(cargo)
end


function gui.exitGame()
	love.event.quit()
end

local buildingPlaceable = false
local building = false
function gui.buildUnit(unit)
	building = unit
	buildingPlaceable = false
end

function gui.saveGame()
	print("savingGame")
	local file = love.filesystem.newFile("save.txt")
	file:open("w")
	file:write("seed:"..scene.seed.."\r\n")
	for i=1, #currentPlanet.units do
		if currentPlanet.units[i].unitClass then
			file:write("unit:"..currentPlanet.units[i].unitClass.."\r\n")
		end
	end

	for i=1, #currentPlanet.units do
		local str = currentPlanet.units[i]:pack()
		file:write("update:"..str.."\r\n")
	end

	file:close()
end

function gui.loadGame()
	local file = love.filesystem.newFile("save.txt")
	file:open("r")
	if (currentPlanet) then
		for i=#currentPlanet.units, 1, -1 do
			currentPlanet.units[i]:endDeath()
		end
	end
	local currentUnit = 1
	for line in file:lines() do --supposedly this closes the file (in the defualt lua implemntation at least)

		local point = string.find(line, ":")
		local thing = string.sub(line, 1, point)
		local data = string.sub(line, point, -1)
		--print(data)
		if thing == "seed:" then
			--print("seed: '"..data.."'")
			scene = game:new("src/scenarios/emptyPlanet", tonumber(string.sub(data, 2, -1)))
		elseif thing == "unit:" then
			local object = {}
			local unitClass = string.sub(data, 2, -1)
			--print(unitClass)
			_G[unitClass]:new(currentPlanet, 0, 0, teams[1])
		elseif thing == "update:" then

			currentPlanet.units[currentUnit]:unpack(data)
			currentUnit = currentUnit + 1
		end

	end
end

function gui.toggleGroup(group)
	for i=1, #elements do
		if elements[i].group == group then
			elements[i].showing = not elements[i].showing
		end
	end
end
function gui.showGroup(group)
	for i=1, #elements do
		if elements[i].group == group then
			elements[i].showing = true
		end
	end
end
function gui.hideGroup(group)
	for i=1, #elements do
		if elements[i].group == group then
			elements[i].showing = false
		end
	end
end

local overElement = false
local pressedElement = false
local oreNode = false
local oreNodePos

local function callback()
	buildingPlaceable = false
end

function gui.mouseMoved(mx, my)
	if building then
		local dx, dy = building.width/2, building.height/2
		local x, y = worldMX, worldMY
		if building.resourceProducer then
			oreNode = utils.getClosest(x, y, currentPlanet.resources, 300)
			if oreNode then
				x, y = oreNode[1], oreNode[2]
				oreNodePos = {x, y}
			else
				oreNodePos = false
				buildingPlaceable = false
				return
			end
		end
		buildingPlaceable = true
		currentPlanet.world:queryBoundingBox( x - dx, y - dy, x + dx, y + dy, callback)
	end
	if overElement then
		local e = overElement
		if not((e.x < mx and e.y < my) and ((e.x + e.width) > mx and (e.y + e.height) > my)) then --mouse is not over this element
			e.mouseOver = false
			overElement = false
		end
	else
		for i=1, #elements do
			local e = elements[i]
			if (e.showing and (e.onClicked or e.overColor)) and ((e.x < mx and e.y < my) and ((e.x + e.width) > mx and (e.y + e.height) > my)) then -- mouse is over this element
				overElement = e
				e.mouseOver = true
			end
		end
	end
end

function gui.updateSelection(selection)
	if selection[1] then
		if selection[1].cargoTruck then -- show cargo options
			gui.showGroup("cargo")
		--elseif selection[1].weapons[1] then --show attack ai options

		end
	else
		gui.hideGroup("cargo")
	end
end

function gui.mousepressed(mx, my, button)
	if not (button == 1) then return end
	if building then
		if buildingPlaceable then
			if building.resourceProducer and oreNode then
				building:new(currentPlanet, oreNode[1], oreNode[2], teams[1])
			else
				local mx, my = worldMX, worldMY
				building:new(currentPlanet, mx, my, teams[1])
			end
			if not love.keyboard.isDown("lshift") then
				building = false
			end
		end
		return true
	end
	for i=1, #elements do
		local e = elements[i]
		if ((e.onClicked or e.textBox) and e.showing) and ((e.x < mx and e.y < my) and (e.x + e.width > mx and e.y + e.height > my)) then -- clicked on this element
			e.down = true
			pressedElement = e
			return true
		end
	end
	return false
end
function gui.mousereleased(mx, my, button)
	if not button == 1 then return end
	local e = pressedElement
	if e then
		if (e.x < mx and e.y < my) and (e.x + e.width > mx and e.y + e.height > my) then -- clicked on this element
			e.down = false
			if e.textBox then
				print("selected textBox")
				gui.textBox = e;
				gui.text = "Type stuff"
			else
				e.onClicked();
			end
		else
			e.down = false
			gui.textBox = false
			pressedElement = false
		end
	end
end

function gui.keypressed(key)
	if gui.textBox then
		if key == "return" then
			gui.textBox.onFinished(gui.text);
			gui.text = false
			gui.textBox = false
		elseif key == "backspace" then
			local byteoffset = utf8.offset(gui.text, -1)
      if byteoffset then
          -- remove the last UTF-8 character.
          -- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
          gui.text = string.sub(gui.text, 1, byteoffset - 1)
      end
		end
		return true;
	end
	if key == " " then building = false end
end

function gui.textinput(t)
	if gui.textBox then gui.text = gui.text..t end
end

function gui.drawBuilding() --draw a building silohette where we are going to build it
	if buildingPlaceable then
		love.graphics.setColor(colors.goodBuildingPlacement)
	else
		love.graphics.setColor(colors.badBuildingPlacement)
	end
	if building.resourceProducer and oreNodePos then
		love.graphics.push()
		love.graphics.scale(zoom, zoom)
		love.graphics.translate(viewX, viewY)
		love.graphics.line(worldMX, worldMY, oreNodePos[1], oreNodePos[2])
		love.graphics.draw(building.image, oreNodePos[1], oreNodePos[2], -math.pi/2, 1, 1, building.width/2, building.height/2)
		love.graphics.pop()
		return
	end
	love.graphics.draw(building.image, mx, my, -math.pi/2, zoom, zoom, building.width/2, building.height/2)
end

function gui.draw()
	love.graphics.push()

	love.graphics.scale(scaleX, scaleY)
	if player then -- player control mode
		love.graphics.translate(500, screenHeight -180)
		love.graphics.draw(dashboardImage)

		love.graphics.setColor(blue)
		love.graphics.rectangle('fill', shieldPower[1], shieldPower[2], powerBarLength, powerBarHeight * player.shieldPowerPercent)
		love.graphics.rectangle('fill', enginePower[1], enginePower[2], powerBarLength, powerBarHeight * player.enginePowerPercent)
		love.graphics.rectangle('fill', weaponPower[1], weaponPower[2], powerBarLength, powerBarHeight * player.weaponPowerPercent)
		love.graphics.setColor(shieldColor)
		if player.shields then
		love.graphics.rectangle('fill', shields[1], shields[2], healthBarWidth, healthBarHeight * (player.shields/player.maxShields))
		end
		local health = player.health/player.maxHealth
		if health < .33 then
			love.graphics.setColor(red)
		elseif health < .66 then
			love.graphics.setColor(yellow)
		else
			love.graphics.setColor(green)
		end
		love.graphics.rectangle('fill',  structure[1], structure[2], healthBarWidth, healthBarHeight * health)
		love.graphics.setColor(white)
		love.graphics.draw(instrumentsImage)
		love.graphics.draw(arrowImage, arrow[1], arrow[2], player.body:getAngle(),1,1,100,100)
		--love.graphics.draw(guiImages.minimap,
	else --rts control mode
		if building then
			gui.drawBuilding()
		end
		for i=1, #elements do
			local e = elements[i]
			if e.showing then
				if e.image then
					if e.imageColor then love.graphics.setColor(e.imageColor) else love.graphics.setColor(colors.white) end
					love.graphics.draw(e.image, e.x, e.y)
				end
				if (e.clickColor and e.down) then
					love.graphics.setColor(e.clickColor)
				elseif (e.overColor and e.mouseOver) then
					love.graphics.setColor(e.overColor)
				else
					love.graphics.setColor(e.color or colors.white)
				end

				if e.fill then
					love.graphics.rectangle("fill", e.x, e.y, e.width, e.height)
				elseif e.outline then
					love.graphics.rectangle("line", e.x, e.y, e.width, e.height)
				end
				if e.text or e.list then
					if e.textColor then love.graphics.setColor(e.textColor) end
					if (e.list) then
						for item=1, #e.list do
							love.graphics.printf(e.list[item], e.x, e.y + (e.spacing * item), e.width, "center");
						end
					else
						love.graphics.printf(e.text, e.x, e.y, e.width, "center")
					end
				end

			end
		end
		if gui.textBox then
			love.graphics.setColor(gui.textBox.textColor)
			love.graphics.printf(gui.text, gui.textBox.x, gui.textBox.y, gui.textBox.width)
		end
	end
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.pop()
end
