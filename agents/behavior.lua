-- Agent


-- Setup

agents.behavior = {}
local behavior = agents.behavior
behavior.__index = behavior


-- Main callbacks

function behavior.new()
	local self = {}
	setmetatable(self, behavior)
	
	return self
end

function behavior:getInputs()
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
		-- dodge
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
		-- getAmmo
		while self:isOutOfAmmo() do
			while self:notFacingAmmo() do
				-- if closest is left
				-- inputs.leftturn = true
				-- else
				-- inputs.rightturn = true
			end
			-- if straight aligned
			-- inputs.forward = true
			-- elseif left aligned
			-- inputs.leftstrafe = true
			-- elseif right aligned
			-- inputs.rightstrafe = true
			-- else
			-- inputs.backward = true
		end
	else
		-- shootOtherPlayers
		while self:notFacingPlayer() do
			-- if closest is left
			-- inputs.leftturn = true
			-- else
			-- inputs.rightturn = true
		end
		inputs.shoot = true
	end
	
	return inputs
end