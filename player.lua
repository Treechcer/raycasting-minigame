player = {
    x = 300,
    y = 300,
    angle = 90,
    height = 10
}

function player.drawPlayer()
    love.graphics.line(player.x, player.y, player.x + player.deltaX * 5, player.y + player.deltaY * 5)

    love.graphics.setColor(1,1,0, 0.5)
    love.graphics.rectangle("fill", player.x, player.y, player.height, player.height)
end

function player.move(d, dt)
    -- not in use, was used for testing
    player.x = player.x + d.x * dt
    player.y = player.y + d.y * dt
end

return player