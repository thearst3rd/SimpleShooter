-- Agent


-- Setup

agents.decision = {}
local decision = agents.decision
decision.__index = decision


-- Main callbacks

function decision.new(player)
	local self = {}
	setmetatable(self, decision)
	
	self.player = player
	
	return self
end

function decision:getInputs(dt)
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
		self:dodge(inputs)
	elseif self:isOutOfAmmo() then
		-- Go to ammo pack
		if self:notFacingAmmo() then
			self:faceNearestAmmo(inputs)
		else
			-- move depending on how facing
		end
	else
		-- Shoot at other players
		if self:notFacingPlayer() then
			self:faceNearestPlayer(inputs)
		else
			inputs.shoot = true
		end
	end
	
	return inputs
end

function decision:isAboutToGetHit()
	for _, bullet in pairs(helper.getAllBullets()) do
		if helper.isFacingObject(bullet, self.player) and helper.getObjectDist(bullet, self.player) < 540 then
			return true
		end
	end
	
	return false
end

function decision:dodge(inputs)
	local bulletsFacingMe = {}
	
	for _, bullet in ipairs(helper.getAllBullets()) do
		if helper.isFacingObject(bullet, self.player) and helper.getObjectDist(bullet, self.player) < 540 then
			table.insert(bulletsFacingMe, bullet)
		end
	end
	
	-- TODO - consider all of them rather than just considering closest one
	local closestBullet
	local minDist = 9999999
	for _, bullet in ipairs(bulletsFacingMe) do
		local dist = helper.getObjectDist(bullet, self.player)
		if dist < minDist then
			minDist = dist
			closestBullet = bullet
		end
	end
	
	-- Look at the angle of the bullet and move in a perpendicular direction to avoid it
	local dirDiff = bullet.dir - self.player.dir
	if dirDiff < 0 then dirDiff = dirDiff + (2 * math.pi) end
	
	if (dirDiff < (math.pi / 8)) or (dirDiff >= (15 * math.pi / 8)) then
		inputs.rightstrafe = true
	elseif dirDiff < (3 * math.pi / 8) then
		inputs.rightstrafe = true
		inputs.backward = true
	elseif dirDiff < (5 * math.pi / 8) then
		inputs.backward = true
	elseif dirDiff < (7 * math.pi / 8) then
		inputs.backward = true
		inputs.leftstrafe = true
	elseif dirDiff < (9 * math.pi / 8) then
		inputs.leftstrafe = true
	elseif dirDiff < (11 * math.pi / 8) then
		inputs.leftstrafe = true
		inputs.forward = true
	elseif dirDiff < (13 * math.pi / 8) then
		inputs.forward = true
	elseif dirDiff < (15 * math.pi / 8) then
		inputs.forward = true
		inputs.rightstrafe = true
	end
end