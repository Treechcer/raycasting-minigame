player = {
    x = 300,
    y = 300,
    angle = 0,
}

function player.drawPlayer()
    --[[love.graphics.line(player.x, player.y, player.x + player.deltaX * 5, player.y + player.deltaY * 5)

    love.graphics.setColor(1,1,0)
    love.graphics.rectangle("fill", player.x, player.y, 10, 10)]]
end

function player.move(d, dt)
    -- not in use, was used for testing
    player.x = player.x + d.x * dt
    player.y = player.y + d.y * dt
end

return player