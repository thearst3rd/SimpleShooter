-- State


-- Setup

states.TEMPLATE = {}
local TEMPLATE = states.TEMPLATE
TEMPLATE.__index = TEMPLATE


-- Main callbacks

function TEMPLATE.load()
	local self = {}
	setmetatable(self, TEMPLATE)
	
	return self
end

function TEMPLATE:update(dt)
	
end

function TEMPLATE:draw()
	
end
