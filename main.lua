-- main.lua
-- Entry point for the Love2D space game
-- Handles game state, entity updates, drawing, and procedural generation

-- Global variables
local planetCountSelected = 0
local buttons = {} -- UI buttons in the menu

-- Entity modules
local Enemy = require('src.entities.enemy')
local Player = require('src.entities.player')
local Wall = require('src.entities.wall')
local planets = {}

-- Game world objects
local walls = {}        -- Solid collision objects (including asteroids)
local asteroids = {}    -- Visual asteroid objects (drawn from asteroid.png)
local asteroidImage = love.graphics.newImage("src/assets/asteriod.png")

-- Game initialization
function love.load()
    love.window.setMode(800, 1000)
    love.window.setTitle("Starry Planet Generator")
    backgroundImage = love.graphics.newImage("src/assets/stars.png")

    gameState = "menu"

    player = Player.new(400, 300)
    enemy = Enemy.new(100, 100)
    circles = {} -- planets

    math.randomseed(os.time()) -- seed for procedural generation

    -- Button setup for choosing planet count
    buttons = {
        { text = "4 Planets", x = 350, y = 400, count = 4 },
        { text = "8 Planets", x = 350, y = 450, count = 8 },
        { text = "10 Planets", x = 350, y = 500, count = 10 }
    }
end

-- Main update loop
function love.update(dt)
    if gameState == "menu" then
        updateMenu(dt)
    elseif gameState == "game" then
        updateGame(dt)
    elseif gameState == "gameover" then
        updateGameOver(dt)
    end
end

-- Main draw loop
function love.draw()
    if gameState == "menu" then
        drawMenu()
    elseif gameState == "game" then
        drawGame()
    elseif gameState == "gameover" then
        drawGameOver()
    end
end

-- Key input handler
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

-- Mouse input for clicking planets or menu buttons
function love.mousepressed(x, y, button)
    if button == 1 then
        if gameState == "menu" then
            for _, btn in ipairs(buttons) do
                if x >= btn.x and x <= btn.x + 200 and y >= btn.y and y <= btn.y + 40 then
                    planetCountSelected = btn.count
                    startGame()
                    break
                end
            end
        elseif gameState == "game" then
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

-- Starts the actual game (planet and asteroid generation)
function startGame()
    gameState = "game"

    -- Generate planets
    circles = {}
    for i = 1, planetCountSelected do
        createRandomCircle()
    end

    -- Reset player/enemy position
    player = Player.new(400, 300)
    enemy = Enemy.new(100, 100)

    -- Add solid wall (example)
    walls = {}

    -- Generate random asteroid walls
    asteroids = {}
    createAsteroids(math.random(1, 4))
end

-- Planet generation
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
end

-- Generate solid asteroid objects that don't overlap planets
function createAsteroids(count)
    local scaledWidth = 48
    local scaledHeight = 48    

    for i = 1, count do
        local placed = false
        while not placed do
            local x = love.math.random(0, love.graphics.getWidth() - scaledWidth)
            local y = love.math.random(0, love.graphics.getHeight() - scaledHeight)
            local overlap = false
            for _, c in ipairs(circles) do
                local dist = math.sqrt((x - c.x)^2 + (y - c.y)^2)
                if dist < c.radius + scaledWidth / 2 then
                    overlap = true
                    break
                end
            end
            if not overlap then
                -- Store asteroid visual and its scaled size
                table.insert(asteroids, {x = x, y = y, width = scaledWidth, height = scaledHeight})
                -- Make wall exactly match this visual size
                table.insert(walls, Wall.new(x, y, scaledWidth, scaledHeight))
                placed = true
            end
        end
    end
end


-- Game update logic
function updateMenu(dt) end

