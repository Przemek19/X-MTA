local animations = {}
local data = {}

data.__animations = {}
data.__isRenderOn = false

local functions = {}

functions.createAnimation = function(name, from, to, time, func, isDestoyAfterTime)
  if functions.getAnimationByName(name) then functions.destroyAnimation(name) end
  if not data.__isRenderOn then addEventHandler("onClientRender", root, animationRender) data.__isRenderOn = true end
  table.insert(animations, {id = name, firstTick = getTickCount(), func = func, from = from, to = to, time = time, value = 0, res = getThisResource()})
  if isDestoyAfterTime then
    setTimer(function(name)
      functions.destroyAnimation(name)
    end, time, 1, name)
  end
  return name
end

functions.getAnimationByName = function(name)
  for i, v in pairs(animations) do
    if name == v.id then
      return i
    end
  end
end

functions.getAnimation = function(name)
  if not functions.getAnimationByName(name) then return false end
  return animations[functions.getAnimationByName(name)].value
end

functions.destroyAnimation = function(name)
  table.remove(animations, functions.getAnimationByName(name))
  if #animations < 1 then removeEventHandler("onClientRender", root, animationRender) data.__isRenderOn = false end
end

animationRender = function()
  for i, v in pairs(animations) do
    v.value = interpolateBetween(v.from, 0, 0, v.to, 0, 0, (getTickCount() - v.firstTick) / v.time, v.func)
  end
end

local prefix = gui.config.functionsPrefix or ""

for i,v in pairs(functions) do
  if type(v) == "function" then
    _G[prefix..i] = v
    --outputChatBox('<export function="' .. prefix .. i .. '" type="client" />')
  end
end

prefix = nil