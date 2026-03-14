local co = coroutine.create(function()
	print("Passo 1")
	coroutine.yield()
	print("Passo 2")
	coroutine.yield()
	print("Passo 3")
end)

print("Status:", coroutine.status(co))
coroutine.resume(co)

print("Status:", coroutine.status(co))
coroutine.resume(co)

print("Status:", coroutine.status(co))
coroutine.resume(co)

print("Status:", coroutine.status(co))
coroutine.resume(co)