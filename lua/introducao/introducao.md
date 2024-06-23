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
// Cat struct in C
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

* referências que usei para esta sessão de datatypes:
- [http://lua-users.org/wiki/LuaTypesTutorial](http://lua-users.org/wiki/LuaTypesTutorial)
- [http://lua-users.org/wiki/StringsTutorial](http://lua-users.org/wiki/StringsTutorial)
- [http://lua-users.org/wiki/TablesTutorial](http://lua-users.org/wiki/TablesTutorial)