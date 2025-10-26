local Menu = {}

function Menu:keypressed(key)
  
end

function Menu:load()
  
end

function Menu:update(dt)
  
end

function Menu:draw()
  love.graphics.clear(0.25, 0.25, 0.5)
  love.graphics.setFont(fontMenu)
  love.graphics.printf("Pong!", 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
end

return Menu