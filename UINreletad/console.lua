local colors = require("UINreletad.colors")
local game = require("game.properties.game")

console = {
    active = true,
    chatLog = {{color = colors.gray, message = "test", time = os.date("%H:%M")}, {color = colors.crosshair, message = "test", time = os.date("%H:%M")}}, -- test values

    --[[ here will be all messages in chat, in format like:
    {{type || color = "command" || colors.red, message = "message"}, {..}, {..}} -- I don't know yet if I'll use colors or type (or both duh)
    ]]

    commands = {"/seed", "/time", "/level", "/enemy"}, -- these are just a few commands that'll use
    -- /seed => outputs the seed of the map
    -- /time => outputs the time of the level
    -- /level => outputs the level that player is currently in
    -- /enemy => outputs some enemy informations
    -- ...

    consoleCD = 0.5,
    lastOpen = 1000000
}

function console.CD(dt)
    console.lastOpen = console.lastOpen + dt
end

function console.drawConsole()
    love.graphics.setColor(colors.seeThroughBlack)
    love.graphics.rectangle("fill", 0, game.height / 1.5, game.width, game.height / 3)
    
    local i = 1

    for key, value in pairs(console.chatLog) do
        love.graphics.setColor(console.chatLog[i].color)
        love.graphics.print("> (" .. console.chatLog[i].time .. ") " .. console.chatLog[i].message  , 0, game.height / 1.5 + (i - 1) * 16)
        i = i + 1
    end
end

return console