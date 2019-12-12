-- Library of helper functions

helper = {}

-- Returns magnitude of 2D input vector
function helper.getMagnitude(x, y)
	return math.sqrt((x * x) + (y * y))
end

-- Returns the normalized coordinates of the 2D input vector
function helper.normalize(x, y)
	-- Check if zero
	if x == 0 and y == 0 then return 0, 0 end
	
	local magnitude = helper.getMagnitude(x, y)
	
	return x / magnitude, y / magnitude
end

-- Scales up a vector by the given number
function helper.scale(size, x, y)
	return x * size, y * size
end

-- Checks if two circles are colliding
function helper.circlesColliding(x1, y1, r1, x2, y2, r2)
	local dist = helper.getMagnitude(x2 - x1, y2 - y1)
	return (dist <= (r1 + r2))
end