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

	if self:isAboutToGetHit() then
		if self:isSafeForward() then
			inputs.forward = true
		elseif self:isSafeLeft() then
			inputs.leftstrafe = true
		elseif self:isSafeRight() then
			inputs.rightstrafe = true
		else
			inputs.backward = true
		end
	elseif self:isOutOfAmmo() then
		if self:notFacingAmmo() then
			self:faceNearestAmmo()
		else
			-- move depending on how facing
		end
	else
		if self:notFacingPlayer() then
			self:faceNearestPlayer()
		else
			inputs.shoot = true
		end
	end
	
	return inputs
end