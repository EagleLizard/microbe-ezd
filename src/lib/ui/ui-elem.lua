
local printf = require "util.printf"

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

  --[[ overrides ]]
  function UiElem:layout()
    local x = self.x
    local y = self.y
    local innerX = 0
    local innerY = 0
    local function overflowX(childHeight)
      innerX = 0
      innerY = innerY + childHeight
    end
    for _, el in ipairs(self.children) do
      --[[ update child positions ]]
      el:layout()
      local ex = x + innerX
      local ey = y + innerY
      local er = el:right(ex)
      if er > self:right() then
        --[[ x overflow; reflow ]]
        local nw = er - self.x
        if nw > self.maxWidth then
          --[[ reflow ]]
          overflowX(el:height())
          ex = x + innerX
          ey = y + innerY
        else
          --[[ grow horiz. ]]
          self.w = nw
        end
      end
      el.x = ex
      el.y = ey
      innerX = innerX + el:width()
      if innerX > self:width() then
        overflowX(el:height())
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
