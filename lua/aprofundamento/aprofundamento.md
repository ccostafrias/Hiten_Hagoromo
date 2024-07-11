# APROFUNDAMENTO

A partir de agora a gente vai aprender a usar as funcionalidades e as bibliotecas do lua que nos permitem escrever projetos minimamente interessantes e complexos. Os principais temas que nós vamos abordar são:

- modules
- metamethods, metatables e OOP
- coroutines
- iterators
- core library
- IO library
- OS library
- module library
- debug library
- otimizações

Tem algumas bibliotecas e funções que não serão abordadas simplesmente por serem algo que você descobre facilmente em 2 segundos no google e que apenas poluiriam este curso. Por exemplo, não iremos falar sobre funções como a `math.sqrt()`, por que caso algum dia você precise dela, você irá simplesmente pesquisar "square root function lua" no google e o primeiro resultado te entregará de bandeija a resposta que você queria. O que faremos aqui é explicar algumas funções um pouco menos óbvias e que são boas de se ter em mente desde já.

## Módulos

Quando seus projetos ficarem muito grandes você provavelmente vai querer separar ele em diferentes arquivos e depois conectar estes arquivos de alguma forma. Em C você deve ter visto que a gente faz isso com arquivos de header, com extensão `.h`. Já no lua, assim como em linguagens como python e JS, não são necessários arquivos header, você simplesmente terá múltiplos arquivos `.lua`. Os arquivos que definirem funções ou variáveis que você queira usar em outro arquivo podem então **exportá-las**. Para isso, basta que o módulo **retorne** o valor que você quer exportar. Assim, outro módulo poderá incluir/importar aquilo que foi retornado.

Vamos fazer um exemplo aqui, vou criar duas funções e algumas variáveis em um módulo, colocar tudo em uma table e retornar:

``` Lua
-- FILE: cat_module.lua
cat = {}

cat.name = "Kira"
cat.age = 6

function meow()
	print("meow")
end
cat.meow = meow

function purr()
	print("prrrrrr")
end
cat.purr = purr

return cat
```

Agora, em outro arquivo, podemos incluir e usar tudo que está nesta table

``` Lua
-- FILE: main.lua
cat = require "cat_module" -- incluindo o módulo

print(cat.name) -- output: Kira
cat.purr() -- output: prrrrrr
cat.meow() -- output: meow
```

Esse método é válido nas versões do lua a partir da 5.2, mas você provavelmente não está usando uma versão antiga então não vou prolongar essa parte (se você está, **por quê????**😭😭😭😭😭 atualize seu lua agora mesmo ou morra).

## Metamethods, metatables e OOP

As variáveis e tipos em lua possuem _**metatables**_ (meta-tabelas), que são tabelas contendo um conjunto de funções que definem o comportamento de cada variável em algumas situações específicas, essas funções são chamadas de _**metamethods**_ (meta-métodos). Por exemplo, quando você soma dois valores em lua, e um deles possuí um meta-método `__add` definido, esse método é chamado recebendo os dois valores como argumento, e esse método definirá o resultado da adição.

Por padrão, as variáveis dos tipos `table` e `userdata` possuem metatables individuais, enquanto as variáveis dos outros tipos todas compartilham uma mesma metatable por tipo (e.g. uma metatable para números, outra pra strings e etc). Além disso, não é possível em condições normais reescrever as metatables compartilhadas dos tipos primitivos, apenas podemos reescrever as metatables de tabelas e userdata.

Por exemplo, quando a gente tenta executar o seguinte código sem mudar o meta-método da tabela, um erro é causado:

``` Lua
t = {x = 2}

if t + 1 == 3 then -- ERRO: attempt to perform arithmetic on a table value (global 't')
	print("OwO")
end
```

mas se antes a gente mudar a metatable de `t`, dá pro código compilar tranquilo:

