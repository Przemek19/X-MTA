--[[
X-MTA Gamemode
@author Pevo <pb.pb@onet.pl>
@copyright Pevo <pb.pb@onet.pl>
@license Dual GPLv3/MIT
]]--

DATA = {}

function setData(name,value)
  if not name then outputDebugString("DATA: NAME can't be empty!",3,200,0,0) return false end
  DATA[name] = value
end

function getData(name)
  if not name then outputDebugString("DATA: NAME can't be empty!",3,200,0,0) return false end
  if not DATA[name] then return nil end
  return DATA[name]
end

function getAllData()
  return DATA
end