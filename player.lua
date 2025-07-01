player = {
    x = 100,
    y = 100,
    angleDeg = 0,
    speed = 3000,
    size = 30
}

function player.render2D()
    local map = require("map")
    local tileX = math.floor(player.x / map.block2DSize)
    local tileY = math.floor(player.y / map.block2DSize)

    love.graphics.setColor(0.8,0.8,0)
    love.graphics.rectangle("fill", (((tileX) * map.block2DSize) / 3) - 3, (((tileY) * map.block2DSize) / 3) - 3, (map.block2DSize / 3) - 3, (map.block2DSize / 3) - 3)

    love.graphics.setColor(0.9,0.9,0)
    love.graphics.line((tileX * map.block2DSize / 3) + (player.size / 6), (tileY * map.block2DSize / 3) + (player.size / 6), (tileX * map.block2DSize / 3) + (math.cos(math.rad(player.angleDeg)) * 40), (tileY * map.block2DSize / 3) + (math.sin(math.rad(player.angleDeg)) * 40))
end

return player