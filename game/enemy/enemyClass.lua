local sprites = require("sprites.spriteLoad")

enemyClass = {
    -- this is used as template / class for all enemy types
    enemyTypes = {
        small = {
            size = {
                height = 1,
                width = 1
            },

            attackDamage = 5,
            attacooldown = 2,
            viewDistance = 5,
            attackRange = 20,
            lastAttackCd = 0,

            speed = 100,
            x = "not asighned",
            y = "not asighned",
            z = "not asighned",
            id = "int_num", -- bilboarding ID because we need to traverse it

            AItype = "normal", -- might implemet more AI types, might

            sprites = sprites.guy,
        },
        medium = {
            size = {
                height = 1.5,
                width = 1.5
            },

            attackDamage = 5,
            attacooldown = 2,
            viewDistance = 5,
            attackRange = 20,
            lastAttackCd = 0,

            speed = 80,
            x = "not asighned",
            y = "not asighned",
            z = "not asighned",
            id = "int_num",

            AItype = "normal",

            sprites = sprites.guy,
        },
        big = {
            size = {
                height = 2,
                width = 2
            },

            attackDamage = 5,
            attacooldown = 2,
            viewDistance = 5,
            attackRange = 20,
            lastAttackCd = 0,

            speed = 200,
            x = "not asighned",
            y = "not asighned",
            z = "not asighned",
            id = "int_num",

            AItype = "normal",

            sprites = sprites.guy
        }
    }
}

function enemyClass.create(enemyType, x, y, z, id) -- this creates the enemy class
    local tempTable = enemyClass.enemyTypes[enemyType]
    tempTable.x = x
    tempTable.y = y
    tempTable.z = z
    tempTable.id = id

    return tempTable
end

return enemyClass