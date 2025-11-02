local Walls = {}

function Walls:load(world)
  self.walls = {
    { x = 0, y = 0, w = 20, h = love.graphics.getHeight() },
    { x = 0, y = love.graphics.getHeight() - 20, w = love.graphics.getWidth(), h = 20 }
  }

  for _, wall in ipairs(self.walls) do
    wall.body = love.physics.newBody(world, wall.x, wall.y, "static")
    wall.shape = love.physics.newRectangleShape(wall.w/2, wall.h/2, wall.w, wall.h)
    wall.fixture = love.physics.newFixture(wall.body, wall.shape)
  end
end

function Walls:update(dt)
  
end

function Walls:draw()
  for _, wall in ipairs(self.walls) do
    love.graphics.rectangle("line", wall.x, wall.y, wall.w, wall.h)
  end
end

return Walls 