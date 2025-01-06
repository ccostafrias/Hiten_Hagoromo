--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- algumas variáveis globais        ~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local water = "♒︎"
local land = "⣿"
local grass = "w"
local mountain = "ᨒ"
local house = "⌂"
local temple = "⾕"
local map = {height = 0, width = 0, tiles = {}}
local iterations

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- nossas funções                   ~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- preenche um mapa com barulho aleatório
function generate_noise(map, noise_density)
	for i = 1, map.height do
		for j = 1, map.width do
			if math.random() <= noise_density then
				map.tiles[i][j] = 1
			else
				map.tiles[i][j] = 0
			end
		end
	end
end

function print_map(map)
	for i = 1, map.height do
		for j = 1, map.width do
			if map.tiles[i][j] == 1 then
				io.write(land..land)
			else
				io.write("  ")
			end
		end
		io.write("\n")
	end
end

-- copies the tiles table from the map to dest
function copy_map(dest, map)
	for i = 1, map.height do
		dest[i] = {}
		for j = 1, map.width do
			dest[i][j] = map.tiles[i][j]
		end
	end
end

-- counts how many of the neighbors of a given cell are active
function count_neighbors(tiles, height, width, i, j)
	local neighbors = 0
	if i > 1 then
		if j > 1 then
			neighbors = neighbors + tiles[i-1][j-1]--> vizinho superior esquerdo
		end
		neighbors = neighbors + tiles[i-1][j]--> vizinho superior
		if j < width then
			neighbors = neighbors + tiles[i-1][j+1]--> vizinho superior direito
		end
	end
	if j < width then
		neighbors = neighbors + tiles[i][j+1]--> vizinho direito
		if i < height then
			neighbors = neighbors + tiles[i+1][j+1]--> vizinho inferior direito
		end
	end
	if i < height then
		neighbors = neighbors + tiles[i+1][j]--> vizinho inferior
		if j > 1 then
			neighbors = neighbors + tiles[i+1][j-1]--> vizinho infeior esquerdo
		end
	end
	if j > 1 then
		neighbors = neighbors + tiles[i][j-1]--> vizinho esquerdo
	end
	return neighbors
end

function step_automata(map)
	local tiles_copy = {}
	copy_map(tiles_copy, map)
	for i = 1, map.height do
		for j = 1, map.width do
			local neighbors = count_neighbors(tiles_copy, map.height, map.width, i, j)
			if neighbors > 4 then
				map.tiles[i][j] = 1
			else 
				map.tiles[i][j] = 0
			end
		end
	end
end

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ponto inicial de execução        ~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- perguntando pro usuário o tamanho do mapa que ele quer:
repeat
	io.write("qual vai ser a largura do seu mapa? (digite um número)\n> ")
	map.width = io.read()
until tonumber(map.width)
map.width = tonumber(map.width)
repeat
	io.write("e a altura? (digite outro número)\n> ")
	map.height = io.read()
until tonumber(map.height)
map.height = tonumber(map.height)

-- inicializando o mapa
for i = 1, map.height do
	map.tiles[i] = {}
end
generate_noise(map, 0.6)

-- decidindo quantas iterações do automata celular a gente vai usar com base na largura do mapa
if map.width <= 5 then
	iterations = 1
elseif map.width <= 20 then
	iterations = 2
elseif map.width <= 40 then
	iterations = 3
elseif map.width <= 100 then
	iterations = 4
else
	iterations = 5
end

for i = 1, iterations do
	print(i.."°a iteração")
	step_automata(map)
	print_map(map)
end