rays = {

}

function rays.drawRays()
    local P2 = math.pi / 2
    local P3 = 3 * math.pi / 2
    local degree = math.rad(1)

    local player = require("player")
    local ra = player.angle -- ray angle
    local DOF = 0 -- depth of field
    local rx, ry, xo, yo --ray X, ray Y, step X, step Y
    local finalDis

    ra = player.angle - degree * 30
    
    if (ra < 0) then
        ra = ra + 2 * math.pi
    end

    if ra > 2 * math.pi then
        ra = ra - 2 * math.pi
    end

    for r = 1, 60 do
        DOF = 0
        -- HORIZONTAL LINE CHECK
        local distanceH = 100000000 --really high number because we wan't shortest distance
        local hx = player.x
        local hy = player.y -- horizontal values of the start X and Y

        local aTan = -1 / math.tan(ra) -- arc tan
        if ra > math.pi then
            ry = math.floor(player.y / 64) * 64 - 0.0001
            rx = (player.y - ry) * aTan + player.x
            yo = -64
            xo = -yo * aTan
        elseif ra < math.pi then
            ry = math.floor(player.y / 64) * 64 + 64
            rx = (player.y - ry) * aTan + player.x
            yo = 64
            xo = -yo * aTan
        else
            rx = player.x
            ry = player.y
            DOF = 8
        end

        while DOF < 8 do
            local mx = math.floor(rx / 64)
            local my = math.floor(ry / 64)

            local map = require("map")

            local mp = my * map.mapX + mx + 1

            if mp >= 0 and mp <= map.mapX * map.mapY and map.map[mp] == 1 then
                hx = rx
                hy = ry
                distanceH = rays.distance(player.x, player.y, hx, hy, ra)
                DOF = 8
            else
                rx = rx + xo
                ry = ry + yo
                DOF = DOF + 1
            end
        end

        -- VERTICAL LINE CHECK

        local distanceV = 100000000 --really high number because we wan't shortest distance
        local vx = player.x
        local vy = player.y -- vertical values of the start X and Y

        DOF = 0
        local nTan = -math.tan(ra) -- not / negative tan
        if ra > P2 and ra < P3 then
            rx = math.floor(player.x / 64) * 64 - 0.0001
            ry = (player.x - rx) * nTan + player.y
            xo = -64
            yo = -xo * nTan
        elseif ra < P2 or ra > P3 then
            rx = math.floor(player.x / 64) * 64 + 64
            ry = (player.x - rx) * nTan + player.y
            xo = 64
            yo = -xo * nTan
        else
            rx = player.x
            ry = player.y
            DOF = 8
        end

        while DOF < 8 do
            local mx = math.floor(rx / 64)
            local my = math.floor(ry / 64)

            local map = require("map")

            local mp = my * map.mapX + mx + 1

            if mp >= 0 and mp <= map.mapX * map.mapY and map.map[mp] == 1 then
                vx = rx
                vy = ry
                distanceV = rays.distance(player.x, player.y, vx, vy, ra)
                DOF = 8
            else
                rx = rx + xo
                ry = ry + yo
                DOF = DOF + 1
            end
        end

        if distanceV < distanceH then
            rx = vx
            ry = vy
            finalDis = distanceV
            love.graphics.setColor(0.9,0,0)
        else
            rx = hx
            ry = hy
            finalDis = distanceH
            love.graphics.setColor(0.7,0,0)
        end

        local cameraAngle = player.angle - ra
        
        if cameraAngle < 0 then
            cameraAngle = cameraAngle + 2 * math.pi
        end

        if cameraAngle > 2 * math.pi then
            cameraAngle = cameraAngle - 2 * math.pi
        end

        finalDis = finalDis * math.cos(cameraAngle)

        --love.graphics.line(player.x, player.y, rx, ry)

        local lineH = (map.mapS * map.height) / finalDis
        local offset = map.height/2 - lineH/2
        --love.graphics.line(r * 20, offset, r * 20, offset + lineH)

        love.graphics.rectangle("fill", r * 20 - 20, offset, 20, lineH)

        if lineH > map.height then
            lineH = map.height
        end

        ra = ra + degree

        if (ra < 0) then
            ra = ra + 2 * math.pi
        end

        if ra > 2 * math.pi then
            ra = ra - 2 * math.pi
        end
    end
end

function rays.distance(ax, ay, bx, by, angle)
    return ( math.sqrt((bx - ax) * (bx-ax) + (by-ay) * (by-ay)))
end

return rays