-- The player class
-- Includes both Human and AI player

local RADIUS = 20

local MOVE_SPEED = 300 			-- pixels/second
local TURN_SPEED = 2 * math.pi 	-- rad/second
local MOVE_ACCEL = 1000 		-- pixels/second/second
local FRICTION_ACCEL = 300 		-- pixels/second/second

local BULLET_COOLDOWN = 1/3 	-- seconds
local MAX_AMMO = 10


-- Setup

objects.player = {}
local player = objects.player
player.__index = player


-- Controlling functions

function player:getHumanInputs()
	local inputs =
	{
		forward = love.keyboard.isDown("w"),
		backward = love.keyboard.isDown("s"),
		leftstrafe = love.keyboard.isDown("a"),
		rightstrafe = love.keyboard.isDown("d"),
		
		leftturn = love.keyboard.isDown("left"),
		rightturn = love.keyboard.isDown("right"),
		
		shoot = love.keyboard.isDown("space"),
	}
	
	return inputs
end

function player:getAiInputs()
	-- TODO implement ai lul
	
	local inputs =
	{
		forward = false,
		backward = false,
		leftstrafe = false,
		rightstrafe = false,
		
		leftturn = false,
		rightturn = false,
		
		shoot = false,
	}
	
	return inputs
end

function player:shootBullet()
	if (self.bulletCooldown <= 0) then
		table.insert(state.objects, objects.bullet.new(self, self.x, self.y, self.dir))
		self.bulletCooldown = BULLET_COOLDOWN
	end
end


-- Main callbacks

function player.new(isHuman, x, y, dir)
	local self = {}
	setmetatable(self, player)
	
	self.isHuman = isHuman or false
	
	self.x = x or 200
	self.y = y or 200
	self.dir = dir or 0
	
	self.xspeed = 0
	self.yspeed = 0
	
	self.lives = 3
	self.bulletCooldown = 0
	self.ammo = MAX_AMMO
	
	self.prevInputs = 
	{
		forward = false,
		backward = false,
		leftstrafe = false,
		rightstrafe = false,
		
		leftturn = false,
		rightturn = false,
		
		shoot = false,
	}
	
	return self
end

function player:update(dt)
	local inputs
	if self.isHuman then
		inputs = self:getHumanInputs()
	else
		inputs = self:getAiInputs()
	end
	
	local xx = 0
	local yy = 0
	
	if inputs.leftturn then
		self.dir = self.dir - TURN_SPEED * dt
	end
	
	if inputs.rightturn then
		self.dir = self.dir + TURN_SPEED * dt
	end
	
	-- loop range around
	if self.dir < 0 then self.dir = self.dir + (2 * math.pi)
	elseif self.dir >= (2 * math.pi) then self.dir = self.dir - (2 * math.pi) end
	
	-- This is used to normalize movement vector so that diagonal movement is not faster than orthogonal movement
	local shouldNormalize = ((inputs.forward or inputs.backward) and not (inputs.forward and inputs.backward))
		and ((inputs.leftstrafe or inputs.rightstrafe) and not (inputs.leftstrafe and inputs.rightstrafe))
	
	local magnitude = shouldNormalize and (1 / math.sqrt(2)) or 1
	
	if inputs.forward then
		xx = xx + magnitude * math.cos(self.dir)
		yy = yy + magnitude * math.sin(self.dir)
	end
	if inputs.backward then
		xx = xx + magnitude * math.cos(self.dir + math.pi)
		yy = yy + magnitude * math.sin(self.dir + math.pi)
	end
	if inputs.leftstrafe then
		xx = xx + magnitude * math.cos(self.dir + (3 * math.pi / 2))
		yy = yy + magnitude * math.sin(self.dir + (3 * math.pi / 2))
	end
	if inputs.rightstrafe then
		xx = xx + magnitude * math.cos(self.dir + (math.pi / 2))
		yy = yy + magnitude * math.sin(self.dir + (math.pi / 2))
	end
	
	-- Accelerate player based on movement inputs
	self.xspeed = self.xspeed + (dt * MOVE_ACCEL * xx)
	self.yspeed = self.yspeed + (dt * MOVE_ACCEL * yy)
	
	-- Cap max speed
	local speedMag = helper.getMagnitude(self.xspeed, self.yspeed)
	if speedMag > MOVE_SPEED then
		self.xspeed, self.yspeed = helper.scale(MOVE_SPEED, helper.normalize(self.xspeed, self.yspeed))
		--self.xspeed = MOVE_SPEED * self.xspeed
		--self.yspeed = MOVE_SPEED * self.yspeed
	end
	
	-- Actually move x and y coords
	self:move(dt)
	
	-- Fire bullets
	if self.bulletCooldown > 0 then
		self.bulletCooldown = self.bulletCooldown - dt
		if self.bulletCooldown < 0 then
			self.bulletCooldown = 0
		end
	end
	
	if inputs.shoot then
		self:shootBullet()
	end
	
	speedMag = helper.getMagnitude(self.xspeed, self.yspeed)
	
	-- Handle friction
	if speedMag > 0 then
		local newSpeedMag = speedMag - (FRICTION_ACCEL * dt)
		if newSpeedMag < 0 then newSpeedMag = 0 end
		self.xspeed, self.yspeed = helper.scale(newSpeedMag, helper.normalize(self.xspeed, self.yspeed))
	end
	
	prevInputs = inputs
end

-- Moves based on x and y speeds, and stays in bounds
function player:move(dt)
	self.x = self.x + (self.xspeed * dt)
	self.y = self.y + (self.yspeed * dt)
	
	
	if self.x < (100 + RADIUS) then
		self.x = 100 + RADIUS
		self.xspeed = 0
	end
	if self.x > (1280 - 100 - RADIUS) then
		self.x = 1280 - 100 - RADIUS
		self.xspeed = 0
	end
	if self.y < (100 + RADIUS) then
		self.y = 100 + RADIUS
		self.yspeed = 0
	end
	if self.y > (720 - 100 - RADIUS) then
		self.y = 720 - 100 - RADIUS
		self.yspeed = 0
	end
end

function player:draw()
	-- Player body
	love.graphics.setColor(isHuman and {1, 0, 0} or {0, 1, 0})
	love.graphics.circle("fill", self.x, self.y, RADIUS)
	love.graphics.setColor(0, 0, 0)
	love.graphics.circle("line", self.x, self.y, RADIUS)
	
	-- Direction line
	love.graphics.line(self.x, self.y, self.x + (RADIUS * math.cos(self.dir)), self.y + (RADIUS * math.sin(self.dir)))
end

-- Draws on top of all other players
function player:drawHud()
	love.graphics.setFont(smallFont)
	
	local xx = math.floor(self.x - 100)
	local yy = math.floor(self.y - RADIUS - 24)
	
	love.graphics.printf(tostring(self.ammo), xx, yy, 200, "center")
end
