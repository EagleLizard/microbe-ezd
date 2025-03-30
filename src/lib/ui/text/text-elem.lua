
local printf = require "util.printf"

local UiElem = require "lib.ui.ui-elem"

---@class ezd.ui.TextElemOpts: ezd.ui.UiElemOpts
---@field innerText? string
---@field font? love.Font

local TextElem = (function ()
  ---@class ezd.ui.TextElem: ezd.ui.UiElem
  ---@field innerText string
  ---@field font love.Font
  ---@field loveText? love.Text
  local TextElem = {}
  TextElem.__index = TextElem
  setmetatable(TextElem, { __index = UiElem })

  local default_font = love.graphics.getFont()

  ---@param opts? ezd.ui.TextElemOpts
  function TextElem.new(opts)
    local self = setmetatable(UiElem.new(opts), TextElem)
    opts = opts or {}
    self._type = "ezd.ui.TextElem"
    self.innerText = opts.innerText or ""
    self.font = opts.font or default_font
    return self
  end
  function TextElem:layout()
    --[[ call super.layout ]]
    UiElem.layout(self)
    --[[ create text obj and calculate w/h ]]
    local loveText = love.graphics.newText(self.font, self.innerText)
    local w = loveText:getWidth()
    local h = loveText:getHeight()
    self.loveText = loveText
    self.w = w
    self.h = h
    -- printf("%s\n", self.loveText)
  end
  function TextElem:render(opts)
    -- printf("%s\n", self.loveText)
    if self.loveText ~= nil then
      love.graphics.draw(self.loveText, self.x, self.y)
    end
    --[[ call super.render ]]
    UiElem.render(self, opts)
  end
  return TextElem
end)()

return TextElem
