
local printf = require "util.printf"
local errorf = require("util.errorf")
local Point = require "lib.geom.point"
local EventRegistry = require "lib.ui.event-registry"
local Queue = require "lib.datastruct.queue"

--[[ 
going to borrow concepts from DOM/TUI apps.
- ui elems are part of a hierarchy of elements
  - a ui is a tree with a root and children
]]

---@class ezd.ui.RenderOpts
---@field x? number offset
---@field y? number offset

---@class ezd.ui.UiElemOpts
---@field x? number
---@field y? number
---@field w? number
---@field h? number
---@field minWidth? number
---@field minHeight? number
---@field maxWidth? number
---@field maxHeight? number
---@field pad? number
---@field padLeft? number
---@field padRight? number
---@field padTop? number
---@field padBottom? number

---@class ezd.ui.UiElem.EventState
---@field mousepressed boolean

local UiElem = (function ()
  ---@class ezd.ui.UiElem
  ---@field _type string
  ---@field children ezd.ui.UiElem[]
  ---@field id integer
  ---@field x number
  ---@field y number
  ---@field w number
  ---@field h number
  ---@field minWidth number
  ---@field minHeight number
  ---@field maxWidth number|nil
  ---@field maxHeight number
  ---@field parent ezd.ui.UiElem|nil
  ---@field pad number
  ---@field padLeft number
  ---@field padRight number
  ---@field padTop number
  ---@field padBottom number
  ---@field mousepressedRegistry ezd.ui.EventRegistry
  ---@field mousereleasedRegistry ezd.ui.EventRegistry
  ---@field onclickedRegistry ezd.ui.EventRegistry
  ---@field eventState ezd.ui.UiElem.EventState
  local UiElem = { _type = "ezd.ui.UiElem" }
  UiElem.__index = UiElem

  local elemIdCounter = 0
  local function getElemId()
    local id = elemIdCounter
    elemIdCounter = elemIdCounter + 1
    return id
  end
  ---comment
  ---@param opts? ezd.ui.UiElemOpts
  ---@return ezd.ui.UiElem
  function UiElem.new(opts)
    local self = setmetatable({}, UiElem)
    opts = opts or {}
    -- self._type = "ezd.ui.UiElem"
    self.id = getElemId()
    self.x = opts.x or 0
    self.y = opts.y or 0
    self.w = opts.w or 0
    self.h = opts.h or 0
    self.minWidth = opts.minWidth or -1
    self.minHeight = opts.minHeight or -1
    self.maxWidth = opts.maxWidth or nil
    self.maxHeight = opts.maxHeight or math.huge
    self.pad = opts.pad or 7
    self.padLeft = opts.padLeft or self.pad
    self.padRight = opts.padRight or self.pad
    self.padTop = opts.padRight or self.pad
    self.padBottom = opts.padBottom
    self.children = {}
    --[[ events ]]
    self.mousepressedRegistry = EventRegistry.new()
    self.mousereleasedRegistry = EventRegistry.new()
    self.onclickedRegistry = EventRegistry.new()
    self.eventState = {
      mousepressed = false,
    }
    return self
  end

  ---comment
  ---@param uiElem ezd.ui.UiElem
  function UiElem:addChild(uiElem)
    if uiElem.parent ~= nil then
      errorf("tried to add elem that already has a parent")
    end
    uiElem.parent = self
    table.insert(self.children, uiElem)
  end
  function UiElem:width()
    if self.w < self.minWidth then
      return self.minWidth
    end
    return self.w
  end
  function UiElem:height()
    if self.h < self.minHeight then
      return self.minHeight
    end
    return self.h
  end
  ---@param nx? number
  function UiElem:right(nx)
    local x = nx or self.x
    local r = x + self:width()
    return r
  end
  ---@param ny? number
  function UiElem:bottom(ny)
    local y = ny or self.y
    local b = y + self:height()
    return b
  end
  ---@param x number
  ---@param y number
  function UiElem:inBoundingRect(x, y)
    return (
      x >= self.x
      and x <= self:right()
      and y >= self.y
      and y <= self:bottom()
    )
  end
  function UiElem:_maxWidth()
    if self.maxWidth ~= nil then
      return self.maxWidth
    end
    --[[
      If the elem doesn't have its own maxWidth, default to inheriting maxWidth
        from parent(s)
    ]]
    if self.maxWidth ~= nil then
      return self.maxWidth
    end
    local mw
    if self.parent ~= nil then
      mw = self.parent:_maxWidth()
      -- printf("%s - mw: %s\n", self.parent._type, mw)
    end
    return mw
  end
  --[[ ancestry ]]
  ---@return ezd.ui.UiElem[]
  function UiElem:getDescendants()
    local elQueue = Queue.new()
    local descEls = {}
    elQueue:push(self)
    while not elQueue:empty() do
      local el = elQueue:pop() ---@type ezd.ui.UiElem|nil
      if el ~= nil then
        for _, child in ipairs(el.children) do
          table.insert(descEls, child)
          elQueue:push(child)
        end
      end
    end
    return descEls
  end

  --[[ events ]]
  ---@param fn function
  function UiElem:onMousepressed(fn)
    return self.mousepressedRegistry:register(fn)
  end
  function UiElem:mousepress(e)
    e = e or {}
    e.el = e.el or self
    if self:inBoundingRect(e.x, e.y) then
      self.eventState.mousepressed = true
      self.mousepressedRegistry:fire(e)
    end
  end
  
  function UiElem:onMousereleased(fn)
    return self.mousereleasedRegistry:register(fn)
  end
  function UiElem:mouserelease(e)
    e = e or {}
    e.el = e.el or self
    if self.eventState.mousepressed and self:inBoundingRect(e.x, e.y) then
      self.mousereleasedRegistry:fire(e)
      self.onclickedRegistry:fire(e)
      self.eventState.mousepressed = false
    end
  end

  function UiElem:onClicked(fn)
    return self.onclickedRegistry:register(fn)
  end

  --[[ overrides ]]
  function UiElem:layout()
    local maxWidth = self:_maxWidth()
    local pad = self.pad
    -- local fc = self.children[1]
    -- local nx = ((fc and fc:right()) or self.x) + 1
    local nx = self.x
    local nr = self:right()
    local nb = self:bottom()
    local maxr = -math.huge
    local maxb = -math.huge
    local lineBoxes = {}
    -- UiElem.layout(self)

    for _, el in ipairs(self.children) do
      el:layout()
      if #lineBoxes < 1 then
        table.insert(lineBoxes, {})
      end
      local lineBox = lineBoxes[#lineBoxes]
      --[[
        Check if the width of the elements in the lineBox plus the
          current element would exceed maxWidth
      ]]
      local lineWidth = 0
      for _, lineEl in ipairs(lineBox) do
        lineWidth = lineWidth + lineEl:width()
      end
      if maxWidth ~= nil then
        --[[ check for overflow or line-breaks]]
        local nextLineWidth = el:width() + lineWidth
        if nextLineWidth > maxWidth then
          --[[
            The elem will overflow.
            By default, overflow will wrap.
          ]]
          table.insert(lineBoxes, {})
          lineBox = lineBoxes[#lineBoxes]
        end
      end
      table.insert(lineBox, el)
    end
    local lineBoxY = self.y
    local maxLineRight = -math.huge
    local maxLineBottom = -math.huge
    for i, lineBox in ipairs(lineBoxes) do
      local lineBottom = -math.huge
      local lineRight = -math.huge
      local lineWidth = -math.huge
      local lineHeight = -math.huge
      for k, lbEl in ipairs(lineBox) do
        local prevLbEl = self.children[k-1]
        local pr = ((prevLbEl and prevLbEl:right()) or (self.x))
        lbEl.x = pr
        lbEl.y = lineBoxY
        lineRight = math.max(lbEl:right(), lineRight)
        lineBottom = math.max(lbEl:bottom(), lineBottom)
        lineWidth = math.max(lbEl:width(), lineWidth)
        lineHeight = math.max(lbEl:height(), lineHeight)
      end
      lineBoxY = lineBoxY + lineHeight
      -- self.w = lineWidth - self.x + pad
      maxLineRight = math.max(lineRight, maxLineRight)
      maxLineBottom = math.max(lineBottom, maxLineBottom)
    end
    self.w = maxLineRight - self.x
    self.h = maxLineBottom - self.y
  end
  ---@param opts? ezd.ui.RenderOpts
  function UiElem:render(opts)
    for _, el in ipairs(self.children) do
      el:render(opts)
    end
  end

  return UiElem
end)()

return UiElem
