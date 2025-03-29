
local printf = require "util.printf"

local UiElem = require "lib.ui.ui-elem"
local TextElem = require "lib.ui.text.text-elem"

---@class ezd.ui.ButtonOpts: ezd.ui.UiElemOpts
---@field text? string

local Button = (function ()
  ---@class ezd.ui.Button: ezd.ui.UiElem
  ---@field label? string
  local Button = {}
  Button.__index = Button
  setmetatable(Button, { __index = UiElem })

  local font = love.graphics.getFont()

  ---@param opts? ezd.ui.ButtonOpts
  function Button.new(opts)
    local self = setmetatable(UiElem.new(opts), Button)
    opts = opts or {}
    self.minWidth = opts.minWidth or 30
    self.minHeight = opts.minHeight or 30
    self.label = opts.text
    self:addChild(TextElem.new({ innerText = self.label }))
    return self
  end

  function Button:layout()
    --[[ call super.layout ]]
    UiElem.layout(self)

    for _, child in ipairs(self.children) do
      child.x = self.x + 5
      child.y = self.y + 5
    end
  end
  function Button:render(opts)
    local x = self.x
    local y = self.y
    local w = self:width()
    local h = self:height()
    love.graphics.rectangle("line", x, y, w, h)
    
    --[[ call super.render ]]
    UiElem.render(self, opts)
  end
  return Button
end)()

return Button