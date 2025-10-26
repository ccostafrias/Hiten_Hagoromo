local Background = require("background")
local Ball = require("ball")
local Player = require("player")
local GameState = require("gameState")
local Timer = require("timer")

local Game = {}

function Game:keypressed(key)
  GameState.ball:keypressed(key)
end

function Game:load()
  load_level(GameState.level)
end

function load_level(level)
  if (GameState.player == nil) then 
    GameState.player = Player(50, 1, 300)
  else
    GameState.player:reset()
  end

  if (GameState.ball == nil) then 
    GameState.ball = Ball(400)
  else
    GameState.ball:reset(-1)
  end

  if (GameState.opponent == nil) then 
    GameState:set_opponents()
  end

  GameState.opponent = GameState.opponents[level]
  Background:load()

end

function Game:update(dt)
  if (GameState.status == "playing") then
    GameState.player:update(dt)
    GameState.opponent:update(dt)
    GameState.ball:update(dt)
  
    verifyScore()
  end

  Timer:update(dt)
end

function Game:draw()
  -- primeira camada
  Background:draw()

  -- segunda camada
  GameState.player:draw()
  GameState.opponent:draw()
  GameState.ball:draw()
  drawScore()
  drawNext()
end

function verifyScore()
  if GameState.player.score >= GameState.opponent.scoreToWin then
    if GameState.level < #GameState.opponents then
      GameState.status = "pause"

      Timer:after(1, function ()
        GameState.status = "playing"
        GameState.level = GameState.level + 1
        load_level(GameState.level)
      end)
    else
      print("ACABOU PORRA")
    end
  end
end

function drawNext()
  if (GameState.status == "pause") then
    love.graphics.clear(0, 0, 0, .1)
    love.graphics.setFont(fontGame)
    love.graphics.printf("Next Level!", 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
  end
end

function drawScore()
  love.graphics.setFont(fontTitle)
  love.graphics.printf("Level "..GameState.level, 0, 50, love.graphics.getWidth(), "center")
  love.graphics.setFont(fontGame)
  love.graphics.printf(GameState.player.score.." x "..GameState.opponent.score, 0, 100, love.graphics.getWidth(), "center")
end

function checkCollision(a, b)
  if a.x < b.x + b.width and -- esquerda de A passou a direita de B
     a.x + a.width > b.x and -- direita de A passou a esquerda de B
     a.y < b.y + b.height and -- topo de A passou a base de B
     a.y + a.height > b.y then -- base de A passou o topo de B
     
     return true
  else
    return false
  end
end

return Game