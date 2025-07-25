-- this is class for enemies, this creates the enemies too

local sprites = require("sprites.spriteLoad")

local enemyClass = { -- I could've make it better... But I won't because too much work
    enemyTypes = {
        small = { -- this is init. for specific enemy
            size = { height = 1, width = 1 },
            attackDamage = 5,
            attacooldown = 2,
            movecooldow = 0.3,
            viewDistance = 5,
            attackRange = 20,
            lastAttackCd = 0,
            lastMovedcCd = 0,
            speed = 3,
            x = "int_num",
            y = "int_num",
            z = "int_num",
            id = "int_num",
            angleDeg = 50,
            AItype = "normal",
            sprites = sprites.guy,
            redLineId = "int_num",
            rotateSpeed = 0.1,
            maxHP = 100,
            currentHp = 100
        },
        medium = {
            size = { height = 1.5, width = 1.5 },
            attackDamage = 5,
            attacooldown = 2,
            movecooldow = 0.3,
            viewDistance = 5,
            attackRange = 20,
            lastAttackCd = 0,
            lastMovedcCd = 0,
            speed = 80,
            x = "int_num",
            y = "int_num",
            z = "int_num",
            id = "int_num",
            angleDeg = 50,
            AItype = "normal",
            sprites = sprites.guy,
            redLineId = "int_num",
            rotateSpeed = 0.1,
            maxHP = 100,
            currentHp = 100
        },
        big = {
            size = { height = 2, width = 2 },
            attackDamage = 5,
            attacooldown = 2,
            movecooldow = 0.3,
            viewDistance = 5,
            attackRange = 20,
            lastAttackCd = 0,
            lastMovedcCd = 0,
            speed = 200,
            x = "int_num",
            y = "int_num",
            z = "int_num",
            id = "int_num",
            angleDeg = 50,
            AItype = "normal",
            sprites = sprites.guy,
            redLineId = "int_num",
            rotateSpeed = 0.1,
            maxHP = 100,
            currentHp = 100
        }
    }
}

local function deepcopy(orig) -- this is for copying the table in "deepcopy" because otherwise it won't work correctly
    local copy
    if type(orig) == "table" then
        copy = {}
        for k, v in pairs(orig) do
            copy[k] = deepcopy(v)
        end
        setmetatable(copy, getmetatable(orig))
    else
        copy = orig
    end
    return copy
end

function enemyClass.create(enemyType, x, y, z, id) -- this creates the enemy from the class
    local template = enemyClass.enemyTypes[enemyType]
    if not template then
        error("Unknown enemy type: " .. tostring(enemyType))
    end

    local enemy = deepcopy(template)
    enemy.x = x
    enemy.y = y
    enemy.z = z
    enemy.id = id
    return enemy
end

return enemyClass