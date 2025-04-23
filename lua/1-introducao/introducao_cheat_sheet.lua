-- VARIÁVEIS E DATA TYPES   | TIPO:
num = 10                  --| number
str = "Hello, World!"     --| string
bool = true               --| boolean
nothing = nil             --| nil
func = function() end     --| function
list = {1, 2, 3}          --| table

-- FLOW CONTROL
-- condicionais:
if not bool and nothing then
	print("case 1")
elseif nothing or bool then
	print("case 2")
else
	print("case 3")
end

-- for loop:
for i = 1, 5, 1 do
	print(i .. "° for loop")
end

-- for loop reverso:
for i = 5, 1, -1 do
	print(6 - i .. "° reverse for loop")
end

-- while loop:
i = 1
while i <= 5 do
	print(i .. "° while loop")
	i = i + 1
end

-- repeat until:
i = 1
repeat
	print(i .. "° repeat")
	i = i + 1
until i > 5

-- VARIÁVEIS LOCAIS
value = 100 -- global

function usesLocal()
	local value = -999 -- local
	print(value)
end

function usesGlobal()
	print(value)
end

usesLocal() -- output: -999
usesGlobal() -- output: 100