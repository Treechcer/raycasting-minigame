--this file is for enemies, making them, behjaviour etc.

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

function enemies.create(type, x, y, z) -- this creates enemy and his billboarding
    bilboarding.createBilboard(enemyClass.enemyTypes[type].sprites, x, y, z, enemyClass.enemyTypes[type].size.height, enemyClass.enemyTypes[type].size.width)
    --print(enemyClass.enemyTypes[type].sprites)
    local id = #bilboarding
    local enTypeChache = enemies[type .. "Enemy"]
    local newEnemy = enemyClass.create(type, x, y, z, id)
    table.insert(enTypeChache, newEnemy)
end

function enemies.behavior() -- this moves enemy etc., I have no idea how would I comment this code, it's awfull  
    for _, type in ipairs(enemies.enTypes) do
        local enTypeChache = enemies[type .. "Enemy"]
        for i = 1, #enTypeChache do
            local enemy = enTypeChache[i]
            if enemy.lastMovedcCd >= enemy.movecooldow and not engine.isBlocked(player.x, player.y, enemy.x, enemy.y) then
                local dx = player.x - enemy.x
                local dy = player.y - enemy.y
                local targetAngle = math.deg(math.atan2(dy, dx))
                if targetAngle < 0 then
                    targetAngle = targetAngle + 360
                end

                enemy.angleDeg = enemies.angleLerp(enemy.angleDeg, targetAngle, enemy.rotateSpeed)
                
                if engine.calculateDistance(player.x, player.y, enemy.x, enemy.y) >= 15 then
                    local rad = math.rad(enemy.angleDeg)
                    enemy.x = enemy.x + math.cos(rad) * enemy.speed
                    enemy.y = enemy.y + math.sin(rad) * enemy.speed
                    bilboarding[enemy.id].x = enemy.x
                    bilboarding[enemy.id].y = enemy.y
                    enemy.lastMovedcCd = 0
                end
            end
        end
    end
end

function enemies.angleLerp(a, b, t) -- this is for them to rotate slowly
    local diff = (b - a + 180) % 360 - 180
    return (a + diff * t) % 360
end

function enemies.colldown(dt) -- resets for all enemy cooldowns
    for _, type in ipairs(enemies.enTypes) do
        local enTypeChache = enemies[type .. "Enemy"]
        for i = 1, #enTypeChache do
            enTypeChache[i].lastMovedcCd = enTypeChache[i].lastMovedcCd + dt
            enTypeChache[i].lastAttackCd = enTypeChache[i].lastAttackCd + dt
        end
    end
end

function enemies.damage(damage, enType, index) -- this is to damage an enemy
    local enemyList = enemies[enType]
    local en = enemyList[index]

    if en ~= nil then
        en.currentHp = en.currentHp - damage

        if en.currentHp <= 0 then
            table.remove(bilboarding, en.id)
            enemies.changeEnemyID(en.id, enType)

            table.remove(enemyList, index)
        end
    end
end

function enemies.changeEnemyID(id, type) -- this is for changing IDs of all enemies after some ID in specific type
    local enemyList = enemies[type]
    for i = id, #enemyList do
        enemyList[i].id = enemyList[i].id - 1
    end
end

return enemies