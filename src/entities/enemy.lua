-- Enemy class
-- Inherits from Entity

local shipImage = love.graphics.newImage("src/assets/ship.png")
local Entity = require('src.entities.entity')
local Utils = require('src.utils.utils') -- for distance calculations

local Enemy = {}
Enemy.__index = Enemy
setmetatable(Enemy, {__index = Entity})

function Enemy.new(x, y)
    local self = Entity.new(x, y, 15, 17)
    setmetatable(self, Enemy)

    self.speed = 100 -- Enemy move speed

    -- Use a simple idle frame for now
    self.frame = love.graphics.newQuad(33, 1, 15, 17, shipImage:getWidth(), shipImage:getHeight())

    return self
end

function Enemy:update(dt, target)
    Entity.update(self, dt)

    -- Chase the target (player)
    local dx = target.x - self.x
    local dy = target.y - self.y
    local distance = Utils.distance(self.x, self.y, target.x, target.y)

    if distance > 1 then -- Avoid jitter when very close
        local dirX = dx / distance
        local dirY = dy / distance

        self.vx = dirX * self.speed
        self.vy = dirY * self.speed
    else
        self.vx = 0
        self.vy = 0
    end
end

function Enemy:draw()
    love.graphics.setColor(1, 0, 0) -- Enemy tinted red
    love.graphics.draw(shipImage, self.frame, self.x, self.y, 0, 2, 2)
end

return Enemy
