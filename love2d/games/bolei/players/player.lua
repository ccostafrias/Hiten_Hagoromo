local Class = require("libs.class")
local Player = Class:derive("Player")
local Timer = require("libs.timer")

function Player:keypressed(key)
  if key == self.controls.jump and self.isGrounded then
    self.body:applyLinearImpulse(0, self.jumpForce)
    self.isGrounded = false
  end

  if key == self.controls.dash then
    self:dash()
  end
end

function Player:dash()
  if not self.canDash then return end

  local dx, _ = self.body:getLinearVelocity()
  local dir = 0

  if love.keyboard.isDown(self.controls.left) then
    dir = -1
  elseif love.keyboard.isDown(self.controls.right) then
    dir = 1
  else
    dir = self.lastWalk or 1
  end

  if dir ~= 0 then
    self.body:applyLinearImpulse(dir * self.dashForce, -self.dashForce)
    self.canDash = false

    -- recarrega dash depois do cooldown
    Timer.after(self.dashCooldown, function()
      self.canDash = true
    end)
  end
end

function Player:reset()
  self.touches = 0
  self.triggerTouch = {active = false, position = {}}
  self.body:setPosition(self.startX, self.startY)
  self.body:setLinearVelocity(0, 0)
  self.body:setAwake(true)
end

function Player:new(world, x, y, controls, opts)
  opts = opts or {}

  self.w = opts.w or 100
  self.h = opts.h or 100
  self.startX = x
  self.startY = y

  self.speed = opts.speed or 300
  self.jumpForce = opts.jumpForce or -5000
  self.dashForce = opts.dashForce or 5000
  -- self.isGrounded = true
  self.canDash = true
  self.dashCooldown = 2
  self.lastWalk = nil

  self.controls = controls or { left = "a", right = "d", jump = "w" }
  self.score = 0
  self.touches = 0
  self.triggerTouch = {active = false, position = {}}

  self.body = love.physics.newBody(world, x, y, "dynamic")
  self.body:setFixedRotation(true)
  self.shape = love.physics.newRectangleShape(self.w, self.h)
  self.fixture = love.physics.newFixture(self.body, self.shape)
  self.fixture:setUserData(self)
  -- self.body:setLinearDamping(0.5)

  self.footShape = love.physics.newEdgeShape(-self.w/3, self.h/2 + 2, self.w/3, self.h/2 + 2)
  self.footSensor = love.physics.newFixture(self.body, self.footShape)
  self.footSensor:setSensor(true)
  self.footSensor:setUserData("footSensor")
end

function Player:update(dt)
  self:move(dt)

  Timer.update(dt)
end

function Player:move(dt)
  if not self.canDash then return end

  local dx, dy = self.body:getLinearVelocity()
  dx = 0

  if love.keyboard.isDown(self.controls.left) then
    dx = -self.speed
    self.lastWalk = -1
  elseif love.keyboard.isDown(self.controls.right) then
    dx = self.speed
    self.lastWalk = 1
  end

  self.body:setLinearVelocity(dx, dy)
end

function Player:draw()
  local x, y = self.body:getPosition()
  love.graphics.rectangle("fill", x - self.w / 2, y - self.h / 2, self.w, self.h)
  love.graphics.setColor(1, 0, 0)
  love.graphics.line(self.body:getWorldPoints(self.footShape:getPoints()))
  love.graphics.setColor(1, 1, 1)

  if self.triggerTouch.active then
    love.graphics.setFont(fontSmaller)

    local text = self.triggerTouch.savedTouch .. getOrdinal(self.triggerTouch.savedTouch) .. " touch"
    love.graphics.print(
      text,
      self.triggerTouch.position.x - fontSmaller:getWidth(text)/2,
      self.triggerTouch.position.y - fontSmaller:getHeight()/2 - 50
    )

    Timer.after(2, function() self.triggerTouch.active = false end)
  end
end

function getOrdinal(num)
  if num == 1 then return "st"
  elseif num == 2 then return "nd"
  elseif num == 3 then return "rd"
  else return "th"
  end
end

function Player:beginContact(a, b, coll)
  local _, ny = coll:getNormal()

  message = ny

  if a == self.footSensor then 
    if ny > 0 then
      self.isGrounded = true
    end
  elseif b == self.footSensor then
    if ny < 0 then
      self.isGrounded = true
    end
  end 
end

return Player