utils = {}

function utils.checkParents(o, key)
	if o.parents then
		for i=1,#o.parents do
			if o.parents[i][key] then
				return o.parents[i][key]
			end
		end
	end
end

function utils.initParents(o)
	for i=1,#o.parents do
		o.parents[i].init(o)
	end
end

function utils.pack(...)
	local varArg = {...}
	local str = ""
	for i=1, #varArg do
		str = str.." "..tostring(varArg[i])
	end
	return str
end

function utils.unpack(packedString)
	
end

-- function new(o)
	-- local object = {}
	-- o.init(object)
	-- utils.initParents(object)
	-- return object
-- end

function utils.removeFromTable(t, object)
	for i=1,#t do
		if t[i] == object then
			table.remove(t, i)
			return
		end
	end
end

function utils.getAngle(dx, dy)
	return math.atan2(dy,dx)
	
end

function utils.getActualCoords(x1, y1, angle1, x2, y2, angle2) --2 is all relative
	local angle2 = angle2 or utils.getAngle(x2,y2)
	local dist = math.sqrt((x2^2) + (y2 ^2))
	local angle = angle1 + angle2
	local dx = math.cos(angle) * dist
	local dy = math.sin(angle) * dist
	return x1 -dx, y1 - dy
end

function utils.getDistance(x1, y1, x2, y2)
	if not x2 then
		return math.sqrt((x1*x1) + (y1 * y1))
	end
	return math.sqrt((x1-x2)^2 + (y1 - y2)^2)
end

function utils.getRoughDistance(x1, y1, x2, y2)
	return math.abs(x1-x2) + math.abs(y1-y2)
end

function utils.withinRectangle(x1, y1, x2, y2, width, height)
	return math.abs(x1-x2) < width and math.abs(y1-y2) < height
end


function utils.getRelativeCoords(x1, y1, x2, y2, angle1)
	local dx, dy = x2 - x1, y2-y1
	local angle2 = utils.getAngle(dx,dy)
	local dist = math.sqrt(dy^2 + dx ^ 2)
	local angle = angle2-angle1
	return math.cos(angle) * dist, math.sin(angle) * dist
end

function utils.limitAngle(angle) --change angle to between math.pi and -math.pi
	angle = angle%(2*math.pi)
	if angle < -math.pi then
		angle = (angle + 2*math.pi) 
	elseif angle > math.pi then
		angle = (angle - 2*math.pi)
	end
	return angle
end

function utils.getClosest(x, y, objects, minDist) --minDist is optional, default is 1000 we will not return anything below this distance away
	local list = {}
	local closestObject = false
	local closestDistance = minDist or 1000
	for i=1, #objects do -- look for people who have our cargo
		local o = objects[i]
		local distance = utils.getDistance(x, y, o[1] or o.body:getX(), o[2] or o.body:getY())
		if distance < closestDistance then
			closestObject = objects[i]
			closestDistance = distance
		end
	end
	if closestObject then return closestObject end
	return false
end

function limit(low, high, num)
	if num > high then return high end
	if num < low then return low end
	return num
end