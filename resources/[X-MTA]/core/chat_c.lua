--[[
X-MTA Gamemode
@author Pevo <pb.pb@onet.pl>
@copyright Pevo <pb.pb@onet.pl>
@license Dual GPLv3/MIT
]]--

local data = {}
data.localChatMaxPosition = 20

addEvent("core-chat-getPlayersFromClient", true)
addEventHandler("core-chat-getPlayersFromClient", getRootElement(), function(m)
  local x, y, z = getElementPosition(localPlayer)
  local x2, y2, z2

  local playersToSend = {}

  for i, v in pairs(getElementsByType("player")) do
    x2, y2, z2 = getElementPosition(v)
    if getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) <= data.localChatMaxPosition and v ~= localPlayer then
      table.insert(playersToSend, v)
    end
  end

  if #playersToSend > 0 then
    m = localPlayer:getName() .. " [" .. localPlayer:getID() .. "]: " .. m
    triggerServerEvent("core-chat-sendMessageToServer", localPlayer, m, playersToSend)
    outputChatBox(m, 255, 255, 255, true)
  else
    triggerEvent("onClientAddNotification", localPlayer, "Aktualnie żaden gracz nie znajduje się w pobliżu!")
  end

  playersToSend = nil
  x, y, z = nil
  x2, y2, z2 = nil

end)