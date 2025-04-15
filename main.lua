-- main.lua
-- This is the entry point for your Love2D game

-- Require our Player class
local Player = require('src.entities.player')
local planets = {}

function love.load()
    -- Initialize your game here
    -- This function runs once when the game starts
    
    love.window.setMode(800, 1000) -- width, height in pixels
    love.window.setTitle("Starry Planet Generator")
    backgroundImage = love.graphics.newImage("src/assets/stars.png")
    
    -- Example: setting default game state
    gameState = "menu"
    
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

-- Mouse click handling to remove circles
function love.mousepressed(x, y, button)
    if gameState == "game" and button == 1 then -- Left mouse button
        -- Check if we clicked on any circle
        for i = #circles, 1, -1 do -- Iterate backwards to safely remove
            local circle = circles[i]
            local distance = math.sqrt((circle.x - x)^2 + (circle.y - y)^2)
            
            if distance <= circle.radius then
                -- Remove the circle if clicked
                table.remove(circles, i)
                break -- Exit after removing one circle
            end
        end
    end
end

-- Function to create a circle with random radius
function createRandomCircle()
    local circle = {
        x = love.math.random(50, love.graphics.getWidth() - 50),
        y = love.math.random(50, love.graphics.getHeight() - 50),
        radius = love.math.random(20, 100),
        color = {
            r = love.math.random(),
            g = love.math.random(),
            b = love.math.random(),
            a = 1
        },
        hasRing = math.random() > 0.6,
        name = "Planet " .. tostring(math.random(100, 9999))
    }

    local spots = {}
        for s = 1, math.random(3, 6) do
            local angle = math.random() * 2 * math.pi
            local dist = math.random() * circle.radius * 0.8
            local spotX = math.cos(angle) * dist
            local spotY = math.sin(angle) * dist
            local spotRadius = math.random(2, 5)
            table.insert(spots, {x = spotX, y = spotY, radius = spotRadius})
        end
        circle.spots = spots
    
    table.insert(circles, circle)
    print("Circle created! Total circles: " .. #circles) -- Debug output
end

-- Example: placeholder functions for different game states
function updateMenu(dt)
    -- Update menu logic
end

function updateGame(dt)
    -- Update game logic
    player:update(dt)
end

function drawMenu()
    -- Draw menu
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("MY GAME", 400, 200)
    love.graphics.print("Press SPACE to start", 400, 250)
end

function drawGame()
    -- Draw game background
    love.graphics.setColor(0.1, 0.1, 0.2)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    local windowWidth, windowHeight = love.graphics.getDimensions()
    local imgWidth, imgHeight = backgroundImage:getDimensions()

    love.graphics.setColor(1, 1, 1)
    for x = 0, windowWidth, imgWidth do
        for y = 0, windowHeight, imgHeight do
            love.graphics.draw(backgroundImage, x, y)
        end
    end
    
    -- Draw all circles
    for _, circle in ipairs(circles) do
        -- draw the ring first (behind the planet)
        if circle.hasRing then
            love.graphics.setColor(circle.color.r, circle.color.g, circle.color.b, 0.4)
            love.graphics.ellipse("fill", circle.x, circle.y, circle.radius * 1.5, circle.radius * 0.5)
        end
        love.graphics.setColor(circle.color.r, circle.color.g, circle.color.b, circle.color.a)
        love.graphics.circle("fill", circle.x, circle.y, circle.radius)
        love.graphics.setColor(1, 1, 1)
        love.graphics.circle("line", circle.x, circle.y, circle.radius)
        -- Draw the spots
        for _, spot in ipairs(circle.spots) do
            love.graphics.setColor(circle.color.r * 0.5, circle.color.g * 0.5,
                                   circle.color.b * 0.5)
            love.graphics.circle("fill", circle.x + spot.x, circle.y + spot.y,
                                 spot.radius)
        end

        -- Draw name
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(circle.name, circle.x - circle.radius/2,
                            circle.y + circle.radius + 10)
    end
    
    -- Draw game objects
    player:draw()
    
    -- Check for nearby planets
    local hoverText = nil
    for _, circle in ipairs(circles) do
        local playerCenterX = player.x + player.width / 2
        local playerCenterY = player.y + player.height / 2
        local distance = math.sqrt((circle.x - playerCenterX)^2 + (circle.y - playerCenterY)^2)
    
        if distance < circle.radius then
            hoverText = "You are near " .. circle.name
            break
        end
    end

    -- Show hover message if applicable
    if hoverText then
        love.graphics.setColor(1, 1, 0)
        love.graphics.print(hoverText, 20, 110)
    end


    -- Draw UI
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Game is running! Use WASD or arrow keys to move", 20, 20)
    love.graphics.print("Press 'E' to create a random circle", 20, 40)
    love.graphics.print("Click on a circle to remove it", 20, 60)
    love.graphics.print("Circles created: " .. #circles, 20, 80)
end