local Class = {}
Class.__index = Class

-- default: caso nao acha nenhum new(), chama esse
function Class:new(...) end

function Class:derive(type)
  local cls = {}
  cls.__call = Class.__call -- sempre herda o call de Class
  cls.type = type
  cls.__index = cls
  cls.super = self -- define quem é a classe "pai", quem a criou
  setmetatable(cls, self)

  return cls
end

function Class:__call(...)
  local instance = setmetatable({}, self)
  instance:new(...)
  
  return instance
end

function Class:get_type()
  return self.type
end

return Class