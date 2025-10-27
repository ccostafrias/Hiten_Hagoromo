local Class = require("Class")
local SM = Class:derive("SceneManager")

function SM:new(scene_dir, scenes)
  self.scenes = {}
  self.scene_dir = scene_dir

  if not scene_dir then scene_dir = "" end

  if scenes ~= nil then
    assert(type(scenes) == "table", "parameter 'scenes' must be table!")

    for _, scene in ipairs(scenes) do
      local M = require(scene_dir.."."..scene)
      assert(M:is("Scene"), "File: "..scene_dir.."."..scene..".lua is not type Scene!")

      self.scenes[scene] = M(self) -- passa para a cena quem é o SM que a criou
    end
  end

    self.prev_scene_name = nil
    self.current_scene_name = nil
    self.current = nil
end

function SM:add(scene) end
function SM:remove(scene) end

function SM:switch(next_scene)
  if self.current ~= nil then
    self.current:exit()
  end

  if next_scene and next_scene ~= self.current_scene_name then
    self.prev_scene_name = self.current_scene_name
    self.current_scene_name = next_scene
    self.current = self.scenes[next_scene]
    self.current:enter()
  end
end

function SM:update(dt)
  if self.current then
    self.current:update(dt)
  end
  
end

function SM:draw()
  if self.current then
    self.current:draw()
  end
end

function SM:keypressed(key)
  if self.current then
    self.current:keypressed(key)
  end
end

function SM:mousepressed(x, y)
  if self.current then
    self.current:mousepressed(x, y)
  end
end

return SM