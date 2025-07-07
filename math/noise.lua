local map = require("game.properties.map")

noise = {
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
    xl = math.floor(x)
    xr = math.floor(x) + 1

    yl = math.floor(y)
    yr = math.floor(y) + 1

    tx = x - xl
    ty = y - yl

    local c00 = noise.ran(xl, yl)
    local c01 = noise.ran(xr, yl)
    local c10 = noise.ran(xl, yr)
    local c11 = noise.ran(xr, yr)

    local t1 = noise.lerp(c00, c01, tx)
    local t2 = noise.lerp(c10, c11, tx)

    return noise.lerp(t1, t2, ty)
end

function noise.ran(x,y)
    return math.sin(x * 10.5476546876 + y * 70.454645374453734 + noise.seed) % 1
end

function noise.lerp(a,b,t)
    return (a + (b - a) * t)
end

return noise