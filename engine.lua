engine = {}

local colors = require("colors")
local textures = require("sprites.texture")
local bilboarding = require("bilboarding")

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


        for bilboardI = 1, #bilboarding do
            local bb = bilboarding[bilboardI]

            local dx = bb.x - player.x
            local dy = bb.y - player.y
            local dist = math.sqrt(dx * dx + dy * dy)
            local angleToBB = math.deg(math.atan2(dy, dx))
            local relativeAngle = angleToBB - player.angleDeg
            while relativeAngle > 180 do
                relativeAngle = relativeAngle - 360
            end
            while relativeAngle < -180 do
                relativeAngle = relativeAngle + 360
            end

            local halfFOV = player.fov / 2
            if math.abs(relativeAngle) < halfFOV then
                local size = 3000 / dist

                local screenX = (relativeAngle + halfFOV) / player.fov * player.game.width

                love.graphics.setColor(1,1,1)
                local heightOffset = bb.z * size / bb.sprite:getHeight()
                love.graphics.draw(bb.sprite, screenX - size / 2, player.game.height / 2 - size / 2 - heightOffset, 0, size / bb.sprite:getWidth(), size / bb.sprite:getHeight()
                )
            end
        end


        local index = mapY * map.lenght + mapX + 1
        if map.map[index] == 1 then
            hit = true
        end
    end

    local perpWallDist
    if side == 0 then
        perpWallDist = (mapX - posX + (1 - stepX) / 2) / rayDirX
        wallX = posY + perpWallDist * rayDirY
    else
        perpWallDist = (mapY - posY + (1 - stepY) / 2) / rayDirY
        wallX = posX + perpWallDist * rayDirX
    end

    wallX = wallX - math.floor(wallX)

    local distance = perpWallDist * map.block2DSize
    local height = 10000 / distance
    return distance, height, side, wallX
end

function engine.castRay()
    local rayCount = math.floor(player.fov / 1.5)
    local fov = player.fov
    local screenWidth = 800
    local sliceWidth = screenWidth / rayCount

    for i = 0, rayCount - 1 do
        local rayAngle = player.angleDeg - (fov / 2) + (i * (fov / rayCount))
        local dist, height, side, wallX = engine.raycast(rayAngle)
        engine.wallDraw(i, dist, height, sliceWidth, 10, side, wallX)
    end
end

function engine.wallDraw(i, distance, height, width, ditterPattern, side, wallX)
    local texX = math.floor(wallX * textures.wall.size)
    texX = math.max(0, math.min(textures.wall.size - 1, texX))
    local darkFactor = 1 + (distance/50)

    for j = 0, height - 1 do
        local texY = math.min(textures.wall.size - 1, math.floor(j * textures.wall.size / height))
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
        if textures.wall.texture[texY + 1][texX + 1] == 1 then
            love.graphics.setColor(adjCol[1] / 255, adjCol[2] / 255, adjCol[3] / 255)
            love.graphics.rectangle("fill", i * width, yPos, width, 1)
        else
            for y = 1, 3 do
                adjCol[y] = (adjCol[y] + 50) / 255
            end
                love.graphics.setColor(adjCol[1],adjCol[2],adjCol[3])
                love.graphics.rectangle("fill", i * width, yPos, width, 1)
        end
    end
end

return engine