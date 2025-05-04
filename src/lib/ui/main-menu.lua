
local printf = require('util.printf')

local UiElem = require('lib.ui.ui-elem')
local menuButton2Module = require('lib.ui.menu-button2')
local MenuButton2 = menuButton2Module.MenuButton2
local style = require('lib.ui.style')

local main_menu_width = 150
local main_menu_height = 100

---@class ezd.ui.MainMenuOpts: ezd.ui.UiElemOpts

local MainMenu = (function ()
  ---@class ezd.ui.MainMenu: ezd.ui.UiElem
  ---@field menuButtons ezd.ui.MenuButton2[]
  local MainMenu = {}
  MainMenu.__index = MainMenu
  setmetatable(MainMenu, { __index = UiElem })

  ---@param opts? ezd.ui.MainMenuOpts
  function MainMenu.new(opts)
    local self = setmetatable(UiElem.new(opts), MainMenu)
    opts = opts or {}
    self.w = opts.w or main_menu_width
    self.h = opts.h or main_menu_height
    self.pad = opts.pad or 15
    self.menuButtons = {}
    return self
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
    local menuBtn = MenuButton2.new(btnOpts)
    -- self:layout()
    self:addChild(menuBtn)
    -- menuBtn:layout()
    -- self:layout()
  end

  function MainMenu:render()
    local w = self:width()
    local h = self:height()
    love.graphics.rectangle("line", self.x, self.y, w, h)
    UiElem.render(self)
  end

  return MainMenu
end)()

local mainMenuModule = {
  MainMenu = MainMenu,
  main_menu_width = main_menu_width,
  main_menu_height = main_menu_height,
}

return mainMenuModule
