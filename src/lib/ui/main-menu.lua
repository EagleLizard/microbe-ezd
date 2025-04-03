
local printf = require('util.printf')

local Rect = require("lib.geom.rect")
local menuButtonModule = require("lib.ui.menu-button")
local MenuButton = menuButtonModule.MenuButton
local menuButton2Module = require('lib.ui.menu-button2')
local MenuButton2 = menuButton2Module.MenuButton2
local EventRegistry = require('lib.ui.event-registry')

local main_menu_width = 150
local main_menu_height = 100

---@class ezd.ui.MainMenuOpts
---@field x? number
---@field y? number
---@field w? number
---@field h? number
---@field pad? number

local MainMenu = (function ()
  ---@class ezd.ui.MainMenu
  ---@field x number
  ---@field y number
  ---@field w number
  ---@field h number
  ---@field menuButtons ezd.ui.MenuButton2[]
  ---@field pad number
  ---@field rowGap number
  ---@field _mousemovedReg ezd.ui.EventRegistry
  local MainMenu = {}
  MainMenu.__index = MainMenu

  ---@param opts? ezd.ui.MainMenuOpts
  function MainMenu.new(opts)
    local self = setmetatable({}, MainMenu)
    opts = opts or {}
    self.x = opts.x or 0
    self.y = opts.y or 0
    self.w = opts.w or main_menu_width
    self.h = opts.h or main_menu_height
    self.pad = opts.pad or 15
    self.rowGap = 10
    self.menuButtons = {}
    self._mousemovedReg = EventRegistry.new()
    return self
  end

  function MainMenu:width()
    return self.w + self:padLeft() + self:padRight()
  end
  function MainMenu:height()
    return self.h + self:padTop() + self:padBottom()
  end
  ---@param tx number
  ---@param ty number
  ---@return boolean
  function MainMenu:checkBoundingRect(tx, ty)
    return (
      tx >= self.x
      and tx <= self.x + self:width()
      and ty >= self.y
      and ty <= self.y + self:height()
    )
  end

  function MainMenu:padRight()
    return self.pad
  end
  function MainMenu:padLeft()
    return self.pad
  end
  function MainMenu:padTop()
    return self.pad
  end
  function MainMenu:padBottom()
    return self.pad
  end

  ---@param fn love.mousemoved
  ---@return fun()
  function MainMenu:onMousemoved(fn)
    return self._mousemovedReg:register(fn)
  end
  function MainMenu:mousemoved(mx, my, dy, dx, istouch)
    if self:checkBoundingRect(mx, my) then
      for _, el in ipairs(self.menuButtons) do
        el:mousemoved(mx, my, dy, dx, istouch)
      end
    end
  end

  ---@param label string
  function MainMenu:addButton(label)
    local leftPad = self.pad
    local rightPad = self.pad
    ---@type ezd.ui.MenuButton2Opts
    local btnOpts = {
      label = label,
      w = self.w,
      -- h = 25,
      -- align = "center",
      -- justify = "center",
      -- align = "end",
      -- justify = "end",
      pad = 5,
    }
    -- local menuBtn = MenuButton.new(btnOpts)
    local menuBtn = MenuButton2.new(btnOpts)
    -- self:layout()
    table.insert(self.menuButtons, menuBtn)
    -- menuBtn:layout()
    -- self:layout()
  end

  function MainMenu:layout()
    local lineY = self.y + self:padTop()
    local lineX = self.x + self:padLeft()
    for _, menuBtn in ipairs(self.menuButtons) do
      local mbx = lineX
      local mby = lineY
      menuBtn.x = mbx
      menuBtn.y = mby
      menuBtn:layout()
      lineY = lineY + menuBtn:height() + self.rowGap
    end
    --[[ get the width/height of children ]]
    local cxMin = math.huge
    local cyMin = math.huge
    local crxMax = -math.huge
    local cbyMax = -math.huge
    for _, child in ipairs(self.menuButtons) do
      cxMin = math.min(cxMin, child.x)
      crxMax = math.max(crxMax, child:right())
      cyMin = math.min(cyMin, child.y)
      cbyMax = math.max(cbyMax, child:bottom())
    end
    local contentWidth = crxMax - cxMin
    local contentHeight = cbyMax - cyMin
    self.w = math.max(self.w, contentWidth)
    self.h = math.max(self.h, contentHeight)
  end

  function MainMenu:render()
    local w = self:width()
    local h = self:height()
    love.graphics.rectangle("line", self.x, self.y, w, h)
    for _, menuBtn in ipairs(self.menuButtons) do
      -- love.graphics.print(string.format("x: %s\nw: %s", menuBtn.x, menuBtn.w), menuBtn.x - 100, menuBtn.y)
      menuBtn:render()
    end
  end

  function MainMenu:draw()
    --[[ 
      !!! should only do layout + render on root elem... I think
    ]]
    self:layout()
    self:render()
  end

  return MainMenu
end)()

local mainMenuModule = {
  MainMenu = MainMenu,
  main_menu_width = main_menu_width,
  main_menu_height = main_menu_height,
}

return mainMenuModule
