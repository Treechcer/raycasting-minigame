love = require("love")

function love.load()
    player = require("player")
    map = require("map")
    rays = require("rays")
end

function love.draw()
    rays.drawRays()
    map.drawMap()
    player.drawPlayer()
end

function love.update(dt)

    if player.deltaX == nil or player.deltaY == nil then
        player.deltaX = (math.cos(player.angle) * 50) * dt
        player.deltaY = (math.sin(player.angle) * 50) * dt
    end

    local xo = 0
    local yo = 0

    if player.deltaX < 0 then
        xo = -40
    else
        xo = 40
    end

    if player.deltaY < 0 then
        yo = -40
    else
        yo = 40
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
        if map.map[ipy * map.mapX + ipxADD] == 0 then
            player.x = player.x + player.deltaX
        end
        if map.map[ipyADD * map.mapX + ipx] == 0 then
           player.y = player.y + player.deltaY
        end
    elseif love.keyboard.isDown("s") then
        if map.map[ipy * map.mapX + ipxSUB] == 0 then
            player.x = player.x - player.deltaX
        end
        if map.map[ipySUB * map.mapX + ipx] == 0 then
           player.y = player.y - player.deltaY
        end
    end
end