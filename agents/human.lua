-- Human agent, not an AI


-- Setup

agents.human = {}
local human = agents.human
human.__index = human


-- Main callbacks

function human.new(player)
	local self = {}
	setmetatable(self, human)
	
	self.player = player
	
	return self
end

function human:getInputs(dt)
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
	
	-- Poll inputs
	inputs.forward = love.keyboard.isDown("w")
	inputs.backward = love.keyboard.isDown("s")
	inputs.leftstrafe = love.keyboard.isDown("a")
	inputs.rightstrafe = love.keyboard.isDown("d")
	
	inputs.leftturn = love.keyboard.isDown("left")
	inputs.rightturn = love.keyboard.isDown("right")
	
	inputs.shoot = love.keyboard.isDown("space")
	
	return inputs
end