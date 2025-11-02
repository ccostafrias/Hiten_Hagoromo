local Walls = require("Walls")
local Ball = require("Ball")
local PlayerLeft = require("players.playerLeft")
local PlayerRight = require("players.playerRight")

PIXELS_PER_METER = 100
thickness = 20
message = ""

local background = love.graphics.newImage("assets/beach.jpg")
local game = { speed = 1, pause = true }
local world = {}
local p1
local p2
local ball

function beginContact(a, b, coll)
  p1:beginContact(a, b, coll)
  p2:beginContact(a, b, coll)
  ball:beginContact(a, b, coll)
end

function endContact()
  -- por enquanto, nada
end

function love.keypressed(key)
  if key == "p" then
    game.pause = not game.pause
  end
  
  p1:keypressed(key)
  p2:keypressed(key)
end

function love.load()
  fontGame = love.graphics.newFont('fonts/PressStart2P-Regular.ttf', 30)
  fontSmaller = love.graphics.newFont('fonts/PressStart2P-Regular.ttf', 15)
  love.graphics.setDefaultFilter("nearest", "nearest")
  
  world = love.physics.newWorld(0, 9.81 * PIXELS_PER_METER)
  world:setCallbacks(beginContact, endContact)

  p1 = PlayerLeft(world)
  p2 = PlayerRight(world)
  ball = Ball(world, p1, p2, game)

  Walls:load(world)
end

function love.update(dt)
  dt = dt * game.speed
  if not game.pause then
    world:update(dt)
  
    Walls:update(dt)
    ball:update(dt)
    p1:update(dt)
    p2:update(dt)
  end
end

function love.draw()
  -- love.graphics.draw(background, 0, 0)
  Walls:draw()
  ball:draw()
  p1:draw()
  p2:draw()

  love.graphics.setFont(fontGame)
  love.graphics.printf(p1.score.."x"..p2.score, 0, 50, love.graphics.getWidth(), "center")
  love.graphics.printf(message, 0, 0, love.graphics.getWidth(), "center")
end