``` Lua
t = {x = 2}

function tableAddition(t, num)
	return t.x + num
end

custom_metatable = {__add = tableAddition} -- cria uma metatable que redefine o metamétodo __add
setmetatable(t, custom_metatable) -- aplica a metatable customizada para t

if t + 1 == 3 then
	print("OwO") -- printa sem nenhum erro
end
```

Metatables também são ultra úteis para simular orientação a objeto (OOP, em inglês). Se você não está familiarizado com OOP (principalmente com o conceito de herança, ou _inheritance_) então seria bom você procurar algum artigo, vídeo, livro, mentor ou IA pra te explicar, mas talvez mesmo sem manjar de OOP você entenda essa próxima parte, então fica por sua conta e risco.

Basicamente, já que tables são análogas a objetos - ou instâncias de classes, em jargão de OOP - nós podemos usar o conceito de metatables para criar relações de herança entre tables. Para isso, a gente vai articular 3 peças chave:

- uma tabela B representando nossa **classe abstrata base**, que pode ser herdada pelas classes filhas através de metatables e do meta-método `__index`
- uma tabela D que representará uma **classe derivada**, herdando a classe base
- um método C da tabela D que seja um _constructor_, quando chamado ele irá instanciar a classe da tabela D

Como exemplo, vamos criar uma classe base chamada `Band`, e uma classe derivada chamada `RockBand`, que com seu _constructor_ `new()` nos permitirá instanciar novas bandas de rock:

``` Lua
Band = {} -- classe base
Band.__index = Band

function Band:play()
	print(self.name .. " starts playing a song")
end

RockBand = {}
setmetatable(RockBand, Band)
RockBand.__index = RockBand

function RockBand.new(name)
	local instance = setmetatable({}, RockBand)
	instance.name = name
	return instance
end

MP = RockBand.new("Major Parkinson")
MP:play() -- output: Major Parkinson starts playing a song
RHCP = RockBand.new("Red Hot Chilli Peppers")
RHCP:play() -- output: Red Hot Chilli Peppers starts playing a song
Grilo = RockBand.new("O Grilo")
Grilo:play() -- output: O Grilo starts playing a song
```

Vamos analisar em detalhe o que esse código faz: Nas duas primeiras linhas a gente está criando uma classe `Band` e setando o `__index` dela para ela mesma, isso nos dá acesso aos seus métodos, como o método `play()`, que é definido logo em sequência. Depois a gente define uma nova classe, `RockBand`, que tem sua metatable setada para `Band`. Assim, quando chamamos um método em uma instância de `RockBand` e esse método não é encontrado na própria classe, ele é procurado na metatable (é o que acontece com o método `play()`). Nós também setamos o `__index` de `RockBand` para `RockBand` pelos mesmos motivos do que fizemos com `Band`. Depois definimos o constructor da classe `RockBand`, que cria uma table local ao mesmo tempo que seta a metatable dela para `RockBand`, com isso a tabela criada aí se torna uma "instância" de `RockBand`. A tabela tem sua propriedade `.name` atribuída e então é retornada da função. A partir daí, quando quisermos criar uma banda de rock é só chamar RockBand.new() passando o nome da banda. Então nas últimas linhas quando a gente faz `MP = RockBand.new("Major Parkinson")` o que acontece é que uma tabela é criada com a metatable `RockBand` que por sua vez tem a metatable `Band`, e quando a gente chama `play()` nessa tabela esse método é procurado nessa cadeia de metatables até ser encontrado. Pronto: criamos herança e OOP em lua. Se você leu o código com atenção provavelmente percebeu que ao definir e chamar o método `play()` a gente usa uma sintaxe esquisita, o dois pontos `:`. Isso acontece por que dentro de `play()` a gente quer ter acesso à table que está chamando ele, então com `:` a table é passada automaticamente como argumento, e pode ser acessada com a variável local `self` (vide a linha 5).

## Coroutines

Para realizar múltiplas tarefas ""simultaneamente"" com lua a gente usa esse treco chamado "co-rotina". Eu digo simultaneamente entre aspas pois na verdade as co-rotinas vão rodar em uma mesma thread no seu processador, então não há paralelismo real.

