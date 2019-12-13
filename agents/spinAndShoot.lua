-- Spins in cirles forever AND shoots. Will look for ammo pack if no ammo left


-- Setup

agents.spinAndShoot = {}
local spinAndShoot = agents.spinAndShoot
spinAndShoot.__index = spinAndShoot

spinAndShoot.color = {0.35, 1, 1}


-- Main callbacks

function spinAndShoot.new(player)
	local self = {}
	setmetatable(self, spinAndShoot)
	
	self.player = player
	
	-- Pick if this agent will go right or go left
	self.right = love.math.random() < 0.5
	
	return self
end

function spinAndShoot:getInputs(dt)
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
	
	if self.player.ammo > 0 then
		inputs.forward = true
		
		if self.right then
			inputs.rightturn = true
		else
			inputs.leftturn = true
		end
		
		inputs.shoot = true
	else
		local ammo = agentHelper.getClosestDistAmmoPack(self)
		if ammo then
			self:goTowardsAmmo(inputs, ammo)
		end
	end
	
	return inputs
end

function spinAndShoot:goTowardsAmmo(inputs, ammo)
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