-- The bullet

local RADIUS = 6
local MOVE_SPEED = 1000


-- Setup

objects.bullet = {}
local bullet = objects.bullet
bullet.__index = bullet


-- Main callbacks

function bullet.new(owner, x, y, dir)
	local self = {}
	setmetatable(self, bullet)
	
	self.owner = owner
	self.x = x or 150
	self.y = y or 150
	self.dir = dir or 0
	
	self.xspeed = MOVE_SPEED * math.cos(self.dir)
	self.yspeed = MOVE_SPEED * math.sin(self.dir)
	
	self.radius = RADIUS
	
	return self
end

function bullet:update(dt)
	self.x = self.x + (self.xspeed * dt)
	self.y = self.y + (self.yspeed * dt)
	
	if self.x < (100 + self.radius) or
		self.x > (1280 - 100 - self.radius) or
		self.y < (100 + self.radius) or
		self.y > (720 - 100 - self.radius) then
		self.markedForDeletion = true
	end
end

function bullet:draw()
	love.graphics.setColor(0, 0, 0)
	love.graphics.circle("fill", self.x, self.y, self.radius)
end