Para mexer com co-rotinas a gente vai usar principlamente essas 4 funções:

- `coroutine.create()`: cria uma co-rotina
- `coroutine.resume()`: passa o controle do processo pra uma co-rotina
- `coroutine.yield()`: faz a co-rotina atual perder o controle do processo
- `coroutine.status()`: retorna o status de uma co-rotina

Então vamos criar um script meio abstrato que usa essas 4 funções para realizar duas tarefas simultaneamente passo-a-passo:

``` Lua
-- definindo duas arrays de dados super importantes
tasksData = { {10, 20, 30}, {500, 1000, 1500, 2000, 2500}}

-- uma função que cria funções que fazem algo com dados
function createDataProcesser(action, dataSource)
	return function()
		for index, data in ipairs(dataSource) do
			print(action .. " the data at position " .. index .. ": " .. data)
			-- usando yield() depois de cada tarefa para essa co-rotina não
			-- monopolizar o tempo de execução, afinal de contas a gente está
			-- simulando paralelismo
			coroutine.yield(index);
		end
	end
end


function processData()
	-- criando duas co-rotinas que fazem coisas diferentes
	local dataAnalyzer = coroutine.create(createDataProcesser("analyzing", tasksData[1]))
	local dataDeleter = coroutine.create(createDataProcesser("deleting", tasksData[2]))
	-- uma variável que indica se há tarefas restantes
	local tasksRemaining = true

	while tasksRemaining do
		-- checando o status das co-rotinas
		local analyzerStatus = coroutine.status(dataAnalyzer)
		local deleterStatus = coroutine.status(dataDeleter)
		-- se o status não for "dead" então a co-rotina ainda existe 
		if analyzerStatus ~= "dead" then
			-- inicia ou dá continuidade à co-rotina
			coroutine.resume(dataAnalyzer)
		end
		if deleterStatus ~= "dead" then
			coroutine.resume(dataDeleter)
		end
		-- se as duas co-rotinas estiverem acabadas, não há mais tarefas restantes
		if analyzerStatus == "dead" and deleterStatus == "dead" then
			tasksRemaining = false
		end
	end
end

processData()
--[[
output:
analyzing the data at position 1: 10
deleting the data at position 1: 500
analyzing the data at position 2: 20
deleting the data at position 2: 1000
analyzing the data at position 3: 30
deleting the data at position 3: 1500
deleting the data at position 4: 2000
deleting the data at position 5: 2500
]]--
```

A maior parte da explicação já está nos comentários, mas eu quero que você note duas coisas; a primeira é a relação entre `yield()` e `resume()`. O `resume()` recebe uma co-rotina como argumento e inicia ela se ainda não tiver sido iniciada, ou dá continuidade à ela se esta já estava em andamento, já o `yield()` é usado dentro de uma co-rotina, e faz com que a execução dela seja pausada e o valor do argumento seja retornado para o lugar com o `resume()` que iniciou este ciclo. Depois, na próxima vez que o `continue()` seja chamado recebendo essa mesma co-rotina, ela irá continuar executando a partir da linha do último `yield()` que ela deu. Ou seja, essas duas funções ficam passando a bola uma para a outra, elas cedem o controle sobre o programa uma para a outra, e isso é chamado de _multi-threading colaborativo_. No nosso programa, apesar do `yield()` estar retornando o index, a gente não está fazendo nada com ele, mas poderíamos. A segunda coisa para notar é que estamos comparando o status de cada rotina com a string "dead", e isso é por que existem 4 status possíveis com seus respectivos significados:

- *running*: a co-rotina é a que está atualmente rodando
- *suspended*: a co-rotina não está rodando mas pode rodar se for passada para um `resume()`
- *normal*: a co-rotina está ativa mas não é a que está atualmente rodando pois deu `resume()` para outra co-rotina
- *dead*: a co-rotina já acabou sua execução

E basicamente é só isso sobre coroutines

## Iterators