local Class = {}
Class.__index = Class

-- default: caso nao acha nenhum new(), chama esse
function Class:new(...) end

function Class:derive(kind)
  local cls = {}
  cls.__call = Class.__call -- sempre herda o call de Class
  cls.kind = kind
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

function Class:get_kind()
  return self.kind
end

function Class:is(class_kind)
  local base = self
  while base do
    if base.kind == class_kind then return true end
    base = base.super
  end
  
  return false
end

return Class