
-- local lurker = require "lurker"
local lick = require "lick"
-- lick.reset = true
lick.updateAllFiles = true
lick.clearPackages = true

local printf = require "util.printf"
local dllModule = require "lib.datastruct.dll"
local Dll = dllModule.Dll
local mainMenuModule = require("lib.ui.main-menu")
local MainMenu = mainMenuModule.MainMenu
local main_menu_width = mainMenuModule.main_menu_width
local main_menu_height = mainMenuModule.main_menu_height
local ClickEvent = require('lib.ui.event.click-event')
local MousemoveEvent = require('lib.ui.event.mousemove-event')
local UiCtrl = require "lib.ui.ui-ctrl.ui-ctrl"

local Ctx = (function ()
  ---@class ezd.Ctx
  ---@field frameCount integer
  ---@field dt number
  ---@field sw integer
  ---@field sh integer
  ---@field mainMenu ezd.ui.MainMenu
  ---@field uiCtrl ezd.ui.UiCtrl
  local Ctx = {}
  Ctx.__index = Ctx
  function Ctx.new()
    local self = setmetatable({}, Ctx)
    self.frameCount = 0
    self.sw = love.graphics.getWidth()
    self.sh = love.graphics.getHeight()
    self.uiCtrl = UiCtrl.new()
    local mainMenu = MainMenu.new({
      x = math.floor(self.sw/2 - main_menu_width/2),
      y = math.floor(self.sh/3 - main_menu_height/3),
    })
    mainMenu:addButton("resume")
    mainMenu:addButton("save")
    mainMenu:addButton("Load")
    mainMenu:addButton("settings")
    mainMenu:addButton("quit")
    self.uiCtrl:addEl(mainMenu)

    return self
  end
  function Ctx:update(dt)
    self.dt = dt
    self.frameCount = self.frameCount + 1
  end
  return Ctx
end)()

---@param ctx ezd.Ctx
local function initEtc(ctx)
  printf("initEtc()\n")
  --[[ test dll ]]
  local testDll = Dll.new()
  local testVals = { 0, 1, 2, 3, 4 }
  for _, testVal in ipairs(testVals) do
    testDll:pushBack(testVal)
  end
  local dllIdx = 1
  testDll:each(function (val)
    assert(testVals[dllIdx] == val)
    dllIdx = dllIdx + 1
  end)
  for i=#testVals,1,-1 do
    local dv = testDll:pop()
    assert(dv == testVals[i])
  end
  printf("\n")
end

local getCtx = (function ()
  local _ctx = nil
  return function()
    local doEtc = false
    if _ctx == nil then
      doEtc = true
    end
    _ctx = _ctx or Ctx.new()
    if doEtc then
      initEtc(_ctx)
      printf("init ctx\n")
    end
    return _ctx
  end
end)()

local function dbgStr(ctx)
  local lines = {}
  table.insert(lines, string.format("fc: %s", ctx.frameCount))
  table.insert(lines, string.format("dt: %s", ctx.dt))
  table.insert(lines, string.format("fps: %s", love.timer.getFPS()))
  local str = ""
  for _, line in ipairs(lines) do
    str = str..line.."\n"
  end
  return str
end

---@type love.mousepressed
function love.mousepressed(mx, my, button, istouch, presses)
  local ctx = getCtx()
  local evt = ClickEvent.new(mx, my, button, istouch, presses);
  ctx.uiCtrl:mousepressed(evt)
end

---@type love.mousereleased
function love.mousereleased(mx, my, button, istouch, presses)
  local ctx = getCtx()
  local evt = ClickEvent.new(mx, my, button, istouch, presses);
  ctx.uiCtrl:mousereleased(evt)
end

---@type love.mousemoved
function love.mousemoved(mx, my, dx, dy, istouch)
  local ctx = getCtx()
  local evt = MousemoveEvent.new(mx, my, dx, dy, istouch)
  ctx.uiCtrl:mousemoved(evt)
end

---@type love.update
function love.update(dt)
  local ctx = getCtx()
  ctx:update(dt)
end

---@type love.draw
function love.draw()
  local ctx = getCtx()
  local printStr = "hello ~ \n"..dbgStr(ctx)
  love.graphics.print(printStr, 20, 20)
  ctx.uiCtrl:draw()
end
