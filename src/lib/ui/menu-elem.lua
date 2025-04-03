
local printf = require('util.printf')
local obj = require('util.obj')
local EventRegistry = require('lib.ui.event-registry')

---@alias ezd.ui.MenuElem.justifyOpts "start"|"end"|"center"
---@alias ezd.ui.MenuElem.alignOpts "start"|"end"|"center"

---@class ezd.ui.MenuElemOpts
---@field x? number
---@field y? number
---@field w? number
---@field h? number
---@field pad? number
---@field padLeft? number
---@field padRight? number
---@field padTop? number
---@field padBottom? number
---@field justify? ezd.ui.MenuElem.justifyOpts horizontal justify content
---@field align? ezd.ui.MenuElem.alignOpts vertical align content
--[[ 
  Base class for menu and menu related elements
]]
---@type ezd.ui.MenuButtonOpts
local menu_elem_opts_defaults = {
  x = 0,
  y = 0,
  w = 5,
  h = 5,
  pad = 1,
  justify = "start",
  align = "start",
}
local MenuElem = (function ()
  ---@class ezd.ui.MenuElem
  ---@field x number
  ---@field y number
  ---@field w number
  ---@field h number
  ---@field justify ezd.ui.MenuElem.justifyOpts horizontal justify content
  ---@field align ezd.ui.MenuElem.alignOpts vertical align content
  ---@field pad number
  ---@field _padLeft number|nil
  ---@field _padRight number|nil
  ---@field _padTop number|nil
  ---@field _padBottom number|nil
  ---@field _mousemovedReg ezd.ui.EventRegistry
  local MenuElem = {}
  MenuElem.__index = MenuElem

  ---@param opts ezd.ui.MenuElemOpts
  function MenuElem.new(opts)
    local self = setmetatable({}, MenuElem)
    opts = obj.assign({}, menu_elem_opts_defaults, opts)
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
    return self
  end

  function MenuElem:width()
    return self.w + self:padLeft() + self:padRight()
  end
  function MenuElem:height()
    return self.h + self:padTop() + self:padBottom()
  end
  function MenuElem:right()
    return self.x + self:width()
  end
  function MenuElem:bottom()
    return self.y + self:height()
  end
  ---comment
  ---@param tx number
  ---@param ty number
  ---@return boolean
  function MenuElem:checkBoundingRect(tx, ty)
    return (
      tx >= self.x
      and tx <= self:right()
      and ty >= self.y
      and ty <= self:bottom()
    )
  end

  function MenuElem:padRight()
    return self._padRight or self.pad
  end
  function MenuElem:padLeft()
    return self._padLeft or self.pad
  end
  function MenuElem:padTop()
    return self._padTop or self.pad
  end
  function MenuElem:padBottom()
    return self._padBottom or self.pad
  end

  ---returns function that removes listener when called 
  ---@param fn love.mousemoved
  ---@return fun()
  function MenuElem:onMousemoved(fn)
    return self._mousemovedReg:register(fn)
  end
  ---@type love.mousepressed
  function MenuElem:mousepressed(...)
    
  end
  ---@type love.mousereleased
  function MenuElem:mousereleased(...)

  end
  function MenuElem:mousemoved(mx, my, dy, dx, istouch)
    if self:checkBoundingRect(mx, my) then
      self._mousemovedReg:fire(mx, my, dy, dx, istouch)
    end
  end

  --[[ super | interfaces | overrides ]]
  ---@type fun(self): ezd.geom.Rect|nil
  function MenuElem:clientRect()end
  function MenuElem:layout()end
  function MenuElem:render()end

  return MenuElem
end)()

return MenuElem
