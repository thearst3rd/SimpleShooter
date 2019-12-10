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
	local w, h = love.graphics.getDimensions()
	love.graphics.setBackgroundColor(0.8, 0.8, 0.8)
	
	love.graphics.setFont(titleFont)
	love.graphics.setColor(1, 0, 0)
	love.graphics.printf("AI Shooter", 0, 100, w, "center")
	
	love.graphics.setFont(bigFont)
	love.graphics.setColor(0, 0, 0)
	local offset = math.abs(math.sin(self.t * 3)) * 32
	
	local yy = math.floor((h / 2) - 100 - offset)
	
	love.graphics.printf("PRESS <ENTER> TO PLAY\nPRESS <ESC> TO QUIT", 0, yy, w, "center")
end

function menu:keypressed(key, scancode, isrepeat)
	if key == "escape" then
		love.event.quit()
	elseif key == "return" then
		state = states.game.load()
	end
end
