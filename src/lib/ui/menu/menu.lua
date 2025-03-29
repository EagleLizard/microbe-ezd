
local printf = require "util.printf"

local UiElem = require "lib.ui.ui-elem"
local Button = require "lib.ui.button.button"

local Menu = (function ()
  ---@class ezd.ui.Menu: ezd.ui.UiElem
  local Menu = {}
  Menu.__index = Menu
  setmetatable(Menu, { __index = UiElem })
  ---comment
  ---@param opts ezd.ui.UiElemOpts
  function Menu.new(opts)
    local self = setmetatable(UiElem.new(opts), Menu)
    -- self.minHeight = opts.minHeight or 100
    -- self.minWidth = opts.minWidth or 200
    self.maxWidth = opts.maxWidth or 200
    local btns = {
      "a",
      "b",
      "c",
      "d",
      "e",
      "f",
      "g",
      "h",
      "i",
    }
    for _, btnLabel in ipairs(btns) do
      local nBtn = Button.new({ text = btnLabel })
      self:addChild(nBtn)
    end
    return self --[[@as ezd.ui.Menu]]
  end
  function Menu:render(opts)
    --[[
      where should origin go? center?
      is origin derived from with/height? Or explicit?  
    ]]
    -- local origin = Point.new(self.x, self.y)
    local x = self.x
    local y = self.y
    local w = self:width()
    local h = self:height()
    love.graphics.rectangle("line", x, y, w, h)
    --[[ update child positions ]]
    self:layout()
    --[[ call super.render ]]
    UiElem.render(self, opts)
  end
  function Menu:layout()
    --[[ call super.layout ]]
    UiElem.layout(self)

    local x = self.x
    local y = self.y
    --[[ update child positions ]]
    local innerX = 0
    local innerY = 0
    for _, child in ipairs(self.children) do
      local function overflowX(childHeight)
        innerX = 0
        innerY = innerY + childHeight
      end
      local cx = x + innerX
      local cy = y + innerY
      local cr = child:right(cx)
      if cr > self:right() then
        --[[ x overflow; reflow ]]
        local nw = cr - self.x
        if nw > self.maxWidth then
          --[[ reflow ]]
          overflowX(child:height())
          cx = x + innerX
          cy = y + innerY
        else
          self.w = nw
        end
      end
      child.x = cx
      child.y = cy
      innerX = innerX + child:width()
      if innerX > self:width() then
        overflowX(child:height())
      end
      -- printf("reflow: %s\n", reflow)
    end
  end
  return Menu
end)()

local menuModule = {
  Menu = Menu,
}

return menuModule
