-- escrevendo em um arquivo
file = io.open("something.txt", "w")
file:write("Hello, file!\n", "vcnvqnd")
file:close()

-- lendo o que a gente escreveu
file = io.open("something.txt", "r")
line1 = file:read("L")
line2 = file:read()
print(line1 .. line2)
file:close()