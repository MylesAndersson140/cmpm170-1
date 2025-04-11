-- main.lua
-- This is the entry point for your Love2D game

-- Require our Player class
local Player = require('src.entities.player')

function love.load()
    -- Initialize your game here
    -- This function runs once when the game starts
    
    -- Example: setting default game state
    gameState = "menu"
    
    -- Example: loading a font
    defaultFont = love.graphics.newFont(14)
    
    -- Set default color and font
    love.graphics.setFont(defaultFont)
    
    -- Create player instance
    player = Player.new(400, 300)
    
    -- Table to store circles
    circles = {}
    
    -- Initialize random seed
    math.randomseed(os.time())
end

function love.update(dt)
    -- Update game logic here
    -- This function runs every frame
    -- dt is "delta time" - the time since the last update in seconds
    
    -- Example: simple game state management
    if gameState == "menu" then
        updateMenu(dt)
    elseif gameState == "game" then
        updateGame(dt)
    end
end

function love.draw()
    -- Draw your game here
    -- This function runs every frame after update
    
    -- Example: simple game state management
    if gameState == "menu" then
        drawMenu()
    elseif gameState == "game" then
        drawGame()
    end
end

function love.keypressed(key)
    -- Handle key presses
    -- This function is called when a key is pressed
    
    -- Example: quit game with escape key
    if key == "escape" then
        love.event.quit()
    end
    
    -- Example: start game when space is pressed in menu
    if gameState == "menu" and key == "space" then
        gameState = "game"
    end
    
    -- Create a circle with random radius when 'e' is pressed during gameplay
    if gameState == "game" and key == "e" then
        createRandomCircle()
    end
end

-- Function to create a circle with random radius
function createRandomCircle()
    local circle = {
        x = love.math.random(50, love.graphics.getWidth() - 50),
        y = love.math.random(50, love.graphics.getHeight() - 50),
        radius = love.math.random(10, 50),
        color = {
            r = love.math.random(),
            g = love.math.random(),
            b = love.math.random(),
            a = 1
        }
    }
    
    table.insert(circles, circle)
end

-- Example: placeholder functions for different game states
function updateMenu(dt)
    -- Update menu logic
end

function updateGame(dt)
    -- Update game logic
end

function drawMenu()
    -- Draw menu
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("MY GAME", 400, 200)
    love.graphics.print("Press SPACE to start", 400, 250)
end

function drawGame()
    -- Draw game
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Game is running!", 400, 300)
end