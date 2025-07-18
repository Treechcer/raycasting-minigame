-- in this file is everything needed to make inventory system, for both inventory system (current one and the future one for armor)

inventory = {
    maxSlots = 3, -- this will be able to be increased with powerups... it might not work if I increase it ngl
    equipedGunSlot = 1, -- slot that is equiped rn
    gunSlots = {"pickaxe", "", ""}, -- these are the items we have in inventory 
    scrollCooldown = 10000, -- doesn't need explanaition

    boxSize = 50 -- this is size of the boxes we render
}

local game = require("game.properties.game")
local sprites = require("sprites.spriteLoad")
local colors = require("UINreletad.colors")

function inventory.draw() -- this is the function to draw the inventory, it doesn't need any inputs because it draws everything needed
    love.graphics.setLineWidth(2)
    for i = 1, 3 do
        if i ~= inventory.equipedGunSlot then -- this draws the unequiped boxes
            love.graphics.setColor(colors.darkGray)
            love.graphics.rectangle("line", game.width / 2 - (inventory.boxSize * 2.6) + (inventory.boxSize * (i)), game.height - inventory.boxSize * 1.5, inventory.boxSize, inventory.boxSize)
        end
        sprite = sprites[inventory.gunSlots[i]] -- sets the sprite from inventory

        if sprite == nil then
            sprite = sprites["fists"] -- empty slot => hands / fists tha will be able to attack one day
        end

        -- this gets the correct size of the image and then draws it

        local spriteX = sprite:getWidth()
        local spriteY = sprite:getHeight()

        local scaleX = ((inventory.boxSize - 10) / spriteX)
        local scaleY = ((inventory.boxSize - 10) / spriteY)
        love.graphics.setColor(colors.white)
        love.graphics.draw(sprite, game.width / 2 - (inventory.boxSize * 2.6) + (inventory.boxSize * (i)) + 5, game.height - inventory.boxSize * 1.5 + 5, 0, scaleX, scaleY)
        
        --
    end

    -- this slot is highligted because it's equiped

    love.graphics.setColor(colors.red)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle("line", game.width / 2 - (inventory.boxSize * 2.6) + (inventory.boxSize * (inventory.equipedGunSlot)), game.height - inventory.boxSize * 1.5, inventory.boxSize, inventory.boxSize)

    --
end

return inventory