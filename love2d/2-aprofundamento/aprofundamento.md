# Aprofundamento em LOVE

Ok, agora que já entendemos como funciona o básico do LÖVE, como sua inicialização, a leitura de inputs e a renderização de assets, vamos abordar alguns outros tópicos importantes para a criação de um bom jogo.

O plano é:

- Falaremos sobre como usar *Sprite Sheets* para criar animações;
- Depois, vamos falar sobre o uso de *Canvas* para renderizar certos elementos em suas próprias "janelas virtuais";
- Em seguida, vamos ver um pouco de *Particle Systems* (Sistemas de Partícula);
- Então, vamos falar um pouquito sobre *Threads* do LOVE, e
- Por fim, vamos bater um papinho final sobre desenvolvimento de jogos, Love2D, e para onde ir agora que você concluiu o curso.

Para explicar essas coisas, vou utilizar exemplos reais de um jogo que estou desenvolvendo, chamado "MushRooms". Contudo, como você - leitor - não possui o contexto inteiro do código do jogo, vou tomar o máximo de cuidado nas explicações e tentar não te deixar perdido.

Parece bom? Então bó

## Animações com Sprite Sheets

Na introdução a Love, nós vimos que é possível renderizar uma "animação" separando seus frames em imagens diferentes e então desenhando elas uma de cada vez. Contudo, esse processo é muito limitado, desorganizado e demorado. Ao invés de fazer isso toda vez que quisermos adicionar uma animação para nosso jogo, vamos usar a estratégia dos verdadeiros desenvolvedores de jogos: *_sprite sheets_*.

Sprite sheets são imagens que reúnem todos os frames de uma ou mais animações. Os frames ficam alinhados em fileiras e colunas, então o que nós fazemos para renderizar uma animação usando sprite sheets é iterar sobre essas fileiras de frames.

![exemplo de sprite sheet](../../assets/exemplo_sprite_sheet.png)

Então vamos ver na prática um exemplo de como sprite sheets são usadas em um sistema de animação. Aqui em baixo temos o código da declaração de uma classe "Animation", responsável por gerenciar animações em um jogo:

``` Lua
Animation = {}
Animation.__index = Animation

function Animation.new(frames, frameDur, looping, loopFrame, frameDim)
	local animation = setmetatable({}, Animation)

	-- atributos que variam
	animation.frames = frames       -- número de frames na animação
	animation.frameDur = frameDur   -- duração de cada frame em segundos
	animation.looping = looping     -- se a animação é ciclica ou não
	animation.loopFrame = loopFrame -- a partir de qual frame a animação é ciclica
	animation.frameDim = frameDim   -- dimensões de cada frame
	-- atributos fixos na instanciação
	animation.currFrame = 1         -- frame atual
	animation.timer = 0             -- tempo decorrido desde a última mudança de frame	
	
	return animation
end
```

Como você pode ver, os objetos dessa nossa classe vão guardar praticamente todas as informações necessárias para rodarmos uma animação (que possivelmente loopa a partir de um ponto arbitrário). A função construtora de animações, contudo, é um pouco mais complexa, vamos dar uma olhada nela:

``` Lua
function newAnimation(path, length, quadSize, frameDur, looping, loopFrame, frameDim)
	local sheetImg = love.graphics.newImage(path)
	local frames = {}
	local gap = 4
	local sWidth = sheetImg:getWidth()
	local sHeight = sheetImg:getHeight()
	local qWidth = quadSize.width
	local qHeight = quadSize.height
	local i = 0

	for y = 0, sHeight - qHeight, qHeight + gap do
		for x = 0, sWidth - qWidth, qWidth + gap do
			i = i + 1
			if i > length then goto createanimation end

			table.insert(frames, love.graphics.newQuad(x, y, qWidth, qHeight, sWidth, sHeight))
		end
	end

	::createanimation::
	return Animation.new(frames, frameDur, looping, loopFrame, frameDim)
end
```

Bom, para entendermos ela melhor, vamos ver o que é cada uma dessas variáveis que nós inicializamos no início da função:

