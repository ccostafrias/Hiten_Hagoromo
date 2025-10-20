local function fibs(max)
  local count1 = 1
  local count2 = 0

  local function iterator()
    local newCount = count1 + count2
    count1 = count2
    count2 = newCount

    if newCount <= max then
      return newCount / (count1 == 0 and 1 or count1)
    end
  end

  return iterator
end

for num in fibs(100000000) do
  print(num)
end