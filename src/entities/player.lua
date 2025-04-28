-- Player class
-- Inherits from Entity

local shipImage = love.graphics.newImage("src/assets/ship.png")
local Entity = require('src.entities.entity')

local Player = {}
Player.__index = Player
setmetatable(Player, {__index = Entity})

function Player.new(x, y)
    local self = Entity.new(x, y, 15, 17) -- Ship body now 16x18, NOT 24 height anymore
    setmetatable(self, Player)

    -- Setup ship body frames (cropped to exclude fire)
    self.shipFrames = {
        idle = love.graphics.newQuad(33, 1, 15, 17, shipImage:getWidth(), shipImage:getHeight()),
        right1 = love.graphics.newQuad(65, 1, 15, 17, shipImage:getWidth(), shipImage:getHeight()),
        right2 = love.graphics.newQuad(81, 1, 15, 17, shipImage:getWidth(), shipImage:getHeight()),
        left1 = love.graphics.newQuad(17, 1, 15, 17, shipImage:getWidth(), shipImage:getHeight()),
        left2 = love.graphics.newQuad(1, 1, 15, 17, shipImage:getWidth(), shipImage:getHeight())
    }

    -- Setup fire (engine exhaust) frames
    self.fireFrames = {
        love.graphics.newQuad(36, 19, 9, 6, shipImage:getWidth(), shipImage:getHeight()), -- frame 1
        love.graphics.newQuad(36, 43, 9, 6, shipImage:getWidth(), shipImage:getHeight())  -- frame 2
    }

    -- Current active frames
    self.currentFrame = self.shipFrames.idle
    self.currentFireFrame = self.fireFrames[1]

    -- State tracking
    self.currentAnimState = "idle"

    -- Fire animation timing
    self.fireAnimationTimer = 0
    self.fireAnimationSpeed = 0.1 -- How fast fire flickers
    self.fireToggle = false

    return self
end

function Player:update(dt)
    Entity.update(self, dt)
    self:handleInput(dt)

    -- Animate fire flickering
    self.fireAnimationTimer = self.fireAnimationTimer + dt
    if self.fireAnimationTimer >= self.fireAnimationSpeed then
        self.fireAnimationTimer = self.fireAnimationTimer - self.fireAnimationSpeed
        self.fireToggle = not self.fireToggle
    end

    -- Set current fire frame
    self.currentFireFrame = self.fireToggle and self.fireFrames[1] or self.fireFrames[2]
end

function Player:handleInput(dt)
    -- Reset velocity
    self.vx = 0
    self.vy = 0

    local speed = 200
    local movedHorizontally = false

    -- Handle horizontal input
    if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
        self.vx = -speed
        self.currentAnimState = "left"
        movedHorizontally = true
    elseif love.keyboard.isDown('right') or love.keyboard.isDown('d') then
        self.vx = speed
        self.currentAnimState = "right"
        movedHorizontally = true
    end

    -- Handle vertical input
    if love.keyboard.isDown('up') or love.keyboard.isDown('w') then
        self.vy = -speed
    end

    if love.keyboard.isDown('down') or love.keyboard.isDown('s') then
        self.vy = speed
    end

    -- Stay idle if no left/right
    if not movedHorizontally then
        self.currentAnimState = "idle"
    end

    -- Set ship body frame based on state
    if self.currentAnimState == "idle" then
        self.currentFrame = self.shipFrames.idle
    elseif self.currentAnimState == "left" then
        self.currentFrame = self.shipFrames.left1
    elseif self.currentAnimState == "right" then
        self.currentFrame = self.shipFrames.right1
    end
end

function Player:draw()
    love.graphics.setColor(1, 1, 1)

    -- Draw ship body (without flame)
    love.graphics.draw(
        shipImage,
        self.currentFrame,
        self.x,
        self.y,
        0,
        2, 2 -- Scale
    )

    -- Draw fire below ship
    love.graphics.draw(
        shipImage,
        self.currentFireFrame,
        self.x + 10,  -- Center fire under ship (fine tune if needed)
        self.y + 36,  -- Just under ship body (scaled)
        0,
        2, 2
    )
end

return Player
