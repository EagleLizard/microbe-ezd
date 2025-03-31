
local printf = require "util.printf"

local UiElem = require "lib.ui.ui-elem"
local Button = require "lib.ui.button.button"

local Menu = (function ()
  ---@class ezd.ui.Menu: ezd.ui.UiElem
  ---@field btnClickedOffFns fun()[]
  ---@field clickedBtn ezd.ui.Button
  local Menu = {}
  Menu.__index = Menu
  setmetatable(Menu, { __index = UiElem })
  ---comment
  ---@param opts ezd.ui.UiElemOpts
  function Menu.new(opts)
    local self = setmetatable(UiElem.new(opts), Menu)
    self._type = "ezd.ui.Menu"
    self.maxWidth = opts.maxWidth or 200
    self.btnClickedOffFns = {}
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
      "j",
      "k",
      "l",
      "m",
      "n",
      "o",
      "p",
      "q",
      "r",
      "s",
      "t",
      "u",
      "v",
      "w",
      "x",
      "y",
      "z",
    }
    for _, btnLabel in ipairs(btns) do
      local nBtn = Button.new({ text = btnLabel })
      local btnClickedOffFn = nBtn:onClicked(function (e)
        self:handleBtnClick(e)
      end)
      table.insert(self.btnClickedOffFns, btnClickedOffFn)
      self:addChild(nBtn)
    end
    return self --[[@as ezd.ui.Menu]]
  end

  --[[ event handling ]]
  function Menu:handleBtnClick(e)
    self.clickedBtn = e.el
    printf("clicked: %s\n", e.el.label)
  end

  function Menu:render(opts)
    --[[
      where should origin go? center?
      is origin derived from with/height? Or explicit?  
    ]]
    local x = self.x
    local y = self.y
    local w = self:width()
    local h = self:height()
    love.graphics.rectangle("line", x, y, w, h)
    if self.clickedBtn ~= nil then
      local clickedBtnTxt = string.format("clicked button: %s", self.clickedBtn.label)
      love.graphics.printf(clickedBtnTxt, x, self:bottom() + 10, w)
    end
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
