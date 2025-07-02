love = require("love")

function love.load()
    player = require("player")
    engine = require("engine")
    degMath = require("degMath")
    map = require("map")
    settings = require("settings")
    colors = require("colors")

    love.mouse.setRelativeMode(true) -- makes the mouse not get out of the window
end

function love.draw()
    love.graphics.setBackgroundColor(colors.ceiling)

    love.graphics.setColor(colors.floor)
    love.graphics.rectangle("fill", 0, 300, 800, 300)

    engine.castRay()
    map.draw2D()
    player.render2D()
    player.checkWall(player.x, player.y)
end

function love.update(dt)
    local moveSpeed = player.speed * dt
    local angleRad = math.rad(player.angleDeg)
    
    if love.keyboard.isDown("a") then
        local sideAngle = angleRad - math.rad(90)

        local x = player.x + math.cos(sideAngle) * moveSpeed
        local y = player.y + math.sin(sideAngle) * moveSpeed

        if player.checkWall(x,y) then
            player.x = x
            player.y = y
        end
    elseif love.keyboard.isDown("d") then
        local sideAngle = angleRad + math.rad(90)

        local x = player.x + math.cos(sideAngle) * moveSpeed
        local y = player.y + math.sin(sideAngle) * moveSpeed

        if player.checkWall(x,y) then
            player.x = x
            player.y = y
        end
    end

    if love.keyboard.isDown("w") then
        local x = player.x + math.cos(angleRad) * moveSpeed
        local y = player.y + math.sin(angleRad) * moveSpeed

        if player.checkWall(x,y) then
            player.x = x
            player.y = y
        end
    elseif love.keyboard.isDown("s") then
        local x = player.x - math.cos(angleRad) * moveSpeed
        local y = player.y - math.sin(angleRad) * moveSpeed

        if player.checkWall(x,y) then
            player.x = x
            player.y = y
        end
    end

    if love.keyboard.isDown("q") then
        love.event.quit() --for ending the game
    end

    --[[if love.mouse.getX() >= width/2 + 10 then
        player.angleDeg = player.angleDeg + 90 * dt
        --love.mouse.setX(width/2)
    elseif love.mouse.getX() <= width/2 - 10 then
        player.angleDeg = player.angleDeg - 90 * dt
        --love.mouse.setX(width/2)
    end]]
end

function love.mousemoved(x, y, dx, dy)
    player.angleDeg = player.angleDeg + dx * settings.sensitivity
    player.angleDeg = degMath.fixDeg(player.angleDeg)

    love.mouse.setX(dx)
end