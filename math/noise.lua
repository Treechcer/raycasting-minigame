--this file is for generating random noise map, for precedular generatio

local map = require("game.properties.map")
local bit = require("bit")

noise = { -- all needed variables that needs to be stored
    seed = os.time(),
    len = map.lenght,
    hei = map.height,
}

function noise.generateMap()
    local tempMap = {}

    for y = 1, noise.hei do
        for x = 1, noise.len do
            table.insert(tempMap, noise.generation(x, y))
        end
    end

    return tempMap
end

function noise.generation(x, y)
    xl = math.floor(x) -- xl and xr are points on the square
    xr = math.floor(x) + 1

    yl = math.floor(y)
    yr = math.floor(y) + 1

    tx = x - xl
    ty = y - yl

    local c00 = noise.ran(xl, yl) -- these make the "random" noise
    local c01 = noise.ran(xr, yl)
    local c10 = noise.ran(xl, yr)
    local c11 = noise.ran(xr, yr)

    local t1 = noise.lerp(c00, c01, tx)
    local t2 = noise.lerp(c10, c11, tx)

    return noise.lerp(t1, t2, ty)
end

function noise.ran(x,y) -- I don't really remmebr but I used some tutorial for this, I just changed some of the numbers
    local result = x * 8660254037 + y * 20194423349 + noise.seed * 30000101111
    result = bit.band(result, 0xffffffff) -- making it 32b number
    result = bit.bxor(result, bit.rshift(result, 13))
    result = bit.band(result * 1274126177, 0xffffffff)
    result = bit.bxor(result, bit.rshift(result, 16))
    return bit.band(result, 0x7fffffff) / 0x7fffffff
end

function noise.lerp(a,b,t) -- this was in the tutorial as well if I recall correctly
    return (a + (b - a) * t)
end

return noise