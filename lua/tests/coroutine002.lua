local co = coroutine.create(function()
	coroutine.yield("Esperando algo...")
	return "Fim"
end)

local ok, msg = coroutine.resume(co)
print(ok, msg)

ok, msg = coroutine.resume(co)
print(ok, msg)