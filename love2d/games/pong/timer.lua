local Timer = {timers = {}}

function Timer:after(seconds, callback, tag)
  table.insert(self.timers, {tag = tag, t = seconds, cb = callback, repeatable = false})
end

function Timer:every(interval, callback, tag)
  table.insert(self.timers, {tag = tag, t = interval, cb = callback, repeatable = true, interval = interval})
end

function Timer:update(dt)
  for i = #self.timers, 1, -1 do
    local timer = self.timers[i]
    timer.t = timer.t - dt

    if timer.t <= 0 then
      timer.cb()

      if timer.repeatable then
        timer.t = timer.interval
      else
        table.remove(self.timers, i)
      end
    end
  end
end

return Timer
