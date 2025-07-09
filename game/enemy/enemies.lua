local enemyClass = require("game.enemy.enemyClass")
local bilboarding = require("game.renderNstore.bilboarding")
local player = require("game.properties.player")
local engine = require("game.renderNstore.engine")

---@class enemies
enemies = {
    count = 0,
    smallEnemy = {},
    mediumEnemy = {},
    bigEnemy = {},
    enTypes = {"small", "medium", "big"}
}

function enemies.create(type, x, y, z)
    bilboarding.createBilboard(enemyClass.enemyTypes[type].sprites, x, y, z, enemyClass.enemyTypes[type].size.height, enemyClass.enemyTypes[type].size.width)
    local id = #bilboarding
    local enTypeChache = enemies[type .. "Enemy"]
    local offSetX = math.sin(math.rad(50)) * 2.1
    local offSetY = math.cos(math.rad(50)) * 2.1
    bilboarding.createBilboard(spriteLoad.redLine, x + offSetX, y + offSetY, z, 1, 2)
    local redLineId = #bilboarding
    local newEnemy = enemyClass.create(type, x, y, z, id, redLineId)
    table.insert(enTypeChache, newEnemy)
end

function enemies.behavior()
    for _, type in ipairs(enemies.enTypes) do
        local enTypeChache = enemies[type .. "Enemy"]
        for i = 1, #enTypeChache do
            local enemy = enTypeChache[i]
            if enemy.lastMovedcCd >= 0.5 and not engine.isBlocked(player.x, player.y, enemy.x, enemy.y) then
                local dx = player.x - enemy.x
                local dy = player.y - enemy.y
                local targetAngle = math.deg(math.atan2(dy, dx))
                if targetAngle < 0 then
                    targetAngle = targetAngle + 360
                end

                enemy.angleDeg = enemies.angleLerp(enemy.angleDeg, targetAngle, 0.1)
                local rad = math.rad(enemy.angleDeg)
                local speed = 2
                enemy.x = enemy.x + math.cos(rad) * speed
                enemy.y = enemy.y + math.sin(rad) * speed
                bilboarding[enemy.id].x = enemy.x
                bilboarding[enemy.id].y = enemy.y

                local offSetX = math.cos(rad) * 2.1
                local offSetY = math.sin(rad) * 2.1
                bilboarding[enemy.redLineId].x = enemy.x + offSetX
                bilboarding[enemy.redLineId].y = enemy.y + offSetY
                enemy.lastMovedcCd = 0
            end
        end
    end
end

function enemies.angleLerp(a, b, t)
    local diff = (b - a + 180) % 360 - 180
    return (a + diff * t) % 360
end

function enemies.colldown(dt)
    for _, type in ipairs(enemies.enTypes) do
        local enTypeChache = enemies[type .. "Enemy"]
        for i = 1, #enTypeChache do
            enTypeChache[i].lastMovedcCd = enTypeChache[i].lastMovedcCd + dt
            enTypeChache[i].lastAttackCd = enTypeChache[i].lastAttackCd + dt
        end
    end
end

return enemies