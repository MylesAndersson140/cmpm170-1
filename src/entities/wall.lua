-- Wall class
-- Defines solid entities that block movement, like asteroids or barriers

local Entity = require('src.entities.entity')
local asteroidImage = love.graphics.newImage("src/assets/asteriod.png")

local Wall = {}
Wall.__index = Wall
setmetatable(Wall, { __index = Entity })

-- Wall constructor
-- x, y: position
-- width, height: size of the wall
-- type: optional, "standard", "damaging", "breakable"
function Wall.new(x, y, width, height, type)
    local self = Entity.new(x, y, width, height)
    setmetatable(self, Wall)

    self.type = type or "standard"
    self.image = asteroidImage
    self.isVisible = true -- used to optionally hide boundary walls
    self.damage = (self.type == "damaging") and 10 or 0
    self.destructible = (self.type == "breakable")

    return self
end

-- Optional: handle logic when an entity collides with the wall
function Wall:onCollision(entity)
    if self.damage > 0 and entity.takeDamage then
        entity:takeDamage(self.damage)
    end
end

-- Drawing function
function Wall:draw()
    if not self.isVisible then return end

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.image, self.x, self.y, 0,
        self.width / self.image:getWidth(),
        self.height / self.image:getHeight())
end

return Wall
