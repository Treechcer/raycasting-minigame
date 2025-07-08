player = {
    x = 100,
    y = 100,
    angleDeg = 0,
    speed = 100,
    size = 30,
    fov = 90,
    angleMovDeg = 0,

    weaponHeight = 0,
    weaponWidth = 0,
    gunNumDeg = 0,
    shootCooldown = 10000, -- makes it that player can shoot, because of course the cooldown won¨t be more like 1s or whatever... yes this number is in seconds

    equipedGunSlot = 1,
    gunSlots = {"gun", "pickaxe", "granade"},
    scrollCooldown = 10000,
}

local map = require("game.properties.map")
local spriteLoad = require("sprites.spriteLoad")
local gunStats = require("game.properties.gunStats")

function player.render2D()
    local tileX = math.floor(player.x / map.block2DSize)
    local tileY = math.floor(player.y / map.block2DSize)

    local blockSizeX = map.miniMapSize / map.lenght
    local blockSizeY = map.miniMapSize / map.height

    love.graphics.setColor(colors.yellow)
    love.graphics.rectangle("fill", (tileX) * blockSizeX + 1, (tileY) * blockSizeY + 1, blockSizeX - 1, blockSizeY - 1)    --love.graphics.line((tileX * map.block2DSize / 3) + (player.size / 6), (tileY * map.block2DSize / 3) + (player.size / 6), (tileX * map.block2DSize / 3) + (math.cos(math.rad(player.angleDeg)) * 20), (tileY * map.block2DSize / 3) + (math.sin(math.rad(player.angleDeg)) * 20))

    local startX = tileX * blockSizeX + blockSizeX / 2
    local startY = tileY * blockSizeY + blockSizeY / 2
    local endX = startX + math.cos(math.rad(player.angleDeg)) * 5
    local endY = startY + math.sin(math.rad(player.angleDeg)) * 5

    love.graphics.line(startX, startY, endX, endY)
end

function player.checkWall(x, y)
    local offset = 5
    for dx = -offset, offset, 5 do
        for dy = -offset, offset, 5 do
            local checkX = x + dx
            local checkY = y + dy

            local tileX = math.floor(checkX / map.block2DSize)
            local tileY = math.floor(checkY / map.block2DSize)

            local index = tileY * map.lenght + tileX + 1

            if game.debug then
                love.graphics.print(map.map[index], 150, 0) 
            end

            if map.map[index] >= 1 then
                return false
            end
        end
    end

    return true
end

function player.renderGun()
    love.graphics.setColor(colors.white)
    width, height = love.graphics.getDimensions()
    local tempPath = player.gunSlots[player.equipedGunSlot]
    love.graphics.draw(spriteLoad[tempPath], width / 3 + gunStats[tempPath].xOffset, height / 1.3 + gunStats[tempPath].yOffset, 0, 1 * gunStats[tempPath].weaponWidth, 1 * gunStats[tempPath].weaponHeight)
end

function player.renderCrosshair()
    love.graphics.setColor(colors.crosshair)
    love.graphics.rectangle("fill", game.width / 2, game.height / 2, 5, 5)
end

function player.cooldwonChange(dt)
    player.shootCooldown = player.shootCooldown + dt
    player.scrollCooldown = player.scrollCooldown + dt
end

return player