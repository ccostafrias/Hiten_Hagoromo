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
print(a + b) --output: 3.5
```