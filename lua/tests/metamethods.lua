local t = {x = 2}
local num = io.read()

local function tableAddition(t, num)
  return t.x + num  
end

local custom_metatable = {__add = tableAddition}
setmetatable(t, custom_metatable)

print(string.format("The sum between %d and %d is %d", t.x, num, t + num))