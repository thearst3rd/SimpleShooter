-- SimpleShooter for CS/IMGD 4100
-- by Terry Hearst and Kyle Reese

local elapsed

function love.load()
	elapsed = 0
end


function love.update(dt)
	elapsed = elapsed + dt
end


function love.draw()
	local w, h = love.graphics.getDimensions()
	love.graphics.ellipse("fill", (w / 2) + math.sin(elapsed) * 200, (h / 2) + math.cos(elapsed) * 200, 50, 50)
end
