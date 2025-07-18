-- in this file is everything needed for projectiles, hit detection and everything neeeded for it

local spriteLoad = require("sprites.spriteLoad")
local bilboarding = require("game.renderNstore.bilboarding")
local map = require("game.properties.map")

projectile = { -- here will be all rojectiles that we'll be able to shoot
    gun = {
        speed = 200,
        dmg = 20,
        sprite = spriteLoad.gun,
        ammonSprite = spriteLoad.fists, -- temp sprite
        projectiles = {} -- will have everyring from bilboarding + index that'll be where it's stored in bilboarding + angle
    },
}

function projectile.create(projectileType) -- this creates project of any supported type
    -- this makes the projectiles spawn a bit before player so he isn't obstructed in vision
    
    local angleRad = math.rad(player.angleDeg)
    
    local forwardX = math.cos(angleRad) * 5
    local forwardY = math.sin(angleRad) * 5

    --

    -- this makes the projectile drawn and adds it to the projectiles table in the correct projectile
    
    bilboarding.createBilboard(spriteLoad.fists, player.x + forwardX, player.y + forwardY, 8, 1, 1)
    local index = #bilboarding
    local tempTable = {x = player.x + forwardX, y = player.y + forwardY, z = 8, id = index, angleDeg = player.angleDeg + player.angleMovDeg}

    table.insert(projectileType.projectiles, tempTable)
    
    --
end

function projectile.move(dt) -- this moves the projectiles by theirs speed every frame
    local toRemove = {} -- for storing projectile to remore duh
    for key, value in pairs(projectile) do
        if type(value) ~= "function" then -- we don't want to check functions obviously
            for index, value1 in ipairs(projectile[key].projectiles) do

                --calculating the distance that it travelled
                
                local forwardX = math.cos(math.rad(projectile[key].projectiles[index].angleDeg)) * projectile[key].speed
                local forwardY = math.sin(math.rad(projectile[key].projectiles[index].angleDeg)) * projectile[key].speed
                
                --
                
                -- this moves the projectile
                
                projectile[key].projectiles[index].x = projectile[key].projectiles[index].x + forwardX * dt
                projectile[key].projectiles[index].y = projectile[key].projectiles[index].y + forwardY * dt
                bilboarding[projectile[key].projectiles[index].id].x = projectile[key].projectiles[index].x
                bilboarding[projectile[key].projectiles[index].id].y = projectile[key].projectiles[index].y
                
                --
                
                -- this checks if the prjectile hit a wall if it did it deltes itself

                local tileX = math.floor(projectile[key].projectiles[index].x / map.block2DSize)
                local tileY = math.floor(projectile[key].projectiles[index].y / map.block2DSize)

                if map.map[tileY * map.lenght + tileX + 1] >= 1 then
                    --projectile.destroy(projectile[key].projectiles, index) -- some thing that didn't worked
                    table.insert(toRemove, {projectile[key].projectiles, index})
                end

                --
            end
        end
    end

    -- this removes the projectiles that need to be removed

    for i = 1, #toRemove do
        projectile.destroy(toRemove[i][1], toRemove[i][2])
    end

    --
end

function projectile.enemyHit() -- this is hit detection, the code is actually awfull (I won't fix hehe) and I don't how to comment it properly lol
    for key, gunType in pairs(projectile) do
        if type(gunType) == "table" and gunType.projectiles then
            for i = 1, #enemies.enTypes do
                local tempEnType = enemies.enTypes[i] .. "Enemy"
                local en = enemies[tempEnType]
                for index, value0 in pairs(en) do
                    for j = #gunType.projectiles, 1, -1 do
                        local proj = gunType.projectiles[j]
                        if engine.calculateDistance(proj.x, proj.y, value0.x, value0.y) <= 5 then -- it's radius (sphere) areound the enemy
                            projectile.destroy(gunType.projectiles, j)
                            enemies.damage(gunType.dmg, tempEnType, index)
                        end
                    end
                end
            end
        end
    end
end

function projectile.destroy(proj, index) -- this removes / destroys the projectile of the type and index
    if proj[index] then
        table.remove(bilboarding, proj[index].id) -- remove from bilboarding

        -- this corrects the IDs of projectiles

        for i = index, #proj do
            if proj[i].id > proj[index].id then
                proj[i].id = proj[i].id - 1
            end
        end

        --

        table.remove(proj, index)
    end
end

return projectile