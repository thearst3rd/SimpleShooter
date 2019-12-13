-- Common actions that an agent might perform

commonActions = {}


-- DODGING

function commonActions.isAboutToGetHit(self)
	if self.player.invin then return false end
	for _, bullet in pairs(helper.getAllBullets()) do
		if helper.isFacingObject(bullet, self.player) then
			return true
		end
	end
	
	return false
end

function commonActions.dodge(self, inputs)
	local bulletsFacingMe = {}
	
	for _, bullet in ipairs(helper.getAllBullets()) do
		if helper.isFacingObject(bullet, self.player) then
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
	
	local _, facingDiff = helper.isFacingObject(closestBullet, self.player)
	
	local offsetAng = -math.pi / 2
	if facingDiff > 0 then
		offsetAng = -offsetAng
	end
	
	-- Look at the angle of the bullet and move in a perpendicular direction to avoid it
	local dirDiff = closestBullet.dir - self.player.dir
	if dirDiff < 0 then dirDiff = dirDiff + (2 * math.pi) end
	
	local dirButtons = helper.dirButtons(dirDiff + offsetAng)
	
	for k, v in pairs(dirButtons) do inputs[k] = v end
end

-- these ones are for "smart" dodging

function commonActions.closeToWall(self)
	local px = self.player.x
	local py = self.player.y
	
	return ((px < 100 + 100) or (px > 1280 - 100 - 100) or (py < 100 + 100) or (py > 720 - 100 - 100))
end

function commonActions.closeToInactiveEnemy(self)
	if self.player.invin then return false end
	local inactivePlayers = {}
	for _, plr in ipairs(state.players) do
		if ((plr.dead and plr.lives > 0) or plr.invin) and plr ~= self.player then
			table.insert(inactivePlayers, plr)
		end
	end
	
	local minDist = 999999
	local closest
	
	for _, plr in ipairs(inactivePlayers) do
		local dist = helper.getObjectDist(self.player, plr)
		if dist < minDist then
			minDist = dist
			closest = plr
		end
	end
	
	if minDist < 150 then
		return true, closest
	else
		return false
	end
end

function commonActions.shouldDodgeSmart(self)
	return commonActions.isAboutToGetHit(self)
		or commonActions.closeToWall(self)
		or commonActions.closeToInactiveEnemy(self)
end

function commonActions.dodgeSmart(self, inputs)
	if commonActions.closeToWall(self) then
		-- Move away from wall
		local dir
		local closeToTop = self.player.y < (100 + 100)
		local closeToBottom = self.player.y > (720 - 100 - 100)
		if self.player.x < (100 + 100) then
			if closeToTop then
				dir = math.pi / 4
			elseif closeToBottom then
				dir = 7 * math.pi / 4
			else
				dir = 0
			end
		elseif self.player.x > (1280 - 100 - 100) then
			if closeToTop then
				dir = 3 * math.pi / 4
			elseif closeToBottom then
				dir = 5 * math.pi / 4
			else
				dir = math.pi
			end
		elseif closeToTop then
			dir = math.pi / 2
		elseif closeToBottom then
			dir = 3 * math.pi / 2
		end
		
		local dirDiff = dir - self.player.dir
		for k, v in pairs(helper.dirButtons(dirDiff)) do
			inputs[k] = v
		end
	else
		if commonActions.isAboutToGetHit(self) then
			commonActions.dodge(self, inputs)
		else
			local isClose, plr = commonActions.closeToInactiveEnemy(self, inputs)
			if isClose then
				local angleToPlayer = math.atan2(plr.y - self.player.y, plr.x - self.player.x)
				if angleToPlayer < 0 then angleToPlayer = angleToPlayer + (2 * math.pi) end
				
				local diff = angleToPlayer - self.player.dir
				while diff < (-math.pi) do diff = diff + (2 * math.pi) end
				while diff >= (math.pi) do diff = diff - (2 * math.pi) end
				
				if math.abs(diff) > 0.1 then
					inputs[diff > 0 and "rightturn" or "leftturn"] = true
				end
				
				for k, v in pairs(helper.dirButtons(diff + math.pi)) do
					inputs[k] = v
				end
			end
		end
	end
end


-- AMMO

function commonActions.goTowardsAmmo(self, inputs)
	local ammo = agentHelper.getClosestDistAmmoPack(self)
	if ammo == nil then return end
	
	local angleToAmmo = math.atan2(ammo.y - self.player.y, ammo.x - self.player.x)
	if angleToAmmo < 0 then angleToAmmo = angleToAmmo + (2 * math.pi) end
	
	local diff = angleToAmmo - self.player.dir
	while diff < (-math.pi) do diff = diff + (2 * math.pi) end
	while diff >= (math.pi) do diff = diff - (2 * math.pi) end
	
	if math.abs(diff) > 0.1 then
		inputs[diff > 0 and "rightturn" or "leftturn"] = true
	end
	
	for k, v in pairs(helper.dirButtons(diff)) do
		inputs[k] = v
	end
end


-- SHOOTING

function commonActions.shootAtPlayer(self, inputs)
	local player = agentHelper.getClosestDistPlayer(self)
	if player == nil then return end
	
	local angleToPlayer = math.atan2(player.y - self.player.y, player.x - self.player.x)
	if angleToPlayer < 0 then angleToPlayer = angleToPlayer + (2 * math.pi) end
	
	local distToPlayer = helper.getObjectDist(self.player, player)
	
	local diff = angleToPlayer - self.player.dir
	while diff < (-math.pi) do diff = diff + (2 * math.pi) end
	while diff >= (math.pi) do diff = diff - (2 * math.pi) end
	
	if math.abs(diff) > 0.06 then
		inputs[diff > 0 and "rightturn" or "leftturn"] = true
	end
	
	if distToPlayer > 400 then
		for k, v in pairs(helper.dirButtons(diff)) do
			inputs[k] = v
		end
	elseif distToPlayer < 300 then
		for k, v in pairs(helper.dirButtons(diff + math.pi)) do
			inputs[k] = v
		end
	end
	
	if helper.isFacingObject(self.player, player) then
		inputs.shoot = true
	end
end

function commonActions.shootAtPlayerLeading(self, inputs, iterations)
	local player = agentHelper.getClosestDistPlayer(self)
	if player == nil then return end
	
	iterations = iterations or 2
	
	local dist
	
	local px, py = player.x, player.y
	local dist = helper.getMagnitude(self.player.x, self.player.y, px, py)
	
	for i = 1, iterations do
		-- this is how long it will take to reach the bullet
		local t = dist / objects.bullet.MOVE_SPEED
		
		px = player.x + (player.xspeed * t)
		py = player.y + (player.yspeed * t)
		
		dist = helper.getMagnitude(self.player.x, self.player.y, px, py)
	end
	
	local angle = math.atan2(py - self.player.y, px - self.player.x)
	if angle < 0 then angle = angle + (2 * math.pi) end
	
	local diff = angle - self.player.dir
	while diff < (-math.pi) do diff = diff + (2 * math.pi) end
	while diff >= (math.pi) do diff = diff - (2 * math.pi) end
	
	if math.abs(diff) > 0.06 then
		inputs[diff > 0 and "rightturn" or "leftturn"] = true
	end
	
	if dist > 400 then
		for k, v in pairs(helper.dirButtons(diff)) do
			inputs[k] = v
		end
	elseif dist < 300 then
		for k, v in pairs(helper.dirButtons(diff + math.pi)) do
			inputs[k] = v
		end
	end
	
	if helper.isFacing(self.player.x, self.player.y, self.player.dir, px, py) then
		inputs.shoot = true
	end
end