-- The player class
-- Includes both Human and AI player

local PLAYER_RADIUS = 20
local MOVE_SPEED = 100 		-- pixels/second
local MOVE_ACCEL = 1000 	-- pixels/second/second


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


-- Main callbacks

function player.new(isHuman, x, y, dir)
	local self = {}
	setmetatable(self, player)
	
	self.isHuman = isHuman or false
	
	self.x = x or 200
	self.y = y or 200
	self.dir = dir or 0
	
	self.radius = PLAYER_RADIUS
	self.moveSpeed = MOVE_SPEED
	
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
	
	-- TODO implement movement
	
	prevInputs = inputs
end

function player:draw()
	-- Player body
	love.graphics.setColor(isHuman and {1, 0, 0} or {0, 1, 0})
	love.graphics.circle("fill", self.x, self.y, self.radius)
	
	-- Direction line
	love.graphics.setColor(0, 0, 0)
	love.graphics.line(self.x, self.y, self.x + (self.radius * math.cos(self.dir)), self.y + (self.radius *
		math.sin(self.dir)))
end
