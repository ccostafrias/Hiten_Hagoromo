local Class = require("Class")
local GameState = require("GameState")
local Ball = Class:derive("Ball")

local particleEmitter

function Ball:reset(direction)
  self.x = love.graphics.getWidth() / 2
  self.y = love.graphics.getHeight() / 2
  self.xVel = self.speed * direction
  self.yVel = 0
  self.multiplier = 1
  particleEmitter:reset()
end

function Ball:keypressed(key)
  if key == "r" then
    self:reset(-1)
  end
end

function Ball:new(speed)
  start_particle()

  self.image = love.graphics.newImage("assets/ball.png")
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()
  self.multiplier = 1
  self.yMult = 5

  self.speed = speed
  self:reset(-1)
end

function Ball:update(dt)
  self:move(dt)
  self:collide()

  particleEmitter:update(dt)
  particleEmitter:setPosition(self.x + self.width/2, self.y + self.height/2) -- move o emitter junto com a bola, dando o efeito de rastro
end

function Ball:move(dt)
  self.x = self.x + self.xVel * self.multiplier * dt
  self.y = self.y + self.yVel * self.multiplier * dt
end

function Ball:collide()
  self:collidePlayer()
  self:collideOpponent()
  self:collideWall()
  self:score()
end

function Ball:collideWall()
  if self.y < 0 then
    self.y = 0
    self.yVel = -self.yVel
  elseif self.y + self.height > love.graphics.getHeight() then
    self.y = love.graphics.getHeight() - self.height
    self.yVel = -self.yVel
  end
end

function Ball:collidePlayer()
  if checkCollision(self, GameState.player) then
    self.xVel = self.speed

    local middleBall = self.y + self.height / 2
    local middlePlayer = GameState.player.y + GameState.player.height / 2
    local collisionPosition = middleBall - middlePlayer
    self.yVel = collisionPosition * self.yMult
    self.multiplier = self.multiplier + .05
  end
end

function Ball:collideOpponent()
  if checkCollision(self, GameState.opponent) then
    self.xVel = -self.speed

    local middleBall = self.y + self.height / 2
    local middleOpponent = GameState.opponent.y + GameState.opponent.height / 2
    local collisionPosition = middleBall - middleOpponent
    self.yVel = collisionPosition * self.yMult
    self.multiplier = self.multiplier * 1.1
  end
end

function Ball:score()
  if self.x < 0 then
    self:reset(1)
    GameState.opponent.score = GameState.opponent.score + 1
  elseif self.x + self.width > love.graphics.getWidth() then
    self:reset(-1)
    GameState.player.score = GameState.player.score + 1
  end
end

function Ball:draw()
  love.graphics.draw(particleEmitter)
  love.graphics.draw(self.image, self.x, self.y)
end

function start_particle()
  local particleImg = love.graphics.newImage("assets/particle.png")
  particleEmitter = love.graphics.newParticleSystem(particleImg, 100)

  particleEmitter:setParticleLifetime(1, 1) -- dura exatamente 1 segundo
  particleEmitter:setEmissionRate(15) -- emite 15 partículas por segundo
  particleEmitter:setSizes(5, 0) -- varia de 5 vezes o tamanho original até 0
  particleEmitter:setColors(1, 1, 1, 1, 1, 1, 1, 0) -- faz um fade, do branco ao transparente
end

return Ball