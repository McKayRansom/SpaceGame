--my own physics object
--emulates a love.physics body as much as possible but has no collisions and hopefully is better on perfomance?
--currently used for projectiles and fighters

physicsObject = {}
x = 1 --this is true just for reference :) (and probably some random places use it, should just replace with numbers for perfomance
y = 2

--makes new physics object
function physicsObject.new(o, useLovePhysics)
	local o = o or {}
	o.a = {0,0}
	o.v = {0,0}
	o.p = {0,0}
	o.angle = 0
	o.angularV = 0
	o.angularA = 0
	o.m = 10
	o.i = 10
	
	setmetatable(o, { __index = physicsObject })
	return o
end
--gets velocity magnitude
function physicsObject:getVelocityMagnitude()
	return math.sqrt(self.v[1]^2 + self.v[2]^2)
end

function physicsObject:getImpulse() --old momentum
	return self.v[1] * self.m, self.v[2] * self.m
end

function physicsObject:getPosition()
	return self.p[1], self.p[2]
end

function physicsObject:getX()
	return self.p[1]
end

function physicsObject:getY()
	return self.p[2]
end

function physicsObject:getAngle()
	return self.angle
end

function physicsObject:getLinearVelocity()
	return self.v[1], self.v[2]
end

function physicsObject:getAngularVelocity()
	return self.angularV
end

function physicsObject:getKineticEnergy()
	return .5 * self:getVelocityMagnitude()^2 * self.m
end

function physicsObject:getMass()
	return self.m
end

function physicsObject:getInertia()
	return self.i
end

function physicsObject:setPosition(x, y)
	self.p = {x, y}
end

function physicsObject:setAngle(angle)
	self.angle = angle
end

function physicsObject:applyLinearImpulse()
	--blank for now :( here for compatability with love.physics bodies
end

function physicsObject:setLinearDamping()
	--also blank for now :( just here for compatibility
end

function physicsObject:setLinearVelocity(vx, vy)
	self.v = {vx, vy}
end
--updates position/velocity
function physicsObject:updatePhysics(t)
	self.v = {self.v[1] +self.a[1] * t, self.v[2] + self.a[2] * t}
	self.p = {self.p[1] +self.v[1] * t, self.p[2] + self.v[2] * t}
	self.angularV = self.angularV + self.angularA * t
	self.angle = self.angle +self.angularV * t
	self.a = {0,0}
	self.angularA = 0
end
--should be called when a force
function physicsObject:applyForce(fx, fy)
	self.a[1] = self.a[1] + fx/self.m
	self.a[2] = self.a[2] + fy/self.m
end

function physicsObject:destroy()
	self.destroyed = true
end

function physicsObject:isDestroyed()
	return self.destroyed
end

function physicsObject:applyTorque(magnitude)
	local acceleration = magnitude / self.i
	self.angularA = self.angularA + acceleration
end

function physicsObject:getPointVelocity(px, py)
	local dist = math.sqrt(px^2 + py^2)
	local velocity = dist *  self.angularV
	local angle = utils.getAngle(px, py)
	local  cosine = math.cos(angle)
	local sine = math.sin(angle)
	return self.v[1] + (sine * velocity), self.v[2] + (cosine * velocity)
end

function physicsObject:predictedPosition(t) -- very handy but still an aproximation (ignores acceleration among other things) still really good actually
	return self.p[1] + self.v[1] * t, self.p[2] + self.v[2] * t
end