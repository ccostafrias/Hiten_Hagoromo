Semana = {
  [1] = 'Domingo',
  [2] = 'Segunda', 
  [3] = 'Terca', 
  [4] = 'Quarta', 
  [5] = 'Quinta', 
  [6] = 'Sexta', 
  [7] = 'Sabado', 
}

for num, dia in pairs(Semana) do
  --print(dia .. " eh o " .. num .. "o dia da semana")
  print(string.format("%s eh o %do dia semana", dia, num))
end