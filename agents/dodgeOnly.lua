-- Agent


-- Setup

agents.dodgeOnly = {}
local dodgeOnly = agents.dodgeOnly
dodgeOnly.__index = dodgeOnly


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
	
	if self:isAboutToGetHit() then
		self:dodge(inputs)
	end
	
	return inputs
end

function dodgeOnly:isAboutToGetHit()
	for _, bullet in pairs(helper.getAllBullets()) do
		if helper.isFacingObject(bullet, self.player) --[[and helper.getObjectDist(bullet, self.player) < 540]] then
			return true
		end
	end
	
	return false
end

function dodgeOnly:dodge(inputs)
	local bulletsFacingMe = {}
	
	for _, bullet in ipairs(helper.getAllBullets()) do
		if helper.isFacingObject(bullet, self.player) --[[and helper.getObjectDist(bullet, self.player) < 540]] then
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
	local dirDiff = closestBullet.dir - self.player.dir
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