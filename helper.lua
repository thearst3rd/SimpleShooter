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

-- Checks if something is facing something else, within a certain radius
function helper.isFacing(x1, y1, dir, x2, y2, threshold)
	threshold = threshold or (math.pi / 8)
	
	local realDir = math.atan2(y2 - y1, x2 - x1)
	if realDir < 0 then realDir = realDir + (2 * math.pi) end
	
	local diff = dir - realDir
	
	return (math.abs(diff) < (threshold / 2))
end