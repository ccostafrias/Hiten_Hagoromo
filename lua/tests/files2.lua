local output, err = io.open("texto.txt", "w")
assert(output ~= nil, "Erro ao escrever: " .. tostring(err)) 
-- verifica se conseguiu abrir para escrever

output:write(
	"O que é,\n", 
	"O que é?\n", 
	"Clara e salgada\n", 
	"Cabe no olho\n", 
	"E pesa uma tonelada"
)
output:close()

local input, err = io.open("texto.txt", "r")
assert(input ~= nil, "Erro ao ler: " .. tostring(err)) 
-- verifica se conseguiu abrir para ler

local count = 0

-- passa por cada linha do arquivo
for line in io.lines("texto.txt") do
  count = count + 1
  print(line)
end

print("Linhas: "..count)
input:close()