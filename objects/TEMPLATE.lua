-- Object


-- Setup

objects.TEMPLATE = {}
local TEMPLATE = objects.TEMPLATE
TEMPLATE.__index = TEMPLATE


-- Main callbacks

function TEMPLATE.new()
	local self = {}
	setmetatable(self, TEMPLATE)
	
	return self
end

function TEMPLATE:update(dt)
	
end

function TEMPLATE:draw()
	
end
