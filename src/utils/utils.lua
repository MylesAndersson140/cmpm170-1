-- Utils.lua
-- Utility functions for your game

local Utils = {}

-- Check if a point is inside a rectangle
function Utils.pointInRect(px, py, rx, ry, rw, rh)
    return px >= rx and px <= rx + rw and py >= ry and py <= ry + rh
end

-- Get distance between two points
function Utils.distance(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

-- Clamp a value between a min and max
function Utils.clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

-- Linear interpolation
function Utils.lerp(a, b, t)
    return a + (b - a) * t
end

-- Random number in range
function Utils.random(min, max)
    return min + math.random() * (max - min)
end

-- Check if table contains value
function Utils.contains(table, value)
    for _, v in pairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

-- Deep copy a table
function Utils.deepCopy(original)
    local copy
    if type(original) == "table" then
        copy = {}
        for k, v in pairs(original) do
            copy[k] = Utils.deepCopy(v)
        end
    else
        copy = original
    end
    return copy
end

return Utils