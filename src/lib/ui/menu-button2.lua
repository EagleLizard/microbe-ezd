
local printf = require('util.printf')

local obj = require('util.obj')
local StyleService = require('lib.service.style-service')
local Point = require('lib.geom.point')
local style = require('lib.ui.style')
local UiElem = require('lib.ui.ui-elem')

local menu_button_opts_defaults = {}

---@class ezd.ui.MenuButton2Opts: ezd.ui.UiElemOpts
---@field label? string
---@field font? love.Font

local MenuButton2 = (function ()
  ---@class ezd.ui.MenuButton2: ezd.ui.UiElem
  ---@field label string|nil
  ---@field font love.Font
  ---@field innerText love.Text|nil
  ---@field innerTextPos ezd.geom.Point|nil
  ---@field _boundRect? ezd.geom.Rect
  local MenuButton2 = {}
  MenuButton2.__index = MenuButton2
  setmetatable(MenuButton2, { __index = UiElem })

  ---@param opts? ezd.ui.MenuButton2Opts
  function MenuButton2.new(opts)
    opts = opts or {}
    local self = setmetatable(UiElem.new(opts), MenuButton2)
    self.label = opts.label or nil
    self.font = opts.font or StyleService.getDefaultFont()

    self:onMouseentered(function ()
      printf("MenuButton2 '%s' enter\n", self.label)
    end)
    self:onMouseexited(function ()
      printf("MenuButton2 '%s' exit\n", self.label)
    end)
    self:onMouseclicked(function (evt)
      printf("MenuButton2 '%s' mouseclicked\n", self.label)
    end)
    return self
  end

  function MenuButton2:width()
    return self.w + self:padLeft() + self:padRight()
  end
  function MenuButton2:height()
    return self.h + self:padTop() + self:padBottom()
  end
  function MenuButton2:right()
    return self.x + self:width()
  end
  function MenuButton2:bottom()
    return self.y + self:height()
  end

  ---comment
  ---@param tx number
  ---@param ty number
  ---@return boolean
  function MenuButton2:checkBoundingRect(tx, ty)
    return (
      tx >= self.x
      and tx <= self:right()
      and ty >= self.y
      and ty <= self:bottom()
    )
  end

  function MenuButton2:layout()
    if self.label == nil then
      return
    end
    local x = self.x + self:padLeft()
    local y = self.y + self:padTop()
    local w = self.w
    local h = self.h
    local innerText = self.innerText
    if innerText == nil then
      innerText = love.graphics.newText(self.font, self.label)
      self.innerText = innerText
    end

    local tx, ty
    -- ty = y
    if self.align == "start" then
      ty = y
    elseif self.align == "end" then
      ty = (y + h) - innerText:getHeight()
    elseif self.align == "center" then
      ty = (y + math.floor(h/2)) - math.floor(innerText:getHeight()/2)
    end
    -- tx = x
    if self.justify == "start" then
      tx = x
    elseif self.justify == "end" then
      tx = (x + w) - innerText:getWidth()
    elseif self.justify == "center" then
      tx = (x + math.floor(w/2)) - math.floor(innerText:getWidth()/2)
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
    -- self.w = self.innerText:getWidth()
    self.w = math.max(self.w, self.innerText:getWidth())
    self.h = math.max(self.h, self.innerText:getHeight())
  end

  function MenuButton2:render()
    local x = self.x
    local y = self.y
    local w = self:width()
    local h = self:height()
    if self._eventState.mouseIn then
      love.graphics.setColor(love.math.colorFromBytes(127, 255, 0))
    else
      love.graphics.setColor(1, 1, 1)
    end 
    local xOffset = 0
    local yOffset = 0
    if self._eventState.mouseDown then
      xOffset = -2
      yOffset = 2
    end
    love.graphics.rectangle("line", x + xOffset, y + yOffset, w, h)
    if self.innerText == nil or self.innerTextPos == nil then
      return
    end
    local tx = self.innerTextPos.x
    local ty = self.innerTextPos.y
    love.graphics.draw(self.innerText, tx + xOffset, ty + yOffset)
  end

  return MenuButton2
end)()

local menuButton2Module = {
  MenuButton2 = MenuButton2,
  menu_button_opts_defaults = menu_button_opts_defaults,
}

return menuButton2Module
