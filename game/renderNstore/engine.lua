engine = {
    drawCalls = {}, -- it's table full of everything we want to draw for z ordering
}

local colors = require("UINreletad.colors")
local textures = require("sprites.texture")
local bilboarding = require("game.renderNstore.bilboarding")
local game = require("game.properties.game")
local audio = require("sounds.audio")

function engine.raycast(angleDeg)
    local DOF = 0
    local viewDistance = player.viewDistance

    local num = 0

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
            DOF = sideDistX
            sideDistX = sideDistX + deltaDistX
            mapX = mapX + stepX
            side = 0
        else
            DOF = sideDistY
            sideDistY = sideDistY + deltaDistY
            mapY = mapY + stepY
            side = 1
        end

        if mapX < 0 or mapY < 0 or mapX >= map.lenght or mapY >= map.height then
            break
        end

        local index = mapY * map.lenght + mapX + 1
        if map.map[index] >= 1 then
            num = map.map[index]
            hit = true
        end

        if DOF >= viewDistance then
            hit = true
            num = 0
            break
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
    local coDist = distance * math.cos(math.rad(angleDeg - player.angleDeg))
    if coDist < 1 then
        coDist = 1
    end
    local height = 10000 / coDist 
    return distance, height, side, wallX, num
end

function engine.castRay()
    engine.drawCalls = {}
    engine.drawFloor()
    local rayCount = player.fov
    local fov = player.fov
    local screenWidth = 800
    local sliceWidth = screenWidth / rayCount

    for i = 0, rayCount - 1 do
        local cameraX = 2 * i / rayCount - 1
        local rayAngle = player.angleDeg + cameraX * (fov / 2)
        local dist, height, side, wallX, num = engine.raycast(rayAngle)
        engine.wallDraw(i, dist, height, sliceWidth, 10, side, wallX, num)
    end

    engine.drawBilboarding()
end

function engine.wallDraw(i, distance, height, width, ditterPattern, side, wallX, num)
    local texX = math.floor(wallX * textures.wall.size)
    texX = math.max(0, math.min(textures.wall.size - 1, texX))
    local darkFactor = 1 + (distance / 50)
    local adjCol = {}

    local maxLines = 200 
    local step = 1
    if height > maxLines then
        step = math.floor(height / maxLines)
    end

    for j = 0, height - 1, step do
        local texY = math.min(textures.wall.size - 1, math.floor(j * textures.wall.size / height))
        local yPos = math.floor((game.height / 2) - height / 2 + j)
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

        local temp = 0

        if num ~= 0 then
            adjCol = {math.floor(((textures.wall.color[num][1] * 255) + col) / darkFactor), math.floor(((textures.wall.color[num][2] * 255) + col) / darkFactor), math.floor(((textures.wall.color[num][3] * 255) + col) / darkFactor)}
            temp = textures.wall.texture[texY + ((num - 1) * textures.wall.size) + 1][texX + 1]
        else
            adjCol = {math.floor(((colors.black[1] * 255) + col) / darkFactor), math.floor(((colors.black[2] * 255) + col) / darkFactor), math.floor(((colors.black[3] * 255) + col) / darkFactor)}
        end

        if temp > 0 then
            for y = 1, 3 do
                adjCol[y] = (adjCol[y] / temp) / 255
            end
            love.graphics.setColor(adjCol)
        else
            for y = 1, 3 do
                adjCol[y] = (adjCol[y] + 50) / 255
            end
            love.graphics.setColor(adjCol[1],adjCol[2],adjCol[3])
        end

        love.graphics.rectangle("fill", i * width, yPos, width, step)
        table.insert(engine.drawCalls, {type = "wall", xpos = i * width, ypos = yPos, width = width, height = step, color = {adjCol[1],adjCol[2],adjCol[3]}, distance = distance})
    end
end

