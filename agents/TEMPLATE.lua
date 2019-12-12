-- Agent


-- Setup

agents.TEMPLATE = {}
local TEMPLATE = agents.TEMPLATE
TEMPLATE.__index = TEMPLATE


-- Main callbacks

function TEMPLATE.new()
	local self = {}
	setmetatable(self, TEMPLATE)
	
	return self
end

function TEMPLATE:getInputs()
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