-- Do nothing agent - does nothing


-- Setup

agents.doNothing = {}
local doNothing = agents.doNothing
doNothing.__index = doNothing


-- Main callbacks

function doNothing.new(player)
	local self = {}
	setmetatable(self, doNothing)
	
	self.player = player
	
	return self
end

function doNothing:getInputs(dt)
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