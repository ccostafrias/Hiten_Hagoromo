local Game = require("scenes.game")
local Menu = require("scenes.menu")
local GameState = require("gameState")
local SM = require("sceneManager")

local sm

function love.keypressed(key, scancode, isrepeat)
  if GameState.state == "menu" then
    Menu:keypressed(key)
  elseif GameState.state == "game" then
    Game:keypressed(key)
  end
	if key == "escape" then
		love.event.quit()
	end
end

function love.load()
  fontTitle = love.graphics.newFont('fonts/PressStart2P-Regular.ttf', 20)
  fontGame = love.graphics.newFont('fonts/PressStart2P-Regular.ttf', 30)
  fontMenu = love.graphics.newFont('fonts/PressStart2P-Regular.ttf', 50)

  sm = SM("scenes", {"Game", "Menu"})

  GameState:load()
  Menu:load()
  Game:load()
end

function love.update(dt)
  if GameState.state == "menu" then
    Menu:update(dt)
  elseif GameState.state == "game" then
    Game:update(dt)
  end
end

function love.draw()
  if GameState.state == "menu" then
    Menu:draw()
  elseif GameState.state == "game" then
    Game:draw()
  end
end