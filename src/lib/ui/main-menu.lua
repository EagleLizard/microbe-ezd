
local printf = require('util.printf')

local MenuElem = require('lib.ui.menu-elem')
local Rect = require("lib.geom.rect")
local menuButtonModule = require("lib.ui.menu-button")
local MenuButton = menuButtonModule.MenuButton
local menuButton2Module = require('lib.ui.menu-button2')
local MenuButton2 = menuButton2Module.MenuButton2

local main_menu_width = 150
local main_menu_height = 100

---@class ezd.ui.MainMenuOpts: ezd.ui.MenuElemOpts

local MainMenu = (function ()
  ---@class ezd.ui.MainMenu: ezd.ui.MenuElem
  ---@field menuButtons ezd.ui.MenuButton2[]
  ---@field rowGap number
  local MainMenu = {}
  MainMenu.__index = MainMenu
  setmetatable(MainMenu, { __index = MenuElem })

  ---@param opts? ezd.ui.MainMenuOpts
  function MainMenu.new(opts)
    opts = opts or {}
    local self = setmetatable(MenuElem.new(opts), MainMenu)
    self.w = opts.w or main_menu_width
    self.h = opts.h or main_menu_height
    self.pad = opts.pad or 15
    self.rowGap = 10
    self.menuButtons = {}
    return self
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
