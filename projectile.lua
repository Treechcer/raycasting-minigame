local spriteLoad = require("sprites.spriteLoad")
local bilboarding = require("bilboarding")
local map = require("map")

projectile = {
    gun = {
        speed = 200,
        dmg = 20,
        sprite = spriteLoad.guy,
        projectiles = {} -- will have everyring from bilboarding + index that'll be where it's stored in bilboarding + angle
    },
}

function projectile.create(projectileType)
    local angleRad = math.rad(player.angleDeg)
    
    local forwardX = math.cos(angleRad) * 5
    local forwardY = math.sin(angleRad) * 5

    bilboarding.createBilboard(projectileType.sprite, player.x + forwardX, player.y + forwardY, 0, 0.5, 0.5)
    local index = #bilboarding
    local tempTable = {x = player.x + forwardX, y = player.y + forwardY, z = 0, id = index, angleDeg = player.angleDeg}

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

                if map.map[tileY * map.lenght + tileX + 1] == 1 then
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

function projectile.destroy(proj, index)
    table.remove(bilboarding, proj[index].id)
    
    for i = index, #proj do
        if proj[i].id > proj[index].id then
            proj[i].id = proj[i].id - 1
        end
    end

    table.remove(proj, index)
end

return projectile