local shieldColor = {1,182,240, 255}
local white = {255,255,255, 255}
local clear = {0, 0, 0, 0, 0}
local over = {0, 0, 0, 100}
local pressed = {0, 0, 0, 200}
local blue = {3,3,219, 255}
local green = {1,124,13, 255}
local goodBuildingPlacement = {1,124,13, 100}
local red = {200,0,0, 255}
local badBuildingPlacement = {200, 0, 0, 100}
local yellow = {239,169,0, 255}
local brown = {92, 56 ,0, 255}
local grey = {92, 92, 92, 255}
local black = {30,30,30, 255}

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
local screenHeight = screenHeight
local screenWidth = screenWidth
local universalShortcuts = {
["f10"] = "menu",
-- [" "] = deselect,
["b"] = "build"
}
local selectedShortcuts = {
-- ["a"] = attackMove,
-- ["m"] = move,
}
local buildBar = false

local elements = {
	--MENU
	{
		name = "menu",
		shortcut = "f10",
		text = "menu",
		textColor = blue,
		fill = true,
		showing = true,
		x = screenWidth -62,
		y = screenHeight - 45,
		overColor = grey,
		clickColor = black,
		width  = 60,
		height = 25,
		onClicked = "toggleGroup",
		parameter = "menu"
	},{
		name = "menuBackground",
		fill = true,
		color = blue,
		group = "menu",
		x = screenWidth - 202, --centered
		y = screenHeight - 295,
		width = 200,
		height = 250,
	},{
		name = "close",
		text = "Close",
		group = "menu",
		textColor = blue,
		fill = true,
		x = screenWidth - 190,
		y = screenHeight - 85,
		overColor = grey,
		clickColor = black,
		width  = 180,
		height = 30,
		onClicked = "toggleGroup",
		parameter = "menu"
	},{
		name = "loadGame",
		text = "Load Game",
		group = "menu",
		textColor = blue,
		fill = true,
		x = screenWidth - 190,
		y = screenHeight - 125,
		overColor = grey,
		clickColor = black,
		width  = 180,
		height = 30,
		onClicked = "loadGame",
		-- onClicked = "toggleGroup",
		-- parameter = "loadGame"
	},{
		name = "saveGame",
		text = "Same Game",
		group = "menu",
		textColor = blue,
		fill = true,
		x = screenWidth - 190,
		y = screenHeight - 165,
		overColor = grey,
		clickColor = black,
		width  = 180,
		height = 30,
		onClicked = "saveGame"
		-- onClicked = "toggleGroup",
		-- parameter = "saveGame"
	},{
		name = "options",
		text = "Options",
		group = "menu",
		textColor = blue,
		fill = true,
		x = screenWidth - 190,
		y = screenHeight - 205,
		overColor = grey,
		clickColor = black,
		width  = 180,
		height = 30,
		onClicked = "mainMenu",
	},{
		name = "quitToDesktop",
		text = "Exit to Desktop",
		group = "menu",
		textColor = blue,
		fill = true,
		x = screenWidth - 190,
		y = screenHeight - 245,
		overColor = grey,
		clickColor = black,
		width  = 180,
		height = 30,
		onClicked = "exitGame",
	},{
		name = "mainMenu",
		text = "Main Menu",
		group = "menu",
		textColor = blue,
		fill = true,
		x = screenWidth - 190,
		y = screenHeight - 285,
		overColor = grey,
		clickColor = black,
		width  = 180,
		height = 30,
		onClicked = "mainMenu",
	},
	-- BUILD BAR
	{
		name = "oreMine",
		image = love.graphics.newImage("images/units/unitPics/resourceBuilding.png"),
		imageColor = blue,
		y = screenHeight - 55,
		x = screenWidth - 300,
		width = 50,
		height = 50,
		onClicked = "buildUnit",
		parameter = oreMine,
		color = clear,
		overColor = over,
		clickColor = pressed,
		fill = true,
		group = "buildBar",
		showing = true,
	},{
		name = "miningTruckFactory",
		image = love.graphics.newImage("images/units/unitPics/miningTruckFactoryIcon.png"),
		imageColor = blue,
		y = screenHeight - 55,
		x = screenWidth - 355,
		width = 50,
		height = 50,
		onClicked = "buildUnit",
		parameter = miningTruckFactory,
		color = clear,
		overColor = over,
		clickColor = pressed,
		fill = true,
		group = "buildBar",
		showing = true,
	},
	-- CargoSwitching
	{
		name = "cargo",
		shortcut = "",
		text = "cargo",
		textColor = blue,
		fill = true,
		showing = true,
		x = 10,
		y = screenHeight - 45,
		overColor = grey,
		clickColor = black,
		width  = 60,
		height = 25,
		onClicked = "toggleGroup",
		parameter = "cargo"
	},{
		name = "metalCargo",
		group = "cargo",
		image = love.graphics.newImage("images/gui/metalIcon.png"),
		imageColor = gray,
		y = screenHeight - 75,
		x = 10,
		color = clear,
		overColor = over,
		clickColor = pressed,
		fill = true,
		width = 60,
		height = 30,
		onClicked = "setSelectionCargo",
		parameter = "metal",
	},{
		name = "oreCargo",
		group = "cargo",
		image = love.graphics.newImage("images/gui/oreIcon.png"),
		imageColor = brown,
		y = screenHeight - 110,
		x = 10,
		color = clear,
		overColor = over,
		clickColor = pressed,
		fill = true,
		width = 60,
		height = 30,
		onClicked = "setSelectionCargo",
		parameter = "ore",
	},

}
local inputMap = {
{349, 83, 349+60, 83+30, "metalIcon"},
{349, 49, 349+60, 49+30,  "oreIcon"},
}
function gui.load()
	
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
	for i=#currentPlanet.units, 1, -1 do
		currentPlanet.units[i]:endDeath()
	end
	local currentUnit = 1
	for line in file:lines() do --supposedly this closes the file (in the defualt lua implemntation at least)
		
		local point = string.find(line, ":")
		local thing = string.sub(line, 1, point)
		local data = string.sub(line, point, -1)
		print(data)
		if thing == "seed:" then
			print("seed: '"..data.."'")
			scene = game:new("src/scenarios/emptyPlanet", tonumber(string.sub(data, 2, -1)))
		elseif thing == "unit:" then
			local object = {}
			local unitClass = string.sub(data, 2, -1)
			print(unitClass)
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

