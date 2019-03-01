--[[
X-MTA Gamemode
@author Pevo <pb.pb@onet.pl>
@copyright Pevo <pb.pb@onet.pl>
@license Dual GPLv3/MIT
]]--

CORE = exports.CORE

INVENTORY_KEY_ID = 3

function getVehicleWithID(id)
  if not id or not tonumber(id) then return false end
  for i, v in pairs(getElementsByType("vehicle")) do
    if v:getData("vid") and v:getData("vid") == id then
      return v
    end
  end
  return false
end

addEventHandler("onInventoryActionClick", root, function(itemInfo, slotInfo, option)
  if itemInfo.id ~= INVENTORY_KEY_ID then return end
  local veh = getVehicleWithID(slotInfo.subtype)
  if not veh then triggerEvent("onClientAddNotification", localPlayer, "Pojazd jest za daleko!", nil, nil, 24) return end

  local vehPos = veh:getPosition()
  local playerPos = localPlayer:getPosition()

  if getDistanceBetweenPoints3D(vehPos.x, vehPos.y, vehPos.z, playerPos.x, playerPos.y, playerPos.z) > 10 then triggerEvent("onClientAddNotification", localPlayer, "Pojazd jest za daleko!", nil, nil, 24) return end

  if option == "Otwórz pojazd" then
    if veh:isLocked() then
      triggerEvent("onClientAddNotification", localPlayer, "Otworzyłeś pojazd!", nil, nil, 24)
      triggerServerEvent("vehicles-openVehicle", localPlayer, veh)
    else
      triggerEvent("onClientAddNotification", localPlayer, "Drzwi już są otwarte!", nil, nil, 24)
    end
  elseif option == "Zamknij pojazd" then
    if veh:isLocked() then
      triggerEvent("onClientAddNotification", localPlayer, "Drzwi już są zamknięte!", nil, nil, 24)
    else
      triggerEvent("onClientAddNotification", localPlayer, "Zamknąłeś pojazd!", nil, nil, 24)
      triggerServerEvent("vehicles-closeVehicle", localPlayer, veh)
    end
  end
end)

local openingVehicles = {}
local closingVehicles = {}

addEvent("vehicles-openVehicleClientSide", true)
addEventHandler("vehicles-openVehicleClientSide", getRootElement(), function(veh)
  if not closingVehicles[veh] then closingVehicles[veh] = {} end
  if not openingVehicles[veh] then openingVehicles[veh] = {} end
  if openingVehicles[veh].timer and isTimer(openingVehicles[veh].timer) then openingVehicles[veh].timer:kill() end
  if openingVehicles[veh].sound and isElement(openingVehicles[veh].sound) then openingVehicles[veh].sound:stop() openingVehicles[veh].sound = nil end
  if closingVehicles[veh].timer and isTimer(closingVehicles[veh].timer) then closingVehicles[veh].timer:kill() end
  if closingVehicles[veh].sound and isElement(closingVehicles[veh].sound) then closingVehicles[veh].sound:stop() closingVehicles[veh].sound = nil end
  openingVehicles[veh].sound = Sound3D("files/music/car_open.mp3", veh:getPosition())
  openingVehicles[veh].sound:setMaxDistance(30)
  veh:setOverrideLights(2)
  openingVehicles[veh].timer = setTimer(function(veh)
    veh:setOverrideLights(1)
    openingVehicles[veh].timer = setTimer(function(veh)
      veh:setOverrideLights(2)
      openingVehicles[veh].timer = setTimer(function(veh)
        veh:setOverrideLights(1)
      end, 300, 1, veh)
    end, 300, 1, veh)
  end, 300, 1, veh)
end)

addEvent("vehicles-closeVehicleClientSide", true)
addEventHandler("vehicles-closeVehicleClientSide", getRootElement(), function(veh)
  if not closingVehicles[veh] then closingVehicles[veh] = {} end
  if not openingVehicles[veh] then openingVehicles[veh] = {} end
  if openingVehicles[veh].timer and isTimer(openingVehicles[veh].timer) then openingVehicles[veh].timer:kill() end
  if openingVehicles[veh].sound and isElement(openingVehicles[veh].sound) then openingVehicles[veh].sound:stop() openingVehicles[veh].sound = nil end
  if closingVehicles[veh].timer and isTimer(closingVehicles[veh].timer) then closingVehicles[veh].timer:kill() end
  if closingVehicles[veh].sound and isElement(closingVehicles[veh].sound) then closingVehicles[veh].sound:stop() closingVehicles[veh].sound = nil end
  closingVehicles[veh].sound = Sound3D("files/music/car_open.mp3", veh:getPosition())
  closingVehicles[veh].sound:setMaxDistance(30)
  veh:setOverrideLights(2)
  closingVehicles[veh].timer = setTimer(function(veh)
    veh:setOverrideLights(1)
    closingVehicles[veh].timer = setTimer(function(veh)
      veh:setOverrideLights(2)
      closingVehicles[veh].timer = setTimer(function(veh)
        veh:setOverrideLights(1)
      end, 300, 1, veh)
    end, 300, 1, veh)
  end, 300, 1, veh)
end)