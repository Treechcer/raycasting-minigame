love = require("love")

function love.load()
    player = require("player")
    map = require("map")
    rays = require("rays")
end

function love.draw()
    map.drawMap()
    rays.drawRays()
    player.drawPlayer()
end

function love.update(dt)

    if player.deltaX == nil or player.deltaY == nil then
        player.deltaX = (math.cos(player.angle) * 50) * dt
        player.deltaY = (math.sin(player.angle) * 50) * dt
    end

    if love.keyboard.isDown("a") then
        player.angle = player.angle - (3 * dt)
        if player.angle < 0 then
            player.angle = 2 * math.pi
        end

        player.deltaX = (math.cos(player.angle) * 50) * dt
        player.deltaY = (math.sin(player.angle) * 50) * dt
    elseif love.keyboard.isDown("d") then
        player.angle = player.angle + (3 * dt)
        if player.angle > 2 * math.pi then
            player.angle = 0
        end

        player.deltaX = (math.cos(player.angle) * 50) * dt
        player.deltaY = (math.sin(player.angle) * 50) * dt
    end
    if love.keyboard.isDown("w") then
        player.x = player.x + player.deltaX
        player.y = player.y + player.deltaY
    elseif love.keyboard.isDown("s") then
        player.x = player.x - player.deltaX
        player.y = player.y - player.deltaY
    end
end