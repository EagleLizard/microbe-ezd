
--[[ 
  This module is the central ui driver/manager
]]

local UiCtrl = (function ()
  ---@class ezd.ui.UiCtrl
  ---@field _rootEl ezd.ui.UiElem
  ---@field _elems ezd.ui.UiElem[]
  local UiCtrl = {}
  UiCtrl.__index = UiCtrl

  function UiCtrl.new()
    local self = setmetatable({}, UiCtrl)
    self._elems = {}
    return self
  end

  ---@param el ezd.ui.UiElem
  function UiCtrl:addEl(el)
    table.insert(self._elems, el)
  end

  ---@param evt ezd.ui.ClickEvent
  function UiCtrl:mousepressed(evt)
    for _, el in ipairs(self._elems) do
      el:mousepressed(evt)
    end
  end
  ---@param evt ezd.ui.ClickEvent
  function UiCtrl:mousereleased(evt)
    for _, el in ipairs(self._elems) do
      el:mousereleased(evt)
    end
  end
  ---@param evt ezd.ui.MousemoveEvent
  function UiCtrl:mousemoved(evt)
    for _, el in ipairs(self._elems) do
      el:mousemoved(evt)
    end
  end

  function UiCtrl:draw()
    for _, el in ipairs(self._elems) do
      el:layout()
      el:render()
    end
  end

  return UiCtrl
end)()

return UiCtrl
