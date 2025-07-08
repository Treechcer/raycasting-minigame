local settings = require("UINreletad.settings")

audio = {
    blockBreak = love.audio.newSource("sounds/effects/blockBreak.wav", "static")
}

audio.blockBreak:setVolume(settings.audio.effects)

return audio