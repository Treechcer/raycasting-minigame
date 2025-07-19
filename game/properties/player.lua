-- this file is mostly for player and player related stuff

player = {
    x = 100,
    y = 100,
    angleDeg = 0,
    speed = 100,
    size = 30,
    fov = 70,
    angleMovDeg = 0,

    weaponHeight = 0,
    weaponWidth = 0,
    gunNumDeg = 0,
    shootCooldown = 10000, -- makes it that player can shoot, because of course the cooldown won¨t be more like 1s or whatever... yes this number is in seconds

    viewDistance = 5, -- how many cells you can see until you see "ghost" walls (fog effect I use)
}

local inventory = require("game.renderNstore.inventory")
local map = require("game.properties.map")
local spriteLoad = require("sprites.spriteLoad")
local gunStats = require("game.properties.gunStats")

function player.render2D() -- minimap render into correct cell
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

function player.checkWall(x, y) -- this is for checking if player when he moves hit's wall
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

function player.renderGun() -- draws the gun
    local offsetY = math.sin(math.rad(player.gunNumDeg)) * 8 -- makes small offset while moving

    love.graphics.setColor(colors.white)
    width, height = love.graphics.getDimensions()
    local tempPath = inventory.gunSlots[inventory.equipedGunSlot]
    if tempPath == "" then
        tempPath = "fists" -- if the item is "none" then player has fists
    end
    --print(tempPath, spriteLoad[tempPath])
    love.graphics.draw(spriteLoad[tempPath], width / 3 + gunStats[tempPath].xOffset, height / 1.3 + gunStats[tempPath].yOffset + offsetY, 0, 1 * gunStats[tempPath].weaponWidth, 1 * gunStats[tempPath].weaponHeight)
end

function player.renderCrosshair() -- this is for scosshair
    love.graphics.setColor(colors.crosshair)
    love.graphics.rectangle("fill", game.width / 2 - 2.5, game.height / 2 - 2.5, 5, 5) -- the -2.5 is to negate the crosshair being 5 px
end

function player.cooldwonChange(dt) -- resets cooldowns for player
    player.shootCooldown = player.shootCooldown + dt
    inventory.scrollCooldown = inventory.scrollCooldown + dt
end

return player