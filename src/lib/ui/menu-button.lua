
local Rect = require("lib.geom.rect")
local Point = require("lib.geom.point")
local StyleService = require("lib.service.style-service")

local menu_button_width = 100
local menu_button_height = 20

---@alias alignOpts "start"|"end"|"center"
---@alias justifyOpts "start"|"end"|"center"

---@class ezd.ui.MenuButtonOpts
---@field x? number
---@field y? number
---@field w? number
---@field h? number
---@field label? string
---@field font? love.Font
---@field align? alignOpts vertical align content
---@field justify? justifyOpts horizontal justify content
---@field pad? number

local MenuButton = (function ()
  ---@class ezd.ui.MenuButton
  ---@field x number
  ---@field y number
  ---@field w number
  ---@field h number
  ---@field label string|nil
  ---@field font love.Font|nil
  ---@field align alignOpts vertical align content
  ---@field justify justifyOpts horizontal justify content
  ---@field pad number
  ---@field btnRect ezd.geom.Rect
  ---@field innerText love.Text|nil
  ---@field innerTextPos ezd.geom.Point|nil
  local MenuButton = {}
  MenuButton.__index = MenuButton

  ---@param opts? ezd.ui.MenuButtonOpts
  function MenuButton.new(opts)
    local self = setmetatable({}, MenuButton)
    opts = opts or {}
    self.x = opts.x or 0
    self.y = opts.y or 0
    self.w = opts.w or menu_button_width
    self.h = opts.h or menu_button_height
    self.label = opts.label or nil
    self.align = opts.align or "center"
    self.justify = opts.justify or "center"
    self.pad = opts.pad or 1
    self.font = opts.font or StyleService.getDefaultFont()
    self.btnRect = Rect.new(self.x, self.y, self.w, self.h)
    return self
  end

  function MenuButton:height()
    return self.h
  end
  function MenuButton:width()
    return self.w
  end

  function MenuButton:layout()
    if self.label == nil then
      return
    end
    local innerText = self.innerText
    if innerText == nil then
      innerText = love.graphics.newText(self.font, self.label)
      self.innerText = innerText
    end

    local tx, ty
    if self.align == "start" then
      ty = self.y
    elseif self.align == "end" then
      ty = (self.y + self:height()) - innerText:getHeight()
    elseif self.align == "center" then
      ty = (self.y + math.floor(self:height()/2)) - math.floor(innerText:getHeight()/2)
    end    
    if self.justify == "start" then
      tx = self.x
    elseif self.justify == "end" then
      tx = (self.x + self:width()) - innerText:getWidth()
    elseif self.justify == "center" then
      tx = (self.x + math.floor(self:width()/2)) - math.floor(innerText:getWidth()/2)
    end
    local tPos = self.innerTextPos
    if tPos == nil then
      tPos = Point.new(tx, ty)
      self.innerTextPos = tPos
    end
  end

  function MenuButton:render()
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
    if self.label == nil then
      return
    end
    if self.innerText == nil or self.innerTextPos == nil then
      -- innerText = love.graphics.newText(self.font, self.label)
      return
    end
    love.graphics.draw(self.innerText, self.innerTextPos.x, self.innerTextPos.y)
  end
  return MenuButton
end)()

local menuButtonModule = {
  MenuButton = MenuButton,
  menu_button_width = menu_button_width,
  menu_button_height = menu_button_height,
}

return menuButtonModule
