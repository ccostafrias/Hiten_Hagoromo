# Cartógrafo Bêbado

Nosso projeto final, o "cartógrafo bêbado", será um gerador de mapas simples para RPGs.

O objetivo final é que ele seja capaz de gerar mapas aleatórios que contenham distribuições de terra que lembrem ao menos um pouco continentes e ilhas. Além disso, queremos que ele distribua montanhas, florestas e cidades pelos continentes. Obs: será tudo feito em ascii, então o objetivo não é fazer algo muito bonito.

Essa parte do curso é 100% opcional, mas eu recomendo que você tente fazer um projetinho com o que você aprendeu de lua até agora, seja ele seu próprio gerador de mapas de RPG ou qualquer outro projeto que desperte seu interesse. Dito isso, bora começar o treco.

## Gerando continentes

Vou dividir o nosso progresso em duas partes: primeiro nós iremos focar na **geração** de continentes, e depois no **preenchimento** deles com florestas, montanhas e cidades. Para começar, vamos criar variáveis com os caracteres que irão representar cada um dos nossos "tipos de célula" por assim dizer:

``` Lua
local water = "〜"
local land = "⣿⣿"
local grass = "w"
local tree = "⽊"
local mountain = "ᨒ"
local house = "⌂"
local temple = "⾕"
```

e então criar uma tabela que contenha as informações sobre o nosso mapa e o mapa em si:

``` Lua
local map = {height = 0, width = 0, tiles = {}}
```

O mapa será uma array bi-dimensional armazenada na propriedade `tiles`.

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
generate_noise(map, 0.6)
```

nossa função `generate_noise()` é bem simples, ela vai receber uma referência pro mapa que iremos preencher e um número de 0 a 1 que representa a proporção de terra em comparação a água que irá ser gerada (quanto maior o valor, mais terra e menos água):

``` Lua
local function generate_noise(map, noise_density)
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
local function print_map(map)
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
local function step_automata(map)
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
```

Note que nela nós precisamos usar duas funções auxiliares (`copy_map` e `count_neighbors`). Essas duas funções são bem intuitivas então não vou me prolongar muito explicando elas, mas suas implementações estão aqui:

``` Lua
local function copy_map(dest, map)
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
	step_automata(map)
	print_map(map)
end
```

Testando o código que escrevemos até agora nós conseguimos chegar em mapas que se parecem com esse:

```
〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜
〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜
〜〜〜〜⣿⣿⣿⣿〜〜〜⣿⣿⣿⣿⣿⣿⣿⣿〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜
〜〜⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿〜⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜
〜⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿〜⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜
〜⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿〜⣿⣿〜⣿⣿⣿⣿⣿⣿⣿⣿〜⣿⣿〜⣿⣿〜⣿⣿〜〜〜〜〜〜〜〜〜
〜⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿〜〜〜〜〜⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿〜〜〜〜〜〜〜
〜〜⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿〜〜〜〜⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿〜〜
〜〜〜⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿〜〜〜〜〜⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿〜〜
〜〜〜⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿〜〜〜〜〜⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿〜
〜〜〜⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿〜〜〜〜〜⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿〜⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿〜〜
〜〜〜⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿〜〜〜〜〜⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿〜〜
〜〜〜⣿⣿⣿⣿〜〜〜⣿⣿⣿⣿〜〜〜⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿〜〜〜⣿⣿⣿⣿⣿⣿〜⣿⣿〜〜〜〜
〜〜〜⣿⣿⣿⣿⣿⣿〜⣿⣿⣿⣿⣿⣿⣿⣿〜⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿〜〜〜⣿⣿⣿⣿⣿⣿〜⣿⣿〜〜〜〜
〜〜⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿〜〜〜⣿⣿⣿⣿⣿⣿⣿⣿〜〜〜〜〜⣿⣿〜〜〜〜〜〜
〜〜〜⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿〜〜〜⣿⣿⣿⣿⣿⣿〜〜〜〜〜〜〜〜〜〜〜〜〜
〜〜〜〜〜〜⣿⣿〜⣿⣿〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜
〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜
```

Isso conclui nossa sessão de geração de continentes, o próximo passo agora é descobrir como nós vamos dar vida a esses mapas.

## Preenchendo continentes









``` Lua

```


