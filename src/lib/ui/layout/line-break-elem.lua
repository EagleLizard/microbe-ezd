
local errorf = require("util.errorf")
local UiElem = require("lib.ui.ui-elem")

local LineBreakElem = (function ()
  ---@class ezd.ui.LineBreakElem: ezd.ui.UiElem
  local LineBreakElem = {}
  LineBreakElem.__index = LineBreakElem
  setmetatable(LineBreakElem, { __index = UiElem })
  function LineBreakElem.new(opts)
    local self = setmetatable(UiElem.new(opts), LineBreakElem)
    self._type = "ezd.ui.LineBoxElem"
    self.pad = 0
    return self
  end
  --[[ override ]]
  function LineBreakElem:addChild()
    errorf("cannot add children to LineBreakElems")
  end
  function LineBreakElem:render()
    UiElem.render(self)
  end
  return LineBreakElem
end)()

return LineBreakElem
