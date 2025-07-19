pickups = {}

local map = require("game.properties.map")
local player = require("game.properties.player")
local engine = require("game.renderNstore.engine")
local inventory = require("game.renderNstore.inventory")
local bilboarding = require("game.renderNstore.bilboarding")

function pickups.pickupWeapon()
    for key, value in pairs(map.gunMap) do
        --print (engine.calculateDistance(player.x, player.y, map.gunMap[key].tileX * map.block2DSize, map.gunMap[key].tileY * map.block2DSize))
        print(key)
        if engine.calculateDistance(player.x, player.y, map.gunMap[key].tileX * map.block2DSize, map.gunMap[key].tileY * map.block2DSize) <= 50 then
            if inventory.gunSlots[inventory.equipedGunSlot] == "" then
                inventory.gunSlots[inventory.equipedGunSlot] = key

                local i
                for index, value0 in ipairs(map.gunIDs) do
                    if value0 == key then
                        i = index
                    end
                end

                table.remove(bilboarding, i)
                --table.remove(map.gunMap, index)
                map.gunMap[key] = nil
                break
            end
        end
    end
end

return pickups