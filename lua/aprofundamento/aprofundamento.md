# APROFUNDAMENTO

A partir de agora a gente vai aprender a usar as funcionalidades e as bibliotecas do lua que nos permitem escrever projetos minimamente interessantes e complexos. Os principais temas que nós vamos abordar são:

- modules
- metamethods, metatables e OOP
- coroutines
- iterators
- core functions
- IO library
- OS library
- debug library
- otimizações

Tem algumas bibliotecas e funções que não serão abordadas simplesmente por serem algo que você descobre facilmente em 2 segundos no google e que apenas poluiriam este curso. Por exemplo, não iremos falar sobre funções como a `math.sqrt()`, por que caso algum dia você precise dela, você irá simplesmente pesquisar "square root function lua" no google e o primeiro resultado te entregará de bandeija a resposta que você queria. O que faremos aqui é explicar algumas funções um pouco menos óbvias e que são boas de se ter em mente desde já.

A referência que estaremos usando ao longo desse arquivo será o [manual de referência oficial do lua 5.4](https://www.lua.org/manual/5.4/manual.html), então se você quiser pode ir acompanhando ele junto do curso pra tirar dúvidas ou sla.

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

Esse método é válido nas versões do lua a partir da 5.2, mas você provavelmente não está usando uma versão antiga então não vou prolongar essa parte (se você está, **por quê???** Atualize seu lua agora mesmo ou morra).

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

Basicamente, já que tables são análogas a objetos - ou instâncias de classes, no bom e velho português - nós podemos usar o conceito de metatables para criar relações de herança entre tables. Para isso, a gente vai articular 3 peças chave:

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

Vamos analisar em detalhe o que esse código faz: Nas duas primeiras linhas a gente está criando uma classe `Band` e setando o `__index` dela para ela mesma, isso vai fazer com que suas instâncias tenham acesso aos métodos da própria classe (ou melhor, aos métodos da tabela Band, como o método `play()`, que é definido logo em sequência). Depois a gente define uma nova classe, `RockBand`, que tem sua metatable setada para `Band`. Assim, quando chamamos um método em uma instância de `RockBand` e esse método não é encontrado na própria classe, ele é procurado na metatable (é o que acontece com o método `play()`). Nós também setamos o `__index` de `RockBand` para `RockBand` pelos mesmos motivos do que fizemos com `Band`. Depois definimos o constructor da classe `RockBand`, que cria uma table local ao mesmo tempo que seta a metatable dela para `RockBand`, com isso a tabela criada aí se torna uma "instância" de `RockBand`. A tabela tem sua propriedade `.name` atribuída e então é retornada da função. A partir daí, quando quisermos criar uma banda de rock é só chamar RockBand.new() passando o nome da banda. Então nas últimas linhas quando a gente faz `MP = RockBand.new("Major Parkinson")` o que acontece é que uma tabela é criada com a metatable `RockBand` que por sua vez tem a metatable `Band`, e quando a gente chama `play()` nessa tabela esse método é procurado nessa cadeia de metatables até ser encontrado. Pronto: criamos herança e OOP em lua. Se você leu o código com atenção provavelmente percebeu que ao definir e chamar o método `play()` a gente usa uma sintaxe esquisita, o dois pontos `:`. Isso acontece por que dentro de `play()` a gente quer ter acesso à table que está chamando ele, então com `:` a table é passada automaticamente como argumento, e pode ser acessada com a variável local `self` (vide a linha 5).

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

Em lua, iteradores irão nos ajudar a loopar por vários valores (como por exemplo os valores contidos em uma tabela). Para isso, podemos ou usar os iteradores próprios da linguagem ou criar os nossos próprios. Na sessão de introdução a gente viu os iteradores `pairs()` e `ipairs()`, que retornam pares de chaves e valores de tabelas, como no exemplo a seguir:

``` Lua
table1 = {city = "Xique Xique", state = "Bahia", country = "Brazil"}
table2 = {"a", "b", "c"}

-- usando pairs para iterar sobre uma table com chaves não-numéricas
for key, value in pairs(table1) do
	print(key, value)
end
-- usando ipairs para iterar sobre uma table com chaves numéricas de forma ordenada
for index, value in pairs(table2) do
	print(index, value)
end

--[[
output:
country Brazil
city    Xique Xique
state   Bahia
1       a
2       b
3       c
]]--
```

Outro iterador bacana da linguagem é o `next()`. Ele vai receber uma table e uma chave como argumentos e vai retornar o próximo par chave-valor da tabela. O fato dele precisar receber uma chave como segundo argumento significa que ele é um iterador _*stateless*_, ou seja, um iterador que não se lembra internamente onde ele estava na última vez que foi chamado; ele precisa receber esse contexto como argumento.

``` Lua
character = {name = "Luffy", role = "captain", crew = "Straw Hats"}
-- pegando a chave e o valor iniciais
key, value = next(character, nil)
-- iterando enquanto houver mais chaves
while key do
    print(key, value)
    -- atualizando a chave e o valor
    key, value = next(character, key)
end
```

Por fim, nós podemos criar nossos próprios iteradores, por exemplo esse aqui, que recebe um número *n* e itera pelos primeiros *n* números pares (ou seja, primeiro retorna 2, depois 4, etc..)

``` Lua
-- função que constrói um iterador
function n_evens(maxCount)
    local curr_even = 0
    local count = 0
    return function()
        -- incrementando as variáveis
        count = count + 1
        curr_even = curr_even + 2
        -- retornando o número par atual se a condição de parada não tiver chegado
        if count <= maxCount then
            return curr_even
        end
    end
end

for num in n_evens(5) do
    print(num)
end

--[[
output:
2
4
6
8
10
]]--
```

O que está acontecendo de fato aqui é que `n_evens()` retorna um iterador, que por sua vez é uma função anônima que se lembra das variáveis do escopo onde ela foi criada (`curr_even` e `count`). No for loop, o iterador retornado por `n_evens()` é chamado a cada loop, incrementando seu contador por 1 e o número par por 2, e então retornando o número par.

Só pra deixar claro, a função iteradora não precisa ser anônima, e ela também não precisa de um contador que controla sua parada (nesse caso ela seria um iterador infinito, e a condição de parada ficaria em algum outro lugar do código). Oia só um iterador muito parecido com o do exemplo anterior mas com essas duas modificações:

``` Lua
-- gera um iterador infinito
function n_evens(maxCount)
    local curr_even = 0
    -- função não anônima
    function iterator()
        curr_even = curr_even + 2
        -- sem condição de parada
        return curr_even
    end
    return iterator
end

for num in n_evens() do
    print(num)
    if num >= 10 then break end
end
```

## Core Functions

Aqui a gente vai ver como usar algumas das funções que já vêm com o lua. Como há muitas, e algumas delas a gente já viu, eu vou filtrar aqui as que eu achar mais interessantes, explicar rapidamente elas e dar um exemplo pra cada. A ordem aqui é alfabética (por que é assim que está na [documentação](https://www.lua.org/manual/5.4/manual.html#5:~:text=6.1%20%E2%80%93%20Basic%20Functions)), então as primeiras funções não necessáriamente são mais legais ou úteis que as últimas. Enfim, vamos lá:

### `assert()`

Essa função simplesmente vê se seu primeiro argumento tem valor de verdade `true`. Se isso for verdade, nada acontece, mas se não for, ocorre um *erro* (e a mensagem de erro pode ser personalizada com um segundo argumento). Isso é útil porque podemos usar como ferramenta de teste ou debug, então costumamos passar como primeiro argumento uma comparação com forma `valor == valor_esperado`, e portanto o resultado do `assert()` nos dirá se o teste passou ou não

``` Lua
secret_code = 1357 -- o valor que queremos saber se está certo
actual_code = 1357 -- o valor esperado

assert(secret_code == actual_code, "Wrong secret-code")
-- output: nada, pois os dois são iguais mesmo

actual_code = 0000 -- mudando o código secreto real
assert(secret_code == actual_code, "Wrong secret-code")
--[[
output: 
lua: ./main.lua:8: Wrong secret-code
stack traceback:
        [C]: in function 'assert'
        ./main.lua:8: in main chunk
        [C]: in ?
]]--
```

### `dofile()`

Essa função roda um outro arquivo .lua e retorna os valores que aquele arquivo retornar. Então aqui no exemplo a gente tem um arquivo `main.lua` e outro arquivo `other.lua`, o `main.lua` chama `dofile()` passando como argumento o caminho para o outro arquivo, fazendo com que ele seja executado:

``` Lua
-- other.lua
print("hello world!")
return 1, 2, 3

-- main.lua
a, b, c = dofile('other.lua')
print(a, b, c)

--[[
output:
hello world
1       2       3
]]--
```

### `error()`

Causa um erro:

``` Lua
error("heeeelp")

--[[
output: 
lua: main.lua:1: heeeelp
stack traceback:
        [C]: in function 'error'
        main.lua:1: in main chunk
        [C]: in ?
]]-- 
```

### `pcall()`

O `pcall()` recebe uma função e seus argumentos, e então chama essa função com os argumentos passados em um _modo protegido_. Isto é, os erros que ocorrerem na função passada como argumento não se propagarão, ao invés disso o `pcall()` retornará 2 valores, sendo o primeiro um bool que é `false` se tiver dado algum erro, e os restantes sendo ou a mensagem de erro ou os valores de retorno da função. No exemplo podemos ver os dois casos:

``` Lua
-- função que pode causar erro
function goesWrong(a, b)
	assert(a == b, "something went wrong")
end
-- função que retorna normalmente
function returnsNormally(a, b)
	return a+b, a*b
end

code, msg = pcall(goesWrong, 2, 3)
print(err, msg) -- output: false   main.lua:3: something went wrong
code, ret1, ret2 = pcall(returnsNormally, 2, 3)
print(code, ret1, ret2) -- output: true    5       6
```


### `type()`

Recebe uma variável como argumento e retorna o tipo dessa variável, bem intuitiva:

``` Lua
t = {'dsad', 'kmofm', 'ghrwd'}
n = 10
s = "yay"
b = false
f = function() end
print(type(t)) -- output: table
print(type(n)) -- output: number
print(type(s)) -- output: string
print(type(b)) -- output: boolean
print(type(f)) -- output: function
```

## Biblioteca de IO

Em lua a gente tem uma tabela `io` que contém todos os métodos que precisarmos para mexer com input/output. O primeiro método é o `io.open()`, que equivaleria ao `fopen()` do C, ele recebe o caminho para um arquivo e o modo de abertura e retorna um "descritor de arquivo" - um objeto que representa um arquivo, como o `FILE *` do C. Os modos de abrir que existem são iguais aos do C: r, w, a, r+, w+ e a+. Por exemplo seria assim que nós criariamos uma variável contendo um arquivo de texto pronto para leitura:

``` Lua
file = io.open("something.txt", "r")
```

Depois de abrir um arquivo, quando nós terminarmos de usá-lo, temos que fechar ele com a função `io.close()`, dessa forma:

``` Lua
io.close(file)
```

E é entre essas duas chamadas de função que a gente lê ou escreve no arquivo. Sendo assim, as duas principais funções que iremos utilizar serão o `read()` e
o `write()`, que funcionam de forma relativamente simples. A read lê do arquivo de acordo com a formatação passada como parâmetro (semelhante ao `fscanf()` do C). As formatações que existem são:

- `"n"` para ler um número
- `"a"` para ler o arquivo até o final
- `"l"` para ler uma linha descartando o '\n'
- `"L"` para ler uma linha incluindo o '\n'
- `{número}` para ler {número} bytes

Se você não passar nenhum argumento para a função ela usará o `"l"` por padrão. Já o `write()` simplemente escreve os argumentos que ele recebe (podendo ser eles números ou strings) para o arquivo. Aqui vai um exemplo da gente escrevendo para um arquivo e depois lendo o que a gente escreveu nele:

``` Lua
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

--[[
output:
Hello, file!
vcnvqnd
]]--
```

Aqui você pode ver que a gente está chamando os métodos através das variáveis contendo o arquivo, dessa forma: `arquivo:funcao(argumentos)`, mas há outro jeito também. Os arquivos de entrada e saída padrão do `io` é o terminal, mas podemos mudar eles para serem o arquivo que quisermos. Ou seja, se chamarmos `io.read()` e `io.write()` sem fazer nada antes, nós estaríamos lendo inputs e escrevendo texto pro terminal, como se estivessemos usando as funções `scanf()` e `printf()` do C, mas com os métodos `io.input()` e `io.output()` nós podemos redefinir os arquivos padrão de input e output do módulo `io`. Segue um exemplo:

``` Lua
--[[
conteúdo do input.txt:

beat me up
beat me down
]]--

-- main.lua:
a = io.read() -- lendo input do terminal
io.write(a) -- escrevendo de volta pro terminal
-- mudando a entrada e a saída padrão
io.input("input.txt")
io.output("output.txt")
-- lendo da nova entrada padrão: input.txt
line1 = io.read("L")
line2 = io.read("L")
-- escrevendo pra nova saída padrão: output.txt
io.write(line2 .. '\n' .. line1)

-- conteúdo do output.txt:
beat me down
beat me up
```

Outro método útil da tabela `io` é o `lines()`, que recebe o caminho para um arquivo e retorna um iterador que itera sobre as linhas desse arquivo:

``` Lua
--[[
conteúdo do something.txt:

for what it's worth
I'd do it again
with no consequence
I will do it again
]]--

-- vamos contar quantos caracteres tem em something.txt
count = 0
for line in io.lines("something.txt") do
    count = count + #line
end
print(count) -- output: 71
```

## Biblioteca de OS

A table `os` nos fornece alguns métodos que interagem com o sistema operacional de uma forma mais direta. Por exemplo, uma das funções dessa tabela é a `os.execute()`, que executa um comando como se você tivesse digitado ele no terminal, tal qual a função `system()` do C:

``` Lua
os.execute("whoami") -- output: {o nome do seu usuário}
```

Outra função muito útil é a `clock()`, que retorna o tempo em segundos que se passou desde o início da execução do programa, então você pode usar ela para fazer benchmark da eficiência de uma função, por exemplo.

``` Lua
function slowww()
	for i = 0, 100000 do
		print(i)
	end
end

start = os.clock()
slowww()
finish = os.clock()

print("slowww() took " .. finish-start .. " seconds to execute")
-- output: slowww() took 0.120197 seconds to execute
```

Também temos algumas outras funções simplezinhas, como a `os.rename()`, que renomeia um arquivo ou diretório, a `os.remove()`, que remove um arquivo ou um diretório vazio, a `os.setlocale()`, que faz a mesma coisa que sua xará do C, e a `os.date()` que retorna a data atual:

``` Lua
print(os.date())
-- output: Thu Sep 26 11:12:04 2024
```

E por último, mas não menos importante, temos também a `os.getenv()`, que recebe o nome de uma variável de ambiente e retorna seu valor, se ela existir, e `nil` se ela não existir:

``` Lua
print(os.getenv("SHELL")) -- output: /bin/bash
print(os.getenv("INEXISTENT_ENVIRONMENT_VARIABLE")) -- output: nil
```

## Biblioteca de Debug

A tabela debug é Pog porque ela deixa você analizar o comportamento do seu código bem de perto sem ter que ficar printando tudo como um lunático. A função mais importante dessa tabela é a `debug.debug()`, que pausa a execução do seu programa e inicia uma sessão de debug, na qual você pode executar comandos em lua para investigar o estado ou o comportamento atual do seu programa. Por exemplo, digamos que a gente tem o seguinte código:

``` Lua
num = 1000
-- função que teoricamente randomiza um número para um outro valor menor ou igual a ele mesmo
randomize = function(num)
	num = math.floor(num * math.random());
end
-- randomizando nosso número 10 vezes e checando uma condição
for i = 1, 10 do
	randomize(num)
	if num < 500 then
		print("smaller than 500")
	else
		print("greater than or equal to 500")
	end
	-- reiniciando o valor dele
	num = 1000
end
```

Quando nós executamos ele, algo que não esperávamos (ou pelo menos finja que não esperava) acontece: o output é sempre esse o mesmo:

``` Shell
$ lua main.lua
greater than or equal to 500
greater than or equal to 500
greater than or equal to 500
greater than or equal to 500
greater than or equal to 500
greater than or equal to 500
greater than or equal to 500
greater than or equal to 500
greater than or equal to 500
greater than or equal to 500
$
```

Para sabermos o que está acontecendo, vamos usar a função `debug.debug()` dentro do nosso for loop, que ficará assim:

``` Lua
for i = 1, 10 do
	debug.debug()
	randomize(num)
	if num < 500 then
		print("smaller than 500")
	else
		print("greater than or equal to 500")
	end
	num = 1000
end
```

Então na primeira vez que a gente chegar na linha do debugger, esperamos que o valor de `num` seja 1000, e nas vezes subsequentes esperamos que este valor mude. Então vamos executar o código e usar o debugger para conferir isso (perceba que toda vez que quisermos dar continuidade à execução do código usamos o comando `cont`):

``` Shell
$ lua main.lua 
lua_debug> print(num)
1000
lua_debug> cont
greater than or equal to 500
lua_debug> print(num)
1000
lua_debug> cont
greater than or equal to 500
lua_debug> print(num)
1000
lua_debug>
...
$ 
```

Ok, a gente na primeira vez que printamos, o valor de `num` realmente era 1000, mas nas vezes subsequentes ele não mudou, e com isso a gente tem um momento de iluminação espiritual e percebemos que a função `randomize()` só está alterando o valor de seu argumento localmente, e que números em lua não são passados como referência para funções. E então a gente corrige o bug usando tables, que são de fato passadas por referência:

``` Lua
num = {1000} -- usando uma table para poder passar por referência
randomize = function(num)
    num[1] = math.floor(num[1] * math.random());
end
for i = 1, 10 do
    randomize(num)
    if num[1] < 500 then
        print("smaller than 500")
    else
        print("greater than or equal to 500")
    end
    num[1] = 1000
end
```

E agora nosso output faz sentido:

``` Shell
$ lua main.lua 
smaller than 500
smaller than 500
smaller than 500
smaller than 500
greater than or equal to 500
smaller than 500
greater than or equal to 500
greater than or equal to 500
smaller than 500
greater than or equal to 500
$
```

Além da função `debug.debug()`, uma outra interessante é a `debug.sethook()`, que recebe como argumentos uma função e uma string com um desses 3 valores: "c", "r", "l". A partir do ponto em que `sethook()` é chamada, a função que ela recebeu será chamada:

- toda vez que uma outra função for chamada, se o segundo argumento for "c"
- toda vez que uma função retornar, se o segundo argumento for "r"
- antes de cada linha ser executada, se o segundo argumento for "l"

Por exemplo:

``` Lua
status = "online"

function changeStatus()
    if status == "online" then
        status = "offline"
    else
        status = "online"
    end
end

function showStatus()
    print("changing status from: " .. status)
end

changeStatus() -- status vira offline
changeStatus() -- status vira online
changeStatus() -- status vira offline
-- AAAAA finge que a gente se perdeu no meio de tanta mudança e queremos saber o status toda vez que ele mudar
debug.sethook(showStatus, "c") -- aplicando nosso hook que confere o status
changeStatus()
changeStatus()
changeStatus()

--[[
output:
changing status from: offline
changing status from: online
changing status from: offline
]]--
```

Também existem outras funções mais nichadas nesse módulo, como a `gethook()`, a `getinfo()` e a `traceback()`, mas eu não quero prolongar d+ essa sessão, então fica como sua lição de casa ler sobre e testar elas se quiser.

## Otimizações

Ebaaa, a sessão final chegou. Aqui a gente vai dar uma olhada nas dicas de otimização da [wiki dos lua-users](http://lua-users.org/wiki/OptimisationTips). Você não precisa aplicar elas a todo momento, mas já que nosso plano é desenvolver jogos e aplicações gráficas (coisas que no geral dependem muito de um código de alto desempenho) vale a pena ter esses truques no arsenal:

- Dê bastante preferência a usar variáveis *locais* ao invés de globais, pois no lua elas são acessadas de forma mais rápida
- `t[#t + 1] = x` é mais rápido do que `table.insert(t, x)`
- Multiplicação é mais rápido do que divisão, ex: `x * 0.5` é preferível à `x/2` 
- `x * x` é mais rápido que `x^2`
- O operador `//` de divisão de inteiros é mais rápido do que o `/` (divisão com floats), mas cuidado, ele descarta as casas decimais
- For loops são um pouco mais rápidos que while loops
- Acesso de valores em tabelas é meio lento, então se há elementos que você acessa repetidamente, pode ser uma boa ideia fazer um "cache" deles em uma variável local
- se você quiser concatenar uma lista de strings, use `table.concat()` ao invés de fazer manualmente com um for loop
- Se você tem uma ideia geral de qual será o tamanho de uma tabela, você pode pré-alocar ela com esse tamanho desde o inicio com a função `table.create()`, por exemplo:

``` Lua
t = {} -- ruim se sua tabela for crescer muitas vezes
t = table.create(100) -- melhor
```

Enfim, por enquanto é isso.

## Conclusão

*PARABÉNS DE NOVO CARALHOOOOOO*, você sobreviveu ao breve curso de Lua. Lembre-se de que toda linguagem de programação tem sua imensa complexidade e de que o que aprendemos aqui é só o começo. Mas assim, as coisas profundas de verdade a gente aprende pondo a mão na massa, então o que eu sugiro fortemente que você faça é usar tudo que a gente aprendeu até agora pra fazer algum projetinho divertido, sua imaginação é o limite. Em linguagens como o C, que nós temos usado de comparativo, pode ser meio assustador começar um novo projeto, mas Lua é tão fofinha e redondinha que eu acredito que você não terá grandes problemas para implementar algo legal.

Mas então, o que vêm agora? Bom, sabendo lua a gente pode começar a aprender *LÖVE*, a framework foda e open source para fazer joguinhos, espero você lá.
