require 'enet'
client = {}
function client:new()
	self.host = enet.host_create()
	self.server = self.host:connect("localhost:6789")
	
end
local updateTime = 0

function client:update(dt)
	local event = self.host:service()
	while event do
		if event.type == "receive" then
			print("Got message")--, event.data, tostring(event.peer))
			if string.sub(event.data, 1, 7) == "update:" then
				client:handlePacket(event.data)
			else
				event.peer:send("pong:")
				local seed = string.sub(event.data, 6)
				print("seed: "..seed)
				love.math.setRandomSeed(tonumber(seed))
				scene = game:new("src/scenarios/holdTheLine")
			end
			
			
		elseif event.type == "connect" then
			print(tostring(event.peer) .. " connected.")
		elseif event.type == "disconnect" then
			print(tostring(event.peer) .. " disconnected.")
		end
		event = self.host:service()
	end
end

function client:handlePacket(packedString)
	local point = string.find(packedString, ":")
	packedString = string.sub(packedString, point+1)
	-- print("packedString is: "..packedString)
	point = string.find(packedString, ":")
	-- print("nextPoint is: "..point)
	local item = 1
	local unit = currentPlanet.units[item]
	while point and unit do
		subString = string.sub(packedString, 0, point + 1)
		-- print("decodingSubstring: "..subString)
		
		
		
		unit:unpack(subString)
		point = string.find(subString, ":")
		packedString = string.sub(packedString, point +1)
		-- print("packedString is: "..packedString)
		point = string.find(packedString, ":")
		item = item + 1
		unit = currentPlanet.units[item]
	end
	return objects
end