
local printf = require "util.printf"

local UiElem = require "lib.ui.ui-elem"

local BoxElem = (function ()
  ---@class ezd.ui.BoxElem: ezd.ui.UiElem
  local BoxElem = {}
  BoxElem.__index = BoxElem
  setmetatable(BoxElem, { __index = UiElem })

  function BoxElem.new(opts)
    local self = setmetatable(UiElem.new(opts), BoxElem)
    opts = opts or {}
    self._type = "ezd.ui.BoxElem"
    return self
  end

  function BoxElem:layout()
    --[[ call super ]]
    UiElem.layout(self)
  end
  function BoxElem:render()
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
    UiElem.render(self)
  end

  return BoxElem
end)()

return BoxElem