- *sheetImg:* a imagem que contém a sprite sheet inteira, ela é criada usando a função `love.graphics.newImage()` que nós já vimos antes, passando-se o caminho para o arquivo da sprite sheet.
- *frames:* é uma lista de Quads (já vamos ver o que é isso), cada um representando a área na sprite sheet referente a um frame específico. Lembre-se que os frames ficam alinhados um do lado do outro na sprite sheet.
- *gap:* em muitas sprite sheets, incluindo as desse jogo, há um espaçamento entre os frames da animação, nesse caso o espaçamento é de 4 pixels.
- *sWidth:* a largura da sprite sheet em pixels.
- *sHeight:* a altura da sprite sheet em pixels.
- *qWidth:* a largura de cada frame (e portanto de cada `Quad`) em pixels.
- *qHeight:* a altura de cada frame (e portanto de cada `Quad`) em pixels.
- *i:* um contador que contabilizará frames.

A próxima parte do código - o loop duplo - não passa de uma etapa de preenchimento da array `frames` com os _Quads_ de cada frame. A palavra "Quads" vem de "quadrilátero". Ou seja, `Quads` são regiões quadriláteras de uma textura (imagem), e são a forma como nós subdividimos uma sprite sheet em seus frames. A função `love.graphics.newQuad()` cria um `Quad` para nós, recebendo como argumentos as coordenadas do quad na textura de referência, suas dimensões e as dimensões da textura de referência.

Em suma, esse loop duplo cria regiões retangulares que designam nossos frames, começando pelo canto superior esquerdo da sprite sheet e scaneando ela da esquerda para a direita, cima para baixo, até que o fim da imagem seja alcançado ou que `i` ultrapasse o número de frames da nossa animação. Ao fazer isso, os quads vão sendo colocados em nossa array `frames`, que posteriormente será útil como você bem verá.

Agora vamos ver como de fato renderizar as animações. Tudo gira em torno do método `update` da classe "Animation". Esta função recebe um `dt` (delta time, o tempo entre o último frame e o atual) e atualiza nossa animação de acordo.

``` Lua
function Animation:update(dt)
    self.timer = self.timer + dt
    -- se já tiver passado a duração de um frame
    if self.timer > self.frameDur then
    	-- reseta o timer
        self.timer = 0
        -- e passa para o próximo frame
        self.currFrame = self.currFrame + 1
        -- se já tiver passado do último frame
        if self.currFrame > #self.frames then
        	-- volta pro primeiro frame de loop se a animação for ciclica
            self.currFrame = self.looping and self.loopFrame or #self.frames
        end
    end
end
```

Ok, então temos uma forma de criar animações e uma forma de rodar elas, então bora ver esse sistema sendo usado na prática.

Neste jogo, as sprite sheets de um personagem (as imagens de suas animações de caminhada, defesa, etc) são guardadas na própria instância do personagem (uma decisão questionável, eu sei...), e as animações também são guardadas no personagem. Tanto as sprite sheets quanto as animações em si são guardadas em uma tabela, mais ou menos assim:

``` Lua
function Player.new(argumentos bla bla bla)
	local player = setmetatable({}, Player)

	-- { outras propriedades... }

	player.state = IDLE      -- define o estado atual do jogador, estreitamente relacionado às animações
	player.spriteSheets = {} -- no tipo imagem do love
	player.animations = {}   -- as chaves são estados e os valores são Animações

	return player
end
```

Como dizem os comentários, o `player.state` guarda o estado atual do jogador (como "parado", "caminhando", "atacando", etc). Como cada estado tem sua própria animação, usamos os estados como chaves para as tabelas de sprite sheets e de animações. Logo, em nossa função `love.update(dt)`, fazemos algo do gênero:

``` Lua
function love.update(dt)
	-- { fazendo outras coisas }
	-- ...
	player.animations[player.state]:update(dt)
end
```

E por fim, em nossa função `love.draw()`, chamamos uma função que renderiza o jogador, que por sua vez faz algo assim:

``` Lua
-- aqui, p é o player
local animation = p.animations[p.state]
local quad = animation.frames[animation.currFrame]
love.graphics.draw(p.spriteSheets[p.state], quad, p.x, p.y)
```

Neste trecho de código, que é o que na prática desenha o jogador na tela em sua posição correta e no frame correto da animação correta, nós fazemos o uso de tudo que vimos nesta seção: a classe `Animation`, `Quads` e - é claro - *Sprite Sheets*.

## Canvas e split-screen

