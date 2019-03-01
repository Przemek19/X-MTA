--[[
X-MTA Gamemode
@author Pevo <pb.pb@onet.pl>
@copyright Pevo <pb.pb@onet.pl>
@license Dual GPLv3/MIT
]]--

--[[local D = exports.DATA

addEvent("customData-server->client_sync", true)
addEventHandler("customData-server->client_sync", getRootElement(), function(element, name, value)
  setCustomData(element, name, value, false)
end)

function setCustomData(element, name, value, isSync)
  if not element and isElement(element) then outputDebugString("setCustomData: element is nil", 3, 200 ,0, 0) return false end
  local currentData = D:getData(element) or {}
  currentData[name] = value
  D:setData(element, currentData)
  if isSync then
    triggerServerEvent("customData-client->server_sync", localPlayer, element, name, value)
  end
  return true
end

function getCustomData(element, name)
  if not element and isElement(element) then outputDebugString("getCustomData: element is nil", 3, 200, 0, 0) return false end
  local currentData = D:getData(element) or {}
  if not currentData or not currentData[name] then return nil end
  return currentData[name]
end

addEvent("onPlayerJoin-customData->client_sync", true)
addEventHandler("onPlayerJoin-customData->client_sync", root, function(DATA)
  for i, _ in pairs(DATA) do
    for ii, vv in pairs(D:getData(i) or {}) do
      setCustomData(i, ii, vv, false)
    end
  end
end)]]--

function setGlobalData(element, name, value)
  if not element or not isElement(element) then return false end
  local globalData = element:getData("globalData") or {}
  globalData[name] = value
  element:setData("globalData", globalData)
  return true
end

function getGlobalData(element, name)
  if not element or not isElement(element) then return false end
  local globalData = element:getData("globalData") or {}
  return globalData[name] or false
end