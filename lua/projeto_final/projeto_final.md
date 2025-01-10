# Cartógrafo Bêbado

Nosso projeto final, o "cartógrafo bêbado", será um gerador de mapas simples para RPGs.

O objetivo final é que ele seja capaz de gerar mapas aleatórios que contenham distribuições de terra que lembrem ao menos um pouco continentes e ilhas. Além disso, queremos que ele distribua montanhas, florestas e cidades pelos continentes. Obs: será tudo feito em ascii, então o objetivo não é fazer algo muito bonito.

Essa parte do curso é 100% opcional, mas eu recomendo que você tente fazer um projetinho com o que você aprendeu de lua até agora, seja ele seu próprio gerador de mapas de RPG ou qualquer outro projeto que desperte seu interesse. Dito isso, bora começar o treco.

## Gerando continentes

Vou dividir o nosso progresso em duas partes: primeiro nós iremos focar na **geração** de continentes, e depois no **preenchimento** deles com florestas, montanhas e cidades. Para começar, vamos criar variáveis com os caracteres que irão representar cada um dos nossos "tipos de célula" por assim dizer:

``` Lua
local water = "  "
local land = "⣿⣿"
local grass = "ww"
local tree = "⽊"
local mountain = "ᨒᨒ"
local house = "⌂⌂"
local temple = "⾕"
```

e então criar uma tabela que contenha as informações sobre o nosso mapa e o mapa em si. Essa tabela será global, pois iremos querer ter acesso a ela por todo nosso código provavelmente.

``` Lua
map = {height = 0, width = 0, tiles = {}}
```

O mapa é uma array bi-dimensional armazenada na propriedade `tiles`.

Ok, antes de começarmos de fato a gerar o mapa, precisamos perguntar para o usuário qual é o tamanho do mapa que ele quer, e isso nós faremos da seguinte maneira:

``` Lua
repeat
	io.write("qual vai ser a largura do seu mapa? (digite um número)\n> ")
	map.width = tonumber(io.read())
until map.width and map.width > 0

repeat
	io.write("e a altura? (digite outro número)\n> ")
	map.height = tonumber(io.read())
until map.height and map.height > 0
```

A função `tonumber()` transforma seu argumento em um número, se possível, e retorna nil caso essa conversão não seja possível. Como queremos que o mapa tenha dimensões positivas nós adicionamos uma condição de que `map.width` e `map.height` devem ser maiores que zero. 

Depois disso, vamos inicializar nossa matriz que conterá o mapa e preencher ela com barulho (distribuir 0's e 1's nela aleatóriamente, sendo que os 0's representam água e os 1's representam terra):

``` Lua
for i = 1, map.height do
	map.tiles[i] = {}
end
generate_noise(0.6)
```

nossa função `generate_noise()` é bem simples, recebendo apenas um número de 0 a 1 que representa a proporção de terra em comparação a água que irá ser gerada (quanto maior o valor, mais terra e menos água):

``` Lua
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
```

Para nós vermos se está tudo indo conforme o esperado, vamos criar mais uma função que exibe o estado atual do nosso mapa no terminal:

``` Lua
local function print_map()
	for i = 1, map.height do
		for j = 1, map.width do
			if map.tiles[i][j] == 1 then
				io.write(land)
			else
				io.write(water)
			end
		end
		io.write("\n")
	end
end
```

Chamando essa função depois de ter inicializado o mapa nós conseguimos obter um resultado desse tipo ao executarmos o programa:

``` Shell
$ lua ./cartografo_bebado.lua
qual vai ser a largura do seu mapa? (digite um número)
> 20
e a altura? (digite outro número)
> 10
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿〜〜⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿〜〜⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
〜⣿⣿⣿⣿〜〜〜〜〜⣿⣿⣿⣿〜⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿〜〜⣿⣿〜
⣿⣿⣿⣿⣿⣿〜⣿⣿〜⣿⣿⣿⣿⣿⣿〜⣿⣿〜〜⣿⣿⣿⣿〜⣿⣿〜⣿⣿⣿⣿
〜⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿〜〜⣿⣿⣿⣿〜⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿〜⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿〜〜〜⣿⣿⣿⣿〜〜〜⣿⣿〜
〜〜〜⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿〜⣿⣿⣿⣿⣿⣿〜〜〜〜〜〜〜〜
⣿⣿⣿⣿〜〜〜⣿⣿⣿⣿〜⣿⣿〜⣿⣿〜〜⣿⣿〜⣿⣿⣿⣿⣿⣿〜⣿⣿
⣿⣿〜〜⣿⣿〜⣿⣿〜〜⣿⣿〜〜⣿⣿〜〜〜⣿⣿〜〜⣿⣿〜
〜⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿〜〜〜⣿⣿⣿⣿〜〜⣿⣿⣿⣿⣿⣿⣿⣿〜⣿⣿⣿⣿
⣿⣿〜⣿⣿⣿⣿〜⣿⣿〜⣿⣿⣿⣿〜⣿⣿⣿⣿⣿⣿〜⣿⣿〜〜〜〜⣿⣿
```

Ok, está tudo dando certo, mas pera aí, isso não parece muito um mapa né? é só um bolo de terra e água mal feito. Bem, é aí que entra o nosso algoritmo de geração de mapa com base em automatas celulares. Ele funciona da seguinte forma: nós vamos iterar sobre cada célula do mapa algumas vezes, e em cada uma das vezes nós vamos ver quantos dos 8 vizinhos desta célula são iguais a 1 (terra). Caso mais do que 4 vizinhos sejam terra, esta célula também se torna terra, caso contrário, ela se torna água. No final das contas isso vai criando aglomerações de terra e água que se assemelham mais a continentes do que essa bagunça que a gente fez aí em cima. Nossa função que faz uma iteração desse automata celular está aqui:

