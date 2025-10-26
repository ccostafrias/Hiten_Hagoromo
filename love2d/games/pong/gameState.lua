local Opponent = require("opponent")
local IA = require("IA")

local GameState = {}

function GameState:load()
  self.status = "playing"
  self.state = "game"
  self.gameMode = "arcade"
  self.level = 1
  self.opponents = {}
  self.opponent = nil
end

function GameState:set_opponents()
  if self.gameMode == "local" then
    local opponent = Opponent(-50, 2, 300)
    table.insert(self.opponents, opponent)

  elseif self.gameMode == "arcade" then
    for _, config in ipairs(self:arcadeEnemyConfigs()) do
      local enemy = IA(config.startX, config.img, config.speed, config.sx, config.sy, config.opts, self.ball)
      table.insert(self.opponents, enemy)
    end
  end
end

function GameState:arcadeEnemyConfigs()
  return {
    { startX = -50, img = 2, speed = 300, sx = 1, sy = 1, opts = { rate = 2 } },
    { startX = -50, img = 2, speed = 100, sx = 1, sy = 2, opts = { rate = 1 } },
    { startX = -50, img = 2, speed = 500, sx = 1, sy = .5, opts = { rate = 0.2 } },
    { startX = -50, img = 2, speed = 1000, sx = 1, sy = .25, opts = { rate = 0.2 } },
  }
end

return GameState