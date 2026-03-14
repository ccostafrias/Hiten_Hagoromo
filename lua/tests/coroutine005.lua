function waitForEnter()
	while true do
		print("Pressione ENTER")
		local input = io.read()
		if input == "" then
			return
		end
		coroutine.yield()
	end
end

local co = coroutine.create(function()
	print("Oi")
	waitForEnter()
	print("Você apertou enter")
end)

while coroutine.status(co) ~= "dead" do
	coroutine.resume(co)
end
