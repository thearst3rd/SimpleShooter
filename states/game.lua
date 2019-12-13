-- Menu state


-- Setup

states.game = {}
local game = states.game
game.__index = game


-- Main callbacks

function game.load(players)
	local self = {}
	setmetatable(self, game)
	
	self.players = {}
	self.objects = {}
	
	-- Initial world state
	for i, plr in ipairs(players) do
		if plr then
			table.insert(self.players, objects.player.new(agents[plr], 200 + (((i - 1) % 3 * 440)),
				(i < 4) and 200 or 720 - 200))
		end
	end
	
	table.insert(self.objects, objects.ammoPack.new(640 - 300, 250))
	table.insert(self.objects, objects.ammoPack.new(640 + 300, 250))
	table.insert(self.objects, objects.ammoPack.new(640 - 300, 720 - 250))
	table.insert(self.objects, objects.ammoPack.new(640 + 300, 720 - 250))
	
	self.inCountdown = true
	self.countdown = 3 	-- seconds
	
	self.won = false
	self.wonCountdown = 5 	-- how long the screen displays the winner
	
	return self
end

function game:update(dt)
	if self.inCountdown then
		self.countdown = self.countdown - dt
		if self.countdown <= 0 then
			self.countdown = 0
			self.inCountdown = false
		end
	else
		-- Update game
		for k, v in ipairs(self.players) do
			if v.update then v:update(dt) end
		end
		for k, v in ipairs(self.objects) do
			if v.update then v:update(dt) end
		end
		
		-- Delete things marked for deletion
		for i = #self.objects, 1, -1 do
			if self.objects[i].markedForDeletion then
				if self.objects[i].destroy then self.objects[i]:destroy() end
				table.remove(self.objects, i)
			end
		end
		for i = #self.players, 1, -1 do
			if self.players[i].markedForDeletion then
				if self.players[i].destroy then self.players[i]:destroy() end
				table.remove(self.players, i)
			end
		end
		
		-- Win game
		if self.won == false then
			local won = self:isWon()
			if won then self.won = won end
		else
			self.wonCountdown = self.wonCountdown - dt
			if self.wonCountdown <= 0 then
				state = states.menu.load()
			end
		end
	end
end

function game:draw()
	-- Draw background and walls
	love.graphics.setBackgroundColor(0.8, 0.8, 0.8)
	love.graphics.setColor(0.4, 0.4, 1)
	
	love.graphics.rectangle("fill", 0, 0, 1280, 100)
	love.graphics.rectangle("fill", 0, 720 - 100, 1280, 100)
	love.graphics.rectangle("fill", 0, 100, 100, 520)
	love.graphics.rectangle("fill", 1280 - 100, 100, 100, 520)
	
	love.graphics.setColor(0, 0, 0)
	love.graphics.line(0, 0,  1280, 0,  1280, 720,  0, 720,  0, 0)
	love.graphics.line(100, 100,  1280 - 100, 100,  1280 - 100, 720 - 100,  100, 720 - 100,  100, 100)
	
	-- Draw objects
	for k, v in ipairs(self.objects) do
		if v.draw then v:draw() end
	end
	
	-- Draw players
	for k, v in ipairs(self.players) do
		if v.draw then v:draw() end
	end
	for k, v in ipairs(self.players) do
		if v.drawHud then v:drawHud() end
	end
	
	-- Draw countdown
	if self.inCountdown then
		love.graphics.setFont(titleFont)
		local num = math.ceil(self.countdown)
		love.graphics.setColor(num > 1 and 1 or 0, num < 3 and 1 or 0, 0)
		love.graphics.printf(tostring(num), 0, 300, 1280, "center")
	end
	
	-- Draw end screen
	if self.won ~= false then
		love.graphics.setFont(titleFont)
		if self.won == "won" then
			love.graphics.setColor(0, 0.7, 0)
			love.graphics.printf("WINNER!", 0, 150, 1280, "center")
		else
			love.graphics.setColor(1, 1, 0)
			love.graphics.printf("DRAW!", 0, 150, 1280, "center")
		end
	end
end


-- Extra callbacks

function game:keypressed(key, scancode, isrepeat)
	if key == "escape" then
		state = states.menu.load()
	end
end

function game:isWon()
	local numLivingPlayers = 0
	local livingPlayer
	for _, player in pairs(self.players) do
		if player.lives > 0 then
			numLivingPlayers = numLivingPlayers + 1
			livingPlayer = player
		end
	end
	
	if numLivingPlayers == 0 then
		return "draw"
	end
	
	if numLivingPlayers == 1 then
		for _, bullet in pairs(helper.getAllBullets()) do
			if bullet.owner ~= livingPlayer then return false end
		end
		
		return "won"
	end
	
	return false
end