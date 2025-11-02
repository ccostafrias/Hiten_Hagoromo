local Player = {}

function Player:load(world)
  self.x = 10
  self.y = 10
  self.w = 33
  self.h = 32
  self.scale = 1
  self.speed = 300

  self.texture = love.graphics.newImage("assets/player.png")
  self.quad = love.graphics.newQuad(0, 0, self.w, self.h, self.texture)

  self.body = love.physics.newBody(world, self.x, self.y, "dynamic")
  self.shape = love.physics.newRectangleShape(self.w/2, self.h/2, self.w, self.h)
  self.fixture = love.physics.newFixture(self.body, self.shape)
end

function Player:update(dt)
  self:move(dt)
end

function Player:move(dt)
  local dx, dy = self.body:getLinearVelocity()
  dx = 0

  if love.keyboard.isDown("a") then
    dx = -self.speed
  end

  if love.keyboard.isDown("d") then
    dx = self.speed
  end

  if love.keyboard.isDown("space") then
    if dy == 0 then
      dy = -self.speed
    end
  end

  self.body:setLinearVelocity(dx, dy)
  self.x, self.y = self.body:getPosition()
end

function Player:draw()
  love.graphics.draw(self.texture, self.quad, self.x, self.y, 0, self.scale, self.scale)
end

return Player