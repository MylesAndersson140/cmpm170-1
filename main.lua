-- main.lua
-- This is the entry point for your Love2D game

-- Require our Player class
local planetCountSelected = 0
local buttons = {} -- new

local Enemy = require('src.entities.enemy')
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
    enemy = Enemy.new(100, 100) -- spawn at some position

    
    -- Table to store circles
    circles = {}
    
    -- Initialize random seed
    math.randomseed(os.time())

    buttons = {
        { text = "4 Planets", x = 350, y = 400, count = 4 },
        { text = "8 Planets", x = 350, y = 450, count = 8 },
        { text = "10 Planets", x = 350, y = 500, count = 10 }
    }
    
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
    elseif gameState == "gameover" then
        updateGameOver(dt)
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
    elseif gameState == "gameover" then
        drawGameOver()
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

    if gameState == "menu" and key == "space" then
        gameState = "game"
    elseif gameState == "gameover" then
        if key == "r" then
            startGame()
        elseif key == "m" then
            gameState = "menu"
        end
    end
end



-- Mouse click handling to remove circles
function love.mousepressed(x, y, button)
    if button == 1 then -- Left click
        if gameState == "menu" then
            -- Check if clicked on a button
            for _, btn in ipairs(buttons) do
                if x >= btn.x and x <= btn.x + 200 and y >= btn.y and y <= btn.y + 40 then
                    planetCountSelected = btn.count
                    startGame()
                    break
                end
            end
        elseif gameState == "game" then
            -- Check if clicked on a planet
            for i = #circles, 1, -1 do
                local circle = circles[i]
                local distance = math.sqrt((circle.x - x)^2 + (circle.y - y)^2)
                
                if distance <= circle.radius then
                    table.remove(circles, i)
                    break
                end
            end
        end
    end
end

function startGame()
    gameState = "game"

    -- Reset planets
    circles = {}
    for i = 1, planetCountSelected do
        createRandomCircle()
    end

    -- Create fresh player and enemy
    player = Player.new(400, 300)   -- spawn player back to center
    enemy = Enemy.new(100, 100)     -- spawn enemy somewhere away
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
    enemy:update(dt, player) -- Pass the player so the enemy can chase\

    if player:collidesWith(enemy) then
        gameState = "gameover"
    end
end

function updateGameOver(dt)
    -- No logic needed for now
end

function drawMenu()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("STAR EXPLORER", 300, 150)
    love.graphics.print("Click below to start:", 300, 200)

    -- Draw buttons
    for _, btn in ipairs(buttons) do
        love.graphics.setColor(0.2, 0.2, 0.6)
        love.graphics.rectangle("fill", btn.x, btn.y, 200, 40)
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", btn.x, btn.y, 200, 40)
        love.graphics.printf(btn.text, btn.x, btn.y + 10, 200, "center")
    end
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
    enemy:draw()
    
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
    love.graphics.print("Click on a circle to remove it", 20, 60)
    love.graphics.print("Circles created: " .. #circles, 20, 80)
end

function drawGameOver()
    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    love.graphics.setColor(1, 0, 0)
    love.graphics.printf("GAME OVER", 0, 300, love.graphics.getWidth(), "center")

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Press R to Retry or M to go to Main Menu", 0, 400, love.graphics.getWidth(), "center")
end
