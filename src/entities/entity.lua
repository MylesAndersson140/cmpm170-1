-- Entity class
-- Base class for game objects

local Entity = {}
Entity.__index = Entity

function Entity.new(x, y, width, height)
    local self = setmetatable({}, Entity)
    
    -- Position
    self.x = x or 0
    self.y = y or 0
    
    -- Dimensions
    self.width = width or 32
    self.height = height or 32
    
    -- Velocity
    self.vx = 0
    self.vy = 0
    
    -- Ensures the player can see the entity, and we are able to modify it.
    self.visible = true
    self.active = true
    
    return self
end

function Entity:update(dt)
    -- Base update logic
    if not self.active then return end
    
    -- Update position based on velocity
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt
end

function Entity:draw()
    -- Base drawing logic
    if not self.visible then return end

    -- For debugging, draw a rectangle representing the entity
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end

-- Helper functions that may come in handy later.
function Entity:getPosition()
    return self.x, self.y
end

function Entity:setPosition(x, y)
    self.x = x
    self.y = y
end

function Entity:getBounds()
    return {
        x = self.x,
        y = self.y,
        width = self.width,
        height = self.height
    }
end

-- Simple AABB collision detection
function Entity:collidesWith(other)
    return self.x < other.x + other.width and
           self.x + self.width > other.x and
           self.y < other.y + other.height and
           self.y + self.height > other.y
end

return Entity