-- mudando a entrada e a saída padrão
io.input("input.txt")
io.output("output.txt")

-- lendo da nova entrada padrão: input.txt
local line1 = io.read("L")
local line2 = io.read("L")

-- escrevendo pra nova saída padrão: output.txt
io.write(line2 .. '\n' .. line1)

-- vamos contar quantos caracteres tem em something.txt
local count = 0
for line in io.lines("input.txt") do
    count = count + #line
end
io.write("Chars: " .. count)