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

## Data Types

Quais são os tipos de dado que o lua nos oferece? Você provavelmente está familiarizado com os data types do C, como int, char, float, double (os quatro tipos primitivos do C), pointers, structs, arrays, e etc. Então, os tipos do lua não são tão diferentes, nós vamos ter no total 8 deles, que são:

- Boolean
- Number
- String
- Nil
- Function
- Table
- Thread
- Userdata