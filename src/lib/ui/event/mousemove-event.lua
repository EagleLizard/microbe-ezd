
local MouseEvent = require('lib.ui.event.mouse-event')

--[[ 
mousemoved
]]

local MousemoveEvent = (function ()
  ---@class ezd.ui.MousemoveEvent: ezd.ui.MouseEvent
  ---@field dx number
  ---@field dy number
  ---@field istouch boolean
  local MousemoveEvent = {}
  MousemoveEvent.__index = MousemoveEvent
  setmetatable(MousemoveEvent, { __index = MouseEvent })

  ---@param x number
  ---@param y number
  ---@param dx number
  ---@param dy number
  ---@param istouch boolean
  function MousemoveEvent.new(x, y, dx, dy, istouch)
    local self = setmetatable(MouseEvent.new(x, y), MousemoveEvent)
    self.dx = dx
    self.dy = dy
    self.istouch = istouch
    return self
  end

  return MousemoveEvent
end)()

return MousemoveEvent
