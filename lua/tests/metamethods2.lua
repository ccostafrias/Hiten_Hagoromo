Band = {} -- classe base
Band.__index = Band

function Band:play()
	print(self.name .. " starts playing a song")
end

RockBand = {}
RockBand.__index = RockBand

function Band:__call(...)
  local instance = setmetatable({}, self)
  instance:new(...)
  
  return instance
end

function RockBand:new(name)
	self.name = name
end

setmetatable(RockBand, Band)

MP = RockBand("Major Parkinson")
MP:play() -- output: Major Parkinson starts playing a song
RHCP = RockBand("Red Hot Chilli Peppers")
RHCP:play() -- output: Red Hot Chilli Peppers starts playing a song
Grilo = RockBand("O Grilo")
Grilo:play() -- output: O Grilo starts playing a song