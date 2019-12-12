-- The player class
-- Includes both Human and AI player

local RADIUS = 20

local MOVE_SPEED = 300 			-- pixels/second
local TURN_SPEED = 2 * math.pi 	-- rad/second
local MOVE_ACCEL = 1000 		-- pixels/second/second
local FRICTION_ACCEL = 300 		-- pixels/second/second

local BULLET_COOLDOWN = 1/3 	-- seconds
local MAX_AMMO = 10
local INVIN_COOLDOWN = 2 		-- seconds
local DEATH_COOLDOWN = 3 		-- seconds


-- Setup

objects.player = {}
local player = objects.player
player.__index = player


-- Player functions

function player:shootBullet()
	if self.bulletCooldown <= 0 and self.ammo > 0 then
		table.insert(state.objects, objects.bullet.new(self, self.x, self.y, self.dir))
		self.bulletCooldown = BULLET_COOLDOWN
		self.ammo = self.ammo - 1
	end
end


-- Main callbacks

function player.new(agent, x, y, dir)
	local self = {}
	setmetatable(self, player)
	
	agent = agent or agents.doNothing
	self.agent = agent.new(self)
	
	self.x = x or 200
	self.y = y or 200
	self.dir = dir or 0
	
	self.xspeed = 0
	self.yspeed = 0
	
	self.radius = RADIUS
	
	self.lives = 3
	self.bulletCooldown = 0
	self.ammo = MAX_AMMO
	
	self.invin = false 	-- invincible
	self.invinCooldown = 0
	
	self.dead = false
	self.deadCooldown = 0
	
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
	if self.dead then
		self.deadCooldown = self.deadCooldown - dt
		
		-- Slide along (continue moving if they were already moving)
		self:move(dt)
		
		-- Respawn
		if self.deadCooldown <= 0 then
			if self.lives > 0 then
				self.dead = false
				self.deadCooldown = 0
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
				
				self.ammo = MAX_AMMO
				self.invin = true
				self.invinCooldown = INVIN_COOLDOWN
			else
				self.markedForDeletion = true
			end
		end
	else
		local inputs = self.agent:getInputs()
		
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
		if helper.getMagnitude(self.xspeed, self.yspeed) > MOVE_SPEED then
			self.xspeed, self.yspeed = helper.scale(MOVE_SPEED, helper.normalize(self.xspeed, self.yspeed))
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
		
		if inputs.shoot --[[and not self.prevInputs.shoot]] then
			self:shootBullet()
		end
		
		-- Collide with other objects
		for _, v in pairs(state.objects) do
			if helper.circlesColliding(self.x, self.y, self.radius, v.x, v.y, v.radius) then
				if getmetatable(v) == objects.bullet then
					if v.owner ~= self then
						self.dead = true
						self.deadCooldown = DEATH_COOLDOWN
						self.lives = self.lives - 1
						v.markedForDeletion = true
					end
				elseif getmetatable(v) == objects.ammoPack then
					if v.active and (self.ammo < MAX_AMMO) then
						v.active = false
						v.activeCooldown = v.maxActiveCooldown
						self.ammo = MAX_AMMO
					end
				end
			end
		end
		
		-- Let invinCooldown run out
		if self.invin then
			self.invinCooldown = self.invinCooldown - dt
			if self.invinCooldown <= 0 then
				self.invinCooldown = 0
				self.invin = false
			end
		end
		
		self.prevInputs = inputs
	end
end

-- Moves based on x and y speeds, and stays in bounds
function player:move(dt)
	self.x = self.x + (self.xspeed * dt)
	self.y = self.y + (self.yspeed * dt)
	
	if self.x < (100 + self.radius) then
		self.x = 100 + self.radius
		self.xspeed = 0
	end
	if self.x > (1280 - 100 - self.radius) then
		self.x = 1280 - 100 - self.radius
		self.xspeed = 0
	end
	if self.y < (100 + self.radius) then
		self.y = 100 + self.radius
		self.yspeed = 0
	end
	if self.y > (720 - 100 - self.radius) then
		self.y = 720 - 100 - self.radius
		self.yspeed = 0
	end
	
	-- Handle friction
	local speedMag = helper.getMagnitude(self.xspeed, self.yspeed)
	if speedMag > 0 then
		speedMag = speedMag - (FRICTION_ACCEL * dt)
		if speedMag < 0 then speedMag = 0 end
		self.xspeed, self.yspeed = helper.scale(speedMag, helper.normalize(self.xspeed, self.yspeed))
	end
end

function player:draw()
	-- Player body
	local alpha = self.dead and 0.4 or (self.invin and ((self.invinCooldown % 0.2) < 0.1 and 1 or 0.1) or 1)
	love.graphics.setColor((getmetatable(self.agent) == agents.human) and {0, 1, 0, alpha} or {1, 0, 0, alpha})
	love.graphics.circle("fill", self.x, self.y, self.radius)
	love.graphics.setColor(0, 0, 0, alpha)
	love.graphics.circle("line", self.x, self.y, self.radius)
	
	-- Direction line
	love.graphics.line(self.x, self.y, self.x + (self.radius * math.cos(self.dir)), self.y + (self.radius * math.sin(self.dir)))
end

-- Draws on top of all other players
function player:drawHud()
	love.graphics.setFont(smallFont)
	
	local xx = math.floor(self.x - 100)
	local yy = math.floor(self.y - self.radius - 24)
	
	love.graphics.setColor(0, 0, 0)
	love.graphics.printf(tostring(self.ammo), xx, yy, 200, "center")
	
	local livesStr = ""
	for i = 1, 3 do
		livesStr = livesStr .. (self.lives >= i and "*" or ".")
	end
	
	yy = math.floor(self.y + self.radius + 4)
	
	love.graphics.setColor(0, 0.6, 0)
	love.graphics.printf(tostring(livesStr), xx, yy, 200, "center")
end