function gui.mouseMoved()
	local mx, my = mx, my
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
			if (e.showing and e.onClicked) and ((e.x < mx and e.y < my) and ((e.x + e.width) > mx and (e.y + e.height) > my)) then -- mouse is over this element
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
		elseif selection[1].weapons[1] then --show attack ai options
			
		end
	else
		gui.hideGroup("cargo")
	end
end

function gui.mousepressed(mx, my, button)
	if not (button == "l") then return end
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
		if (e.onClicked and e.showing) and ((e.x < mx and e.y < my) and (e.x + e.width > mx and e.y + e.height > my)) then -- clicked on this element
			e.down = true
			pressedElement = e
			return true
		end
	end
	return false
end
function gui.mousereleased(mx, my, button)
	if not button == "l" then return end
	local e = pressedElement
	if e then
		if (e.x < mx and e.y < my) and (e.x + e.width > mx and e.y + e.height > my) then -- clicked on this element
			e.down = false
			gui[e.onClicked](e.parameter)
		else
			e.down = false
			pressedElement = false
		end
	end
end

function gui.keypressed(key) 
	if key == " " then building = false end
end

function gui.drawBuilding() --draw a building silohette where we are going to build it
	if buildingPlaceable then
		love.graphics.setColor(goodBuildingPlacement) 
	else
		love.graphics.setColor(badBuildingPlacement)
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
					if e.imageColor then love.graphics.setColor(e.imageColor) else love.graphics.setColor(white) end
					love.graphics.draw(e.image, e.x, e.y)
				end
				if (e.clickColor and e.down) then
					love.graphics.setColor(e.clickColor)
				elseif (e.overColor and e.mouseOver) then
					love.graphics.setColor(e.overColor)
				else
					love.graphics.setColor(e.color or white)
				end
				
				if e.fill then
					love.graphics.rectangle("fill", e.x, e.y, e.width, e.height)
				end
				if e.text then
					if e.textColor then love.graphics.setColor(e.textColor) end
					love.graphics.printf(e.text, e.x, e.y, e.width, "center")
				end
				
			end
		end
	end
	love.graphics.setColor(white)
	love.graphics.pop()
end
