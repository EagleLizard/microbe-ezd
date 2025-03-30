
local printf = require "util.printf"
local Point = require "lib.geom.point"

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

local UiElem = (function ()
  ---@class ezd.ui.UiElem
  ---@field children ezd.ui.UiElem[]
  ---@field id integer
  ---@field x number
  ---@field y number
  ---@field w number
  ---@field h number
  ---@field minWidth number
  ---@field minHeight number
  ---@field maxWidth number
  ---@field maxHeight number
  local UiElem = {}
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
    self.id = getElemId()
    self.x = opts.x or 0
    self.y = opts.y or 0
    self.w = opts.w or 0
    self.h = opts.h or 0
    self.minWidth = opts.minWidth or -1
    self.minHeight = opts.minHeight or -1
    self.maxWidth = opts.maxWidth or math.huge
    self.maxHeight = opts.maxHeight or math.huge
    self.children = {}
    return self
  end

  ---comment
  ---@param uiElem ezd.ui.UiElem
  function UiElem:addChild(uiElem)
    --
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
  --[[ overrides ]]
  function UiElem:layout()
    ---@param sfIdx integer
    ---@param nextEl ezd.ui.UiElem
    local function getNextChildPos(sfIdx, nextEl)
      --[[
        find the next empty x and y pos out of only
          the childEls that have already been laid-out
      ]]
      local nx = self.x
      local ny = self.y
      local maxY = self.y
      local maxX = self.x
      local maxR = self.x
      local maxB = self.y
      for i=1, sfIdx-1 do
        local child = self.children[i]
        local cy = child.y
        local cx = child.x
        local cr = child:right()
        local cb = child:bottom()
        if cy > maxY then
          maxY = cy
          maxX = self.x
          maxR = self.x
          maxB = self.y
        end
        if cx > maxX then
          maxX = cx
        end
        if cr > maxR then
          maxR = cr
        end
        if cb > maxB then
          maxB = cb
        end
        
      end
      if maxR - self.x < self.maxWidth then
        --[[ can grow ]]
        nx = maxR
        ny = maxY
      else
        nx = self.x
        ny = maxB
      end
      local nPt = Point.new(nx, ny)
      return nPt
    end
    for i, el in ipairs(self.children) do
      el:layout()
      local nPos = getNextChildPos(i, el)
      el.x = nPos.x
      el.y = nPos.y
      local er = el:right()
      local eb = el:bottom()
      local nw = er - self.x
      local nh = eb - self.y
      if nw > self.w then
        --[[ grow horiz. ]]
        self.w = nw
      end
      if nh > self.h then
        --[[ grow vert. ]]
        self.h = nh
      end
    end
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
