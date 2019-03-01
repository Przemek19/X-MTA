--[[
X-MTA Gamemode
@author Pevo <pb.pb@onet.pl>
@copyright Pevo <pb.pb@onet.pl>
@license Dual GPLv3/MIT
]]--

CORE = exports.core
DB = exports.DB

DBPREFIX = CORE:getServerConfig("SQLPrefix") or ""

local data = {
  usersTable = "users"
}

function getDBName(name)
  return "`" .. DBPREFIX .. name .. "`"
end

local usersTable = getDBName(data.usersTable)

addEvent("authorization-logging", true)
addEvent("authorization-register", true)

function alert(text, color, plr, size)
  triggerClientEvent(plr, "onClientAddNotification", plr, text, color, nil, size or 24)
end

function logging(plr, login, password)
  local result = DB:query("SELECT id FROM " .. usersTable .. " WHERE login=? AND password=?", login, CORE:encrypt(password))
  if #result ~= 1 then alert("Login lub hasło są nieprawidłowe", {220, 30, 10}, plr, 14) return false end

  triggerEvent("core-loadUser", plr, result[1].id)
  triggerClientEvent(plr, "authorization-destroyPanel", plr)
end

function register(plr, login, email, password)
  local result = DB:query("SELECT * FROM " .. usersTable .. " WHERE login=?", login)
  if #result ~= 0 then alert("Podany login jest zajęty!", {220, 30, 10}, plr) return false end
  result = DB:query("SELECT * FROM " .. usersTable .. " WHERE email=?", email)
  if #result ~= 0 then alert("Na ten email jest już zarejestrowane jedno konto!", {220, 30, 10}, plr, 14) return false end
  result = DB:query("SELECT * FROM " .. usersTable .. " WHERE registerSerial=?", plr:getSerial())
  if #result ~= 0 then alert("Na ten serial jest już zarejestrowane jedno konto!", {220, 30, 10}, plr, 14) return false end

  triggerEvent("core-createNewUser", plr, login, email, password)

  alert("Rejestracja przebiegła pomyślnie!", {10, 220, 30}, plr, 14)
end

addEventHandler("authorization-logging", getRootElement(), function(login, password)
  if not source or not login or not password then return end
  logging(source, login, password)
end)

addEventHandler("authorization-register", getRootElement(), function(login, email, password)
  if not source or not login or not email or not password then return end
  register(source, login, email, password)
end)