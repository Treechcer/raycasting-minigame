local spriteLoad = require("sprites.spriteLoad")
local bilboarding = require("game.renderNstore.bilboarding")
local map = require("game.properties.map")

projectile = {
    gun = {
        speed = 200,
        dmg = 20,
        sprite = spriteLoad.gun,
        ammonSprite = spriteLoad.fists,
        projectiles = {} -- will have everyring from bilboarding + index that'll be where it's stored in bilboarding + angle
    },
}

function projectile.create(projectileType)
    local angleRad = math.rad(player.angleDeg)
    
    local forwardX = math.cos(angleRad) * 5
    local forwardY = math.sin(angleRad) * 5

    bilboarding.createBilboard(spriteLoad.fists, player.x + forwardX, player.y + forwardY, 8, 1, 1)
    local index = #bilboarding
    local tempTable = {x = player.x + forwardX, y = player.y + forwardY, z = 8, id = index, angleDeg = player.angleDeg + player.angleMovDeg}

    table.insert(projectileType.projectiles, tempTable)
end

function projectile.move(dt)
    local toRemove = {}
    for key, value in pairs(projectile) do
        if type(value) ~= "function" then
            for index, value1 in ipairs(projectile[key].projectiles) do
                local forwardX = math.cos(math.rad(projectile[key].projectiles[index].angleDeg)) * projectile[key].speed
                local forwardY = math.sin(math.rad(projectile[key].projectiles[index].angleDeg)) * projectile[key].speed

                projectile[key].projectiles[index].x = projectile[key].projectiles[index].x + forwardX * dt
                projectile[key].projectiles[index].y = projectile[key].projectiles[index].y + forwardY * dt
                bilboarding[projectile[key].projectiles[index].id].x = projectile[key].projectiles[index].x
                bilboarding[projectile[key].projectiles[index].id].y = projectile[key].projectiles[index].y

                local tileX = math.floor(projectile[key].projectiles[index].x / map.block2DSize)
                local tileY = math.floor(projectile[key].projectiles[index].y / map.block2DSize)

                if map.map[tileY * map.lenght + tileX + 1] >= 1 then
                    --projectile.destroy(projectile[key].projectiles, index)
                    table.insert(toRemove, {projectile[key].projectiles, index})
                end
            end
        end
    end

    for i = 1, #toRemove do
        projectile.destroy(toRemove[i][1], toRemove[i][2])
    end
end

function projectile.enemyHit()
    for key, gunType in pairs(projectile) do
        if type(gunType) == "table" and gunType.projectiles then
            for i = 1, #enemies.enTypes do
                local tempEnType = enemies.enTypes[i] .. "Enemy"
                local en = enemies[tempEnType]
                for index, value0 in pairs(en) do
                    for j = #gunType.projectiles, 1, -1 do
                        local proj = gunType.projectiles[j]
                        if engine.calculateDistance(proj.x, proj.y, value0.x, value0.y) <= 5 then
                            projectile.destroy(gunType.projectiles, j)
                            enemies.damage(gunType.dmg, tempEnType, index)
                        end
                    end
                end
            end
        end
    end
end

function projectile.destroy(proj, index)
    if proj[index] then
        table.remove(bilboarding, proj[index].id)

        for i = index, #proj do
            if proj[i].id > proj[index].id then
                proj[i].id = proj[i].id - 1
            end
        end

        table.remove(proj, index)
    end
end

return projectile