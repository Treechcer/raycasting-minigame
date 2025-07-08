local enemyClass = require("game.enemy.enemyClass")
local bilboarding = require("game.renderNstore.bilboarding")

enemies = {
    count = 0,
    smallEnemy = {},
    mediumEnemy = {},
    bigEnemy = {},
}

function enemies.create(type, x, y, z)
    bilboarding.createBilboard(enemyClass.enemyTypes[type].sprites, x, y, z, enemyClass.enemyTypes[type].size.height, enemyClass.enemyTypes[type].size.width)
    local id = #bilboarding
    table.insert(enemies[type .. "Enemy"], enemyClass.create(type, x, y, z, id))
end

function enemies.behavior()
    for i = 1, #enemies.smallEnemy do
        --if enemies.smallEnemy[i].attacooldown == 0 then
            enemies.smallEnemy[i].x = enemies.smallEnemy[i].x + math.sin(math.rad(enemies.smallEnemy[i].angleDeg))
            enemies.smallEnemy[i].y = enemies.smallEnemy[i].y + math.cos(math.rad(enemies.smallEnemy[i].angleDeg))
            bilboarding[enemies.smallEnemy[i].id].x = enemies.smallEnemy[i].x
            bilboarding[enemies.smallEnemy[i].id].y = enemies.smallEnemy[i].y

            enemies.smallEnemy[i].angleDeg = enemies.smallEnemy[i].angleDeg + 1
        --end
    end
end

return enemies