function engine.isBlocked(x0, y0, x1, y1) -- small checker if between two points (in X,Y) is or is not wall, now only for bilboarding
    local mapX0 = math.floor(x0 / map.block2DSize)
    local mapY0 = math.floor(y0 / map.block2DSize)
    if map.map[mapY0 * map.lenght + mapX0 + 1] >= 1 then
        return true
    end

    local dx = x1 - x0
    local dy = y1 - y0
    local distance = math.sqrt(dx*dx + dy*dy)
    local minSteps = 30 --makes it percise
    local steps = math.max(minSteps, math.floor(distance / map.block2DSize))

    local stepX = dx / steps
    local stepY = dy / steps

    local cx, cy = x0, y0
    for i=1, steps do
        cx = cx + stepX
        cy = cy + stepY

        local mapX = math.floor(cx / map.block2DSize)
        local mapY = math.floor(cy / map.block2DSize)

        if mapX < 0 or mapX >= map.lenght or mapY < 0 or mapY >= map.height then
            return false
        end

        if map.map[mapY * map.lenght + mapX + 1] >= 1 then
            return true
        end
    end

    return false
end

function engine.calculateDistance(x0, y0, x1, y1)
    local dx = x1 - x0
    local dy = y1 - y0
    distance = math.sqrt(dx*dx + dy*dy)

    return distance
end

function engine.drawBilboarding()
    for i = 1, #bilboarding do
        bilboarding[i].distance = engine.calculateDistance(player.x, player.y, bilboarding[i].x, bilboarding[i].y)
    end

    for bilboardI = 1, #bilboarding do
        local bb = bilboarding[bilboardI]

        local dx = bb.x - player.x
        local dy = bb.y - player.y
        local angleToBB = math.deg(math.atan2(dy, dx))
        local relativeAngle = angleToBB - player.angleDeg

        while relativeAngle > 180 do
            relativeAngle = relativeAngle - 360
        end
        while relativeAngle < -180 do
            relativeAngle = relativeAngle + 360
        end

        local sprite
        if type(bb.sprite) == "table" then
            local angleRelative = relativeAngle
            local sector = degMath.fixDeg(player.angleDeg - angleRelative) / 360 * #bb.sprite
            local spriteIndex = math.floor(sector) + 1
            sprite = bb.sprite[spriteIndex]
        else
            sprite = bb.sprite
        end

        if sprite == nil then
            sprite = spriteLoad.error
        end

        local halfFOV = player.fov / 2
        if math.abs(relativeAngle) < halfFOV and bb.distance < player.viewDistance * map.block2DSize then
            local dist = bb.distance
            local size = 3000 / dist
            local screenX = (relativeAngle + halfFOV) / player.fov * game.width

            love.graphics.setColor(1,1,1)
            local heightOffset = bb.z * size / sprite:getHeight()
            --love.graphics.draw(sprite, screenX - (size * bb.widthAplify) / 2, game.height / 2 - (size * bb.heightAplify) / 2 - heightOffset, 0, (size * bb.widthAplify) / sprite:getWidth(), (size * bb.heightAplify) / sprite:getHeight())
            table.insert(engine.drawCalls, {type = "billboarding", sprite = sprite, xpos = screenX - (size * bb.widthAplify) / 2, ypos = game.height / 2 - (size * bb.heightAplify) / 2 - heightOffset, width = (size * bb.widthAplify) / sprite:getWidth(), height = (size * bb.heightAplify) / sprite:getHeight(), distance = bb.distance})
        end
    end
end



function engine.sortDistance(inputTable)
    local sorted = {}

    local copy = {}
    for i = 1, #inputTable do
        table.insert(copy, inputTable[i])
    end

    table.sort(copy, function (a, b) return a.distance > b.distance end)

    --[[for j = 1, #copy do
        local maxValue = copy[1].distance
        local maxIndex = 1
        for i = 1, #copy do
            if maxValue < copy[i].distance then
                maxValue = copy[i].distance
                maxIndex = i
            end
        end
        table.insert(sorted, copy[maxIndex])
        table.remove(copy, maxIndex)
    end]]

    return copy
end

function engine.drawFloor()

end

