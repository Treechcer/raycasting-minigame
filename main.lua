love = require("love")

function love.load()
    player = require("player")
    map = require("map")
    rays = require("rays")

    love.graphics.setBackgroundColor(0.5,0.5,0.5)
end

function love.draw()
    --love.graphics.setColor(0.2,0.3,0.7)
    --love.graphics.rectangle("fill", 0, 0, map.width, map.height / 2)

    --love.graphics.setColor(0.3,0.3,0.3)
    --love.graphics.rectangle("fill", 0, map.height / 2, map.width, map.height)

    rays.drawRays()
    --map.drawMap()
    --player.drawPlayer()
end

function love.update(dt)

    if player.deltaX == nil or player.deltaY == nil then
        player.deltaX = (math.cos(player.angle) * 50) * dt
        player.deltaY = (math.sin(player.angle) * 50) * dt
    end

    local xo = 0
    local yo = 0

    if player.deltaX < 0 then
        xo = -10
    else
        xo = 10
    end

    if player.deltaY < 0 then
        yo = -10
    else
        yo = 10
    end

    ipx = math.floor(player.x/64)
    ipxADD = math.floor((player.x + xo) / 64)
    ipxSUB = math.floor((player.x - xo) / 64)

    ipy = math.floor(player.y / 64)
    ipyADD = math.floor((player.y + yo) / 64)
    ipySUB = math.floor((player.y - yo) / 64)

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
        if map.mapW[ipy * map.mapX + ipxADD + 1] == 0 then
            player.x = player.x + player.deltaX
        end
        if map.mapW[ipyADD * map.mapX + ipx + 1] == 0 then
           player.y = player.y + player.deltaY
        end
    elseif love.keyboard.isDown("s") then
        if map.mapW[ipy * map.mapX + ipxSUB + 1] == 0 then
            player.x = player.x - player.deltaX
        end
        if map.mapW[ipySUB * map.mapX + ipx + 1] == 0 then
           player.y = player.y - player.deltaY
        end
    end

    if love.keyboard.isDown("e") then -- open door
        if player.deltaX < 0 then
            xo = -35
        else
            xo = 35
        end

        if player.deltaY < 0 then
            yo = -35
        else
            yo = 35
        end

        ipx = math.floor(player.x/64)
        ipxADD = math.floor((player.x + xo) / 64)

        ipy = math.floor(player.y / 64)
        ipyADD = math.floor((player.y + yo) / 64)

        if map.mapW[ipyADD * map.mapX + ipxADD + 1] == 4 then
            map.mapW[ipyADD * map.mapX + ipxADD + 1] = 0
        end
    end
end