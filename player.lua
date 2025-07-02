player = {
    x = 100,
    y = 100,
    angleDeg = 0,
    speed = 100,
    size = 30,
    fov = 90,

    game = {
        debug = false,
    },
}

local map = require("map")

function player.render2D()
    local tileX = math.floor(player.x / map.block2DSize)
    local tileY = math.floor(player.y / map.block2DSize)

    love.graphics.setColor(0.8,0.8,0)
    love.graphics.rectangle("fill", (((tileX) * map.block2DSize) / 3) - 3, (((tileY) * map.block2DSize) / 3) - 3, (map.block2DSize / 3) - 3, (map.block2DSize / 3) - 3)
    --love.graphics.line((tileX * map.block2DSize / 3) + (player.size / 6), (tileY * map.block2DSize / 3) + (player.size / 6), (tileX * map.block2DSize / 3) + (math.cos(math.rad(player.angleDeg)) * 20), (tileY * map.block2DSize / 3) + (math.sin(math.rad(player.angleDeg)) * 20))

    local startX = (tileX * map.block2DSize / 3) + (player.size / 6)
    local startY = (tileY * map.block2DSize / 3) + (player.size / 6)
    local endX = startX + math.cos(math.rad(player.angleDeg)) * 20
    local endY = startY + math.sin(math.rad(player.angleDeg)) * 20

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

            --if player.game.debug then
                love.graphics.print(map.map[index], 150, 0) 
            --end

            if map.map[index] == 1 then
                return false
            end
        end
    end

    return true
end

return player