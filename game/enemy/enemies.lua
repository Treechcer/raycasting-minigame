local enemyClass = require("game.enemy.enemyClass")
local bilboarding = require("game.renderNstore.bilboarding")

enemies = {
    count = 0,
    smallEnemy = {},
    mediumEnemy = {},
    bigEnemy = {},
}

function enemies.create(type, x, y, z)
    local id = #bilboarding
    enemies[type] = enemyClass.create(type, x, y, z, id)
    bilboarding.createBilboard(enemyClass.enemyTypes[type].sprites, x, y, z, enemyClass.enemyTypes[type].size.height, enemyClass.enemyTypes[type].size.width)
end

return enemies