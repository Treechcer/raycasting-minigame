-- this file is for map and map related things

gunStats = require("game.properties.gunStats")
spriteLoad = require("sprites.spriteLoad")

map = {
    lenght = 16,
    height = 16,
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

    gunMap = {}, --here will be like "gunName" = {tileX, tileY} --both INT

    miniMapSize = 200,  --it's a square (also in px)
}

map.surface = map.height * map.lenght -- surface of map

function map.draw2D() -- minimap drawing
    love.graphics.setColor(colors.black)
    love.graphics.rectangle("fill", 0, 0, map.miniMapSize + 1, map.miniMapSize + 1)
    local blockSizeX = map.miniMapSize / map.lenght
    local blockSizeY = map.miniMapSize / map.height
    
    for y = 1, map.height do -- this draws all the "cells" of the minimap
        for x = 1, map.lenght do
            if map.map[(y - 1) * map.lenght + x] >= 1 then
                love.graphics.setColor(colors.gray)
            else
                love.graphics.setColor(colors.white)
            end

            love.graphics.rectangle("fill", (x - 1) * blockSizeX + 1, (y - 1) * blockSizeY + 1, blockSizeX - 1, blockSizeY - 1)
        end
    end

    love.graphics.setColor(colors.crosshair)
    for key, value in pairs(map.gunMap) do -- this draws the weapons to map (might be just temp)
        local x = map.gunMap[key].tileX
        local y = map.gunMap[key].tileY

        love.graphics.rectangle("fill", (x - 1) * blockSizeX + 1, (y - 1) * blockSizeY + 1, blockSizeX - 1, blockSizeY - 1)
    end
end

function map.random() -- this generates the random map
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

    map.map[2 + map.lenght] = 0

    math.randomseed(os.time()) -- this for random placements
    for key, value in pairs(gunStats) do
        notSpawnedWeapons = true
        while notSpawnedWeapons do -- try to place it until it's spawned
            local x = math.random(map.lenght)
            local y = math.random(map.height)

            if map.map[(y - 1) * map.lenght + x] == 0 then
                map.gunMap[key] = {
                    tileX = x,
                    tileY = y,
                }
                local offset = map.block2DSize / 2
                bilboarding.createBilboard(spriteLoad[key], x * map.block2DSize - offset, y * map.block2DSize - offset, 0, 3, 3)
                --print(gunStats[key].mapNum)
                notSpawnedWeapons = false
            end
        end
    end

    --[[for l = 1, #map.map do
        print(map.map[l])
    end]]
end

return map