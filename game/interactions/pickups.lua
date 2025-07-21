pickups = {}

local map = require("game.properties.map")
local player = require("game.properties.player")
local engine = require("game.renderNstore.engine")
local inventory = require("game.renderNstore.inventory")
local bilboarding = require("game.renderNstore.bilboarding")
local audio = require("sounds.audio")

function pickups.pickupWeapon()
    for key, value in pairs(map.gunMap) do
        --print (engine.calculateDistance(player.x, player.y, map.gunMap[key].tileX * map.block2DSize, map.gunMap[key].tileY * map.block2DSize))
        --print(key)
        if engine.calculateDistance(player.x, player.y, map.gunMap[key].tileX * map.block2DSize, map.gunMap[key].tileY * map.block2DSize) <= 75 and inventory.gunSlots[inventory.equipedGunSlot] == "" then
            inventory.gunSlots[inventory.equipedGunSlot] = key

            local i
            local tempTable = map.gunIDs
            for key0, value0 in pairs(tempTable) do
                if value0.gun == key then
                    i = value0.id
                end
            end

            table.remove(bilboarding, i)
            --table.remove(map.gunMap, index)
            map.gunMap[key] = nil

            audio.pickup:setPitch(1 - math.random() / 2)
            audio.pickup:play()

            break
        end
    end
end

return pickups