local class = require("Class")
local Button = class:derive("Button")

local ROUNDESS = 10

function Button:mousepressed(x, y)
  if self:is_limited(x, y) then
    self.isClicked = true
    if type(self.func) == "function" then self.func() end
  end
end

function Button:new(text, func, x, y, w, h)
  self.text = text
  self.func = func
  self.x = x
  self.y = y
  self.w = w
  self.h = h
  self.isClicked = false
  self.isHover = false
end

function Button:update(dt)
  local x, y = love.mouse.getPosition()

  if self:is_limited(x, y) then
    self.isHover = true
  else
    self.isHover = false
  end
end

function Button:is_limited(x, y)
  return x > self.x - self.w/2 and x < self.x + self.w - self.w/2 and y > self.y - self.h/2 and y < self.y + self.h - self.h/2
end

function Button:draw()
  if not self.isHover then 
    love.graphics.setColor(0, .1, .7, 1) 
  else 
    love.graphics.setColor(1, .2, .7, 1) 
  end
  love.graphics.rectangle("fill", self.x - self.w/2, self.y - self.h/2, self.w, self.h, ROUNDESS, ROUNDESS)

  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setFont(fontGame)
  love.graphics.printf(self.text, self.x - self.w/2, self.y - 15, self.w, "center")

end

return Button