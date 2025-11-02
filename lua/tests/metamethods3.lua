-- '__index' funciona como um fallback em tables
-- ou seja, quando método qualquer não é encontrado em uma table,
-- esse método será procurado na table associada ao campo '__index'
local Class = {}
Class.__index = Class

function Class:derive(type)
  local cls = {}
  cls.__call = Class.__call  -- sempre herda o '__call' de Class
  cls.type = type            -- pode ser útil para algum tipo de verificação no futuro
  cls.__index = cls          -- também cria um 'fallback' para essa subclasse que foi derivada
  cls.super = self           -- define quem é a subclasse "pai" da hierarquia
  setmetatable(cls, self)    -- associa essa nova subclasse a quem a criou, para assim herdar tudo

  return cls
end

-- possibilita chamar as classes/subclasses (tabelas) como funções
function Class:__call(...)
  local instance = setmetatable({}, self) -- associa a instância à subclasse que a chamou
  instance:new(...)                       -- cria a instância de acordo com as regras daquela subclasse
  
  return instance
end

-- default: caso nao acha nenhum new(), chama esse
function Class:new(...) end

-- tem a mesma função de new, mas para a subclasse pai
function Class:superNew(...)
  if self.super then
    self.super.new(self, ...)
  end
end


-- EXEMPLOS

-- criamos uma subclasse Animal e uma Mammal
local Animal = Class:derive("Animal")
local Mammal = Animal:derive("Mammal")

-- determinamos as regras de criação de um Animal
function Animal:new(especie, barulho)
  self.especie = especie
  self.barulho = barulho
end

function Animal:faz_barulho()
  print(self.barulho)
end

-- determinamos as regras de criação de um Mammal
function Mammal:new(...)
  self:superNew(...) -- Mammal, por sua vez, chama superNew(), que nesse caso é Animal:new() (a subclasse 'pai'!)

  self.temTetinha = true
end

-- criamos instâncias de Mammal (note que podemos chamar como uma função, graças ao '__call')
local Cat = Mammal("gato", "meooow")
local Dog = Mammal("catioro", "AU AU")

Cat:faz_barulho()
Dog:faz_barulho()