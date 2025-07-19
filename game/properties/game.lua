-- all variables needed in between levels etc. hence why it's called "game"

game = {
    debug = false,
    width = love.graphics.getWidth(),
    height = love.graphics.getHeight()
}

game.canvas = love.graphics.newCanvas(game.width, game.height)

return game