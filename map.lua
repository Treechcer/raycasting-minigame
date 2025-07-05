map = {
    lenght = 9,
    height = 9,
    block2DSize = 64,
    map = {
        1,1,1,1,1,1,1,1,1,
        1,0,0,0,0,0,0,0,1,
        1,0,0,1,0,0,0,0,1,
        1,0,1,1,1,0,0,0,1,
        1,0,0,1,0,0,0,0,1,
        1,0,0,0,0,1,0,0,1,
        1,0,0,0,1,1,1,0,1,
        1,0,0,0,0,1,0,0,1,
        1,1,1,1,1,1,1,1,1,
    }
}

map.surface = map.height * map.lenght

function map.draw2D()
    for y = 1, map.height do
        for x = 1, map.lenght do
            if map.map[(y - 1) * map.lenght + x] == 1 then
                love.graphics.setColor(colors.gray)
            else
                love.graphics.setColor(colors.white)
            end
            love.graphics.rectangle("fill", (((x - 1) * map.block2DSize) / 3) - 3, (((y - 1) * map.block2DSize) / 3) - 3, (map.block2DSize / 3) - 3, (map.block2DSize / 3) - 3)
        end
    end
end

return map