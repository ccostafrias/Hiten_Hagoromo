Opponent = {}

function Opponent:load()
  self.width = 20
  self.height = 100
  self.x = love.graphics.getWidth() - (50 + self.width)
  self.y = love.graphics.getHeight() / 2
  self.speed = 300
  self.yVel = 0
  self.score = 0

  self.timer = 0
  self.rate = 1
end

function Opponent:update(dt)
  self:move(dt)
  self.timer = self.timer + dt

  if self.timer > self.rate then
    self.timer = 0
    self:acquireTarget()
  end

  self:checkBoundaries()
end

function Opponent:move(dt)
  self.y = self.y + self.yVel * dt
end

function Opponent:acquireTarget()
  if Ball.y + Ball.height < self.y then
    self.yVel = -self.speed
  elseif Ball.y > self.y + self.height then
    self.yVel = self.speed
  end
end

function Opponent:checkBoundaries()
  if self.y < 0 then
    self.y = 0
    
  elseif self.y + self.height > love.graphics.getHeight() then
    self.y = love.graphics.getHeight() - self.height 
  end
  
end

function Opponent:draw()
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end