function updateGame(dt)
    player:update(dt)
    enemy:update(dt, player,walls)

    -- Clamp player within screen
    player.x = math.max(0, math.min(player.x, love.graphics.getWidth() - player.width))
    player.y = math.max(0, math.min(player.y, love.graphics.getHeight() - player.height))

    -- Collision detection with walls
    for _, wall in ipairs(walls) do
        if player:collidesWith(wall) then
            wall:onCollision(player)
    
            -- Reset velocity
            player.vx = 0
            player.vy = 0
    
            -- Push the player out of the wall
            if player.x + player.width > wall.x and player.x < wall.x then
                player.x = wall.x - player.width
            elseif player.x < wall.x + wall.width and player.x > wall.x then
                player.x = wall.x + wall.width
            end
    
            if player.y + player.height > wall.y and player.y < wall.y then
                player.y = wall.y - player.height
            elseif player.y < wall.y + wall.height and player.y > wall.y then
                player.y = wall.y + wall.height
            end
        end
    end
    

    -- Stop enemy on asteroid collision
    for _, wall in ipairs(walls) do
        if enemy:collidesWith(wall) then
            wall:onCollision(enemy)
            enemy.vx = 0
            enemy.vy = 0
            enemy:update(-dt)
            end
    end


    -- Collision with enemy
    if player:collidesWith(enemy) then
        gameState = "gameover"
    end
end

function updateGameOver(dt) end

-- Game drawing logic
function drawMenu()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("STAR EXPLORER", 300, 150)
    love.graphics.print("Click below to start:", 300, 200)

    for _, btn in ipairs(buttons) do
        love.graphics.setColor(0.2, 0.2, 0.6)
        love.graphics.rectangle("fill", btn.x, btn.y, 200, 40)
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", btn.x, btn.y, 200, 40)
        love.graphics.printf(btn.text, btn.x, btn.y + 10, 200, "center")
    end
end

function drawGame()
    -- Draw background
    love.graphics.setColor(0.1, 0.1, 0.2)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    -- Draw tiled star background
    local windowWidth, windowHeight = love.graphics.getDimensions()
    local imgWidth, imgHeight = backgroundImage:getDimensions()
    love.graphics.setColor(1, 1, 1)
    for x = 0, windowWidth, imgWidth do
        for y = 0, windowHeight, imgHeight do
            love.graphics.draw(backgroundImage, x, y)
        end
    end

    -- Draw planets and rings
    for _, circle in ipairs(circles) do
        if circle.hasRing then
            love.graphics.setColor(circle.color.r, circle.color.g, circle.color.b, 0.4)
            love.graphics.ellipse("fill", circle.x, circle.y, circle.radius * 1.5, circle.radius * 0.5)
        end
        love.graphics.setColor(circle.color.r, circle.color.g, circle.color.b, circle.color.a)
        love.graphics.circle("fill", circle.x, circle.y, circle.radius)
        love.graphics.setColor(1, 1, 1)
        love.graphics.circle("line", circle.x, circle.y, circle.radius)

        for _, spot in ipairs(circle.spots) do
            love.graphics.setColor(circle.color.r * 0.5, circle.color.g * 0.5, circle.color.b * 0.5)
            love.graphics.circle("fill", circle.x + spot.x, circle.y + spot.y, spot.radius)
        end

        love.graphics.setColor(1, 1, 1)
        love.graphics.print(circle.name, circle.x - circle.radius / 2, circle.y + circle.radius + 10)
    end

    -- Draw asteroids
    for _, asteroid in ipairs(asteroids) do
        local scaleX = 32 / asteroidImage:getWidth()
        local scaleY = 32 / asteroidImage:getHeight()
        love.graphics.draw(asteroidImage, asteroid.x, asteroid.y, 0, scaleX, scaleY)
    end

    -- Draw walls (asteroid collision boxes)
    for _, wall in ipairs(walls) do
        wall:draw()
    end

    -- Draw player and enemy
    player:draw()
    enemy:draw()

    -- Hover UI for planets
    local hoverText = nil
    for _, circle in ipairs(circles) do
        local px = player.x + player.width / 2
        local py = player.y + player.height / 2
        local distance = math.sqrt((circle.x - px)^2 + (circle.y - py)^2)
        if distance < circle.radius then
            hoverText = "You are near " .. circle.name
            break
        end
    end
    if hoverText then
        love.graphics.setColor(1, 1, 0)
        love.graphics.print(hoverText, 20, 110)
    end

    -- UI text
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Game is running! Use WASD or arrow keys to move", 20, 20)
    love.graphics.print("Click on a planet to remove it", 20, 60)
    love.graphics.print("Planets created: " .. #circles, 20, 80)
end

function drawGameOver()
    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    love.graphics.setColor(1, 0, 0)
    love.graphics.printf("GAME OVER", 0, 300, love.graphics.getWidth(), "center")

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Press R to Retry or M to go to Main Menu", 0, 400, love.graphics.getWidth(), "center")
end
