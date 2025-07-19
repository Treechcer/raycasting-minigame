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
    audio = require("sounds.audio")
    enemies = require("game.enemy.enemies")
    inventory = require("game.renderNstore.inventory")
    console = require("UINreletad.console")

    love.mouse.setRelativeMode(true) -- makes the mouse not get out of the window

    map.random()
end

function love.draw()

    love.graphics.setCanvas(game.canvas)
    love.graphics.clear()

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

    -- this is temporary for drawing floors and ceilings, I'll add proper ones one day

    love.graphics.setBackgroundColor(colors.ceiling)

    love.graphics.setColor(colors.floor)
    love.graphics.rectangle("fill", 0, 300, 800, 300)

    --

    -- These functions are here to draw everything in the "game loop", 2D map, gun etc.
    
    engine.castRay()
    map.draw2D()
    player.render2D()
    player.renderGun()
    player.renderCrosshair()
    inventory.draw()
    projectile.enemyHit()

    if console.active then
        console.drawConsole()
    end

    --
    if game.debug then -- some debug values will be displayed or done, for normal playthrough it'll be off
        player.checkWall(player.x, player.y)

        love.graphics.setColor(colors.black)
        love.graphics.print(love.timer.getFPS(), 200, 200)
    end

    love.graphics.setColor(1,1,1)
    love.graphics.setCanvas()
    love.graphics.draw(game.canvas, 0, 0)
end

function love.update(dt)
    --some needed variables
    player.angleMovDeg = 0
    local moveSpeed = player.speed * dt
    local angleRad = math.rad(player.angleDeg)

    local moveX = 0
    local moveY = 0
    local forwardX = math.cos(angleRad)
    local forwardY = math.sin(angleRad)
    local sideX = math.cos(angleRad + math.rad(90)) -- these two variables are here if player wants to walk to left / right, we just ratate the angle of played by 90°
    local sideY = math.sin(angleRad + math.rad(90))
    
    if love.keyboard.isDown("e") then -- temp. test for spawning enemies
        enemies.create("small", player.x, player.y, 0)
    end

    if love.keyboard.isDown("a") then -- these inputs make some movement for the player, if it'll be possible which is determined few lines down
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

    local normalisedVector = (moveX ^ 2 + moveY ^ 2) ^ 0.5 -- we normalise the vector, so we will walk the same speed if we go more than one dirrection
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
        --player.weaponHeight = math.sin(math.rad(player.gunNumDeg)) * 30
    end

    if love.keyboard.isDown("space") and player.shootCooldown >= 0.5 then -- this is for shooting, temporary it's on space
        --bilboarding.createBilboard(spriteLoad.gun, player.x, player.y, -600)
        if inventory.gunSlots[inventory.equipedGunSlot] == "gun" then
            projectile.create(projectile.gun)
        elseif inventory.gunSlots[inventory.equipedGunSlot] == "pickaxe" then
            engine.pickaxe()
        end
        player.shootCooldown = 0
    end

    -- here we open and close the console, you can't write to the console yet

    if love.keyboard.isDown("t") and console.lastOpen >= console.consoleCD then
        console.active = not console.active
        console.lastOpen = 0
    end

    --

    -- here are called functions for cooldown time reset and for enemy behaviour

    enemies.behavior()
    cooldows(dt)

    --

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

    if love.keyboard.isDown("q") then -- Q is for Quit!
        love.event.quit()
    end

    --[[if love.mouse.getX() >= width/2 + 10 then
        player.angleDeg = player.angleDeg + 90 * dt
        --love.mouse.setX(width/2)
    elseif love.mouse.getX() <= width/2 - 10 then
        player.angleDeg = player.angleDeg - 90 * dt
        --love.mouse.setX(width/2)
    end]]
end

function love.mousemoved(x, y, dx, dy) -- here we change where the player looks
    player.angleDeg = player.angleDeg + dx * settings.sensitivity
    player.angleDeg = degMath.fixDeg(player.angleDeg)

    love.mouse.setX(dx)
end

function love.wheelmoved(x, y) -- this is for changing the weapon we have equiped
    if y > 0 and inventory.scrollCooldown >= 0.5 then
        if inventory.equipedGunSlot < #inventory.gunSlots then
            inventory.scrollCooldown = 0
            inventory.equipedGunSlot = inventory.equipedGunSlot + 1
        end
    elseif y < 0 and inventory.scrollCooldown >= 0.5 then
        if inventory.equipedGunSlot > 1 then
            inventory.scrollCooldown = 0
            inventory.equipedGunSlot = inventory.equipedGunSlot - 1
        end
    end
end

function cooldows(dt)
    player.cooldwonChange(dt)
    projectile.move(dt)
    enemies.colldown(dt)
    console.CD(dt)
end