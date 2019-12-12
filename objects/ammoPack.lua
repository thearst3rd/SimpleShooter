-- Ammo pack

local RADIUS = 15
local BOX_RADIUS = 17
local ACTIVE_COOLDOWN_TIME = 5 	-- seconds

-- Setup

objects.ammoPack = {}
local ammoPack = objects.ammoPack
ammoPack.__index = ammoPack


-- Main callbacks

function ammoPack.new(x, y)
	local self = {}
	setmetatable(self, ammoPack)
	
	self.x = x or 50
	self.y = y or 50
	
	self.active = true
	self.activeCooldown = 0
	self.maxActiveCooldown = ACTIVE_COOLDOWN_TIME
	
	self.radius = RADIUS
	
	self.spin = love.math.random() * 2 * math.pi
	
	return self
end

function ammoPack:update(dt)
	if self.active then
		self.spin = self.spin + dt
		if self.spin > 2 * math.pi then
			self.spin = self.spin - 2 * math.pi
		end
	else
		self.activeCooldown = self.activeCooldown - dt
		if self.activeCooldown <= 0 then
			self.active = true
			self.activeCooldown = 0
		end
	end
end

function ammoPack:draw()
	if self.active then
		love.graphics.setColor(0.16, 0.09, 0)
		love.graphics.circle("fill", self.x, self.y, self.radius)
		love.graphics.setColor(0, 0, 0)
		love.graphics.circle("line", self.x, self.y, self.radius)
		
		love.graphics.setColor(0.6, 0.47, 0.31)
		local xoff = BOX_RADIUS * math.cos(self.spin)
		local yoff = BOX_RADIUS * math.sin(self.spin)
		love.graphics.polygon("fill", self.x + xoff, self.y + yoff,
			self.x + yoff, self.y - xoff,
			self.x - xoff, self.y - yoff,
			self.x - yoff, self.y + xoff)
		love.graphics.setColor(0, 0, 0)
		love.graphics.polygon("line", self.x + xoff, self.y + yoff,
			self.x + yoff, self.y - xoff,
			self.x - xoff, self.y - yoff,
			self.x - yoff, self.y + xoff)
	end
end
