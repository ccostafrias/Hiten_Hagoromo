require "player"
require "ball"
require "opponent"

function love.keypressed(key, scancode, isrepeat)
  Ball:keys_pressed()

	if key == "escape" then
		love.event.quit()
	end
end

function love.load()
  Player:load()
  Opponent:load()
  Ball:load()
end

function love.update(dt)
  Player:update(dt)
  Opponent:update(dt)
  Ball:update(dt)
end

function love.draw()
	-- limpando a tela com um azul acinzentado
	love.graphics.clear(0.25, 0.25, 0.5)
	
  Opponent:draw()
  Player:draw()
  Ball:draw()
end

function checkCollision(a, b)
  if a.x < b.x + b.width and -- esquerda de A passou a direita de B
     a.x + a.width > b.x and -- direita de A passou a esquerda de B
     a.y < b.y + b.height and -- topo de A passou a base de B
     a.y + a.height > b.y then -- base de A passou o topo de B
     
     return true
  else
    return false
  end
  
end