--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- algumas variáveis globais        ~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local water = "  "
local land = "⣿⣿"
local grass = "ww"
local tree = "⽊"
local mountain = "ᨒᨒ"
local house = "⌂⌂"
local temple = "⾕"
map = {height = 0, width = 0, tiles = {}}
tile_to_ID = {["  "] = 0, ["⣿⣿"] = 1, ["ww"] = 2, ["⽊"] = 3, ["ᨒᨒ"] = 4, ["⌂⌂"] = 5, ["⾕"] = 6}
local iterations

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- nossas funções                   ~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- preenche um mapa com barulho aleatório
local function generate_noise(noise_density)
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

local function print_map()
	for i = 1, map.height do
		for j = 1, map.width do
			if map.tiles[i][j] == 6 then
				io.write(temple)
			elseif map.tiles[i][j] == 5 then
				io.write(house)
			elseif map.tiles[i][j] == 4 then
				io.write(mountain)
			elseif map.tiles[i][j] == 3 then
				io.write(tree)
			elseif map.tiles[i][j] == 2 then
				io.write(grass)
			elseif map.tiles[i][j] == 1 then
				io.write(land)
			else
				io.write(water)
			end
		end
		io.write("\n")
	end
end

-- copia as células da tabela mapa para a tabela dest
local function copy_map(dest)
	for i = 1, map.height do
		dest[i] = {}
		for j = 1, map.width do
			dest[i][j] = map.tiles[i][j]
		end
	end
end

local moves = {{-1, -1}, {0, -1}, {1, -1}, {1, 0}, {1, 1}, {0, 1}, {-1, 1}, {-1, 0}}

-- conta quantos vizinhos de uma dada célula são terra (1)
local function count_neighbors(tiles, height, width, i, j)
	local neighbors = 0
	for m = 1, #moves do
		local newJ = j + moves[m][1]
		local newI = i + moves[m][2]

		if newJ > 1 and newJ < width and newI > 1 and newI < height then
			neighbors = neighbors + tiles[newI][newJ]
		end
	end

	return neighbors
end

local function step_automata()
	local tiles_copy = {}
	copy_map(tiles_copy)
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

local function initial_tile_spread(tile, density)
	local positions = {} -- posição das células que serão colocadas
	for i = 1, map.height do
		for j = 1, map.width do
			if map.tiles[i][j] == tile_to_ID[land] then
				if math.random() < density then
					map.tiles[i][j] = tile_to_ID[tile]
					table.insert(positions, {i, j})
				end
			end
		end
	end
	return positions
end

local function populate_with_tile(tile, density, spreadability, iterations)
	-- distribui aleatóriamente as células iniciais do tipo dado
	local positions = initial_tile_spread(tile, density)
	-- espalha mais células deste tipo ao redor das iniciais
	for i = 1, iterations do
		local new_positions = {}
		for i = 1, #positions do
			local pos = positions[i]
			if math.random() < spreadability then
				-- abaixo
				if pos[1] + 1 < map.height and map.tiles[pos[1] + 1][pos[2]] == tile_to_ID[land] then
					map.tiles[pos[1] + 1][pos[2]] = tile_to_ID[tile]
					table.insert(new_positions, {pos[1] + 1, pos[2]})
				end
				-- acima
				if pos[1] - 1 > 0 and map.tiles[pos[1] - 1][pos[2]] == tile_to_ID[land] then
					map.tiles[pos[1] - 1][pos[2]] = tile_to_ID[tile]
					table.insert(new_positions, {pos[1] - 1, pos[2]})
				end
				-- à direita
				if pos[2] + 1 < map.width and map.tiles[pos[1]][pos[2] + 1] == tile_to_ID[land] then
					map.tiles[pos[1]][pos[2] + 1] = tile_to_ID[tile]
					table.insert(new_positions, {pos[1], pos[2] + 1})
				end
				-- à esquerda
				if pos[2] - 1 > 0 and map.tiles[pos[1]][pos[2] - 1] == tile_to_ID[land] then
					map.tiles[pos[1]][pos[2]] = tile_to_ID[tile]
					table.insert(new_positions, {pos[1], pos[2] - 1})
				end
			end
		end
		for _, value in pairs(new_positions) do
			table.insert(positions, value)
		end
	end
end

-- aleatóriamente substitui casas por templos para deixar as cidades mais interessantes
local function spawn_temples(density)
	for i = 1, map.height do
		for j = 1, map.width do
			if map.tiles[i][j] == tile_to_ID[house] then
				if math.random() < density then
					map.tiles[i][j] = tile_to_ID[temple]
				end
			end
		end
	end
end

-- aleatóriamente substitui gramas por árvores para criar florestas
local function spawn_trees(density)
	for i = 1, map.height do
		for j = 1, map.width do
			if map.tiles[i][j] == tile_to_ID[grass] then
				if math.random() < density then
					map.tiles[i][j] = tile_to_ID[tree]
				end
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
	map.width = tonumber(io.read())
until map.width and map.width > 0

repeat
	io.write("e a altura? (digite outro número)\n> ")
	map.height = tonumber(io.read())
until map.height and map.height > 0

-- inicializando o mapa
for i = 1, map.height do
	map.tiles[i] = {}
end
generate_noise(0.6)

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
	step_automata()
end

print_map()

populate_with_tile(house, 0.02, 0.3, 4)
populate_with_tile(grass, 0.1, 0.4, 5)
populate_with_tile(mountain, 0.02, 0.35, 3)
spawn_temples(0.05)
spawn_trees(0.6)

print("\n--------------------------------------------------------\n")
print_map()