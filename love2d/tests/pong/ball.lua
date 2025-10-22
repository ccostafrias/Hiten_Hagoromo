Ball = {}

function Ball:reset(side)
  self.x = love.graphics.getWidth() / 2
  self.y = love.graphics.getHeight() / 2
  self.xVel = self.speed * side
  self.yVel = 0
end

function Ball:keys_pressed()
  if love.keyboard.isDown("r") then
    self:reset(-1)
  end
end

function Ball:load()
  self.radius = 10
  self.width = 20
  self.height = 20
  self.speed = 400
  self:reset(-1)
end

function Ball:update(dt)
  self:move(dt)
  self:collide()
end

function Ball:move(dt)
  self.x = self.x + self.xVel * dt
  self.y = self.y + self.yVel * dt
end

function Ball:collide()
  if checkCollision(self, Player) then
    self.xVel = self.speed

    local middleBall = self.y + self.height / 2
    local middlePlayer = Player.y + Player.height / 2
    local collisionPosition = middleBall - middlePlayer
    self.yVel = collisionPosition * 5
  elseif checkCollision(self, Opponent) then
    self.xVel = -self.speed

    local middleBall = self.y + self.height / 2
    local middleOpponent = Opponent.y + Opponent.height / 2
    local collisionPosition = middleBall - middleOpponent
    self.yVel = collisionPosition * 5
  end

  if self.y < 0 then
    self.y = 0
    self.yVel = -self.yVel
  elseif self.y + self.height > love.graphics.getHeight() then
    self.y = love.graphics.getHeight() - self.height
    self.yVel = -self.yVel
  end

  if self.x < 0 then
    self:reset(1)
    Opponent.score = Opponent.score + 1
  elseif self.x + self.width > love.graphics.getWidth() then
    self:reset(-1)
    Player.score = Player.score + 1
  end
end

function Ball:draw()
  love.graphics.circle("fill", self.x, self.y, self.radius)
end