Um *canvas* é uma espécie de "janela virtual para renderização". Basicamente, da mesma forma que você geralmente renderiza formas, imagens, animações e tudo mais em uma *janela*, você pode renderizar em um canvas. E então, você pode _renderizar um canvas em uma janela_, ou renderizar um canvas em outro canvas, e assim em diante. Os canvas não são visíveis a princípio, então até que você renderize eles na janela de sua aplicação, qualquer coisa presente neles não aparecerão em lugar nenhum.

Para o conceito "canvas" ficar mais claro, vou dar um exemplo. Vamos supor que você queira que seu jogo tenha um mini-mapa no canto da tela. Ao invés de você renderizar cada parte de mini-mapa diretamente na tela, você pode renderizá-las em um canvas e então renderizar este canvas na tela de uma vez só.

Para criar um novo canvas, utilizamos a função `love.graphics.newCanvas()`, passando como argumentos a largura e a altura do canvas que queremos. Esta função nos retornará um objeto `Canvas`, o qual nós veremos como usar agora.

O processo de usar um canvas é relativamente simples. Uma vez que você criou seu canvas, basta que, dentro da função `love.draw()`, você *ative* seu canvas, *desenhe nele* e depois *desenhe ele na tela*.

``` Lua
-- ativando o canvas
love.graphics.setCanvas(canvas)
-- desenhando algo nele (um mini mapa, por exemplo...)
love.graphics.draw(minimap, minimap.x, minimap.y)
-- desativando o canvas (ou ativando o canvas da janela inteira)
love.graphics.setCanvas()
-- desenhando o canvas na janela
love.graphics.draw(canvas, canvasPos.x, canvasPos.y)
```

Aqui, nós usamos apenas uma nova função, mas que nos serviu dois propósitos: a `love.graphics.setCanvas()`. Quando ela é chamada recebendo um canvas como argumento, ela ativa este canvas, e a partir de então qualquer operação de renderização é aplicada no canvas ativo. Contudo, quando ela é chamada sem receber argumentos, ela ativa o "canvas padrão", digamos assim, que é a própria janela na qual seu jogo está rodando.

Na última linha, veja que nós estamos renderizando o canvas como se ele fosse uma imagem: usando a função `love.graphics.draw()`.

Simples, não? Bem, esta ferramenta, apesar de simples, nos abre algumas janelas (ba dum - tsss) que antes seriam muito inacessíveis. Por exemplo, agora podemos implementar *Split Screen* em nossos jogos. Basta que a visão de cada jogador seja desenhada em seu próprio canvas, e então os canvas sejam desenhados em suas respectivas posições na tela.

Caso você viva em baixo de uma estrela do mar que vive em baixo de uma pedra, _split screen_ é uma forma de exibir múltiplas perspectivas em uma única tela dividindo-a em seções. Se você já viu como a tela de Mario Kart fica quando mais de uma pessoa está jogando no mesmo console/computador: isso é split screen.

No jogo que estou implementando, por exemplo, tenho uma classe chamada `Camera`. Cada instância de câmera segue o personagem de um jogador. Para que o split screen deste jogo funcione, eu associei um canvas a cada câmera. Dessa forma, na função `love.draw()`, algo do tipo acontece:

``` Lua
function love.draw()
	-- iterando por todas as câmeras, cada uma possui um canvas e segue um jogador
	for i, c in pairs(cameras) do
		love.graphics.setCanvas(c.canvas)
		love.graphics.clear(0.0, 0.0, 0.0, 1.0)
		renderWorld(i)
		renderPlayers(i)
		love.graphics.setCanvas()
		love.graphics.draw(c.canvas, c.canvasPos.x, c.canvasPos.y)
	end
end
```

Se você prestou atenção nos exemplos de código anteriores, este trecho não deve te surpreender muito. Tudo que estamos fazendo aqui é seguir as etapas do uso de canvases (?).

1. Ativar o canvas
2. Renderizar o conteúdo do canvas
3. Desativar o canvas
4. Desenhar o canvas na tela

Não entrarei nos detalhes da implementação da classe `Camera` ou das funções `renderWorld()` e `renderPlayers()`, pois isto exigiria muito tempo e não incrementaria muito em seu conhecimento sobre Love2D, mas vou anexar aqui uma imagem do split screen funcionando:

![split screen funcionando](../../splitscreen.png)

Na esquerda temos a câmera do personagem *Mush*, e na direita temos a câmera do personagem *Shroom*. Conforme eles se mexem, as câmeras os acompanham. É isso! :D
