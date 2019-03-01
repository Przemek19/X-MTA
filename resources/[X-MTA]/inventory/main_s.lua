--[[
X-MTA Gamemode
@author Pevo <pb.pb@onet.pl>
@copyright Pevo <pb.pb@onet.pl>
@license Dual GPLv3/MIT
]]--

addEvent("inventory-changeEQStatus->server", true)
addEventHandler("inventory-changeEQStatus->server", getRootElement(), function()
  triggerClientEvent(source, "inventory-changeEQStatus->client", source)
end)

addEvent("inventory-doThisFunctionIfConnectedToServer", true)
addEventHandler("inventory-doThisFunctionIfConnectedToServer", getRootElement(), function()
  triggerClientEvent(source, "inventory-doThisFunctionIfConnectedToServer", source)
end)