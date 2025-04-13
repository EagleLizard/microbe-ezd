
local obj = require('util.obj')
local EventRegistry = require('lib.ui.event.event-registry')
local style = require('lib.ui.style')

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
---@field padLeft? number
---@field padRight? number
---@field padTop? number
---@field padBottom? number
---@field margin? number
---@field marginLeft? number
---@field marginRight? number
---@field marginTop? number
---@field marginBottom? number

---@type ezd.ui.UiElemOpts
local ui_elem_opts_defaults = {
  x = 0,
  y = 0,
  w = 5,
  h = 5,
  pad = 1,
  margin = 1,
  justify = "start",
  align = "start",
  children = {},
  parent = nil,
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
  ---@field margin number
  ---@field _marginLeft number|nil
  ---@field _marginRight number|nil
  ---@field _marginTop number|nil
  ---@field _marginBottom number|nil
  ---@field _mousemovedReg ezd.ui.EventRegistry
  ---@field _mouseenteredReg ezd.ui.EventRegistry
  ---@field _mouseexitedReg ezd.ui.EventRegistry
  ---@field _mousepressedReg ezd.ui.EventRegistry
  ---@field _mousereleasedReg ezd.ui.EventRegistry
  ---@field _clickedReg ezd.ui.EventRegistry
  ---@field _eventState ezd.ui.UiElem.EventState
  ---@field children ezd.ui.UiElem[]
  ---@field parent ezd.ui.UiElem|nil
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
    self.children = {}
    self.parent = nil

    self.pad = opts.pad
    self._padLeft = opts.padLeft or nil
    self._padRight = opts.padRight or nil
    self._padTop = opts.padTop or nil
    self._padBottom = opts.padBottom or nil
    self.margin = opts.margin
    self._marginLeft = opts.marginLeft or nil
    self._marginRight = opts.marginRight or nil
    self._marginTop = opts.marginTop or nil
    self._marginBottom = opts.marginBottom or nil

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
  --[[ pad ]]
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
  --[[ margin ]]
  function UiElem:marginRight()
    return self._marginRight or self.margin
  end
  function UiElem:marginLeft()
    return self._marginLeft or self.margin
  end
  function UiElem:marginTop()
    return self._marginTop or self.margin
  end
  function UiElem:marginBottom()
    return self._marginBottom or self.margin
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
    for _, el in ipairs(self.children) do
      el:mouseexited(...)
    end
    return self._mouseexitedReg:fire(...)
  end
  function UiElem:mouseentered(...)
    for _, el in ipairs(self.children) do
      el:mouseentered(...)
    end
    return self._mouseenteredReg:fire(...)
  end
  ---@param evt ezd.ui.ClickEvent
  function UiElem:mousepressed(evt)
    for _, el in ipairs(self.children) do
      el:mousepressed(evt)
    end
    if self:checkBoundingRect(evt.x, evt.y) then
      if not self._eventState.mouseDown then
        self._eventState.mouseDown = true
        self._mousepressedReg:fire(evt)
      end
    end
  end
  ---@param evt ezd.ui.ClickEvent
  function UiElem:mousereleased(evt)
    for _, el in ipairs(self.children) do
      el:mousereleased(evt)
    end
    self._mousereleasedReg:fire(evt)
    if self._eventState.mouseDown and self:checkBoundingRect(evt.x, evt.y) then
      self._clickedReg:fire(evt)
    end
    self._eventState.mouseDown = false
  end
  ---@param evt ezd.ui.MousemoveEvent
  function UiElem:mousemoved(evt)
    for _, el in ipairs(self.children) do
      el:mousemoved(evt)
    end
    if self:checkBoundingRect(evt.x, evt.y) then
      self._mousemovedReg:fire(evt)
      if not self._eventState.mouseIn then
        self._eventState.mouseIn = true
        self._mouseenteredReg:fire()
      end
    else
      if self._eventState.mouseIn then
        self._eventState.mouseIn = false
        self._mouseexitedReg:fire()
      end
    end
  end

  --[[ Children ]]
  ---@param el ezd.ui.UiElem
  function UiElem:setParent(el)
    if self.parent ~= nil then
      error("UiElem already has a parent")
    end
    self.parent = el
  end
  ---@param el ezd.ui.UiElem
  function UiElem:addChild(el)
    el:setParent(self)
    table.insert(self.children, el)
  end

  --[[ super | interfaces | overrides ]]

  --[[
    layout calculates the position and size of the elems
    todo:xxx: current layout does 1 elem per row & stretches
      child elems to full-width because it was ported from menu-elem
      impl., should write the layout to do block/inline-block, flex, or
      another more sensible default
  ]]
  function UiElem:layout()
    --[[
      First, layout all the children.
        position by defaults left-to-right, top-to-bottom (rows)
    ]]
    local lineX = self.x + self:padLeft() + self:marginLeft()
    local lineY = self.y + self:padTop() + self:marginTop()
    for _, childEl in ipairs(self.children) do
      local cx = lineX
      local cy = lineY
      childEl.x = cx
      childEl.y = cy
      childEl:layout()
      lineY = lineY + childEl:height() + self:marginBottom()
    end
    --[[ get the width/height of children ]]
    local exMin = math.huge
    local eyMin = math.huge
    local erMax = -math.huge
    local ebMax = -math.huge
    for _, childEl in ipairs(self.children) do
      exMin = math.min(exMin, childEl.x)
      erMax = math.max(erMax, childEl:right())
      eyMin = math.min(eyMin, childEl.y)
      ebMax = math.max(ebMax, childEl:bottom())
    end
    local contentWidth = (erMax - exMin) + self:marginLeft() + self:marginRight()
    local contentHeight = (ebMax - eyMin) + self:marginTop() + self:marginBottom()
    self.w = math.max(self.w, contentWidth)
    self.h = math.max(self.h, contentHeight)
  end
  function UiElem:render()
    for _, el in ipairs(self.children) do
      el:render()
      style.setDefault()
    end
  end

  return UiElem
end)()

return UiElem
