--[[
X-MTA Gamemode
@author Pevo <pb.pb@onet.pl>
@copyright Pevo <pb.pb@onet.pl>
@license Dual GPLv3/MIT
]]--

DB = exports.DB
CORE = exports.CORE

function pack(...)
  return { ... }, select("#", ...)
end

function addVehicle(model, isSpawn, plr)
  local x, y, z = 0, 0, 3
  if plr and isElement(plr) then
    local pos = plr:getPosition()
    x, y, z = pos.x, pos.y, pos.z
    pos = nil
  end
  local position = x .. "," .. y .. "," .. z + 2 .. "0,0,0"
  DB:query("INSERT INTO `mta_vehicles` (`model`, `position`, `isSpawn`) VALUES (?, ?)", tonumber(model), position, tonumber(isSpawn))
  local ID = DB:query("SELECT `ID` FROM `mta_vehicles` ORDER BY id DESC")[1]
  if isSpawn then
    spawnVehicle(ID)
  end
  return ID
end

function getVehicleWithID(id)
  if not id or not tonumber(id) then return false end
  for i, v in pairs(getElementsByType("vehicle")) do
    if v:getData("vid") and v:getData("vid") == id then
      return v
    end
  end
  return false
end

function spawnVehicle(id)
  local r = DB:query("SELECT * FROM `mta_vehicles` WHERE id=?", tonumber(id))[1]
  if not r then return false end

  local pos = split(r.position, ",")
  if not pos[6] then pos = "0,0,0,0,0,0" end

  local thisVehicle = Vehicle(r.model, pos[1], pos[2], pos[3], pos[4], pos[5], pos[6])

  thisVehicle:setHealth((r.health > 300) and r.health or 300)

  thisVehicle:setData("vid", r.id)
  
  if r.globalData and fromJSON(r.globalData) then
    thisVehicle:setData("globalData", fromJSON(r.globalData) or {})
  end

  local c = CORE:getGlobalData(thisVehicle, "color") or {255, 255, 255}
  local r1, g1, b1, r2, g2, b2, r3, g3, b3, r4, g4, b4 = unpack(c)

  thisVehicle:setColor(r1, g1, b1, r2, g2, b2, r3, g3, b3, r4, g4, b4)

  if r.handbrake == 1 then
    thisVehicle:setFrozen(true)
  end

  local panelState = fromJSON(r.panelState or "") or {}
  for i = 0, #panelState - 1 do
    thisVehicle:setPanelState(i, panelState[i + 1])
  end

  local doorState = fromJSON(r.doorState or "") or {}
  for i = 0, #doorState - 1 do
    thisVehicle:setDoorState(i, doorState[i + 1])
  end

  local lightState = fromJSON(r.lightState or "") or {}
  for i = 0, #lightState - 1 do
    thisVehicle:setLightState(i, lightState[i + 1])
  end

  thisVehicle:setLocked(r.isLocked == 1)

  thisVehicle:setDamageProof(true)

  if r.wheelStates and fromJSON(r.wheelStates) then
    thisVehicle:setWheelStates(unpack(fromJSON(r.wheelStates)))
  end

  DB:query("UPDATE `mta_vehicles` SET isSpawn=1 WHERE id=?", r.id)
end

function spawnAllVehicles()
  for _, v in pairs(DB:query("SELECT * FROM `mta_vehicles`")) do
    if v.isSpawn == 1 then
      spawnVehicle(v.id)
    end   
  end
end

function saveVehicle(id)
  local veh = getVehicleWithID(id)
  if not veh then return false end
  
  local pos = veh:getPosition()
  local rot = veh:getRotation()
  local position = pos.x .. "," .. pos.y .. "," .. pos.z .. "," .. rot.x .. "," .. rot.y .. "," .. rot.z
  
  local r1, g1, b1, r2, g2, b2, r3, g3, b3, r4, g4, b4 = veh:getColor(true)
  local c = pack(r1, g1, b1, r2, g2, b2, r3, g3, b3, r4, g4, b4)

  CORE:setGlobalData(veh, "color", c)

  local panelState = {}
  for i = 0, 6 do
    table.insert(panelState, veh:getPanelState(i))
  end

  local doorState = {}
  for i = 0, 5 do
    table.insert(doorState, veh:getDoorState(i))
  end

  local lightState = {}
  for i = 0, 3 do
    table.insert(lightState, veh:getDoorState(i))
  end

  local wheelStates = pack(veh:getWheelStates())

  DB:query("UPDATE `mta_vehicles` SET isLocked=?, wheelStates=?, panelState=?, doorState=?, lightState=?, position=?, health=?, handbrake=?, globalData=? WHERE id=?", (veh:isLocked() and 1 or 0), toJSON(wheelStates), toJSON(panelState), toJSON(doorState), toJSON(lightState), position, veh:getHealth(), (veh:isFrozen() and 1 or 0), toJSON(veh:getData("globalData") or {}), id)
end

function saveAllVehicles()
  for i, v in pairs(getElementsByType("vehicle")) do
    if v:getData("vid") then
      saveVehicle(v:getData("vid"))
    end
  end
end

function unspawnVehicle(id, isNotSave)
  local veh = getVehicleWithID(id)
  if not veh then return false end

  if not isNotSave then
    saveVehicle(id)
  end
  DB:query("UPDATE `mta_vehicles` SET isSpawn=0 WHERE id=", tonumber(id))
  veh:destroy()
end

addEventHandler("onResourceStart", getRootElement(), function(res)
  if res ~= getThisResource() then return end
  spawnAllVehicles()
end)

addEventHandler("onResourceStop", getRootElement(), function(res)
  if res ~= getThisResource() then return end
  saveAllVehicles()
end)

addEventHandler("onVehicleEnter", getRootElement(), function(_, seat)
  if seat == 0 then source:setDamageProof(false) end
end)

addEventHandler("onVehicleExit", getRootElement(), function(_, seat)
  if seat == 0 then source:setDamageProof(true) end
end)

addEvent("vehicles-openVehicle", true)
addEventHandler("vehicles-openVehicle", getRootElement(), function(veh)
  veh:setLocked(false)
  triggerClientEvent("vehicles-openVehicleClientSide", source, veh)
end)

addEvent("vehicles-closeVehicle", true)
addEventHandler("vehicles-closeVehicle", getRootElement(), function(veh)
  veh:setLocked(true)
  triggerClientEvent("vehicles-closeVehicleClientSide", source, veh)
end)