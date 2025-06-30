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

        vmt = 0
        hmt = 0

        DOF = 0
        -- HORIZONTAL LINE CHECK
        local distanceH = 100000000 --really high number because we wan't shortest distance
        local hx = player.x
        local hy = player.y -- horizontal values of the start X and Y

        local aTan = -1 / math.tan(ra) -- arc tan
        if ra > math.pi then
            ry = math.floor(player.y / map.mapS) * map.mapS - 0.0001
            rx = (player.y - ry) * aTan + player.x
            yo = -map.mapS
            xo = -yo * aTan
        elseif ra < math.pi then
            ry = math.floor(player.y / map.mapS) * map.mapS + map.mapS
            rx = (player.y - ry) * aTan + player.x
            yo = map.mapS
            xo = -yo * aTan
        else
            rx = player.x
            ry = player.y
            DOF = 8
        end

        while DOF < 8 do
            local mx = math.floor(rx / map.mapS)
            local my = math.floor(ry / map.mapS)

            local map = require("map")

            local mp = my * map.mapX + mx + 1

            if mp > 0 and mp < map.mapX * map.mapY and map.mapW[mp] > 0 then
                hx = rx
                hy = ry
                distanceH = rays.distance(player.x, player.y, hx, hy, ra)
                DOF = 8
                hmt= map.mapW[mp] - 1
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
            rx = math.floor(player.x / map.mapS) * map.mapS - 0.0001
            ry = (player.x - rx) * nTan + player.y
            xo = -map.mapS
            yo = -xo * nTan
        elseif ra < P2 or ra > P3 then
            rx = math.floor(player.x / map.mapS) * map.mapS + map.mapS
            ry = (player.x - rx) * nTan + player.y
            xo = map.mapS
            yo = -xo * nTan
        else
            rx = player.x
            ry = player.y
            DOF = 8
        end

        while DOF < 8 do
            local mx = math.floor(rx / map.mapS)
            local my = math.floor(ry / map.mapS)

            local map = require("map")

            local mp = my * map.mapX + mx + 1

            if mp > 0 and mp < map.mapX * map.mapY and map.mapW[mp] > 0 then
                vx = rx
                vy = ry
                distanceV = rays.distance(player.x, player.y, vx, vy, ra)
                DOF = 8
                vmt = map.mapW[mp] - 1
            else
                rx = rx + xo
                ry = ry + yo
                DOF = DOF + 1
            end
        end

        local shade = 1

        if distanceV < distanceH then
            hmt = vmt
            rx = vx
            ry = vy
            finalDis = distanceV
            shade = 0.75
        else
            rx = hx
            ry = hy
            finalDis = distanceH
        end

        local cameraAngle = player.angle - ra
        
        if cameraAngle < 0 then
            cameraAngle = cameraAngle + 2 * math.pi
        end

        if cameraAngle > 2 * math.pi then
            cameraAngle = cameraAngle - 2 * math.pi
        end

        finalDis = finalDis * math.cos(cameraAngle)
        
        --local temp = {love.graphics.getColor()}
        --love.graphics.setColor(0,1,0)
        --love.graphics.line(player.x, player.y, rx, ry)
        --love.graphics.setColor(temp)

        local lineH = (map.mapS * map.height) / finalDis
        local offset = map.height/2 - lineH/2
        --love.graphics.line(r * 20, offset, r * 20, offset + lineH)

        --love.graphics.rectangle("fill", r * 20 - 20, offset, 20, lineH)



        -- drawing walls
        local textures = require("textures")
        local tyStep = 32 / lineH
        local ty = 0+hmt * 32
        if shade == 1 then
            tx = (rx / 2) % 32
            if ra > 180 then
                tx = 31 - tx
            end
        else
            tx = (ry / 2) % 32
            if ra > 90 and ra < 270 then
                tx = 31 - tx
            end
        end

        love.graphics.setPointSize(15)
        for y = 0, lineH do
            local c = textures[math.floor(ty) * 32 + 1 + math.floor(tx)] * shade

            if hmt == 0 then
                love.graphics.setColor(c    , c / 2, c / 2)
            elseif hmt == 1 then
                love.graphics.setColor(c    , c    , c / 2)
            elseif hmt == 2 then
                love.graphics.setColor(c / 2, c / 2, c    )
            elseif hmt == 3 then
                love.graphics.setColor(c / 2, c    , c / 2)
            else
                love.graphics.setColor(c, c, c)
            end
            love.graphics.points(r * 15 - 15, y + offset)
            ty = ty + tyStep
        end

        -- drwaing floor
        local screenHeight = love.graphics.getHeight()
        for y = lineH + offset, screenHeight do
            local dy = y - (screenHeight / 2)
            local deg = ra
            local raFix = math.cos(fixAngleRad(player.angle - ra))

            local tx = player.x / 2 + math.cos(deg) * 158 * 32 / dy / raFix
            local ty = player.y / 2 - math.sin(deg) * 158 * 32 / dy / raFix

            local mapPoint = map.mapF[math.floor(ty / 32) * map.mapX + math.floor(tx/32) + 1] * 32 * 32

            local txi = (math.floor(tx) % 32)
            local tyi = (math.floor(ty) % 32)
        
            local c = textures[tyi * 32 + txi + 1 + mapPoint] * 0.7


            love.graphics.setColor(c, c, c)
            love.graphics.points(r * 15, y)

            --draw ceiling

            local mapPoint = map.mapC[math.floor(ty / 32) * map.mapX + math.floor(tx/32) + 1] * 32 * 32

            local txi = (math.floor(tx) % 32)
            local tyi = (math.floor(ty) % 32)
        
            local c = textures[tyi * 32 + txi + 1 + mapPoint] * 0.7


            love.graphics.setColor(c, c, c)
            love.graphics.points(r * 15, screenHeight-y)
        end

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

function fixAngleRad(a)
    if a < 0 then
        return a + 2 * math.pi
    elseif a > 2 * math.pi then
        return a - 2 * math.pi
    else
        return a
    end
end

function rays.distance(ax, ay, bx, by, angle)
    return ( math.sqrt((bx - ax) * (bx-ax) + (by-ay) * (by-ay)))
end

return rays