--[[
X-MTA Gamemode
@author Pevo <pb.pb@onet.pl>
@copyright Pevo <pb.pb@onet.pl>
@license Dual GPLv3/MIT
]]--

local tex = {}
tex.circle = "images/circle.png"
tex.smile = "images/smile.png"
tex.arrow = "images/arrow.png"
tex.car = "images/car.png"
tex.square = "images/square.png"

for i, v in pairs(tex) do
  tex[i] = dxCreateTexture(v)
end

local markers = {}
local defaultColor = {230, 200, 10, 200}
local isRendering
local maxDistanceBetweenPlayerAndMarker = 100

-- CONST -- DO NOT CHANGE THIS
local STRW = 2.8
----------------

function createCustomMarker(x, y, z, color, size, texture, rot)
  if not color or not color[3] then color = defaultColor end
  z = z - 0.96
  rot = rot or 0
  if not size or not tonumber(size) then size = 1 end
  local element = Marker(x, y, z, "cylinder", size, color[1], color[2], color[3], 0)
  table.insert(markers, {element = element, size = size, rot = rot, texture = texture, color = color, resource = (sourceResource or getThisResource())})
  setRender(true)
  return element
end

local anim = 0

local vehSpeed

function renderAll()
  local pp = localPlayer:getPosition()
  anim = anim + 0.004
  for i, v in pairs(markers) do
    local position = v.element:getPosition()
    if getDistanceBetweenPoints3D(position.x, position.y, position.z, pp.x, pp.y, pp.z) < maxDistanceBetweenPlayerAndMarker then
      local zSize = interpolateBetween(0, 0, 0, 0.2, 0, 0, anim, "SineCurve")

      dxDrawMaterialLine3D(position.x - v.size / STRW, position.y - v.size / STRW, position.z - 0.001, position.x + v.size / STRW, position.y + v.size / STRW, position.z - 0.01, tex.circle, v.size, tocolor(v.color[1], v.color[2], v.color[3], v.color[4] or 255), position.x, position.y, position.z)
      
      dxDrawMaterialLine3D(position.x, position.y + v.size / 8, position.z + v.size - zSize, position.x, position.y, position.z + v.size / 1.75 - zSize, tex.arrow, v.size / 4, tocolor(v.color[1], v.color[2], v.color[3], math.max((v.color[4] or 255), 1) / 2), position.x, position.y, position.z)
      dxDrawMaterialLine3D(position.x, position.y - v.size / 8, position.z + v.size - zSize, position.x, position.y, position.z + v.size / 1.75 - zSize, tex.arrow, v.size / 4, tocolor(v.color[1], v.color[2], v.color[3], math.max((v.color[4] or 255), 1) / 2), position.x, position.y, position.z)

      dxDrawMaterialLine3D(position.x + v.size / 8, position.y, position.z + v.size - zSize, position.x, position.y, position.z + v.size / 1.75 - zSize, tex.arrow, v.size / 4, tocolor(v.color[1], v.color[2], v.color[3], math.max((v.color[4] or 255), 1) / 2), position.x, position.y, position.z)
      dxDrawMaterialLine3D(position.x - v.size / 8, position.y, position.z + v.size - zSize, position.x, position.y, position.z + v.size / 1.75 - zSize, tex.arrow, v.size / 4, tocolor(v.color[1], v.color[2], v.color[3], math.max((v.color[4] or 255), 1) / 2), position.x, position.y, position.z)

      dxDrawMaterialLine3D(position.x + v.size / 8, position.y, position.z + v.size * 0.995 - zSize, position.x - v.size / 8, position.y, position.z + v.size * 0.995 - zSize, tex.square, v.size / 4, tocolor(v.color[1], v.color[2], v.color[3], math.max((v.color[4] or 255), 1) / 2), position.x, position.y, position.z)

      if v.texture then
        dxDrawMaterialLine3D(position.x - v.size / STRW / 1.5, position.y - v.size / STRW / 1.5, position.z - 0.001, position.x + v.size / STRW / 1.5, position.y + v.size / STRW / 1.5, position.z - 0.01, tex[v.texture], v.size / 1.5, tocolor(v.color[1], v.color[2], v.color[3], v.color[4] or 255), position.x, position.y, position.z)
      end
    end
  end
end

function setRender(isRenderOn)
  if isRenderOn then
    if not isRendering then
      addEventHandler("onClientRender", root, renderAll)
      isRendering = true
    end
  else
    if isRendering then
      removeEventHandler("onClientRender", root, renderAll)
      isRendering = nil
    end 
  end
end

function isCustomMarker(element)
  for i, v in pairs(markers) do
    if v.element == element then return i end
  end
  return false
end

addEventHandler("onClientElementDestroy", getRootElement(), function()
  if not isCustomMarker(source) then return end
  if not #markers then return end
  if markers[isCustomMarker(source)] then markers[isCustomMarker(source)] = nil end
  setRender(not (#markers < 1))
end)

addEventHandler("onClientResourceStop", getRootElement(), function(resource)
  if #markers == 0 then return end
  local elementsToDestroy = {}
  for i, v in pairs(markers) do
    if v.resource == resource then
      table.insert(elementsToDestroy, v.element)
    end
  end
  for i, v in pairs(elementsToDestroy) do
    v:destroy()
  end
end)

addEventHandler("onClientMarkerHit", createCustomMarker(1808.50366, -2598.88428, 13.5468, {11, 70, 212}, 2, "car"), function()
  triggerEvent("onClientAddNotification", localPlayer, localPlayer:getName() .. " wszedł w marker!", nil, nil, 14)
end)