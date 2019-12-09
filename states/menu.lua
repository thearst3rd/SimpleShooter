-- Menu state


-- Setup

states.menu = {}
local menu = states.menu
menu.__index = menu


-- Main callbacks

function menu.load()
	local self = {}
	setmetatable(self, menu)
	
	self.t = 0
	
	return self
end

function menu:update(dt)
	self.t = self.t + dt
end

function menu:draw()
	love.graphics.setBackgroundColor(0.8, 0.8, 0.8)
	love.graphics.setFont(bigFont)
	love.graphics.setColor(0, 0, 0)
	
	local w, h = love.graphics.getDimensions()
	local offset = math.abs(math.sin(self.t * 3)) * 16
	
	love.graphics.printf("PRESS <SPACE> TO PLAY\nPRESS <ESC> TO QUIT", 0, (h / 2) - 100 - offset, w, "center")
end

function menu:keypressed(key, scancode, isrepeat)
	if key == "escape" then
		love.event.quit()
	elseif key == "space" then
		state = states.game.load()
	end
end
