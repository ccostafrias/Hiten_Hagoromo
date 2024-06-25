# INTRODUÇÃO

AEEEE bora lá. Antes de qualquer coisa, **o que é lua?** Bom, lua é uma linguagem [interpretada](https://en.wikipedia.org/wiki/Interpreter_(computing)) (diferentemente do C, que é compilado) que é famosa pelas seguintes características:

- ser fácil de aprender
- ser basicamente um python melhorado
- ter sido criada por brasileiros
- ser a linguagem usada para programar joguinhos de roblox
- ser a linguagem usada pra criar plugins do neovim
- começar as arrays com index 1 ao invés de 0

Muito massa, né? Outras coisas notáveis de lua são o fato dela ser incrivelmente minimalista (tendo apenas 21 keywords) e ser bem prática de integrar com outras linguagens (principalmente C e C++). Só a nível de curiosidade, essas são todas as 21 keywords do lua em uma ordem arbitrária:

- if
- else
- elseif
- then
- and
- or
- not
- true
- false
- nil
- local
- function
- repeat
- for
- in
- while
- do
- until
- break
- return
- end

Beleza, até o fim dessa sessão do dojo você vai saber o que cada uma delas faz. Mas agora chega de papo, vamos lutar (ou melhor, aprender).

## Instalando lua

Se você está em um sistema linux basta usar os seguintes 4 comandos:

``` shell
curl -L -R -O https://www.lua.org/ftp/lua-5.4.6.tar.gz
tar zxf lua-5.4.6.tar.gz
cd lua-5.4.6
make all test
```

para confirmar que deu tudo certo, use `lua -v` e o output será a versão que está instalada.

Se você está em um sistema windows:

- acesse este [link](https://luabinaries.sourceforge.net/)
- scrolla pra baixo e seleciona versão que você quer instalar
- vai na pastinha "Tools Executables" que aparecer
- baixe ou a Win32_bin.zip ou a Win64_bin.zip, a depender da sua máquina
- extraia o zip
- coloque a pasta contendo os .exe na sua variável PATH (se não souber fazer isso, siga este [passo a passo](https://stackoverflow.com/questions/44272416/how-to-add-a-folder-to-path-environment-variable-in-windows-10-with-screensho) do stackoverflow)

Se você está no MacOS, instale o brew se ele não estiver instalado e use:

``` shell
brew update
brew install lua
```

## Variáveis e Data Types

Quais são os tipos de dado que o lua nos oferece? Você provavelmente está familiarizado com os data types do C, como int, char, float, double (os quatro tipos primitivos do C), pointers, structs, arrays, e etc. Então, os tipos do lua não são tão diferentes, nós temos 8 deles no total, que são:

- Boolean
- Number
- String
- Nil
- Function
- Table
- Thread
- Userdata

Antes de eu explicar cada um dos tipos eu preciso deixar algo claro: lua é uma linguagem com tipagem dinâmica. Ou seja, diferentemente do C, onde cada variável tem um tipo fixo que é definido na declaração da variável - como em `int a = 2` para criar um inteiro - em lua **as variáveis em si não têm tipo, apenas os valores têm tipo**. O que isso significa? na prática, significa duas coisas: primeiro que você não precisa especificar o tipo de uma variável em sua declaração (ao invés de `int a = 2`, basta escrever `a = 2`), e segundo que você pode "mudar o tipo" de uma variável, por exemplo vc pode botar uma `String` em uma variável que anteriormente guardava um `Boolean`, ou botar um `Number` em uma variável que guardava uma `Table`, saca? Em linguagens com tipagem estática, como o C, isso daria um erro de compilação, mas como as variáveis de lua não são restritas a um tipo (são dinâmicas), qualquer variável pode guardar qualquer tipo de dado. Exemplo:

``` Lua
var = 10 -- declarando var como Number
print(a)
var = "Bom dia" -- mudando var para String
print(a) -- printa Bom dia sem problemas
```

**OBS: comentários em lua são feitos com --**

Ok, agora vamos ver cada um desses tipos um pouco melhor _(na verdade só os primeiros 6, os últimos 2 ficam pra depois)_.

### Boolean

As variáveis booleanas são as mais simples, pois só podem ter 2 valores: `true` ou `false`. Esses valores geralmente são usados em condicionais e yada yada, disso vc já sabe então não vou me extender.

### Number

Aqui as coisas ficam mais interessantes, em lua tanto os números inteiros quanto os números decimais (`floats` e `doubles` em C) são agrupados em um tipo só: `Number`. Um número em lua tem, por padrão, 64 bits, então tem precisão equivalente a um double do C. Aqui vai um exemplo da gente misturando números inteiros com decimais sem problema nenhum:

``` Lua
a = 1
b = 2.5
print(a + b) -- output: 3.5
print(a / b) -- output: 0.4
```

### String

Em lua as strings são tipos primitivos, diferentemente do C, onde strings são apenas um ponteiro para uma sequência de chars. Sendo assim, se você tenta fazer algo como:

``` Lua
texto = "Lorem Ipsum"
print(texto[1]) -- tentando pegar a primeira letra de texto
```

não vai dar certo, pois a string não é uma array e portanto não é indexavel. Por outro lado, em lua é muito mais fácil manipular strings (isso a gente vê melhor mais pra frente), veja só:

``` Lua
nome = "Oda "
status = "Gênio"
print(nome .. status) -- output: Oda Gênio
print(string.sub(nome, 1, 2)) -- output: Od
```

A sintaxe `..` junta duas strings, e a função string.sub() recebe 3 argumentos, uma string e dois números, e então retorna uma substring do primeiro argumento de acordo que vai do segundo argumento até o terceiro, então nesse caso uma substring de "Oda" que vai da primeira letra até a segunda (pq passamos 1 e 2 como argumentos), o que resulta em "Od".

### Nil

O `nil` seria mais ou menos equivalente ao `NULL` do C, ele representa algo que não existe, e suas principais características são: ser diferente de todos os outros valores e ser _falsy_. Na programação chamamos um valor de falsy se em um contexto booleano ele se comporta como o `false`.

### Function

Ué, funções são... um tipo de dado? SIM! em lua (mas não apenas em lua) funções são _first class citizens_ (cidadões de primeira classe), isso basicamente significa que elas podem ser atribuidas à uma variável, podem ser passadas como parâmetros para outras funções e podem ser retornadas de funções. Muito pog. Em lua nós declaramos uma função assim:

``` Lua
function sum(a, b)
	return a + b
end
```

aí você percebe outras particularidades:

1. Não é necessário usar chaves {} para delimitar o escopo da função, o que delimita o fim da função é a keyword `end`
2. Não é necessário definir o tipo de retorno da função ou dos argumentos

bem simples né? também dá pra declarar elas da seguinte maneira:

``` Lua
sum = function(a, b)
	return a + b
end
```

não importa como você declara ela, ela pode ser tratada como uma variável de qualquer forma. Bora criar uma função que recebe uma função como argumento só pra demonstrar aqui:

``` Lua
function sum(a, b)
	return a + b
end

function recievesFunction(func, a, b)
	c = func(a, b)
	return c
end

print(recievesFunction(sum, 700, 27))
```

neste exemplo a função `recievesFunction` recebe 3 argumentos, uma função e duas variáveis, e então chama a função recebida passando as duas variáveis como argumento. O ponto é, nós passamos a função `sum` como argumento para `recievesFunction` como se ela fosse uma variável, mas ela **É** uma variável, então está tudo nas conformidades.

### Table

Table, ou tabela em português, é o tipo de dado _não primitivo_ principal do lua. Tudo aquilo que você faria com arrays, structs, objetos, dicionários ou sets em outras linguagens você faz com tabelas em lua.

Já que as tabelas são tão versáteis, vamos ver os vários jeitos de usar elas um de cada vez, começando com o jeito de usar elas como arrays. Veja como `myTable` é declarada aqui:

``` Lua
myTable = {1, 1, 2, 3, 5, 8, 13, 21}
```

Muito parecida com a declaração de arrays no C, né? o jeito de acessar um elemento (indexar a array) também é praticamente igual, com a única diferença sendo que os índices de tables no lua começam em 1 ao invés de 0:

``` Lua
myTable = {1, 1, 2, 3, 5, 8, 13, 21}
print(myTable[1]) -- output: 1
print(myTable[2]) -- output: 1
print(myTable[3]) -- output: 2
print(myTable[4]) -- output: 3
print(myTable[5]) -- output: 5
print(myTable[6]) -- output: 8
```

Se quisermos acessar o último elemento da tabela podemos usar o operador `#` para pegar o tamanho (número de elementos) da tabela e então usar esse número para indexar a própria tabela. ps: o # também funciona para pegar o tamanho de uma string:

``` Lua
myTable = {1, 1, 2, 3, 5, 8, 13, 21}
myString = "pirataria"
print(myTable[#myTable]) -- output: 21
print(#myString) -- output: 9
```

Blz, agora pra continuar a analogia com o C, bora usar a table como se fosse uma struct. Para isso, a gente vai criar **associações entre chaves e valores** (keys e values). As chaves são basicamente equivalentes ao nome de uma propriedade em C, enquanto os valores são aquilo que é guardado na propriedade (no caso de lua, aquilo que é associado à uma chave). Vou botar uma comparação aqui de estruturas equivalentes nas duas linguagens:

``` C
// Cat struct em C
struct Cat {
	char name[10];
	short int age;
};

struct Cat myCat = {.name = "Kira", .age = 6};

printf("%s is %d years old\n", myCat.name, myCat.age);
```

``` Lua
-- myCat table in lua
myCat = {name = "Kira", age = 6}

print(myCat.name .. " is " .. myCat.age .. " years old")
```

Veja só, a estrutura `myCat` no C tem duas propriedades: `name` e `age`, o mesmo vale para a table do lua, o que a gente fez ali foi criar uma table com as chaves `name` e `age` e associar elas com os valores `"kira"` e `6`. A forma de acessar o valor associado a uma chave é usando a sintaxe `tableName.key`, mas há outras formas também:

``` Lua
myCat = {name = "Kira", age = 6}
print(myCat["name"])
```

Isto é por que `{name = "Kira"}` é a mesma coisa que `{["name"] = "Kira"}`, só que mais bonitinho.

Tenha em mente que qualquer coisa pode ser uma chave. **QUALQUER COISA** (exceto `nil` e NaN). Por exemplo, aqui está uma struct que usa vários tipos de dado como chaves:

``` Lua
function myFunc(a, b)
	return nil
end

crazyTable = {name = "conway", [10] = "quack!", [myFunc] = 1, [false] = "wasd"}
print(crazyTable["name"]) -- output: conway
print(crazyTable[10]) -- output: quack!
print(crazyTable[myFunc]) -- output: 1
print(crazyTable[false]) -- output: wasd
```

E se você quiser adicionar um valor novo na tabela depois dela ser criada? é só fazer o seguinte:

``` Lua
myTable = {}
myTable[1] = 9000
myTable["idk"] = 7
-- etc
print(myTable[1]) -- 9000
print(myTable.idk) -- 7
```

E para deletar um valor podemos usar o método `table.remove()`:

``` Lua
pairNums = {2, 4, 6, 8, 10}
print(pairNums[1]) -- 2
print(pairNums[2]) -- 4
print(pairNums[3]) -- 6
print(pairNums[4]) -- 8
print(pairNums[5]) -- 10

table.remove(pairNums, 3) -- removendo o valor no index 3

print(pairNums[1]) -- 2
print(pairNums[2]) -- 4
print(pairNums[3]) -- 8
print(pairNums[4]) -- 10
print(pairNums[5]) -- não existe mais, agora pairNums só tem 4 elementos
```

Agora pra gente finalizar esse papo de table (e data types) você precisa saber que as tables, diferentemente de números ou strings, são passadas como referência quando usadas como parâmetro ou atribuídas a outras variáveis. Se você não sabe o que "ser passada como referência" significa, é mais ou menos assim: o valor guardado em uma variável do tipo table não é a tabela em si, mas uma referência para a tabela, um pointer. Então quando você faz algo do tipo

``` Lua
tableA = {5, 4, 3, 2, 1}
tableB = tableA
tableB[1] = 10
```

você não tem duas tables diferentes `tableA` e `tableB`, você tem uma table só e duas referências pra ela; dois pointer para ela. Então quando você modifica a `tableB` você também está por consequência modificando a `tableA`. Se você não prestar atenção nisso vários bugs sinistros podem surgir sem você entender o por quê. Demonstração:

``` Lua
tableA = {5, 4, 3, 2, 1}
tableB = tableA
tableB[1] = 10
print(tableA[1]) -- output: 10
```

Você também pode confirmar isso printando a tabela em si, o que vai resultar em um endereço de memória sendo printado:

``` Lua
tableA = {5, 4, 3, 2, 1}
tableB = tableA
print(tableA) -- output: endereço de memória, ex: 0x62e3eae1df60
print(tableB) -- output: mesmo endereço
```

Muito provavelmente você ficou com várias curiosidades do tipo "o que acontece se eu fizer X ou Y", então eu recomendo de verdade que você pegue sua IDE e seu terminal e experimente fazer essas coisas você mesmo, esse é o melhor jeito de aprender.

referências que usei para esta sessão de datatypes:
- [http://lua-users.org/wiki/LuaTypesTutorial](http://lua-users.org/wiki/LuaTypesTutorial)
- [http://lua-users.org/wiki/StringsTutorial](http://lua-users.org/wiki/StringsTutorial)
- [http://lua-users.org/wiki/TablesTutorial](http://lua-users.org/wiki/TablesTutorial)

## Flow control

Agora vamos pra parte mais divertida; comandos de flow do programa. Como toda boa linguagem de programação, lua tem if/else, for loops e while loops. Assumindo que você já está familiarizado com essas estruturas, vamos passar rapidinho por essa parte só para aprender a sintexe mesmo, já que o funcionamento é igual ao de qualquer outra lingugem.

### Condicionais

Diferentemente de C, que possui apenas as keywords `if` e `else` para criar blocos condicionais, lua tem `if`, `else` e `elseif`. A única diferença aqui é o `elseif`, que equivale a um `else if` do C, como você deve ter adivinhado. Então blocos de condicionais no lua são feitos da seguinte forma:

``` Lua
a = 0
b = 1

-- um if sozinho
if a == 0 then
	print("a == 0")
end

-- um if com elseif
if a == 1 then
	print("a == 1")
elseif b == 1 then
	print("b == 1")
end

-- if com elseif e else
if a == 2 then
	print("a == 2")
elseif b == 2 then
	print("b == 2")
else
	print("UwU")
end
```

então nos casos mais complexos são usadas 5 keywords: `if`, `elseif`, `else`, `then`, `end`. O `end` a gente já viu na declaração de funções, ele delimita o final de um bloco de código, já o `then` simplesmente indica que o bloco que vêm depois dele é executado se a condição anterior a ele for verdadeira. Outra coisa que difere as condicionais do lua com as do C é que em lua nós não usamos simbolos como `!`, `||` e `&&` para designar operadores lógicos, ao invés disso usamos as keywords `not`, `or` e `and`, como neste exemplo:

``` Lua
-- equivalente a !false
if not false then
	print("UwU")
end
-- equivalente a true || false
if true or false then
	print("OwO")
end
-- equivalente a true && true
if true and true then
	print("OvO")
end
```

Outra coisa curiosa é que em lua o valor `0` não é falsy, ele é truthy (se comporta como `true` em um contexto booleano), ex:

``` Lua
if 0 then
	print("zero is true") -- é printado
end

if not 0 then
	print("zero is false") -- não é printado
end
```

### Loops

Vamos começar pelo mais simples, o `while` loop. Ele é extremamente parecido com o do C, olha só:

``` Lua
a = 2
while a <= 1024 do
	print(a)
	a = a * 2
end
```

esse loop vai executar o bloco de código dentro dele até que a condição determinada (`a <= 1024` neste caso) seja falsa. A única coisa que eu acho bom que não passe despercebida é o uso da  keyword `do`.

Outro tipo de loop é o `repeat until`. Ele funciona de uma forma parecida ao `do while` loop do C, mas ao contrário. Leia esse exemplo e depois eu explico:

``` Lua
a = 2
repeat
	print(a)
	a = a * 2
until a > 1024
```

Esse bloco entre o `repeat` e o `until` vai rodar pelo menos uma vez e continuará rodando até que a condição que vem depois do `until` se torne **verdadeira**. Mas por que isso é o contrário do `do while` no C? é porque o `do while` roda até que a condição que vêm depois do `while` se torne **falsa**.

Por último temos o `for` loop, que em lua é consideravelmente diferente daquele em C. A sintaxe é mais ou menos assim:

``` Lua
for i = initialValue, stopValue, step do
	-- faz algo
end
```

O que equivaleria ao seguinte loop em C:

``` C
for(int i = initialValue; i <= stopValue; i += step){
	// faz algo
}
```

Obviamente `initialValue`, `stopValue` e `step` deveriam ser números, estes nomes estão aí só de exemplo. Aqui vai um loop de verdade:

``` Lua
for i = 0, 10, 2 do
	print(i) -- output: 0, 2, 4, 6, 8, 10
end
```

Mas desse jeito a gente só tem loops que incrementam o `i` e param quando ele é maior do que um determinado valor, e se nós quisermos um `i` que é decrementado e que o loop pare quando `i` for menor que algum valor? Nesse caso é só usar um step negativo:

``` Lua
for i = 10, 0, -2 do
	print(i) -- output: 10, 8, 6, 4, 2, 0
end
```

Por último, a gente também pode usar o for loop para iterar pelas entradas de uma tabela com as funções `ipairs()` ou `pairs()`, que geram um iterador a partir da tabela que elas recebem como argumento (a diferença entre as duas é que `ipairs()` só funciona quando as chaves da tabela são números), saca só:

``` Lua
someTable = {name = "Orimoto", age = 65, course = "SI"}

for key, value in pairs(someTable) do
	print(key .. ": " .. value)
end

--[[
	output:
	age: 65
	course: SI
	name: Orimoto
]]--
```

Note que o output não está na ordem, isso é porque tabelas que não estão sendo usadas como arrays mas sim como objetos não são ordenadas. Também note que usamos a keyword `in` neste caso, que serve para navegar pelos elementos de um iterador.

Agora, caso você queira sair de um loop prematuramente em alguma situação específica, você pode usar o comando `break`. Ele funciona igual ao do C, simplesmente para a execução da iteração atual e pula pra próxima linha fora do loop. Exemplo:

``` Lua
for i = 1, 100, 1 do
	print(i .. " OwO")
	if i % 11 == 0 then
		break
	end
	print(i .. " UwU")
end
```

Este loop vai ser interrompido quando `i` for 11 antes que o décimo primeiro UwU seja printado (não me pergunte qual é o sentido desse exemplo, apenas aceite).

Referência usada para esta sessão de flow control:
- [http://lua-users.org/wiki/ControlStructureTutorial](http://lua-users.org/wiki/ControlStructureTutorial)

## Escopos

Eu não sei se você percebeu mas a gente já aprendeu como usar 20 das 21 keywords do lua, incrível. A única que falta é a `local`, e essa keyword tem tudo a ver com escopos. Em IP você deve ter aprendido que as variáveis em C só são válidas no escopo em que elas são criadas e em seus escopos internos. Ou seja, uma variável criada no escopo global é válida em qualquer lugar, uma variável criada dentro de um loop é válida apenas dentro do loop, e uma criada dentro de uma função é válida só dentro da função, etc (ignorando, é claro, variáveis alocadas manualmente, que só deixam de ser válidas quando passadas pro `free()`). No lua é diferente, por padrão toda variável que você cria é global, e o único jeito de limitar elas a um escopo é com a keyword `local`. Para entendermos melhor, vamos ver duas situações: uma com o uso de `local` e outra sem.

``` Lua
-- cria uma tabela com 3 elementos e retorna a soma deles
function createTable(a, b, c)
	someTable = {a, b, c}
	return a + b + c
end

createTable(5, 10, 15)

print(someTable[1]) -- output: 5
print(someTable[2]) -- output: 10
print(someTable[3]) -- output: 15
```

Neste caso acima, no qual a gente não usa a keyword `local`, a tabela e seus elementos pode ser acessada mesmo fora do escopo onde ela foi criada: o escopo da função `createTable`.

``` Lua
-- cria uma tabela com 3 elementos e retorna a soma deles
function createTable(a, b, c)
	local someTable = {a, b, c}
	return a + b + c
end

createTable(5, 10, 15)

print(someTable[1]) -- ERRO: attempt to index a nil value (global 'someTable')
```

Mas neste caso, no qual a gente usa a keyword `local`, a tabela deixa de existir assim que a gente sai do escopo da função, e portanto tentar acessar seus elementos causa um erro. Isso é muito bom pois a gente pode controlar quais variáveis pertencem a quais áreas do nosso código, além de evitar possíveis conflitos de nomes de variáveis ou alguns bugs sorrateiros. Minha dica para caso você não saiba quando usar `local` é que você use ele por padrão em toda variável, e só deixe de usar quando você **quiser** ou **precisar** que uma variável seja "omnipresente" no seu código (ênfase no quiser).

Você também pode criar funções locais, e isso é considerado boa prática:

``` Lua
local function divide(a, b)
	return a / b
end
```

Algo interessante também é que tudo isso pode ser usado para criar _closures_, um tipo de função que é muito comum no paradigma de programação funcional. Uma closure é uma função que "se lembra" das variáveis locais do escopo onde ela foi criada, mesmo depois que o escopo já acabou. Por exemplo, vamos criar uma função `createCounter()` que define uma variável local `counter` e uma função local `increment()`, que vai incrementar a variável `counter`. `increment()` será nossa closure, e a função `createCounter()` retornará essa closure. Assim, quando a gente chamar `createCounter()`, e mesmo depois de seu escopo ser extinto, `increment()` ainda terá acesso à variável local `counter`; ela "se lembrará" de uma variável que já devia ter sumido.

``` Lua
function createCounter()
	local counter = 0

	-- increment é uma closure
	local function increment()
		counter = counter + 1
		print(counter)
	end

	return increment
end
-- newCounter recebe uma closure
newCounter = createCounter()
newCounter() -- output: 1
newCounter() -- output: 2
newCounter() -- output: 3
-- otherCounter recebe outra closure
otherCounter = createCounter()
otherCounter() -- output: 1
otherCounter() -- output: 2
-- o counter de otherCounter não afeta o counter do newCounter
-- e vice versa
newCounter() -- output: 4
newCounter() -- output: 5
otherCounter() -- output: 3
```

Referência para esta parte de escopos
- [http://lua-users.org/wiki/ScopeTutorial](http://lua-users.org/wiki/ScopeTutorial)