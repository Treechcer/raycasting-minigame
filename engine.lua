engine = {}

function engine.raycast(angleDeg)
    local posX = player.x / map.block2DSize
    local posY = player.y / map.block2DSize

    local angleRad = math.rad(degMath.fixDeg(angleDeg))
    local rayDirX = math.cos(angleRad)
    local rayDirY = math.sin(angleRad)

    local deltaDistX = math.abs(1 / rayDirX)
    local deltaDistY = math.abs(1 / rayDirY)

    local mapX = math.floor(posX)
    local mapY = math.floor(posY)

    local stepX, stepY
    local sideDistX, sideDistY

    if rayDirX < 0 then
        stepX = -1
        sideDistX = (posX - mapX) * deltaDistX
    else
        stepX = 1
        sideDistX = (mapX + 1.0 - posX) * deltaDistX
    end

    if rayDirY < 0 then
        stepY = -1
        sideDistY = (posY - mapY) * deltaDistY
    else
        stepY = 1
        sideDistY = (mapY + 1.0 - posY) * deltaDistY
    end

    local hit = false
    local side
    while not hit do
        if sideDistX < sideDistY then
            sideDistX = sideDistX + deltaDistX
            mapX = mapX + stepX
            side = 0
        else
            sideDistY = sideDistY + deltaDistY
            mapY = mapY + stepY
            side = 1
        end

        if mapX < 0 or mapY < 0 or mapX >= map.lenght or mapY >= map.height then
            break
        end

        local index = mapY * map.lenght + mapX + 1
        if map.map[index] == 1 then
            hit = true
        end
    end

    local perpWallDist
    if side == 0 then
        perpWallDist = (mapX - posX + (1 - stepX) / 2) / rayDirX
    else
        perpWallDist = (mapY - posY + (1 - stepY) / 2) / rayDirY
    end

    local distance = perpWallDist * map.block2DSize
    local height = 10000 / distance
    return distance, height, side
end

function engine.castRay()
    local rayCount = player.fov / 2
    local fov = player.fov
    local screenWidth = 800
    local sliceWidth = screenWidth / rayCount

    for i = 0, rayCount - 1 do
        local rayAngle = player.angleDeg - (fov / 2) + (i * (fov / rayCount))
        local dist, height, side = engine.raycast(rayAngle)
        engine.wallDraw(i, dist, height, sliceWidth, 10, side)
    end
end
local colors = require("colors")
function engine.wallDraw(i, distance, height, width, ditterPattern, side)
    
    darkFactor = 1 + (distance/50)

    for j = 0, height - 1 do
        local yPos = math.floor(300 - height / 2 + j)
        local col = 0

        local ditter = ((i + yPos) % ditterPattern < (ditterPattern / (distance / 10)))

        if ditter then
            col = 30
        else
            col = 0
        end

        if side == 0 then
            col = col - 25
        end

        adjCol = {math.floor(((colors.wall[1] * 255) + col) / darkFactor), colors.wall[2], math.floor(((colors.wall[2] * 255) + col) / darkFactor)}

        love.graphics.setColor(adjCol[1] / 255, adjCol[2] / 255, adjCol[3] / 255)
        love.graphics.rectangle("fill", i * width, yPos, width, 1)
    end
end

return engine