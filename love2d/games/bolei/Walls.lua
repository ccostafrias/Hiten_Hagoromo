local Class = require("libs.class")
local Walls = {}

function Walls:create(x, y, w, h, data, sensor)
  
end

function Walls:load(world)
  local windowH, windowW = love.graphics.getHeight(), love.graphics.getWidth()
  local sideWallHeight = 10*windowH
  self.walls = {
    { x = thickness/2           , y = windowH - sideWallHeight/2 , w = thickness  , h = sideWallHeight                                  }, -- parede esquerda
    { x = windowW/2             , y = windowH - thickness/2      , w = windowW    , h = thickness      , data = "ground"                }, -- chao
    { x = windowW - thickness/2 , y = windowH - sideWallHeight/2 , w = thickness  , h = sideWallHeight                                  }, -- parede direita
    { x = windowW/2             , y = windowH * 3/4 - thickness  , w = thickness  , h = windowH/2                                       }, -- rede
    { x = windowW/2             , y = windowH - sideWallHeight/2 , w = thickness/4, h = sideWallHeight , sensor = true, data = "sensor" }, -- sensor
  }

  for _, wall in ipairs(self.walls) do
    wall.body = love.physics.newBody(world, wall.x, wall.y, "static")
    wall.shape = love.physics.newRectangleShape(wall.w, wall.h)
    wall.fixture = love.physics.newFixture(wall.body, wall.shape)
    wall.fixture:setFriction(2.0)
    wall.fixture:setUserData(wall.data or 'wall')
    if wall.sensor then wall.fixture:setSensor(true) end
  end
end

function Walls:update(dt)
  
end

function Walls:draw()
  for _, wall in ipairs(self.walls) do
    if wall.sensor then goto continue end
    love.graphics.rectangle("line", wall.x - wall.w/2, wall.y - wall.h/2, wall.w, wall.h)

    ::continue::
  end
end

return Walls 