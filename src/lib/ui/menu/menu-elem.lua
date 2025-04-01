
local printf = require "util.printf"
local obj = require("util.obj")

local UiElem = require "lib.ui.ui-elem"
local BoxElem = require "lib.ui.container.box-elem"
local TextElem = require "lib.ui.text.text-elem"
local Button = require "lib.ui.button.button"

local test_btn_labels = {
  "a",
  "b",
  "c",
  "d",
  "e",
  "f",
  "g",
  -- "h",
  -- "i",
  -- "j",
  -- "k",
  -- "l",
  -- "m",
  -- "n",
  -- "o",
  -- "p",
  -- "q",
  -- "r",
  -- "s",
  -- "t",
  -- "u",
  -- "v",
  -- "w",
  -- "x",
  -- "y",
  -- "z",
}

local function makeToolbar()
  local toolbarBox = BoxElem.new({ pad = 5 })
  local titleText = TextElem.new({ innerText = "menu" })
  local actionsText = TextElem.new({ innerText = "actions" })
  local actionsBox = BoxElem.new()
  local testBtnsBox = BoxElem.new()
  for _, testBtnLabel in ipairs(test_btn_labels) do
    local btnEl = Button.new({ text = testBtnLabel })
    testBtnsBox:addChild(btnEl)
  end

  actionsBox:addChild(actionsText)
  toolbarBox:addChild(titleText)
  toolbarBox:addChild(actionsBox)
  toolbarBox:addChild(testBtnsBox)

  return toolbarBox
end

local MenuElem = (function ()
  ---@class ezd.ui.MenuElem: ezd.ui.UiElem
  local MenuElem =  {}
  MenuElem.__index = MenuElem
  setmetatable(MenuElem, { __index = UiElem })

  function MenuElem.new(opts)
    opts = opts or {}
    local self = setmetatable(UiElem.new(opts), MenuElem)
    self._type = "ezd.ui.MenuElem"
    -- self.maxWidth = 200
    self.maxWidth = 400
    self:addChild(makeToolbar())
    return self
  end

  function MenuElem:layout()
    -- UiElem.layout
  end

  function MenuElem:render()
    UiElem.layout(self)
    -- love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
    UiElem.render(self)
  end

  return MenuElem
end)()

return MenuElem
