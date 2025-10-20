secret_code = 1357 -- o valor que queremos saber se está certo
actual_code = 1357 -- o valor esperado

assert(secret_code == actual_code, "Wrong secret-code")
-- output: nada, pois os dois são iguais mesmo

actual_code = 0000 -- mudando o código secreto real
assert(secret_code == actual_code, "Wrong secret-code")
--[[
output: 
lua: ./main.lua:8: Wrong secret-code
stack traceback:
        [C]: in function 'assert'
        ./main.lua:8: in main chunk
        [C]: in ?
]]--