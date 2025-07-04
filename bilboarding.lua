bilboarding = {
    --bilboards will stored as indexed table: {sprite = image object, x = int, y = int, z = int} (z = height up or down)
}

local spriteLoad = require("sprites.spriteLoad")

function bilboarding.createBilboard(spriteLocation, x, y, z)
    table.insert(bilboarding, {sprite = spriteLocation, x = x, y = y, z = z})
end

bilboarding.createBilboard(spriteLoad.gun, 100, 100, -600) -- z = - 600 is ground level

return bilboarding