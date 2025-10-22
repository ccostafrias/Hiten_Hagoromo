require "TEsound"

local cat = {}
local window = {}
local MAX_FRAMES = 190

function init_cat()
	cat.velocity = 10
	cat.curr_frame = 1
	cat.frame_delay = 0.01
	cat.animation_timer = 0
  cat.isReverse = false
	cat.animation = {}

	local frame_path_skeleton = "assets/cat_animation/frame-"
	
	for i = 1, MAX_FRAMES do
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

function animate_cat(dt)
  cat.animation_timer = cat.animation_timer + dt
  if cat.animation_timer > cat.frame_delay then
    cat.animation_timer = 0
    cat.curr_frame = cat.curr_frame + (not cat.isReverse and 1 or -1)
    
    -- loopando a animação
    if cat.curr_frame > #cat.animation or cat.curr_frame < 1 then
      cat.curr_frame = (not cat.isReverse and 1 or MAX_FRAMES)
    end
  end
end

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

function love.keypressed(key, scancode, isrepeat)
	if key == "escape" then
		love.event.quit()
	end

  if key == "space" then
    cat.isReverse = not cat.isReverse
  end

  if key == "u" then
    TEsound.play("assets/cat_sounds/cat_a.ogg", "static")
  end
  if key == "i" then
    TEsound.play("assets/cat_sounds/cat_i.ogg", "static")
  end
  if key == "o" then
    TEsound.play("assets/cat_sounds/cat_o.ogg", "static")
  end
end

function love.load()
  window.width = 1000
  window.height = 800
  love.window.setMode(window.width, window.height)

  init_cat()
end

function love.update(dt)
  update_movement()
  animate_cat(dt)
end

function love.draw()
	-- limpando a tela com um azul acinzentado
	love.graphics.clear(0.25, 0.25, 0.5)
	-- desenhando o gatinho na posição 
	love.graphics.draw(cat.animation[cat.curr_frame], cat.position.x, cat.position.y)
end