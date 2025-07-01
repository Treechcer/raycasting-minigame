love = require("love")

function love.load()
    player = require("player")
    engine = require("engine")
    degMath = require("degMath")
    map = require("map")
end

function love.draw()
    love.graphics.setBackgroundColor(20 / 255, 0, 20 / 255)

    love.graphics.setColor(60 / 255, 0, 60 / 255)
    love.graphics.rectangle("fill", 0, 300, 800, 300)

    engine.castRay()
    map.draw2D()
    player.render2D()
end

function love.update(dt)
    local moveSpeed = player.speed * dt
    if love.keyboard.isDown("a") then
        player.angleDeg = player.angleDeg - 90 * dt
    elseif love.keyboard.isDown("d") then
        player.angleDeg = player.angleDeg + 90 * dt
    end

    local angleRad = math.rad(player.angleDeg)
    if love.keyboard.isDown("w") then
        player.x = player.x + math.cos(angleRad) * moveSpeed * dt
        player.y = player.y + math.sin(angleRad) * moveSpeed * dt
    elseif love.keyboard.isDown("s") then
        player.x = player.x - math.cos(angleRad) * moveSpeed * dt
        player.y = player.y - math.sin(angleRad) * moveSpeed * dt
    end
end