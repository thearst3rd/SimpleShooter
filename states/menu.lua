-- Menu state


-- Setup

states.menu = {}
local menu = states.menu
menu.__index = menu


local persistentPlayers =
{
	--     1          2           3           4                 5          6         7
	-- agentIndex, isHuman, hoverButtonL, hoverButtonR, hoverButtonHuman, isOn, toggleHover
	{1, true, false, false, false, true, false},
	{1, false, false, false, false, true, false},
	{1, false, false, false, false, false, false},
	{1, false, false, false, false, false, false},
	{1, false, false, false, false, false, false},
	{1, false, false, false, false, false, false},
}


-- Main callbacks

function menu.load()
	local self = {}
	setmetatable(self, menu)
	
	self.t = 0
	
	self.agentKeys = {}
	for k, v in pairs(agents) do
		if k ~= "human" then
			table.insert(self.agentKeys, k)
		end
	end
	
	self.players = persistentPlayers
	
	self.playHover = false
	
	return self
end

local playButtonYOff = 570
local playButtonW = 200
local playButtonH = 100

function menu:update(dt)
	self.t = self.t + dt
	
	for n = 1, 6 do
		self:handlePlayer(n)
	end
	
	local mx, my = love.mouse.getPosition()
	
	mx = mx - (1280 / 2) + (playButtonW / 2)
	my = my - playButtonYOff
	
	self.playHover = ((mx > 0) and (mx < playButtonW) and (my > 0) and (my < playButtonH))
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
	
	local yy = math.floor(250 - offset)
	
	love.graphics.printf("SET UP YOUR ARENA!", 0, yy, w, "center")
	
	for n = 1, 6 do
		self:drawPlayer(n)
	end
	
	love.graphics.setColor(self.playHover and {1, 1, 1} or {0.6, 0.6, 0.6})
	love.graphics.rectangle("fill", (1280 / 2) - (playButtonW / 2), playButtonYOff, playButtonW, playButtonH)
	
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("line", (1280 / 2) - (playButtonW / 2), playButtonYOff, playButtonW, playButtonH)
	love.graphics.setFont(bigFont)
	love.graphics.printf("PLAY!", (1280 / 2) - (playButtonW / 2), playButtonYOff + 25, playButtonW, "center")
end

function menu:keypressed(key, scancode, isrepeat)
	if key == "escape" then
		love.event.quit()
	--elseif key == "return" then
		--state = states.game.load()
	end
end

function menu:mousepressed(x, y, button, istouch, presses)
	for n = 1, 6 do
		plr = self.players[n]
		
		if plr[3] then
			plr[1] = plr[1] - 1
			if plr[1] <= 0 then
				plr[1] = #self.agentKeys
			end
		elseif plr[4] then
			plr[1] = plr[1] + 1
			if plr[1] > #self.agentKeys then
				plr[1] = 1
			end
		elseif plr[5] then
			local human = plr[2]
			-- Turn off all other humans
			for k, v in pairs(self.players) do v[2] = false end
			
			plr[2] = not human
		elseif plr[7] then
			plr[6] = not plr[6]
		end
	end
	if self.playHover then
		local players = {}
		for n = 1, 6 do
			local plr = self.players[n]
			players[n] = plr[6] and (plr[2] and "human" or self.agentKeys[plr[1]])
		end
		state = states.game.load(players)
	end
end


-- Handling the player selection dialogs

local padding = 100 	-- on EACH side
local yOff = 400
local onButtonYOff = 40
local buttonsYOff = 80
local buttonBoxSize = 26
local buttonOffset = 10
local humanYOff = 130
local humanRad = 13

-- returns the center coordinate of where the player select dialog should be
local function calcPlayerXPosition(n)
	local space = 1280 - (2 * padding)
	local chunk = space / 5
	local offset = (n - 1) * chunk
	return math.floor(padding + offset)
end

