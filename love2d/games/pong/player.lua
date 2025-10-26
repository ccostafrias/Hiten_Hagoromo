local Paddle = require("paddle")
local Player = Paddle:derive("Player")

function Player:move(dt)
  if love.keyboard.isDown("s") then
    self.y = self.y + self.speed * dt
  end

  if love.keyboard.isDown("w") then
    self.y = self.y - self.speed * dt
  end
end

return Player