
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
  return Menu
end)()

local menuModule = {
  Menu = Menu,
}

return menuModule
