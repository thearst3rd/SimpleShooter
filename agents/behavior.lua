-- Agent


-- Setup

agents.behavior = {}
local behavior = agents.behavior
behavior.__index = behavior


-- Main callbacks

function behavior.new(player)
	local self = {}
	setmetatable(self, behavior)

	self.player = player
	
	return self
end

function behavior:getInputs(dt)
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
				self:faceNearestAmmo()
			end
			-- move depending on how facing
		end
	else
		-- shootOtherPlayers
		while self:notFacingPlayer() do
			self:faceNearestPlayer()
		end
		inputs.shoot = true
	end
	
	return inputs
end

function behavior:isAboutToGetHit()
	-- TODO
end

function behavior:isSafeForward()
	-- TODO
end

function behavior:isSafeLeft()
	-- TODO
end

function behavior:isSafeRight()
	-- TODO
end

function behavior:isOutOfAmmo()
	return self.player.ammo == 0
end

function behavior:notFacingAmmo()
	local closestAmmo = agentHelper.getClosestDistAmmoPack(self)

end

function behavior:notFacingPlayer()
	-- TODO
end

function behavior:faceNearestAmmo()
	-- TODO
end

function behavior:faceNearestPlayer()
	-- TODO
end