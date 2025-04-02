
local Rect = require("lib.geom.rect")
local menuButtonModule = require("lib.ui.menu-button")
local MenuButton = menuButtonModule.MenuButton

local main_menu_width = 200
local main_menu_height = 250

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
  ---@field menuButtons ezd.ui.MenuButton[]
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

  ---@param label string
  function MainMenu:addButton(label)
    local leftPad = self.pad
    local rightPad = self.pad
    ---@type ezd.ui.MenuButtonOpts
    local btnOpts = {
      label = label,
      w = self.w - (leftPad + rightPad),
      h = 35,
      -- align = "end",
      -- justify = "end",
    }
    local menuBtn = MenuButton.new(btnOpts)
    table.insert(self.menuButtons, menuBtn)
    self:layout()
  end

  function MainMenu:layout()
    local pad = self.pad
    local lineY = self.y + pad
    local lineX = self.x + pad
    for _, menuBtn in ipairs(self.menuButtons) do
      local mbx = lineX
      local mby = lineY
      menuBtn.x = mbx
      menuBtn.y = mby
      menuBtn:layout()
      lineY = lineY + menuBtn:height() + self.rowGap
    end
  end

  function MainMenu:render()
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
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
