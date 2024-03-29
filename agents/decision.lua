-- Agent


-- Setup

agents.decision = {}
local decision = agents.decision
decision.__index = decision

decision.color = {1, 1, 0.35}


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

	if commonActions.isAboutToGetHit(self) then
		commonActions.dodge(self, inputs)
	else
		if self.player.ammo <= 0 then
			commonActions.goTowardsAmmo(self, inputs)
		else
			if #(helper.getAllAlivePlayers()) > 1 then
				commonActions.shootAtPlayer(self, inputs)
			else
				if self.player.ammo < 10 then
					commonActions.goTowardsAmmo(self, inputs)
				else
					-- Chill (do nothing for now)
				end
			end
		end
	end
	
	return inputs
end