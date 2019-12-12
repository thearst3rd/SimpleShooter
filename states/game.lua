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
	
	-- which direction each player will face
	-- im lazy and this will work
	local dirTable =
	{
		math.pi / 6,
		math.pi / 2,
		5 * math.pi / 6,
		11 * math.pi / 6,
		3 * math.pi / 2,
		7 * math.pi / 6,
	}
	
	-- Initial world state
	for i, plr in ipairs(players) do
		if plr then
			table.insert(self.players, objects.player.new(agents[plr], 200 + (((i - 1) % 3 * 440)),
				(i < 4) and 200 or 720 - 200,
				dirTable[i]))
		end
	end
	
	table.insert(self.objects, objects.ammoPack.new(640 - 300, 250))
	table.insert(self.objects, objects.ammoPack.new(640 + 300, 250))
	table.insert(self.objects, objects.ammoPack.new(640 - 300, 720 - 250))
	table.insert(self.objects, objects.ammoPack.new(640 + 300, 720 - 250))
	
	return self
end

function game:update(dt)
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
end


-- Extra callbacks

function game:keypressed(key, scancode, isrepeat)
	if key == "escape" then
		state = states.menu.load()
	end
end
