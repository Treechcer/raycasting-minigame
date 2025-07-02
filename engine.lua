engine = {}

function engine.raycast(angleDeg)
    local x = player.x
    local y = player.y

    local angleRad = math.rad(degMath.fixDeg(angleDeg))
    local dx = math.cos(angleRad)
    local dy = math.sin(angleRad)

    local i = 0
    while i < 500 do
        x = x + dx * 2
        y = y + dy * 2
        i = i + 1

        local tileX = math.floor(x / map.block2DSize)
        local tileY = math.floor(y / map.block2DSize)
        if tileX < 0 or tileY < 0 or tileX >= map.lenght or tileY >= map.height then
            break
        end

        local index = tileY * map.lenght + tileX + 1
        if map.map[index] == 1 then
            break
        end
    end

    local distance = math.sqrt((x - player.x)^2 + (y - player.y)^2)
    local height = 10000 / distance
    return distance, height
end

function engine.castRay()
    local rayCount = 90
    local fov = player.fov
    local screenWidth = 800
    local sliceWidth = screenWidth / rayCount

    for i = 0, rayCount - 1 do
        local rayAngle = player.angleDeg - (fov / 2) + (i * (fov / rayCount))
        local dist, height = engine.raycast(rayAngle)
        engine.wallDraw(i, dist, height, sliceWidth, 10)
    end
end

function engine.wallDraw(i, distance, height, width, ditterPattern)
    local colors = require("colors") 
    darkFactor = 1 + (distance/50)

    for j = 0, height - 1 do
        local yPos = math.floor(300 - height / 2 + j)

        local ditter = ((i + yPos) % ditterPattern < (ditterPattern / (distance / 10)))

        if ditter then
            col = 30
        else
            col = 0
        end

        adjCol = {math.floor(((colors.wall[1] * 255) + col) / darkFactor), 0, math.floor(((colors.wall[2] * 255) + col) / darkFactor)}

        love.graphics.setColor(adjCol[1] / 255, adjCol[2] / 255, adjCol[3] / 255)
        love.graphics.rectangle("fill", i * width, yPos, width, 1)
    end
end

return engine