function menu:handlePlayer(n)
	local plr = self.players[n]
	
	-- Reset hovering values
	plr[3] = false
	plr[4] = false
	plr[5] = false
	plr[7] = false

	local mx, my = love.mouse.getPosition()
	
	local px = calcPlayerXPosition(n)
	local py = yOff
	
	-- Toggle button
	
	local mxx = mx - px + 25
	local myy = my - py - onButtonYOff
	
	if (mxx > -buttonBoxSize / 2) and (mxx < buttonBoxSize / 2) and (myy > 0) and (myy < buttonBoxSize) then
		plr[7] = true
	end
	
	-- Left right buttons
	
	mxx = mx - px
	myy = my - py - buttonsYOff
	
	if (myy > 0) and (myy < buttonBoxSize) then
		if (mxx > (-buttonOffset - buttonBoxSize)) and (mxx < -buttonOffset) then
			plr[3] = true
		elseif (mxx > buttonOffset) and (mxx < (buttonOffset + buttonBoxSize)) then
			plr[4] = true
		end
	end
	
	-- Human radio
	
	mxx = mx - px + 30
	myy = my - py - humanYOff
	
	if (mxx > -humanRad) and (mxx < humanRad) and (myy > -humanRad) and (myy < humanRad) then
		plr[5] = true
	end
end

function menu:drawPlayer(n)
	local mx, my = love.mouse.getPosition()
	
	local px = calcPlayerXPosition(n)
	local py = yOff
	
	local plr = self.players[n]
	
	-- Text
	
	love.graphics.setColor(0, 0, 0)
	love.graphics.setFont(mediumFont)
	love.graphics.printf(plr[2] and "human" or self.agentKeys[plr[1]], px - 200, py, 400, "center")
	
	-- On button
	
	px = px - 25
	py = yOff + onButtonYOff
	
	love.graphics.print("On?", px + 30, py)
	
	local o = plr[7] and 0.5 or 0
	love.graphics.setColor(plr[6] and {o, 1, o} or {1, o, o})
	love.graphics.rectangle("fill", px - buttonBoxSize / 2, py,
		buttonBoxSize, buttonBoxSize)
	
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("line", px - buttonBoxSize / 2, py,
		buttonBoxSize, buttonBoxSize)
	
	-- Left right buttons
	
	px = px + 25
	py = yOff + buttonsYOff
	
	love.graphics.setColor(plr[3] and {1, 1, 1} or {1, 1, 0})
	love.graphics.polygon("fill", px - buttonOffset, py,
		px - buttonOffset - buttonBoxSize, py + (buttonBoxSize / 2),
		px - buttonOffset, py + buttonBoxSize)
	love.graphics.setColor(plr[4] and {1, 1, 1} or {1, 1, 0})
	love.graphics.polygon("fill", px + buttonOffset, py,
		px + buttonOffset + buttonBoxSize, py + (buttonBoxSize / 2),
		px + buttonOffset, py + buttonBoxSize)
	
	love.graphics.setColor(0, 0, 0)
	love.graphics.polygon("line", px - buttonOffset, py,
		px - buttonOffset - buttonBoxSize, py + (buttonBoxSize / 2),
		px - buttonOffset, py + buttonBoxSize)
	love.graphics.polygon("line", px + buttonOffset, py,
		px + buttonOffset + buttonBoxSize, py + (buttonBoxSize / 2),
		px + buttonOffset, py + buttonBoxSize)
	
	-- Human radio
	
	px = px - 30
	py = yOff + humanYOff
	
	love.graphics.circle("line", px, py, humanRad)
	
	love.graphics.setFont(smallFont)
	love.graphics.print("Human?", px + 22, py - 10)
	
	if plr[2] then
		love.graphics.circle("fill", px, py, humanRad * (2/3))
	end
	
	if plr[5] then
		love.graphics.setColor(1, 1, 1, 0.4)
		love.graphics.circle("fill", px, py, humanRad)
	end
end