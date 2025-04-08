
local MouseEvent = (function ()
  ---@class ezd.ui.MouseEvent
  ---@field id integer
  ---@field x number
  ---@field y number
  local MouseEvent = {}
  MouseEvent.__index = MouseEvent
  local eventIdCounter = 0
  local function getEventId()
    local id = eventIdCounter
    eventIdCounter = eventIdCounter + 1
    return id
  end
  function MouseEvent.new(x, y)
    local self = setmetatable({}, MouseEvent)
    self.id = getEventId()
    self.x = x
    self.y = y
    return self
  end
  return MouseEvent
end)()

return MouseEvent
