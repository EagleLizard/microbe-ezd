
-- local lurker = require "lurker"
local lick = require "lick"
lick.reset = true
lick.updateAllFiles = true
lick.clearPackages = true

local printf = require "util.printf"
local dllModule = require "lib.datastruct.dll"
local Dll = dllModule.Dll
local menuModule = require "lib.ui.menu.menu"
local Menu = menuModule.Menu
local MenuElem = require "lib.ui.menu.menu-elem"

local Obj = (function ()
  ---@class ezd.Obj
  ---@field id integer
  local Obj = {}
  Obj.__index = Obj
  local objIdCounter = 0
  local function getObjId()
    local id = objIdCounter
    objIdCounter = objIdCounter + 1
    return id
  end
  function Obj.new()
    local self = setmetatable({}, Obj)
    self.id = getObjId()
    return self
  end
  --[[ overrides ]]
  function Obj:draw()end
  function Obj:update()end
  return Obj
end)()

local Ctx = (function ()
  ---@class ezd.Ctx
  ---@field frameCount integer
  ---@field dt number
  ---@field sw integer
  ---@field sh integer
  ---@field menu ezd.ui.MenuElem
  local Ctx = {}
  Ctx.__index = Ctx
  function Ctx.new()
    local self = setmetatable({}, Ctx)
    self.frameCount = 0
    self.sw = love.graphics.getWidth()
    self.sh = love.graphics.getHeight()
    -- self.menu = Menu.new({
    --   x = 10 + 200,
    --   y = 10,
    --   w = 100,
    --   h = 100
    -- })
    self.menu = MenuElem.new({
      x = 10 + 200,
      y = 10,
      w = 100,
      h = 100,
    })
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

function love.mousepressed(mx, my, dx, dy, istouch)
  local ctx = getCtx()
  local els = ctx.menu:getDescendants()
  for _, el in ipairs(els) do
    el:mousepress({
      x = mx,
      y = my,
    })
  end
end
function love.mousereleased(mx, my, dx, dy, istouch)
  local ctx = getCtx()
  local els = ctx.menu:getDescendants()
  for _, el in ipairs(els) do
    el:mouserelease({
      x = mx,
      y = my,
    })
  end
end

function love.update(dt)
  local ctx = getCtx()
  ctx:update(dt)
end

function love.draw()
  local ctx = getCtx()
  local printStr = "hello ~ \n"..dbgStr(ctx)
  love.graphics.print(printStr, 20, 20)
  ctx.menu:render()
end
