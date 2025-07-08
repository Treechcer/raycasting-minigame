love = require("love")

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    
    player = require("game.properties.player")
    engine = require("game.renderNstore.engine")
    degMath = require("math.degMath")
    map = require("game.properties.map")
    settings = require("UINreletad.settings")
    colors = require("UINreletad.colors")
    spriteLoad = require("sprites.spriteLoad")
    projectile = require("game.renderNstore.projectile")
    noise = require("math.noise")
    gunStats = require("game.properties.gunStats")

    love.mouse.setRelativeMode(true) -- makes the mouse not get out of the window

    map.random()
end

function love.draw()

    --[[map.random()

    t = noise.generateMap()
    x = 1
    y = 1
    for i = 1, #t do
        local x = ((i - 1) % map.lenght)
        local y = math.floor((i - 1) / map.lenght)
        local value = t[i]

        love.graphics.setColor(value, value, value)
        love.graphics.rectangle("fill", x * 5, y * 5, 5, 5)
    end]]

    love.graphics.setBackgroundColor(colors.ceiling)

    love.graphics.setColor(colors.floor)
    love.graphics.rectangle("fill", 0, 300, 800, 300)

    engine.castRay()
    map.draw2D()
    player.render2D()
    player.renderGun()
    player.renderCrosshair()

    if game.debug then
        player.checkWall(player.x, player.y)

        love.graphics.setColor(colors.black)
        love.graphics.print(love.timer.getFPS(), 0, 0)
    end
end

function love.update(dt)
    player.angleMovDeg = 0
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
        player.angleMovDeg = -19.5
    elseif love.keyboard.isDown("d") then
        moveX = moveX + sideX
        moveY = moveY + sideY
        player.angleMovDeg = 19.5
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
        if player.gunSlots[player.equipedGunSlot] == "gun" then
            projectile.create(projectile.gun)
        elseif player.gunSlots[player.equipedGunSlot] == "pickaxe" then
            engine.pickaxe()
        end
        player.shootCooldown = 0
    end

    player.cooldwonChange(dt)
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

function love.wheelmoved(x, y)
    if y > 0 and player.scrollCooldown >= 0.5 then
        if player.equipedGunSlot < #player.gunSlots then
            player.scrollCooldown = 0
            player.equipedGunSlot = player.equipedGunSlot + 1
        end
    elseif y < 0 and player.scrollCooldown >= 0.5 then
        if player.equipedGunSlot > 1 then
            player.scrollCooldown = 0
            player.equipedGunSlot = player.equipedGunSlot - 1
        end
    end
end