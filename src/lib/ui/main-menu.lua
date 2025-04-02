
local Rect = require("lib.geom.rect")
local menuButtonModule = require("lib.ui.menu-button")
local MenuButton = menuButtonModule.MenuButton
local menuButton2Module = require('lib.ui.menu-button2')
local MenuButton2 = menuButton2Module.MenuButton2

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
  ---@field bodyRect ezd.geom.Rect
  ---@field menuButtons ezd.ui.MenuButton2[]
  ---@field pad number
  ---@field rowGap number
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
    self.bodyRect = Rect.new(self.x, self.y, self.w, self.h)
    self.menuButtons = {}
    return self
  end

  function MainMenu:height()
    return self.h + self.pad + self.pad
  end
  function MainMenu:rightPad()
    return self.pad
  end
  function MainMenu:leftPad()
    return self.pad
  end
  function MainMenu:topPad()
    return self.pad
  end
  function MainMenu:bottomPad()
    return self.pad
  end

  ---@param label string
  function MainMenu:addButton(label)
    local leftPad = self.pad
    local rightPad = self.pad
    ---@type ezd.ui.MenuButtonOpts
    local btnOpts = {
      label = label,
      w = self.w - (leftPad + rightPad),
      -- h = 25,
      -- align = "end",
      -- justify = "end",
      pad = 5,
    }
    -- local menuBtn = MenuButton.new(btnOpts)
    local menuBtn = MenuButton2.new(btnOpts)
    table.insert(self.menuButtons, menuBtn)
    self:layout()
  end

  function MainMenu:layout()
    local lineY = self.y + self:topPad()
    local lineX = self.x + self:leftPad()
    for _, menuBtn in ipairs(self.menuButtons) do
      local mbx = lineX
      local mby = lineY
      menuBtn.x = mbx
      menuBtn.y = mby
      menuBtn:layout()
      lineY = lineY + menuBtn:height() + self.rowGap
    end
    --[[ get the height of children ]]
    local cyMin = math.huge
    local cbyMax = -math.huge
    for _, child in ipairs(self.menuButtons) do
      cyMin = math.min(cyMin, child.y)
      cbyMax = math.max(cbyMax, child:bottom())
    end
    local contentHeight = cbyMax - cyMin
    self.h = math.max(self.h, contentHeight)
  end

  function MainMenu:render()
    local w = self.w + self:rightPad()
    love.graphics.rectangle("line", self.x, self.y, w, self:height())
    for _, menuBtn in ipairs(self.menuButtons) do
      menuBtn:render()
    end
  end

  return MainMenu
end)()

local mainMenuModule = {
  MainMenu = MainMenu,
  main_menu_width = main_menu_width,
  main_menu_height = main_menu_height,
}

return mainMenuModule
