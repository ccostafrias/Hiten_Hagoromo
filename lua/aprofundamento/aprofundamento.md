# APROFUNDAMENTO

A partir de agora a gente vai aprender a usar as funcionalidades e as bibliotecas do lua que nos permitem escrever projetos minimamente interessantes e complexos. Os principais temas que nós vamos abordar são:

- modules
- metamethods, metatables e OOP
- multi-threading
- iterators
- core functions
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

## Multi-threading



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
```