function engine.pickaxe()
    local rad = math.rad(player.angleDeg)
    local x1 = player.x + math.cos(rad) * 30
    local y1 = player.y + math.sin(rad) * 30
    local index = math.floor(y1 / map.block2DSize) * map.lenght + math.floor(x1 / map.block2DSize) + 1
    if engine.isBlocked(player.x, player.y, x1, y1) and map.map[index] > 1 then
        map.map[index] = 0
        audio.blockBreak:setPitch(1 - math.random() / 2)
        audio.blockBreak:play()
    end
end

function engine.zOrderRender()

    local ordered = engine.sortDistance(engine.drawCalls)

    for index, value in ipairs(ordered) do
        local tableTemp = ordered[index]
        if tableTemp.type == "wall" then
            love.graphics.setColor(tableTemp.color)
            love.graphics.rectangle("fill", tableTemp.xpos, tableTemp.ypos, tableTemp.width, tableTemp.height)
        elseif tableTemp.type == "billboarding" then
            --love.graphics.draw(sprite, screenX - (size * bb.widthAplify) / 2, game.height / 2 - (size * bb.heightAplify) / 2 - heightOffset, 0, (size * bb.widthAplify) / sprite:getWidth(), (size * bb.heightAplify) / sprite:getHeight())
            --table.insert(engine.drawCalls, {type = "billboarding", sprite = sprite, xpos = screenX - (size * bb.widthAplify) / 2, ypos = game.height / 2 - (size * bb.heightAplify) / 2 - heightOffset, width = (size * bb.widthAplify) / sprite:getWidth(), height = (size * bb.heightAplify) / sprite:getHeight(), distance = bb.distance})
            local cache = 1 - tableTemp.distance / 350
            love.graphics.setColor(cache, cache, cache)
            love.graphics.draw(tableTemp.sprite, tableTemp.xpos, tableTemp.ypos, 0, tableTemp.width, tableTemp.height)

            --[[ for showing how rendering works, it's not perfect abd I don't care, good enough
            local serialized = serializeTable(ordered)
            love.filesystem.write("output.lua", "return " .. serialized)
            ]]
        end
    end
end

--[[function serializeTable(tbl, indent) -- this code is just for testing / showing how it looks to render my whole code, part generates txt file, the other renderes it frame by frame, no other usages than just testing / showing off
    indent = indent or ""
    local nextIndent = indent .. "  "
    local result = {"{\n"}

    for k, v in pairs(tbl) do
        local key
        if type(k) == "string" and k:match("^%a[%w_]*$") then
            key = k
        else
            key = "[" .. serializeValue(k) .. "]"
        end

        local value = serializeValue(v, nextIndent)

        table.insert(result, nextIndent .. key .. " = " .. value .. ",\n")
    end

    table.insert(result, indent .. "}")
    return table.concat(result)
end

function serializeValue(value, indent)
    indent = indent or ""
    local t = type(value)
    if t == "string" then
        return string.format("%q", value)
    elseif t == "number" or t == "boolean" or t == "nil" then
        return tostring(value)
    elseif t == "table" then
        return serializeTable(value, indent)
    else
        return '"<' .. t .. '>"' -- this causes error, it won't work and crash btw.
    end
end

inf = math.huge
engine.serializedData = dofile("output.lua")

engine.frameIndex = 0

function engine.frameDraw()
    engine.frameIndex = engine.frameIndex + 5
    local data = engine.serializedData
    if engine.frameIndex > #data then
        engine.frameIndex = #data
    end

    for i = 1, engine.frameIndex do
        local item = data[i]

        if item.type == "wall" then
            love.graphics.setColor(item.color[1], item.color[2], item.color[3])
            love.graphics.rectangle("fill", item.xpos, item.ypos, item.width, item.height)
        
        elseif item.type == "billboarding" then
            local cache = 1 - item.distance / 350
            love.graphics.setColor(cache, cache, cache)
            love.graphics.draw(spriteLoad.fists, item.xpos, item.ypos, 0, item.width, item.height)
        end
    end

    love.graphics.setColor(1,1,1)
end]]

return engine