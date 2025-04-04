
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

local Ctx = (function ()
  ---@class ezd.Ctx
  ---@field frameCount integer
  ---@field dt number
  ---@field sw integer
  ---@field sh integer
  ---@field mainMenu ezd.ui.MainMenu
  local Ctx = {}
  Ctx.__index = Ctx
  function Ctx.new()
    local self = setmetatable({}, Ctx)
    self.frameCount = 0
    self.sw = love.graphics.getWidth()
    self.sh = love.graphics.getHeight()
    self.mainMenu = MainMenu.new({
      x = math.floor(self.sw/2 - main_menu_width/2),
      y = math.floor(self.sh/3 - main_menu_height/3),
    })
    self.mainMenu:addButton("resume")
    self.mainMenu:addButton("save")
    self.mainMenu:addButton("Load")
    self.mainMenu:addButton("settings")
    self.mainMenu:addButton("quit")
    for _, btn in ipairs(self.mainMenu.menuButtons) do
      -- btn:onMousemoved(function()
      --   printf("%s\n", btn.label)
      -- end)
      btn:onMouseentered(function ()
        printf("button '%s' enter\n", btn.label)
      end)
      btn:onMouseexited(function ()
        printf("button '%s' exit\n", btn.label)
      end)
    end
    self.mainMenu:onMousemoved(function (x, y, dx, dy, istouch)
      printf("MainMenu mousemoved\n")
    end)
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
  -- testDll:pushBack(0)
  -- printf("%s\n", testDll.head.val)
  local testVals = { 0, 1, 2, 3, 4 }
  for _, testVal in ipairs(testVals) do
    -- printf("%s ", testVal)
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
  local str = ""
  for _, line in ipairs(lines) do
    str = str..line.."\n"
  end
  return str
end

---@type love.mousepressed
function love.mousepressed(mx, my, dx, dy, istouch)
  local ctx = getCtx()
end

---@type love.mousereleased
function love.mousereleased(mx, my, dx, dy, istouch)
  local ctx = getCtx()
end

---@type love.mousemoved
function love.mousemoved(mx, my, dx, dy, istouch)
  local ctx = getCtx()
  ctx.mainMenu:mousemoved(mx, my, dx, dy, istouch)
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
  ctx.mainMenu:draw()
end
