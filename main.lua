love = require("love")

function love.load()
    player = require("player")
    engine = require("engine")
    degMath = require("degMath")
    map = require("map")
    settings = require("settings")
    colors = require("colors")
    spriteLoad = require("sprites.spriteLoad")
    projectile = require("projectile")

    love.mouse.setRelativeMode(true) -- makes the mouse not get out of the window
end

function love.draw()
    love.graphics.setBackgroundColor(colors.ceiling)

    love.graphics.setColor(colors.floor)
    love.graphics.rectangle("fill", 0, 300, 800, 300)

    engine.castRay()
    map.draw2D()
    player.render2D()
    player.renderGun()

    if player.game.debug then
        player.checkWall(player.x, player.y)

        love.graphics.setColor(0, 0, 0)
        love.graphics.print(love.timer.getFPS(), 0, 0)
    end
end

function love.update(dt)
    local moveSpeed = player.speed * dt
    local angleRad = math.rad(player.angleDeg)

    local moveX = 0
    local moveY = 0
    local forwardX = math.cos(angleRad)
    local forwardY = math.sin(angleRad)
    local sideX = math.cos(angleRad + math.rad(90))
    local sideY = math.sin(angleRad + math.rad(90))

    if love.keyboard.isDown("a") then
        moveX = moveX - sideX
        moveY = moveY - sideY
    elseif love.keyboard.isDown("d") then
        moveX = moveX + sideX
        moveY = moveY + sideY
    end

    if love.keyboard.isDown("w") then
        moveX = moveX + forwardX
        moveY = moveY + forwardY
    elseif love.keyboard.isDown("s") then
        moveX = moveX - forwardX
        moveY = moveY - forwardY
    end

    local normalisedVector = (moveX ^ 2 + moveY ^ 2) ^ 0.5
    if normalisedVector > 0 then
        --player.x = moveX + player.speed * dt
        --player.y = moveY + player.speed * dt

        moveX = player.x + (moveX * moveSpeed / normalisedVector)
        moveY = player.y + (moveY * moveSpeed / normalisedVector)

        local xMove = player.checkWall(moveX, player.y)
        local yMove = player.checkWall(player.x, moveY)

        local x = xMove and moveX or player.x
        local y = yMove and moveY or player.y

        player.x = x
        player.y = y

        player.gunNumDeg = player.gunNumDeg + 300 * dt
        player.gunNumDeg = degMath.fixDeg(player.gunNumDeg)
        player.weaponHeight = math.sin(math.rad(player.gunNumDeg)) * 30
    end

    if love.keyboard.isDown("space") and player.shootCooldown >= 0.5 then
        --bilboarding.createBilboard(spriteLoad.gun, player.x, player.y, -600)
        projectile.create(projectile.gun)
        player.shootCooldown = 0
    end

    player.shootCooldown = player.shootCooldown + dt
    projectile.move(dt)

    --[[
    if love.keyboard.isDown("a") then
        local sideAngle = angleRad - math.rad(90)

        local x = player.x + math.cos(sideAngle) * moveSpeed
        local y = player.y + math.sin(sideAngle) * moveSpeed

        local xMove = player.checkWall(x, player.y)
        local yMove = player.checkWall(player.x, y)

        x = xMove and x or player.x
        y = yMove and y or player.y

        player.x = x
        player.y = y
    elseif love.keyboard.isDown("d") then
        local sideAngle = angleRad + math.rad(90)

        local x = player.x + math.cos(sideAngle) * moveSpeed
        local y = player.y + math.sin(sideAngle) * moveSpeed

        local xMove = player.checkWall(x, player.y)
        local yMove = player.checkWall(player.x, y)

        x = xMove and x or player.x
        y = yMove and y or player.y

        player.x = x
        player.y = y
    end

    if love.keyboard.isDown("w") then
        local x = player.x + math.cos(angleRad) * moveSpeed
        local y = player.y + math.sin(angleRad) * moveSpeed

        local xMove = player.checkWall(x, player.y)
        local yMove = player.checkWall(player.x, y)

        x = xMove and x or player.x
        y = yMove and y or player.y

        player.x = x
        player.y = y
    elseif love.keyboard.isDown("s") then
        local x = player.x - math.cos(angleRad) * moveSpeed
        local y = player.y - math.sin(angleRad) * moveSpeed

        local xMove = player.checkWall(x, player.y)
        local yMove = player.checkWall(player.x, y)

        x = xMove and x or player.x
        y = yMove and y or player.y

        player.x = x
        player.y = y
    end]]

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