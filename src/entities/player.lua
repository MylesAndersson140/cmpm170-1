-- Player class
-- Inherits from Entity

local rocketImage = love.graphics.newImage("src/assets/rocket.png")
local Entity = require('src.entities.entity')

local Player = {}
Player.__index = Player
setmetatable(Player, {__index = Entity}) -- Inheritance

function Player.new(x, y)
    local self = Entity.new(x, y, 32, 48) -- Call parent constructor
    return setmetatable(self, Player)
end

function Player:update(dt)
    -- Call parent update method
    Entity.update(self, dt)
    
    -- Player-specific update logic
    self:handleInput(dt)
end

function Player:handleInput(dt)
    -- Reset velocity
    self.vx = 0
    self.vy = 0
    
    -- Move based on keyboard input
    local speed = 200 -- pixels per second
    
    if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
        self.vx = -speed
    end
    
    if love.keyboard.isDown('right') or love.keyboard.isDown('d') then
        self.vx = speed
    end
    
    if love.keyboard.isDown('up') or love.keyboard.isDown('w') then
        self.vy = -speed
    end
    
    if love.keyboard.isDown('down') or love.keyboard.isDown('s') then
        self.vy = speed
    end
end

function Player:draw()
    -- Custom player drawing
    love.graphics.setColor(1, 1, 1) -- Reset color
    love.graphics.draw(rocketImage, self.x, self.y, 0, 0.5, 0.5) -- scales to 50%
end

return Player