``` Lua
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
```

Note que nela nós precisamos usar duas funções auxiliares (`copy_map` e `count_neighbors`). Essas duas funções são bem intuitivas então não vou me prolongar muito explicando elas, mas suas implementações estão aqui:

``` Lua
local function copy_map(dest)
	for i = 1, map.height do
		dest[i] = {}
		for j = 1, map.width do
			dest[i][j] = map.tiles[i][j]
		end
	end
end

local function count_neighbors(tiles, height, width, i, j)
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
```

Com a função `step_automata()` em mãos, temos que levar em conta que a quantidade de iterações do automata que devemos rodar para obter um bom mapa depende do tamanho do mapa. No geral, quanto maior o mapa, mais iterações serão necessárias para formar um bom mapa. Pensando nisso, defini quantas iterações iremos rodar com base na largura do mapa:

``` Lua
local iterations

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
```

e por fim podemos rodar nosso algoritmo em um loop:

``` Lua
for i = 1, iterations do
	print(i.."°a iteração")
	step_automata()
	print_map()
end
```

Testando o código que escrevemos até agora nós conseguimos chegar em mapas que se parecem com esse:

```
                                                            
                              ⣿⣿                            
    ⣿⣿⣿⣿                    ⣿⣿⣿⣿⣿⣿                          
      ⣿⣿                    ⣿⣿⣿⣿⣿⣿                          
      ⣿⣿  ⣿⣿              ⣿⣿⣿⣿⣿⣿⣿⣿                  ⣿⣿⣿⣿    
              ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿                    ⣿⣿⣿⣿⣿⣿  
          ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿                ⣿⣿⣿⣿⣿⣿    
    ⣿⣿      ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿      ⣿⣿            ⣿⣿      
    ⣿⣿⣿⣿⣿⣿      ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿                  
  ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿                
    ⣿⣿⣿⣿⣿⣿    ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿    ⣿⣿                  
    ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿                ⣿⣿⣿⣿⣿⣿      
      ⣿⣿                  ⣿⣿⣿⣿⣿⣿                  ⣿⣿⣿⣿⣿⣿    
                                                            
                                                            
```

Isso conclui nossa sessão de geração de continentes, o próximo passo agora é descobrir como nós vamos dar vida a esses mapas.

## Preenchendo continentes

Meu plano para deixar esses mapas mais vivos se baseia em criar uma função capaz de espalhar casas, grama e montanhas de forma dinâmica. Para isso, vamos usar duas funções: uma que coloca distribui células do tipo especificado aleatóriamente pelo mapa, e outra que, a partir das posições onde estas células foras colocadas, espalha mais dessa mesma célula. Isso, em teoria, criaria o efeito de uma cidade crescendo ou uma mata se espalhando.

Como nosso mapa é representado como uma matriz de números, vou também criar uma tabela que nos ajude a traduzir a string dos tipos de célula para seus respectivos IDs:

``` Lua
tile_to_ID = {["  "] = 0, ["⣿⣿"] = 1, ["ww"] = 2, ["⽊"] = 3, ["ᨒᨒ"] = 4, ["⌂⌂"] = 5, ["⾕"] = 6}
```

E então a função a seguir é a que distribuirá as celulas iniciais de um dado tipo pelo mapa, retornando as posições pelas quais esta distribuição ocorreu:

``` Lua
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
```

E esta outra função será a que espalhará mais desta célula ao redor das que já estão lá, de acordo com a "espalhabilidade" passada como argumento:

``` Lua
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
```

E não podemos esquecer de chamar nossas funções:

``` Lua
populate_with_tile(house, 0.02, 0.3, 4)
populate_with_tile(grass, 0.1, 0.4, 5)
populate_with_tile(mountain, 0.02, 0.35, 3)
```

Com isso, nossos mapas terão grandes gramados e vilas com apenas casas simples. Para deixarmos ele um pouco mais detalhado, vamos criar mais duas funções: uma que distribui árvores onde já há gramado (para criarmos florestinhas), e outra que distribui templos onde já há casas (para que nossas cidades tenham algo de diferente nelas):

``` Lua
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
``` 

Como sempre, sem esquecer de chamar nossas funções:

``` Lua
spawn_temples(0.05)
spawn_trees(0.6)
```

Agora só falta adaptar nossa função `print_map()` para os novos tipos de célula e ver os resultados.

``` Lua
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
```

Finalmente, rodando este programa algumas vezes com diferentes tamanhos de mapa, consegui gerar alguns que achei bem massa, oia só:

### mapa 1: godzilla homofóbico

mapa gerado:

![mapa 1](https://i.imgur.com/z2fyp4S.png)

adaptação:

![mapa 1 adaptado](https://i.imgur.com/Fi60YlV.png)

### mapa 2: sereia peidorreira

mapa gerado:

![mapa 2](https://i.imgur.com/6gPlg1v.png)

adaptação:

![mapa 2 adaptado](https://i.imgur.com/CwEVRP1.png)

### mapa 3: peixe gordo

mapa gerado:

![mapa 3](https://i.imgur.com/hTNWKz7.png)

adaptação:

![mapa 3 adaptado](https://i.imgur.com/EsshlHn.png)
## Conclusão

UHUUUULLL chegamos ao fim desse humilde projeto :). Se você chegou até aqui, parabéns, o curso de lua está oficialmente e absolutamente terminado, espero que tenha aprendido algo legal! E se você fez seu próprio projeto ou adaptou esse aqui para o seu gosto, parabéns dobrado pra vc, pegue um bolo de presente: 🍰. Novamente, vejo você na sessão de LOVE2D!!