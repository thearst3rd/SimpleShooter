-- Spins in cirles forever


-- Setup

agents.spinInCircles = {}
local spinInCircles = agents.spinInCircles
spinInCircles.__index = spinInCircles


-- Main callbacks

function spinInCircles.new(player)
	local self = {}
	setmetatable(self, spinInCircles)
	
	self.player = player
	
	-- Pick if this agent will go right or go left
	self.right = love.math.random() < 0.5
	
	return self
end

function spinInCircles:getInputs(dt)
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
	
	inputs.forward = true
	
	if self.right then
		inputs.rightturn = true
	else
		inputs.leftturn = true
	end
	
	inputs.shoot = true
	
	return inputs
end