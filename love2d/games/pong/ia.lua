local Paddle = require("paddle")
local IA = Paddle:derive("IA")

function IA:new(startX, img, speed, sx, sy, opts, ball)
  Paddle.new(self, startX, img, speed)

  self.ball = ball
  self.timer = 0
  self.sx = sx
  self.sy = sy

  -- atributos adicionais
  for key, value in pairs(opts or {}) do
    self[key] = value
  end
end

function IA:move(dt)
  -- a cada 'rate' segundos, o opponent receberá a posição relativa da bola (acima ou abaixo dele)
  self.timer = self.timer + dt

  if self.timer > self.rate then
    self.timer = 0
    self:acquireTarget()
  end
  
  self.y = self.y + self.yVel * dt
end

function IA:acquireTarget()
  -- se a bola está acima
  if self.ball.y + self.ball.height < self.y then
    self.yVel = -self.speed
  -- se a bola está abaixo
  elseif self.ball.y > self.y + self.height then
    self.yVel = self.speed
  end
end

return IA