--[[
X-MTA Gamemode
@author Pevo <pb.pb@onet.pl>
@copyright Pevo <pb.pb@onet.pl>
@license Dual GPLv3/MIT
]]--

GUI = exports.gui

local sw, sh = GUI:screenSize()
local zoom = GUI:zoom()

carsWithoutSpeedometer = {

}

local tex = {
  speedometer = dxCreateTexture("images/speedometer.png"),
  arrow = dxCreateTexture("images/arrow.png"),
}

function renderAll()
  local veh = localPlayer:getOccupiedVehicle()
  if not veh or not isElement(veh) then return end
  local speed = math.floor(getElementSpeed(veh, 1)) 
  local text = speed .. " km/h"
  dxDrawText(text, 0, 0, sw - 8 / zoom, sh - 10 / zoom, tocolor(0, 0, 0), 1, GUI:font("Lato", 16, "bold"), "right", "bottom")
  dxDrawText(text, 0, 0, sw - 12 / zoom, sh - 10 / zoom, tocolor(0, 0, 0), 1, GUI:font("Lato", 16, "bold"), "right", "bottom")
  dxDrawText(text, 0, 0, sw - 10 / zoom, sh - 12 / zoom, tocolor(0, 0, 0), 1, GUI:font("Lato", 16, "bold"), "right", "bottom")
  dxDrawText(text, 0, 0, sw - 10 / zoom, sh - 8 / zoom, tocolor(0, 0, 0), 1, GUI:font("Lato", 16, "bold"), "right", "bottom")

  dxDrawText(text, 0, 0, sw - 10 / zoom, sh - 10 / zoom, nil, 1, GUI:font("Lato", 16, "bold"), "right", "bottom")
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

addEventHandler("onClientPlayerVehicleEnter", localPlayer, function(vehicle)
  for i, v in pairs(carsWithoutSpeedometer) do
    if v == vehicle:getModel() then return end
  end
  setRender(true)
end)

setRender(true)