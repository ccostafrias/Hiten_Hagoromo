local Class = require("Class")
local Scene = Class:derive("Scene")

function Scene:mousepressed(...) end
function Scene:keypressed(...) end

function Scene:new(scene_mgr)
  self.scene_mgr = scene_mgr
end

function Scene:enter() end
function Scene:update(dt) end
function Scene:draw() end
function Scene:exit() end

return Scene