Table = {city = "Xique Xique", state = "Bahia", country = "Brazil"}

for index, value in pairs(Table) do
	print(index, value)
end

-- nao funciona, pois nao esta enumerado
for index, value in ipairs(Table) do
	print(index, value)
end