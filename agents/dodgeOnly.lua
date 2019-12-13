-- Agent


-- Setup

agents.dodgeOnly = {}
local dodgeOnly = agents.dodgeOnly
dodgeOnly.__index = dodgeOnly

dodgeOnly.color = {1, 0.7, 0.3}


-- Main callbacks

function dodgeOnly.new(player)
	local self = {}
	setmetatable(self, dodgeOnly)
	
	self.player = player
	
	return self
end

function dodgeOnly:getInputs(dt)
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
	
	if commonActions.isAboutToGetHit(self) then
		commonActions.dodge(self, inputs)
	end
	
	return inputs
end
