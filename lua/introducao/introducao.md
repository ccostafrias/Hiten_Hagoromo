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

### Funtion

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

não importa como você define ela, ela pode ser tratada como uma variável de qualquer forma, bora criar uma função que recebe uma função como argumento só pra demonstrar aqui:

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