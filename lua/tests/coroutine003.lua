local co = coroutine.create(function()
	local dt = coroutine.yield()
	print("Recebi:", dt)

	dt = coroutine.yield()
	print("Recebi:", dt)

	dt = coroutine.yield()
	print("Recebi:", dt)
end)

print(coroutine.resume(co))
coroutine.resume(co, 0.16)
coroutine.resume(co, 0.32)
