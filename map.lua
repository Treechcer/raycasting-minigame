map = {
    mapX = 10,
    mapY = 8,
    mapS = 100,

    map = {
        1,1,1,1,1,1,1,1,1,1,
        1,0,0,0,0,0,0,0,0,1,
        1,0,0,0,0,0,0,0,0,1,
        1,1,0,0,0,0,0,0,1,1,
        1,0,0,0,0,0,0,0,0,1,
        1,0,0,0,0,0,0,0,0,1,
        1,0,0,0,0,0,0,0,0,1,
        1,1,1,1,1,1,1,1,1,1,
    },

    width = love.graphics.getWidth(),
    height = love.graphics.getHeight()
}

map.mapS = map.mapX * map.mapY

function map.drawMap()
    for y = 0, map.mapY - 1 do
        for x = 0, map.mapX - 1 do
            if map.map[y * map.mapX + x + 1] == 1 then
                love.graphics.setColor(1,1,1, 0.5)
            else
                love.graphics.setColor(0,0,0, 0,5)
            end

            love.graphics.rectangle("fill", x * map.mapS - 1, y * map.mapS -1, map.mapS - 1, map.mapS - 1)

            love.graphics.setColor(0.8,0.8,0.8, 0.5)
            love.graphics.rectangle("line", x * map.mapS, y * map.mapS, map.mapS, map.mapS)
        end
    end
end

return map