-- Menu state


-- Setup

states.game = {}
local game = states.game
game.__index = game


-- Main callbacks

function game.load()
	local self = {}
	setmetatable(self, game)
	
	self.players = {}
	self.objects = {}
	
	-- Initial world state
	table.insert(self.players, objects.player.new(true))
	
	return self
end

function game:update(dt)
	for k, v in ipairs(self.players) do
		if v.update then v:update(dt) end
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
	
	-- Draw players
	for k, v in ipairs(self.players) do
		if v.draw then v:draw() end
	end
end


-- Extra callbacks

function game:keypressed(key, scancode, isrepeat)
	if key == "escape" then
		state = states.menu.load()
	end
end
