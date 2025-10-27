local GameState = require("GameState")
local SM = require("SceneManager")

local sm

function love.mousepressed(...)
  sm:mousepressed(...)
end

function love.keypressed(key)
  sm:keypressed(key)
	if key == "escape" then
		love.event.quit()

	end
end

function love.load()
  fontTitle = love.graphics.newFont('fonts/PressStart2P-Regular.ttf', 20)
  fontGame = love.graphics.newFont('fonts/PressStart2P-Regular.ttf', 30)
  fontMenu = love.graphics.newFont('fonts/PressStart2P-Regular.ttf', 50)

  GameState:load()
  sm = SM("scenes", {"Game", "Menu"})
  sm:switch("Menu")
end

function love.update(dt)
  sm:update(dt)
end

function love.draw()
  sm:draw()
end