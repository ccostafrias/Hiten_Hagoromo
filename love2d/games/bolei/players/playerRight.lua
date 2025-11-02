local Player = require("players.player")
local PlayerRight = Player:derive("PlayerRight")

function PlayerRight:new(world)
  local x = love.graphics.getWidth() * 3/4
  local y = love.graphics.getHeight() - 100
  local controls = { left = "left", right = "right", jump = "up", dash = "rshift" }

  self.side = 1
  self.super.new(self, world, x, y, controls)
end

return PlayerRight