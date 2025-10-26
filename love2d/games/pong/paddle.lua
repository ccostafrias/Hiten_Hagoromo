local Class = require("class")
local Paddle = Class:derive("Paddle")

function Paddle:new(startX, img, speed)
  self.img = love.graphics.newImage("assets/"..img..".png")
  self.width = self.img:getWidth()
  self.height = self.img:getHeight()
  self.sx = 1
  self.sy = 1
  self.scoreToWin = 3

  self.x = startX > 0 and startX or love.graphics.getWidth() - (-startX + self.width)
  self.speed = speed
  self:reset()
end

function Paddle:reset()
  self.score = 0
  self.y = love.graphics.getHeight() / 2
  self.yVel = 0
end

function Paddle:update(dt)
  self:move(dt)
  self:checkBoundaries()
end

-- default
function Paddle:move(dt) end

function Paddle:checkBoundaries()
  if self.y < 0 then
    self.y = 0
    
  elseif self.y + self.height > love.graphics.getHeight() then
    self.y = love.graphics.getHeight() - self.height 
  end
  
end

function Paddle:draw()
  -- love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
  love.graphics.draw(self.img, self.x, self.y, 0, self.sx, self.sy)
end

return Paddle