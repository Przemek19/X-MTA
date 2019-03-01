--[[
X-MTA Gamemode
@author Pevo <pb.pb@onet.pl>
@copyright Pevo <pb.pb@onet.pl>
@license Dual GPLv3/MIT
]]--

chat = {
  lettersCount = {2, 60},
  cooldown = 700,
}

addEventHandler("onPlayerChat", getRootElement(), function(m, t)
  cancelEvent()
  if t ~= 0 then return end
  if not source:getData("uid") then return end
  if source:getData("mute") then triggerClientEvent(source, "onClientAddNotification", source, "Posiadasz mute i nie możesz napisać wiadomości!", {220, 0, 20}) return end
  if string.len(m) < chat.lettersCount[1] or string.len(m) > chat.lettersCount[2] then
    triggerClientEvent(source, "onClientAddNotification", source, "Wiadomość zawiera nieprawidłową ilość znaków!", {220, 0, 20})
    return
  end
  if source:getData("chat_cooldown") and isTimer(source:getData("chat_cooldown")) then
    triggerClientEvent(source, "onClientAddNotification", source, "Piszesz za szybko! Odczekaj chwilę...", {220, 0, 20})
    source:setData("chat_cooldown", setTimer(function()end, chat.cooldown, 1))
    return
  end
  source:setData("chat_cooldown", setTimer(function()end, chat.cooldown, 1))

  triggerClientEvent(source, "core-chat-getPlayersFromClient", source, m)

  --outputChatBox(source:getName() .. "[" .. source:getID() .. "]: " .. m)
end)

addEvent("core-chat-sendMessageToServer", true)
addEventHandler("core-chat-sendMessageToServer", getRootElement(), function(m, playersToSend)
  for i, v in pairs(playersToSend) do
    outputChatBox(m, v, 255, 255, 255, true)
  end
end)