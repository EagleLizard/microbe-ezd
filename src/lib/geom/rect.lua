
local Rect = (function ()
  ---@class ezd.geom.Rect
  ---@field x number
  ---@field y number
  ---@field w number
  ---@field h number
  local Rect = {}
  Rect.__index = Rect

  function Rect.new(x, y, w, h)
    local self = setmetatable({}, Rect)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    return self
  end

  function Rect:checkInBounds(x, y)
    return (
      x >= self.x
      and x <= self.x + self.w
      and y >= self.y
      and y <= self.y + self.h
    )
  end

  return Rect
end)()

return Rect
