-- Library of helper functions for agents

agentHelper = {}

function agentHelper.getClosestDistAmmoPack(agent)
	local player = agent.player
	
	local minDist = 9999999999
	local closestAmmo
	
	for i, obj in pairs(helper.getAllAmmoPacks()) do
		local dist = helper.getMagnitude(obj.x - player.x, obj.y - player.y)
		if (dist < minDist) and obj.active then
			minDist = dist
			closestAmmo = obj
		end
	end
	
	return closestAmmo
end

function agentHelper.getClosestDistPlayer(agent)
	local player = agent.player
	
	local minDist = 9999999999
	local closestPlayer
	
	for i, obj in pairs(helper.getAllAlivePlayers()) do
		if obj ~= player then
			local dist = helper.getMagnitude(obj.x - player.x, obj.y - player.y)
			if dist < minDist then
				minDist = dist
				closestPlayer = obj
			end
		end
	end
	
	return closestPlayer
end

function agentHelper.isFacingObject(agent, obj, threshold)
	local player = agent.player
	
	return helper.isFacingObject(player, obj, threshold)
end