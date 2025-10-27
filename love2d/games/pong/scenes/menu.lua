local Scene = require("Scene")
local Menu = Scene:derive("Menu")
local GameState = require("GameState")
local Button = require("Button")

function Menu:keypressed(key)
  if key == "g" then
    self.scene_mgr:switch("Game")
  end
end

function Menu:mousepressed(x, y)
  for title, button in pairs(self.buttons) do
    button:mousepressed(x, y)
  end
end

function Menu:new(scene_mgr)
  self.super:new(scene_mgr)

  self.buttons = {}
  for i, button in ipairs(self:get_buttons()) do
    self.buttons[button.title] = Button(button.title, button.func, love.graphics.getWidth()/2, 250 + i*100, 300, 80)
  end
  
end

function Menu:get_buttons()
  return {
    {title = 'Arcade', func = function () 
      GameState.gameMode = 'arcade'
      self.scene_mgr:switch("Game")
    end},
    {title = 'Local', func = function () 
      GameState.gameMode = 'local'
      self.scene_mgr:switch("Game")
    end},
    {title = 'Exit', func = function () 
      love.event.quit()
    end},
  }
end

function Menu:update(dt)
  for title, button in pairs(self.buttons) do
    button:update(dt)
  end
end

function Menu:draw()
  love.graphics.clear(0.25, 0.25, 0.5)
  love.graphics.setFont(fontMenu)
  love.graphics.printf("Pong", 0, 200, love.graphics.getWidth(), "center")

  for title, button in pairs(self.buttons) do
    button:draw()
  end
end

return Menu