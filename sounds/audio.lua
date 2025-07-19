--this file is for most of the audio work, it'll load all the music, because it's expensive to load it every frame

local settings = require("UINreletad.settings")

audio = {
    blockBreak = love.audio.newSource("sounds/effects/blockBreak.wav", "static"),
    pickup = love.audio.newSource("sounds/effects/pickup.wav", "static"),
}

audio.blockBreak:setVolume(settings.audio.effects)

return audio