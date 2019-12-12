-- Agent


-- Setup

agents.TEMPLATE = {}
local TEMPLATE = agents.TEMPLATE
TEMPLATE.__index = TEMPLATE


-- Main callbacks

function TEMPLATE.new(player)
	local self = {}
	setmetatable(self, TEMPLATE)
	
	self.player = player
	
	return self
end

function TEMPLATE:getInputs(dt)
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