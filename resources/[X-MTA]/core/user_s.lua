--[[
X-MTA Gamemode
@author Pevo <pb.pb@onet.pl>
@copyright Pevo <pb.pb@onet.pl>
@license Dual GPLv3/MIT
]]--

local usersTable = "mta_users"

addEventHandler("onPlayerChangeNick", getRootElement(), function()
  cancelEvent()
end)

function loadUser(plr, uid)
  local result = DB:query("SELECT * FROM " .. usersTable .. " WHERE id=?", tonumber(uid))[1]
  DB:query("UPDATE " .. usersTable .. " SET lastSeen=NOW() WHERE id=?", result.id)
  plr:setData("uid", result.id)
  if result.globalData and fromJSON(result.globalData) then
    plr:setData("globalData", fromJSON(result.globalData))
  end

  local position = getGlobalData(plr, "lastPosition") or CONFIG.firstPosition or {{0, 0, 3}, 0, 0, 0}

  local cords = position[1]

  spawnPlayer(plr, cords[1], cords[2], cords[3])
  plr:setInterior(position[2])
  plr:setDimension(position[3])
  plr:setRotation(0, 0, position[4])
  cords = nil
  position = nil

  plr:setModel(getGlobalData(plr, "skin") or 0)

  plr:setName(result.login)

  DB:query("INSERT INTO mta_sessions (`uid`, `serial`, `ip`, `joinDate`) VALUES (?,?,?,NOW())", plr:getData("uid"), plr:getSerial(), plr:getIP())
  result = nil
end

function createNewUser(plr, login, email, password)
  DB:query("INSERT INTO " .. usersTable .. " (`login`,`password`,`email`,`registerSerial`,`registerIP`) VALUES (?,?,?,?,?)", login, password, email, plr:getSerial(), plr:getIP())
end

function saveUser(plr, quitType)
  local x, y, z = getElementPosition(plr)
  local _, _, rot = getElementRotation(plr)
  setGlobalData(plr, "lastPosition", {{x, y, z}, plr:getInterior(), plr:getDimension(), rot})
  x, y, z = nil, nil, nil
  DB:query("UPDATE " .. usersTable .. " SET lastQuit=NOW(), globalData=? WHERE id=?", toJSON(plr:getData("globalData")), plr:getData("uid"))
  DB:query("UPDATE mta_sessions SET quitDate=NOW(), quitType=? WHERE uid=? AND quitType IS NULL", quitType, plr:getData("uid"))
end

addEventHandler("onPlayerQuit", getRootElement(), function(quitType)
  if not source:getData("uid") then return end
  saveUser(source, quitType)
end)

addEvent("core-loadUser", true)
addEventHandler("core-loadUser", getRootElement(), function(uid)
  loadUser(source, uid)
end)

addEvent("core-createNewUser", true)
addEventHandler("core-createNewUser", getRootElement(), function(login, email, password)
  createNewUser(source, login, email, encrypt(password))
end)

addEventHandler("onPlayerJoin", getRootElement(), function()
  for i = 0, getMaxPlayers() do
    if not getElementByID(i) then
      source:setID(i)
      break
    end
  end
end)