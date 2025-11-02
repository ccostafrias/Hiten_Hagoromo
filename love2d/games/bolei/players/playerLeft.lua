local Player = require("players.player")
local PlayerLeft = Player:derive("PlayerLeft")

function PlayerLeft:new(world)
  local x = love.graphics.getWidth()/4
  local y = love.graphics.getHeight() - 100
  local controls = { left = "a", right = "d", jump = "w", dash = "lshift" }

  self.side = -1
  self.super.new(self, world, x, y, controls)
end

return PlayerLeft