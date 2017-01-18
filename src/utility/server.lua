server = {}
require 'enet'
local clients = {}
function server:new()
	self.host = enet.host_create("localhost:6789")

end
local updateTime = 0
function server.replaceDecimalPoints(str)
	local start, finish = str:find( ".", 1, true)
	while start do
		str[start] = "&"
		start, finish = str:find( ".", 1, true)
	end
	return str
end
function server:update(dt)
	local event = self.host:service()
	while event do
		if event.type == "receive" then
			print("Got message: ", event.data, tostring(event.peer))
			event.peer:send("pong:"..1713)
			love.math.setRandomSeed(1713)
			scene = game:new("src/scenarios/holdTheLine")
			-- event.peer:send("planet:"..planet.pack(currentPlanet)
		elseif event.type == "connect" then
			print(tostring(event.peer) .. " connected.")
			table.insert(clients, event.peer)
		elseif event.type == "disconnect" then
			print(tostring(event.peer) .. " disconnected.")
			utils.removeFromTable(clients, event.peer)
		end
		event = self.host:service()
	end
	updateTime = updateTime + dt
	if updateTime > 1 and clients[1]then
		updateTime = 0
		local packet = "update:"
		for i=1, #currentPlanet.units do
			local str = currentPlanet.units[i]:pack()
			packet = packet..str..":"
		end
		clients[1]:send(packet)
	end
end
