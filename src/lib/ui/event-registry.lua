
local EventRegistry = (function ()
  ---@class ezd.ui.EventRegistry
  ---@field fnMap { [integer]: function }
  local EventRegistry = {}
  EventRegistry.__index = EventRegistry

  local eventFnIdCounter = 0
  local function getEventFnId()
    local id = eventFnIdCounter
    eventFnIdCounter = eventFnIdCounter + 1
    return id
  end

  function EventRegistry.new()
    local self = setmetatable({}, EventRegistry)
    self.fnMap = {}
    return self
  end

  ---@param fn function
  ---@return function
  function EventRegistry:register(fn)
    local fnId = getEventFnId()
    self.fnMap[fnId] = fn
    return function()
      table.remove(self.fnMap, fnId)
    end
  end

  function EventRegistry:fire(...)
    for _, fn in pairs(self.fnMap) do
      fn(...)
    end
  end

  return EventRegistry
end)()

return EventRegistry