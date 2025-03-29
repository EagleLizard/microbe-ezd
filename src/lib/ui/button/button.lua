
local printf = require "util.printf"

local uiElemModule = require "lib.ui.ui-elem"
local UiElem = uiElemModule.UiElem

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
    self.minWidth = 30
    self.minHeight = 30
    self.label = opts.text
    return self
  end
  function Button:render(opts)
    local x = self.x
    local y = self.y
    local w = self:width()
    local h = self:height()
    love.graphics.rectangle("line", x, y, w, h)
    if self.label ~= nil then
      local text = love.graphics.newText(font, self.label)
      local textX = x + 5
      local textY = y + 5
      -- love.graphics.print(self.text, textX, textY)
      -- love.graphics.printf(self.label, textX, textY, w)
      love.graphics.draw(text, textX, textY)
    end
    UiElem.render(self, opts)
  end
  return Button
end)()

return Button