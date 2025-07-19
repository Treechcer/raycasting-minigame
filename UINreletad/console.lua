local colors = require("UINreletad.colors")
local game = require("game.properties.game")
local noise = require("math.noise")

console = {
	active = false,
	chatLog = {},

    lastCommands = {""}, -- all used commands (if they were correct)
    lastCommandIndex = 1,

	commands = { "/seed", "/time", "/level", "/enemy" }, -- all valid commands

    commandFunctions = {
        seed = function () -- function printing the seed of your level
            console.chatLogAdd({message = noise.seed, color = colors.red, time = console.time()})
            table.insert(console.lastCommands, "/seed")
        end,

        -- all these functions are temp. functions because I didn't do the things for them to show, the data does not exist YET

        time = function ()
            console.chatLogAdd({message = "", color = colors.red, time = console.time()})
            table.insert(console.lastCommands, "/time")
        end,

        leve = function ()
            console.chatLogAdd({message = "temporary", color = colors.red, time = console.time()})
            table.insert(console.lastCommands, "/level")
        end,

        enem = function ()
            console.chatLogAdd({message = "temp enemy", color = colors.red, time = console.time()})
            table.insert(console.lastCommands, "/enemy")
        end
    },

    -- variables for cooldown 

	consoleCD = 0.5,
	lastOpen = 1000000,

    -- variables for the blinking ">"

	blinking = true,
	blinkiTime = 0,
	blinkCD = 0.5,
	lastBlink = 0,

    input = "",  -- here will be hte input of player stored

	time = function() -- function for getting time in console
		return os.date("%H:%M:%S")
	end,

	chatLogAdd = function(chatLog) -- this add log into console
		table.insert(console.chatLog, chatLog)
	end,
}

function console.CD(dt) -- resets CD for console
	console.lastOpen = console.lastOpen + dt
	console.lastBlink = console.lastBlink + dt
	console.blinkiTime = console.blinkiTime + dt

	if console.blinkiTime >= console.blinkCD - 0.1 then
		console.blinkiTime = 0
		console.blinking = not console.blinking
	end
end

function console.drawConsole() -- function for drawing the console
	love.graphics.setColor(colors.seeThroughBlack) --sets BG color
	love.graphics.rectangle("fill", 0, game.height / 1.5, game.width, game.height / 3) --draws BG

	local i = 1 -- I could do normal for loop, but I didn't, not gonna fix it lol
	for key, value in pairs(console.chatLog) do
		love.graphics.setColor(console.chatLog[i].color)
		love.graphics.print("> (" .. console.chatLog[i].time .. ") " .. console.chatLog[i].message, 0, game.height / 1.5 + (i - 1) * 16) --prints the log that is on the index
		i = i + 1
	end

    love.graphics.setColor(colors.gray)
	if console.blinking then -- if it now blinks it's drawn, if not it doens't
		love.graphics.print(">", 0, game.height - 16)
	end
    love.graphics.print(console.input, 8, game.height - 16) -- this is your input drawn
end

function console.takeInput(key) -- this adds a key into input
    console.input = console.input .. key
end

function console.check() -- this function checks if your command is correct (I can't have input for now, doesn't need it ngl)
    for index, value in ipairs(console.commands) do
        local regEx = "^" .. console.commands[index] .. "%s*"
        local result = string.find(console.input, regEx)
        print(result)

        if result then
            local func = console.commandFunctions[string.sub(console.input, 2, 5)]
            if type(func) == "function" then -- this calls correct function
                func()
                print(console.lastCommands[1])
            end

            console.input = "" -- resets console to "nothing"
            break
        end
    end
end

--these are temp chatLogs, they mean nothing

console.chatLogAdd({ color = colors.gray, message = "test", time = console.time() }) 
console.chatLogAdd({ color = colors.crosshair, message = "test", time = console.time() })

return console