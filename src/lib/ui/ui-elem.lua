
local obj = require('util.obj')
local EventRegistry = require('lib.ui.event.event-registry')

--[[ 
Generalized ui-element
  DOM-like
  
]]
---@alias ezd.ui.UiElem.justifyOpts "start"|"end"|"center"
---@alias ezd.ui.UiElem.alignOpts "start"|"end"|"center"

---@class ezd.ui.UiElemOpts
---@field x? number
---@field y? number
---@field w? number
---@field h? number
---@field align? ezd.ui.UiElem.alignOpts vertical align content
---@field justify? ezd.ui.UiElem.justifyOpts horizontal justify content
---@field pad? number

---@type ezd.ui.UiElemOpts
local ui_elem_opts_defaults = {
  x = 0,
  y = 0,
  w = 5,
  h = 5,
  pad = 1,
  justify = "start",
  align = "start",
}

---@class ezd.ui.UiElem.EventState
---@field mouseIn boolean
---@field mouseDown boolean

local UiElem = (function ()
  ---@class ezd.ui.UiElem
  ---@field x number
  ---@field y number
  ---@field w number
  ---@field h number
  ---@field justify ezd.ui.UiElem.justifyOpts
  ---@field align ezd.ui.UiElem.alignOpts
  ---@field pad number
  ---@field _padLeft number|nil
  ---@field _padRight number|nil
  ---@field _padTop number|nil
  ---@field _padBottom number|nil
  ---@field _mousemovedReg ezd.ui.EventRegistry
  ---@field _mouseenteredReg ezd.ui.EventRegistry
  ---@field _mouseexitedReg ezd.ui.EventRegistry
  ---@field _mousepressedReg ezd.ui.EventRegistry
  ---@field _mousereleasedReg ezd.ui.EventRegistry
  ---@field _clickedReg ezd.ui.EventRegistry
  ---@field _eventState ezd.ui.UiElem.EventState
  local UiElem = {}
  UiElem.__index = UiElem

  function UiElem.new(opts)
    local self = setmetatable({}, UiElem)
    opts = obj.assign({}, ui_elem_opts_defaults, opts)
    self.x = opts.x
    self.y = opts.y
    self.w = opts.w
    self.h = opts.h
    self.justify = opts.justify
    self.align = opts.align
    self.pad = opts.pad
    self._padLeft = opts.padLeft or nil
    self._padRight = opts.padRight or nil
    self._padTop = opts.padTop or nil
    self._padBottom = opts.padBottom or nil
    self._mousemovedReg = EventRegistry.new()
    self._mouseenteredReg = EventRegistry.new()
    self._mouseexitedReg = EventRegistry.new()
    self._mousepressedReg = EventRegistry.new()
    self._mousereleasedReg = EventRegistry.new()
    self._clickedReg = EventRegistry.new()
    self._eventState = {
      mouseIn = false,
      mouseDown = false,
    }
    return self
  end

  --[[ Layout ]]

  function UiElem:width()
    return self.w + self:padLeft() + self:padRight()
  end
  function UiElem:height()
    return self.h + self:padTop() + self:padBottom()
  end
  function UiElem:right()
    return self.x + self:width()
  end
  function UiElem:bottom()
    return self.y + self:height()
  end
  ---@param tx number
  ---@param ty number
  function UiElem:checkBoundingRect(tx, ty)
    return (
      tx >= self.x
      and tx <= self:right()
      and ty >= self.y
      and ty <= self:bottom()
    )
  end
  function UiElem:padRight()
    return self._padRight or self.pad
  end
  function UiElem:padLeft()
    return self._padLeft or self.pad
  end
  function UiElem:padTop()
    return self._padTop or self.pad
  end
  function UiElem:padBottom()
    return self._padBottom or self.pad
  end
  
  --[[ Events ]]

  function UiElem:onMouseentered(fn)
    return self._mouseenteredReg:register(fn)
  end
  function UiElem:onMouseexited(fn)
    return self._mouseexitedReg:register(fn)
  end
  ---@param fn fun(evt: ezd.ui.MousemoveEvent)
  function UiElem:onMousemoved(fn)
    return self._mousemovedReg:register(fn)
  end
  function UiElem:onMousepressed(fn)
    return self._mousepressedReg:register(fn)
  end
  function UiElem:onMousereleased(fn)
    return self._mousereleasedReg:register(fn)
  end
  ---@param fn fun(evt: ezd.ui.ClickEvent)
  ---@return fun()
  function UiElem:onMouseclicked(fn)
    return self._clickedReg:register(fn)
  end

  function UiElem:mouseexited(...)
    return self._mouseexitedReg:fire(...)
  end
  function UiElem:mouseentered(...)
    return self._mouseenteredReg:fire(...)
  end
  ---@param evt ezd.ui.ClickEvent
  function UiElem:mousepressed(evt)
    if self:checkBoundingRect(evt.x, evt.y) then
      if not self._eventState.mouseDown then
        self._eventState.mouseDown = true
        self._mousepressedReg:fire(evt)
      end
    end
  end
  ---@param evt ezd.ui.ClickEvent
  function UiElem:mousereleased(evt)
    self._mousereleasedReg:fire(evt)
    if self._eventState.mouseDown and self:checkBoundingRect(evt.x, evt.y) then
      self._clickedReg:fire(evt)
    end
    self._eventState.mouseDown = false
  end
  ---@param evt ezd.ui.MousemoveEvent
  function UiElem:mousemoved(evt)
    if self:checkBoundingRect(evt.x, evt.y) then
      self._mousemovedReg:fire(evt)
      if not self._eventState.mouseIn then
        self._eventState.mouseIn = true
        self._mouseenteredReg:fire()
      end
    else
      if self._eventState.mouseIn then
        self._eventState.mouseIn = false
        self._mouseenteredReg:fire()
      end
    end
  end

  --[[ super | interfaces | overrides ]]
  function UiElem:layout()end
  function UiElem:render()end

  return UiElem
end)()

return UiElem
