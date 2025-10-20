local inventario = {}
local pocao_vida_base = {item = 'Pocao', tipo = 'Consumivel', cura = 50}

local function melhorar_pot(pot)
  pot.cura = pot.cura + 20
end

inventario["max_slots"] = 10
inventario[1] = pocao_vida_base

print("O 1o item do invetario eh " .. inventario[1].item .. " com " .. inventario[1].cura .. " de cura")
melhorar_pot(inventario[1])
print("O 1o item do invetario eh " .. inventario[1].item .. " com " .. inventario[1].cura .. " de cura")
