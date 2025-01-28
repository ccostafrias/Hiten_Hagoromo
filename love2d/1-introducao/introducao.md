# Introdução a LÖVE

LÖVE é uma framework mto fofa para desenvolvimento de jogos em lua. Aqui na introdução nós veremos o básicão de sua API.

## Instalando

Se você estiver no Windows ou Mac, pode encontrar os links de download [aqui](https://love2d.org/), mas caso esteja em uma distribuição Linux baseada em Debian (como o Ubuntu), basta que rode o comando `sudo apt install love` no terminal.

Para testar se a instalação deu certo, pode rodar o comando `love --version`, que deverá ter um output como esse: `LOVE 11.4 (Mysterious Mysteries)`.

## Conhecendo a estrutura da API

A documentação da framework pode ser encontrada [neste site](https://love2d.org/wiki/love), que é o site que estarei usando como referência principal neste curso. Nele, você pode notar que a API (e por consequência a própria documentação) está dividida em alguns **módulos**, sendo eles:

- love.audio
- love.data
- love.event
- love.filesystem
- love.font
- love.graphics
- love.image
- love.joystick
- love.keyboard
- love.math
- love.mouse
- love.physics
- love.sound
- love.system
- love.thread
- love.timer
- love.touch
- love.video
- love.window

Além disso, também há uma grande lista de funções callback, com as quais nós vamos nos familiarizar aos poucos.

Cada módulo contém **tipos**, **funções** e **enums** relacionados ao seu propósito. Por exemplo, o módulo `love.audio` tem o tipo `RecordingDevice`, a função `love.audio.play` e o enum `TimeUnit`.

Os módulos que mais exploraremos nessa introdução serão:

- `love.graphics`
- `love.keyboard`
- `love.mouse`
- `love.window`

## As 3 funções essenciais

Geralmente um jogo feito com love terá no mínimo essas 3 funções de callback:

- `love.load()`: chamada 1 vez no início da execução do programa. É onde você define o estado inicial do jogo;
- `love.update(dt)`: roda todo frame e é onde você atualiza o estado do jogo. O argumento `dt` é o tempo em segundos desde a última chamada desta função (tempo decorrido desde o último frame);
- `love.draw()`: também roda todo frame. É onde você faz as chamadas que renderizam algo na tela.

Logo, o formato geral de um jogo será:

``` Lua
function love.load()
	-- inicializa o estado do jogo
end

function love.update()
	-- atualiza o estado do jogo
end

function love.draw()
	-- desenha na tela
end
```