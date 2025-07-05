map = {
    lenght = 8,
    height = 8,
    block2DSize = 64,
    map = {
        1,1,1,1,1,1,1,1,
        1,0,0,0,0,0,0,1,
        1,0,0,1,0,0,0,1,
        1,0,1,1,1,0,0,1,
        1,0,0,1,0,0,0,1,
        1,0,0,0,0,1,0,1,
        1,0,0,0,1,1,1,1,
        1,1,1,1,1,1,1,1,
    },

    miniMapSize = 150 --it's a square
}

map.surface = map.height * map.lenght

function map.draw2D()
    love.graphics.setColor(colors.black)
    love.graphics.rectangle("fill", 0, 0, map.miniMapSize + 3, map.miniMapSize + 3)
    
    for y = 1, map.height do
        for x = 1, map.lenght do
            if map.map[(y - 1) * map.lenght + x] == 1 then
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

return map