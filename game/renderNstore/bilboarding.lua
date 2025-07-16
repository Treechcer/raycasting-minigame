bilboarding = {
    --bilboards will stored as indexed table: {sprite = image object, x = int, y = int, z = int} (z = height up or down)
}

local spriteLoad = require("sprites.spriteLoad")

function bilboarding.createBilboard(sprite, x, y, z, heightAplify, widthAplify)
    table.insert(bilboarding, {sprite = sprite, x = x, y = y, z = z, heightAplify = heightAplify, widthAplify = widthAplify, distance = 0})
end

function bilboarding.print()
    for i = 1, #bilboarding, 1 do
        print(i)
    end
end

bilboarding.createBilboard(spriteLoad.testRotation, 100, 100, 0, 1, 1)

return bilboarding