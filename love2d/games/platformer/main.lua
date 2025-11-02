local Player = require("Player")
local Walls = require("Walls")
local Camera = require("libs.camera")

local cam = Camera()

local PIXELS_PER_METER = 100
local world = love.physics.newWorld(0, 9.81 * PIXELS_PER_METER)

function love.load()
  love.graphics.setDefaultFilter("nearest", "nearest")

  Walls:load(world)
  Player:load(world)

  cam:zoom(4)
end

function love.update(dt)
  world:update(dt)

  Walls:update(dt)
  Player:update(dt)

  cam:lookAt(Player.x, Player.y)

  if cam.x < love.graphics.getWidth()/2 then cam.x = love.graphics.getWidth()/2
  -- elseif cam.x > w/2 then cam.x = w/2 
  end

  if cam.y < love.graphics.getHeight()/2 then cam.y = love.graphics.getHeight()/2
  end

end

function love.draw()
  cam:attach()
    Walls:draw()
    Player:draw()
  cam:detach()
end