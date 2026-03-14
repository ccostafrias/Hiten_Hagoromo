function wait(seconds)
	local t = 0
	while t < seconds do
		t = t + coroutine.yield()
	end
end

local co = coroutine.create(function()
	print("Começou")
	wait(2)
	print("Depois de 2 segundos")
end)

local dt = 0.01
for i = 1, 100 do
	coroutine.resume(co, dt)
	print("Frame", i)
end