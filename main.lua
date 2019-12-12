-- SimpleShooter for CS/IMGD 4100
-- by Terry Hearst and Kyle Reese


-- Define fonts for later use

titleFont = love.graphics.newFont(72)
bigFont = love.graphics.newFont(36)
mediumFont = love.graphics.newFont(24)
smallFont = love.graphics.newFont(16)


-- Helper library

require "helper"
require "agentHelper"


-- Include all the game states

states = {}
require "states/game"
require "states/menu"


-- Include all objects

objects = {}
require "objects/player"
require "objects/bullet"
require "objects/ammoPack"


-- Include all AI agents

agents = {}
require "agents/doNothing"
require "agents/human"
require "agents/behavior"


-- Main game callbacks

function love.load()
	state = states.menu.load()
end

function love.update(dt)
	if state and state.update then
		state:update(dt)
	end
end

function love.draw()
	if state and state.draw then
		state:draw()
	end
end


-- Pass through other callbacks

for _, v in ipairs{"keypressed", "keyreleased", "mousemoved", "mousepressed", "mousereleased"} do
	love[v] = function(...)
		if state and state[v] then
			state[v](state, ...)
		end
	end
end
