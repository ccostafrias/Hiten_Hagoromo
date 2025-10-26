local class = require("class")
local Button = class:derive("Button")

function Button:new(text, func, width, height, enabled)
  self.text = text
  self.func = func
  self.width = width
  self.height = height
  self.enabled = enabled
end

return Button