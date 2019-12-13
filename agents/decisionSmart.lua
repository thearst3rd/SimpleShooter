-- "Smart" decision tree


-- Setup

agents.decisionSmart = {}
local decisionSmart = agents.decisionSmart
decisionSmart.__index = decisionSmart

decisionSmart.color = {1, 0.35, 0.35}


-- Main callbacks

function decisionSmart.new(player)
	local self = {}
	setmetatable(self, decisionSmart)
	
	self.player = player
	
	return self
end

function decisionSmart:getInputs(dt)
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
	
	if commonActions.shouldDodgeSmart(self) then
		commonActions.dodgeSmart(self, inputs)
	else
		if self.player.ammo <= 0 then
			commonActions.goTowardsAmmo(self, inputs)
		else
			if #(helper.getAllAlivePlayers()) > 1 then
				commonActions.shootAtPlayerLeading(self, inputs)
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