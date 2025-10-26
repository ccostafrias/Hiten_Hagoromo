local Paddle = require("paddle")
local Opponent = Paddle:derive("Opponent")

function Opponent:move(dt)
  if love.keyboard.isDown("down") then
    self.y = self.y + self.speed * dt
  end
  
  if love.keyboard.isDown("up") then
    self.y = self.y - self.speed * dt
  end
end

return Opponent