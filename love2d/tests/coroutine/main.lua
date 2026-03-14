local temp = 0
local lastInput = {}
local text = ""

function waitTime(seconds)
  temp = seconds
  while temp > 0 do
    temp = temp - coroutine.yield()
  end
  temp = 0
end

function waitInput()
  while true do
    if #lastInput > 0 then
      return 
    end
    
    coroutine.yield()
  end
end

local coTime = coroutine.create(function ()
  print("Coroutine time started")
  waitTime(10)
  print("Coroutine time end")
end)

local coInput = coroutine.create(function ()
  text = "waiting for input..."
  waitInput()
  text = "input received! key = "..lastInput[1]
end)

function love.keypressed(key)
  lastInput[1] = key  
end

function love.load()
  
end

function love.update(dt)
  if coroutine.status(coTime) ~= "dead" then
    coroutine.resume(coTime, dt)
  end

  if coroutine.status(coInput) ~= "dead" then
    coroutine.resume(coInput)
    lastInput[1] = nil
  end
end

function love.draw()
  love.graphics.print("CONTADOR: "..temp, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
  love.graphics.print(text, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2 + 100)
end