
local MouseEvent = require('lib.ui.event.mouse-event')

--[[ 
  mousepressed & mousereleased
]]

local ClickEvent = (function ()
  ---@class ezd.ui.ClickEvent: ezd.ui.MouseEvent
  ---@field button number
  ---@field istouch boolean
  ---@field presses number
  local ClickEvent = {}
  ClickEvent.__index = ClickEvent
  setmetatable(ClickEvent, { __index = MouseEvent })
  ---@param x number
  ---@param y number
  ---@param button number
  ---@param istouch boolean
  ---@param presses number
  function ClickEvent.new(x, y, button, istouch, presses)
    local self = setmetatable(MouseEvent.new(x,  y), ClickEvent)
    self.button = button
    self.istouch = istouch
    self.presses = presses
    return self
  end

  return ClickEvent
end)()

return ClickEvent
