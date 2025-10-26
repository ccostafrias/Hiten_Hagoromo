local Background = {}

function Background:load()
  self.universe = love.graphics.newImage("assets/universe.png")
  self.planets = love.graphics.newImage("assets/planets.png")
end

function Background:draw()
  love.graphics.draw(self.universe, 0, 0)
  love.graphics.draw(self.planets, 0, 0)  
end

return Background