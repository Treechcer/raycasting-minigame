inventory = {
    maxSlots = 3,
    equipedGunSlot = 1,
    gunSlots = {"pickaxe", "gun", "granade"},
    scrollCooldown = 10000,

    boxSize = 50
}

local game = require("game.properties.game")
local sprites = require("sprites.spriteLoad")
local colors = require("UINreletad.colors")

function inventory.draw()
    love.graphics.setLineWidth(2)
    for i = 1, 3 do
        if i ~= inventory.equipedGunSlot then
            love.graphics.setColor(colors.darkGray)
            love.graphics.rectangle("line", game.width / 2 - (inventory.boxSize * 2.6) + (inventory.boxSize * (i)), game.height - inventory.boxSize * 1.5, inventory.boxSize, inventory.boxSize)
        end
        sprite = sprites[inventory.gunSlots[i]]

        local spriteX = sprite:getWidth()
        local spriteY = sprite:getHeight()

        local scaleX = ((inventory.boxSize - 10) / spriteX)
        local scaleY = ((inventory.boxSize - 10) / spriteY)
        love.graphics.setColor(colors.white)
        love.graphics.draw(sprite, game.width / 2 - (inventory.boxSize * 2.6) + (inventory.boxSize * (i)) + 5, game.height - inventory.boxSize * 1.5 + 5, 0, scaleX, scaleY)
    end

    love.graphics.setColor(colors.red)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle("line", game.width / 2 - (inventory.boxSize * 2.6) + (inventory.boxSize * (inventory.equipedGunSlot)), game.height - inventory.boxSize * 1.5, inventory.boxSize, inventory.boxSize)

end

return inventory