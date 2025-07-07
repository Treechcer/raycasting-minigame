map = {
    lenght = 15,
    height = 15,
    block2DSize = 64,
    map = {
        1,1,1,1,1,1,1,0,
        1,0,0,0,0,0,0,0,
        1,0,0,0,0,0,0,0,
        1,0,0,0,0,0,0,0,
        1,0,0,0,0,0,0,0,
        1,0,0,0,0,0,0,0,
        1,0,0,0,0,0,0,0,
        1,0,0,0,0,0,0,0,
    },

    miniMapSize = 150 --it's a square
}

map.surface = map.height * map.lenght

function map.draw2D()
    love.graphics.setColor(colors.black)
    love.graphics.rectangle("fill", 0, 0, map.miniMapSize + 3, map.miniMapSize + 3)
    
    for y = 1, map.height do
        for x = 1, map.lenght do
            if map.map[(y - 1) * map.lenght + x] >= 1 then
                love.graphics.setColor(colors.gray)
            else
                love.graphics.setColor(colors.white)
            end
            local blockSizeX = map.miniMapSize / map.lenght
            local blockSizeY = map.miniMapSize / map.height

            love.graphics.rectangle("fill", (x - 1) * blockSizeX + 3, (y - 1) * blockSizeY + 3, blockSizeX - 3, blockSizeY - 3)
        end
    end
end

function map.random()
    local noise = require("math.noise")
    local temp = noise.generateMap()

    for y = 1, #temp do
        local x = ((y - 1) % map.lenght) + 1
        local z = math.floor((y - 1) / map.lenght) + 1

        if x == 1 or x == map.lenght or z == 1 or z == map.height then
            map.map[y] = 1
        else
            local t = temp[y] * 0.75
            if t < 0.50 then
                map.map[y] = 0
            elseif t < 0.66 then
                map.map[y] = 2
            else
                map.map[y] = 3
            end
        end
    end

    --[[for l = 1, #map.map do
        print(map.map[l])
    end]]
end

return map