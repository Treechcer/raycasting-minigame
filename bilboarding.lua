bilboarding = {
    --bilboards will stored as indexed table: {sprite = image object, x = int, y = int, z = int} (z = height up or down)
}

local spriteLoad = require("sprites.spriteLoad")

table.insert(bilboarding, {sprite = spriteLoad.gun, x = 100, y = 100, z = -600}) -- z = - 600 is ground level

return bilboarding