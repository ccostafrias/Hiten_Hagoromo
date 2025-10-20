local num = {} -- usando uma table para poder passar num por referência
local MAX = 1000

local randomize = function(i)
    num[i] = math.floor(MAX * math.random());
end

for i = 1, 10 do
    randomize(i)
    print(string.format("num[%d] = %d", i, num[i]))
    debug.debug()
    if num[i] < 500 then
      print("smaller than 500")
    else
      print("greater than or equal to 500")
    end
end