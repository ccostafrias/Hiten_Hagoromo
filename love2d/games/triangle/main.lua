require "mouse"

Triangle = {}

function update_color(dt)
  total_time = total_time + dt
  if math.fmod(total_time, .3) < .1 then
    Triangle.color = {1, 0, 0, 1}
  elseif math.fmod(total_time, .3) < .2 then
    Triangle.color = {0, 1, 0, 1}
  else
    Triangle.color = {0, 0, 1, 1}
  end
end

function update_triangle_vertices()
  Triangle.vertices = {
    Triangle.pos.x - Triangle.edge / 2, Triangle.pos.y + Triangle.height / 3,
    Triangle.pos.x                    , Triangle.pos.y - Triangle.height * 2 / 3,
    Triangle.pos.x + Triangle.edge / 2, Triangle.pos.y + Triangle.height / 3
  }
end

function update_movement()
  if love.keyboard.isDown("w") then
    Triangle.pos.y = Triangle.pos.y - Triangle.velocity
  end

  if love.keyboard.isDown("a") then
    Triangle.pos.x = Triangle.pos.x - Triangle.velocity
  end

  if love.keyboard.isDown("s") then
    Triangle.pos.y = Triangle.pos.y + Triangle.velocity
  end

  if love.keyboard.isDown("d") then
    Triangle.pos.x = Triangle.pos.x + Triangle.velocity
  end
end

function love.mousepressed(x, y, button, istouch, presses)
  if button == 1 then
    Triangle.pos.x = x
    Triangle.pos.y = y
  end
end

function love.keypressed(key, scancode, isrepeat)
  if key == "escape" then
    love.event.quit()
  end
  
  if key == "space" then
    if Triangle.color[1] == 1 then
      Triangle.color = {0, 1, 0, 1} -- de vermelho pra verde
    elseif Triangle.color[2] == 1 then
      Triangle.color = {0, 0, 1, 1} -- de verde pra azul
    else
      Triangle.color = {1, 0, 0, 1} -- de azul pra vermelho
    end
  end
end

function love.load()
  -- variaveis iniciais
  Triangle.pos = {x = love.graphics.getWidth() / 2, y = love.graphics.getHeight() / 2}
  Triangle.velocity = 5
  Triangle.color = {1, 0, 0, 1}
  Triangle.edge = 200
  Triangle.height = Triangle.edge * 1.732 / 2
  update_triangle_vertices()

  total_time = 0
end

function love.update(dt)
  update_movement()
  update_triangle_vertices()
  if verify_mouse_inside() then
    update_color(dt)
  else
    Triangle.color = {1, 0, 0, 1}
  end
end

function love.draw()
  love.graphics.setColor(Triangle.color)
  love.graphics.polygon("fill", Triangle.vertices)
end