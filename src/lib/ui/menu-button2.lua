
local obj = require('util.obj')
local StyleService = require('lib.service.style-service')
local Point = require('lib.geom.point')
local MenuElem = require('lib.ui.menu-elem')

local menu_button_opts_defaults = {}

---@class ezd.ui.MenuButton2Opts: ezd.ui.MenuElemOpts
---@field label? string
---@field font? love.Font

local MenuButton2 = (function ()
  ---@class ezd.ui.MenuButton2: ezd.ui.MenuElem
  ---@field label string|nil
  ---@field font love.Font
  ---@field innerText love.Text|nil
  ---@field innerTextPos ezd.geom.Point|nil
  local MenuButton2 = {}
  MenuButton2.__index = MenuButton2
  setmetatable(MenuButton2, { __index = MenuElem })

  ---@param opts? ezd.ui.MenuButton2Opts
  function MenuButton2.new(opts)
    opts = opts or {}
    local self = setmetatable(MenuElem.new(opts), MenuButton2)
    self.label = opts.label or nil
    self.font = opts.font or StyleService.getDefaultFont()
    return self
  end

  function MenuButton2:width()
    return self.w + self:padLeft() + self:padRight()
  end
  function MenuButton2:height()
    return self.h + self:padTop() + self:padBottom()
  end
  function MenuButton2:bottom()
    return self.y + self:height()
  end

  function MenuButton2:layout()
    if self.label == nil then
      return
    end
    local x = self.x + self:padLeft()
    local y = self.y + self:padTop()
    local innerText = self.innerText
    if innerText == nil then
      innerText = love.graphics.newText(self.font, self.label)
      self.innerText = innerText
    end

    local tx, ty
    if self.align == "start" then
      ty = y
    elseif self.align == "end" then
      ty = (y + self:height()) - innerText:getHeight()
    elseif self.align == "center" then
      ty = (y + math.floor(self:height()/2)) - math.floor(innerText:getHeight()/2)
    end    
    if self.justify == "start" then
      tx = x
    elseif self.justify == "end" then
      tx = (x + self:width()) - innerText:getWidth()
    elseif self.justify == "center" then
      tx = (x + math.floor(self:width()/2)) - math.floor(innerText:getWidth()/2)
    end
    local tPos = self.innerTextPos
    if tPos == nil then
      tPos = Point.new(tx, ty)
      self.innerTextPos = tPos
    end

    --[[
      The width/height is similar to clientWidth/clientHeight in html DOM elems.
        In this case it would be either the current width/height val, or the
        width/height of the inner content, whichever is larger
    ]]
    self.w = math.max(self.w, self.innerText:getWidth())
    self.h = math.max(self.h, self.innerText:getHeight())
  end

  function MenuButton2:render()
    local w = self:width()
    local h = self:height()
    love.graphics.rectangle("line", self.x, self.y, w, h)
    if self.innerText == nil or self.innerTextPos == nil then
      return
    end
    love.graphics.draw(self.innerText, self.innerTextPos.x, self.innerTextPos.y)
  end

  return MenuButton2
end)()

local menuButton2Module = {
  MenuButton2 = MenuButton2,
  menu_button_opts_defaults = menu_button_opts_defaults,
}

return menuButton2Module
