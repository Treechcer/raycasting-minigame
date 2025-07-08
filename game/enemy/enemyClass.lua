local sprites = require("sprites.spriteLoad")

local enemyClass = {
    enemyTypes = {
        small = {
            size = { height = 1, width = 1 },
            attackDamage = 5,
            attacooldown = 2,
            viewDistance = 5,
            attackRange = 20,
            lastAttackCd = 0,
            speed = 100,
            x = "not assigned",
            y = "not assigned",
            z = "not assigned",
            id = "int_num",
            angleDeg = 50,
            AItype = "normal",
            sprites = sprites.guy,
        },
        medium = {
            size = { height = 1.5, width = 1.5 },
            attackDamage = 5,
            attacooldown = 2,
            viewDistance = 5,
            attackRange = 20,
            lastAttackCd = 0,
            speed = 80,
            x = "not assigned",
            y = "not assigned",
            z = "not assigned",
            id = "int_num",
            angleDeg = 50,
            AItype = "normal",
            sprites = sprites.guy,
        },
        big = {
            size = { height = 2, width = 2 },
            attackDamage = 5,
            attacooldown = 2,
            viewDistance = 5,
            attackRange = 20,
            lastAttackCd = 0,
            speed = 200,
            x = "not assigned",
            y = "not assigned",
            z = "not assigned",
            id = "int_num",
            angleDeg = 50,
            AItype = "normal",
            sprites = sprites.guy,
        }
    }
}

-- Deep copy helper
local function deepcopy(orig)
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

-- Create enemy instance
function enemyClass.create(enemyType, x, y, z, id)
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