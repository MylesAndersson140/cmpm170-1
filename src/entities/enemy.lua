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

    self.speed = 60 -- Enemy move speed

    -- Use a simple idle frame for now
    self.frame = love.graphics.newQuad(33, 1, 15, 17, shipImage:getWidth(), shipImage:getHeight())

    return self
end

function Enemy:update(dt, target, walls)
    if not target then return end

    local dx = target.x - self.x
    local dy = target.y - self.y
    local distance = Utils.distance(self.x, self.y, target.x, target.y)

    if distance > 1 then
        local dirX = dx / distance
        local dirY = dy / distance

        -- Save original position
        local originalX, originalY = self.x, self.y

        -- Try full movement (diagonal)
        self.vx = dirX * self.speed
        self.vy = dirY * self.speed
        Entity.update(self, dt)

        local collided = false
        for _, wall in ipairs(walls) do
            if self:collidesWith(wall) then
                collided = true
                break
            end
        end

        if collided then
            -- Revert to original position
            self.x, self.y = originalX, originalY

            -- Try X only
            self.vx = dirX * self.speed
            self.vy = 0
            Entity.update(self, dt)

            collided = false
            for _, wall in ipairs(walls) do
                if self:collidesWith(wall) then
                    collided = true
                    break
                end
            end

            if collided then
                self.x, self.y = originalX, originalY

                -- Try Y only
                self.vx = 0
                self.vy = dirY * self.speed
                Entity.update(self, dt)

                collided = false
                for _, wall in ipairs(walls) do
                    if self:collidesWith(wall) then
                        collided = true
                        break
                    end
                end

                if collided then
                    -- Everything failed, revert
                    self.x, self.y = originalX, originalY
                    self.vx = 0
                    self.vy = 0
                end
            end
        end
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
