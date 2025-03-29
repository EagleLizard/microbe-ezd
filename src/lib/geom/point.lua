
local Point = (function ()
  ---@class ezd.geom.Point
  ---@field x number
  ---@field y number
  local Point = {}
  Point.__index = Point
  function Point.new(x, y)
    local self = setmetatable({}, Point)
    self.x = x
    self.y = y
    return self
  end
  return Point
end)()

return Point
