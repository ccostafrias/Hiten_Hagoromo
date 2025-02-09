# Introdução a LÖVE

LÖVE é uma framework mto fofa para desenvolvimento de jogos em lua. Aqui na introdução nós veremos o básicão de sua API.

## Instalando

Se você estiver no Windows ou Mac, pode encontrar os links de download [aqui](https://love2d.org/), mas caso esteja em uma distribuição Linux baseada em Debian (como o Ubuntu), basta que rode o comando `sudo apt install love` no terminal.

Para testar se a instalação deu certo, você pode rodar o comando `love --version`, que deverá ter um output como esse: `LOVE 11.4 (Mysterious Mysteries)`.

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

Cada módulo contém **tipos**, **funções** e **enums** relacionados a seu propósito. Por exemplo, o módulo `love.audio` tem o tipo `RecordingDevice`, a função `love.audio.play()` e o enum `TimeUnit`, tudo relacionado a audio.

Os módulos que mais exploraremos nessa introdução serão:

- love.graphics
- love.keyboard
- love.mouse
- love.window

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

## Criando e rodando um programa extremamente simples

Para termos uma noção básica do que estamos fazendo aqui, bora criar um programinha bem simples. Ele renderizará um triângulo que muda de cor a cada segundo que passa.

Antes de qualquer coisa, precisamos criar uma pasta para nosso projeto. Dentro dessa pasta, temos que criar um arquivo `main.lua`, que será o ponto de entrada do nosso programa, visto que o love exige que seu arquivo principal tenha esse nome.

Com isso, vamos declarar as variáveis que estaremos usando nesse programa. Nós podemos declarar elas no escopo global mesmo:

``` Lua
local triangle_vertices -- coordenadas dos vértices em formato {x1, y1, x2, y2, x3, y3}
local triangle_color -- cor em formato {r, g, b, a}
local total_time -- em segundos
```

Depois, vamos para as 3 funções principais que vimos antes, começando pela `love.load()`:

``` Lua
function love.load()
	-- inicializando variáveis
	triangle_vertices = {150,500, 400,100, 650,500}
	triangle_color = {1, 0, 0, 1}
	total_time = 0
	
	-- setando estados iniciais
	love.window.setMode(800, 600) -- tamanho da janela
end
```

Agora vou pular a função `love.update()` por um instante e ir direto para a `love.draw()`. Ela chamará duas outras funções do love:

- `love.graphics.setColor()`: define a cor dos objetos que nós desenharmos na tela daqui em diante, e 
- `love.graphics.polygon()`: desenha um poligono com base em seus vértices e no modo de desenho. Nós usaremos o modo "fill", que preenche o polígono com a cor que definimos com o `setColor()`.

Então nosso `love.draw()` ficou assim:

``` Lua
function love.draw()
	love.graphics.setColor(triangle_color)
	love.graphics.polygon("fill", triangle_vertices)
end
```

Se nós rodarmos o programa agora, ele apenas desenhará um triangulo vermelho na tela. Mas como isso é muito sem graça, vamos preencher a função `love.update()`, que fica entre as duas que nós já escrevemos:

``` Lua
function love.update(dt)
	total_time = total_time + dt
	if math.fmod(total_time, 3) < 1 then
		triangle_color = {1, 0, 0, 1}
	elseif math.fmod(total_time, 3) < 2 then
		triangle_color = {0, 1, 0, 1}
	else
		triangle_color = {0, 0, 1, 1}
	end
end
```

Essa função está mudando a cor do triângulo a cada segundo, alternando-a entre vermelho, verde e azul. Obs: a função `math.fmod()` é como o operador de resto `%` do C.

Pronto! Agora podemos rodar nosso programa. Para fazer isso, usamos o comando `love` no terminal, passando como argumento o _caminho relativo_ para a pasta do projeto. Por exemplo: `love ./projetos_love/triangulo_colorido`. Caso você já esteja na pasta do projeto, um `love .` basta.

Se você seguiu tudo até aqui, deve haver uma janela na sua tela com um triângulo piscante.

## Mexendo com inputs e mais callbacks

Sem inputs, um jogo seria só um filme, então como podemos pegar inputs do teclado e mouse do jogador? Faremos isso, por enquanto, com as seguintes funções:

- `love.keypressed()`: uma função de callback. É chamada quando uma tecla é pressionada;
- `love.keyboard.isDown()`: função que returna `true` se a tecla que passarmos como argumento estiver pressionada;
- `love.mousepressed()`: outro callback. É chamado quando um botão do mouse é pressionado. 

Então, para começar, bora fazer nosso triângulo se mover como um personagem de um jogo.

A primeira coisa que teremos que adicionar ao nosso programa serão algumas variáveis globais novas, mais especificamente essas aqui:

``` Lua
local triangle_pos -- posição do "centro" do triângulo
local triangle_velocity -- velocidade com a qual o triângulo se move
```

Sem esquecer de inicializá-las no `love.load()`:

``` Lua
triangle_pos = {x = 400, y = 300}
triangle_velocity = 5
```

Também vamos mudar um pouco como a variável `triangle_vertices` funciona. Teremos uma função chamada `update_triangle_vertices()`, que, com base na posição do triângulo (`triangle_pos`), irá calcular as coordenadas dos vértices do triângulo.

``` Lua
function update_triangle_vertices()
	triangle_vertices = {triangle_pos.x - 50, triangle_pos.y + 50,
                         triangle_pos.x     , triangle_pos.y - 50, 
                         triangle_pos.x + 50, triangle_pos.y + 50}
end
```

E nós iremos chamar ela tanto no `love.load()` quanto no `love.update()`.

Agora vamos criar uma função `update_movement()`, que irá conferir se as teclas **w**, **a**, **s** e **d** estão pressionadas e atualizar a posição do triângulo de acordo:

``` Lua
function update_movement()
	if love.keyboard.isDown("w") then
		triangle_pos.y = triangle_pos.y - triangle_velocity
	end
	if love.keyboard.isDown("a") then
		triangle_pos.x = triangle_pos.x - triangle_velocity
	end
	if love.keyboard.isDown("s") then
		triangle_pos.y = triangle_pos.y + triangle_velocity
	end
	if love.keyboard.isDown("d") then
		triangle_pos.x = triangle_pos.x + triangle_velocity
	end
end
```

E é claro, vamos chamar ela dentro da função `love.update()`.

Vamos também, por enquanto, apagar as partes do código que fazem o triângulo ficar mudando de cor. Isto pois iremos fazer ele mudar de cor com base no nosso input daqui a pouco. Dessa forma, nossas funções de load e update ficaram assim:

``` Lua
function love.load()
	-- inicializando variáveis
	triangle_pos = {x = 400, y = 300}
	update_triangle_vertices()
	triangle_velocity = 5
	triangle_color = {1, 0, 0, 1}
	
	-- setando estados iniciais
	love.window.setMode(800, 600) -- setando o tamanho da janela
end

function love.update(dt)
	update_movement()
	update_triangle_vertices()
end
```

E você deve estar conseguindo o triângulo pela tela usando o **wasd**.

Nossa próxima feature será fazer com que a tecla `esc` feche o programa, e que a tecla `space` mude a cor do triângulo. Para tal, utilizaremos a callback `love.keypressed()` citada anteriormente. Seu argumento `key` nos diz qual tecla foi apertada, sendo o argumento que usaremos por agora para definir separadamente o comportamento de cada tecla. Logo, nossa função ficará assim:

``` Lua
function love.keypressed(key, scancode, isrepeat)
	-- termina a execução do programa
	if key == "escape" then
		love.event.quit()
	end
	-- muda a cor do triângulo: R -> G -> B -> R -> ...
	if key == "space" then
		if triangle_color[1] == 1 then
			triangle_color = {0, 1, 0, 1} -- de vermelho pra verde
		elseif triangle_color[2] == 1 then
			triangle_color = {0, 0, 1, 1} -- de verde pra azul
		else
			triangle_color = {1, 0, 0, 1} -- de azul pra vermelho
		end
	end
end
```

Assim, nosso triângulo volta a ficar coloridão (com o "jogador" controlando sua cor).

Por fim, para mexermos um pouco com o mouse, vamos fazer com que o botão esquerdo do mouse seja capaz de teletransportar o triângulo para o cursor. De forma semelhante a como fizemos com o teclado, usaremos o callback `love.mousepressed()`:

``` Lua
function love.mousepressed(x, y, button, istouch, presses)
	if button == 1 then
		triangle_pos.x = x
		triangle_pos.y = y
	end
end
```

O botão pressionado está sendo comparado com **1** pois este número representa o botão esquerdo, 2 representa o direito, e 3 o botão do meio. `x` e `y`, como você deve imaginar, são as coordenadas do cursor no momento em que o botão foi pressionado.

E é isso. Agora nosso triângulo se move, muda de cor e se teletransporta - ingualzinho a um personagem de jogos eletrônicos.

## Renderizando imagens/gifs

Eu sei que triângulos são extremamente legais e tudo mais, mas e se nós substituíssemos nosso triângulo por algo que parece mais vivo, como um **GATINHO**. Para isso, nós precisariamos de uma imagem dele, já que renderizar um gato composto de triângulos no __pelo__ seria bem difícil. Bom, como no love2d renderizar imagens e gifs é semelhante (renderizar um gif é renderizar cada frame seu como uma imagem diferente), nós vamos renderizar um **gif** de uma vez para pelo menos ver algo se mexendo na tela.

O gif que estarei usando é [esse aqui](https://www.reddit.com/r/Catloaf/comments/yrvghr/found_it_the_very_rare_3d_360_degrees_catloaf/), mas você pode escolher outro se quiser (ou se o link tiver caído). Primeiro, criaremos uma pasta chamada "**assets**" no mesmo diretório que nosso `main.lua` está. Depois, dentro de `assets`, criaremos mais uma pasta chamada "**oiiai_cat_animation**" ou algo do tipo, e colocaremos nosso gif dentro dela. Por fim, vamos usar o `ffmpeg` para repartir nosso gif em todos os seus frames.

Se você não tem o ffmpeg instalado, dê uma olhada no [site deles](https://www.ffmpeg.org/download.html), mas no linux tu pode só meter um `sudo apt install ffmpeg` e jaé.

Com o ffmpeg instalado, use o comando abaixo dentro da pasta que contém o gif para dividi-lo em frames enumerados. Não esqueça de substituir o nome do gif pelo nome que você deu a ele.

```
ffmpeg -i ./oiiai_cat.gif frame-%3d.png
```

Com isso, você deve ter agora um monte de pngs prontos para serem renderizados, então bora partir pro código.

Antes de mais nada, nós podemos apagar qualquer coisa no código que diga respeito ao triângulo, pois vamos abandonar ele de vez.

No escopo global, vamos declarar uma tabela chamada `cat` para guardar todas as informações sobre nosso gato:

``` Lua
local cat = {}
```

Também vou declarar uma tabela `window` para guardar as dimensões da janela, assim a gente não precisa ficar "hardcodando" a altura e a largura da jenela em todo lugar:

``` Lua
-- ** no escopo global **
local window = {}

-- ** na função love.load() **
window.width = 1000
window.height = 800
love.window.setMode(window.width, window.height)
```

e um pouco abaixo da declaração de `cat` vamos definir uma função `init_cat()`, que inicializa todos os atributos do gatinho, como sua posição, tamanho, os frames de sua animação e etc:

``` Lua
function init_cat()
	cat.velocity = 10
	cat.curr_frame = 1
	cat.frame_delay = 0.03
	cat.animation_timer = 0
	cat.animation = {}

	-- os caminhos finais pros frames são algo assim: ./assets/oiiai_cat_animation/frame-###.png
	local frame_path_skeleton = "assets/oiiai_cat_animation/frame-"
	
	-- meu gif tem 190 frames, mas troque aqui 190 pelo número de frames do seu gif, caso tenha usado outro
	for i = 1, 190 do
		local frame_path = frame_path_skeleton
		-- colocando 0 no começo de números baixos. Ex: 005
		if i < 10 then
			frame_path = frame_path.."00"
		elseif i < 100 then
			frame_path = frame_path.."0"
		end
		frame_path = frame_path..i..".png" -- finalizando com o número do frame e a extensão do arquivo
		cat.animation[i] = love.graphics.newImage(frame_path) -- colocando o frame na array de animação
	end

	cat.width = cat.animation[1]:getWidth()
	cat.height = cat.animation[1]:getHeight()
	local x = (window.width / 2) - (cat.width / 2)
	local y = (window.height / 2) - (cat.height / 2)
	cat.position = {x = x, y = y}
end
```

Aqui neste trecho estamos usando algumas funções e métodos novos, então vou explicar eles:

- `love.graphics.newImage()`: cria um objeto do tipo "Image" com base no caminho do arquivo que você passa como argumento;
- `:getWidth()`: um método que retorna a largura de uma imagem (e de texturas no geral);
- `:getHeight()`: o mesmo que o de cima, mas para a altura.

Uma parte da função que exige atenção é o loop, pois é ele que preenche nossa array `cat.animation` com os frames do gif. E como sempre, não podemos esquecer de chamar nossa função `init_cat()` dentro do `love.load()`.

O próximo passo é criar a lógica que vai passar de um frame da animação para o próximo, loopando quando a animação chegar no final. Essa lógica, como é de esperar, ficará na função `love.update()`:

``` Lua
cat.animation_timer = cat.animation_timer + dt
if cat.animation_timer > cat.frame_delay then
	cat.animation_timer = 0
	cat.curr_frame = cat.curr_frame + 1
	
	-- loopando a animação
	if cat.curr_frame > #cat.animation then
		cat.curr_frame = 1
	end
end
```

Este trecho é relativamente simples, nós vemos se o tempo entre um frame e outro já passou, e caso sim, nós incrementamos o frame atual (`cat.curr_frame`), loopando a animação caso necessário.

Para nós podermos mover o bixano pela tela - como nós estávamos movendo o triângulo - vamos modificar a função `update_movement()` para alterar a posição do gatito:

``` Lua
function update_movement()
	if love.keyboard.isDown("w") then
		cat.position.y = cat.position.y - cat.velocity
	end
	if love.keyboard.isDown("a") then
		cat.position.x = cat.position.x - cat.velocity
	end
	if love.keyboard.isDown("s") then
		cat.position.y = cat.position.y + cat.velocity
	end
	if love.keyboard.isDown("d") then
		cat.position.x = cat.position.x + cat.velocity
	end
end
```

E então chamar ela dentro do `love.update()`, para que a atualização do movimento ocorra em todo frame.

Agora só falta o toque final para colocarmos esse gatinho na tela, chamar a função do love que desenha imagens dentro do `love.draw()`. A função que usamos para isso é a `love.graphics.draw()`, passando como argumentos a **imagem** e as posições **x** e **y**:

``` Lua
function love.draw()
	-- limpando a tela com um azul acinzentado
	love.graphics.clear(0.25, 0.25, 0.5)
	-- desenhando o gatinho na posição 
	love.graphics.draw(cat.animation[cat.curr_frame], cat.position.x, cat.position.y)
end
```

E PRONTO! agora se tudo deu certo, tu tem um gif que anda pela tela (no meu caso um gatinho giratório). Ele deve estar mais ou menos assim:

![Gatinho giratório](https://i.imgur.com/FfmLZRG.png)

OBS: finge que ele está girando, não consegui colocar um vídeo aqui, só imagem

Também vou propor um mini desafio aqui para ver se vc tá manjando. Tente fazer com que clicar "espaço" no teclado faça com que o gif se reverta (começe a tocar de trás para frente).