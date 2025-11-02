local Class = require("libs.class")
local Ball = Class:derive("Ball")
local Timer = require("libs.timer")

function Ball:beginContact(a, b, coll)
  local x, y = coll:getPositions()

  -- bola e chão
  if (a == self.fixture and b:getUserData() == "ground") or
     (b == self.fixture and a:getUserData() == "ground") 
  then
    if self.game.speed ~= 1 then return end

    if x < love.graphics.getWidth()/2 then
      -- bola caiu no campo da esquerda
      self:add_point(self.p2)
    else
      -- bola caiu no campo da direita
      self:add_point(self.p1)
    end
  end

  -- bola e player
  local p1, p2
  if (a == self.fixture and string.find(b:getUserData().kind or "", "Player")) then
    p1 = b:getUserData()
  elseif (b == self.fixture and string.find(a:getUserData().kind or "", "Player")) then
    p1 = a:getUserData()
  end

  if p1 then
    if self.game.speed ~= 1 then return end

    p2 = self.p1 == p1 and self.p2 or self.p1

    p1.triggerTouch.active = true
    p1.triggerTouch.position = {x = x, y = y}

    p1.touches = p1.touches + 1
    p1.triggerTouch.savedTouch = p1.touches

    if p1.touches > 3 then
      self:add_point(p2)
    end
  end

  -- bola e sensor
  if (a == self.fixture and b:getUserData() == "sensor") or
     (b == self.fixture and a:getUserData() == "sensor") 
  then
    self.p1.touches = 0
    self.p2.touches = 0
  end
end

function Ball:add_point(player, time)
  player.score = player.score + 1
  self.game.speed = 0.2

  Timer.after(time or 2, function()
    self.resetSide = player.side
    self.game.speed = 1
  end)
end

function Ball:reset_position(dir)
  local x = love.graphics.getWidth()/2 + (self.r/2 + 50)*dir
  local y = 50
  
  self.body:setPosition(x, y)
  self.body:setLinearVelocity(0, 0)    -- zera velocidade linear
  self.body:setAngularVelocity(0)      -- zera velocidade de rotação
  self.body:setAngle(0)                -- reseta rotação (opcional)
  self.body:applyLinearImpulse(100 * dir, 0)
end

function Ball:new(world, p1, p2, game)
  self.r = 32
  self.x = love.graphics.getWidth()/2 - (self.r/2 + 50)
  self.y = 50
  self.texture = love.graphics.newImage("assets/ball.png")
  self.resetSide = nil

  self.body = love.physics.newBody(world, self.x, self.y, "dynamic")
  self.shape = love.physics.newCircleShape(self.r)
  self.fixture = love.physics.newFixture(self.body, self.shape)
  self.fixture:setUserData(self)

  self.p1 = p1
  self.p2 = p2
  self.game = game
  
  -- caractericas da bola
  self.fixture:setDensity(0.2)
  self.fixture:setRestitution(0.8)
  self.fixture:setFriction(0.1)
  self.body:resetMassData()
  self.body:setGravityScale(0.5)
  self.body:applyLinearImpulse(-100, 0)
end

function Ball:update(dt)
  if self.resetSide then
    self:reset_position(self.resetSide)
    self.p1:reset()
    self.p2:reset()
    self.resetSide = nil
  else
    self.x, self.y = self.body:getPosition()
    self.angle = self.body:getAngle()
    Timer.update(dt / self.game.speed)
  end
end

function Ball:draw()
  local x, y = self.body:getPosition()
  if (y < 0)  then love.graphics.polygon("fill", triangleAtVec(x, y)) end -- faz um pequeno triangulo quando a bola sai da tela

  love.graphics.draw(self.texture, self.x, self.y, self.angle, 1, 1, self.r, self.r)
end

function triangleAtVec(x, y, side)
  side = side or 15

  local lockedY = 20
  local verticalHeight = love.graphics.getHeight() - y
  local verticalMultiplier = 1 + (verticalHeight - love.graphics.getHeight()) / 500

  side = side * verticalMultiplier
  local h = side * math.sqrt(3) / 2

  local vec = {x - side/2, lockedY - h / 3,
               x         , lockedY + h * 2 / 3,
               x + side/2, lockedY - h / 3}
  return vec
end

return Ball