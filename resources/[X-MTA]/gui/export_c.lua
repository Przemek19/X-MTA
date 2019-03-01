--[[
X-MTA Gamemode
@author Pevo <pb.pb@onet.pl>
@copyright Pevo <pb.pb@onet.pl>
@license Dual GPLv3/MIT
]]--

local prefix = gui.config.functionsPrefix or ""

for i,v in pairs(gui.functions) do
  if type(v) == "function" then
    _G[i] = v --_G[prefix..i] = v
    --outputChatBox('<export function="' .. prefix .. i .. '" type="client" />')
    --outputChatBox('<export function="' .. i .. '" type="client" />')
  end
end

for i,v in pairs(gui.globalFunctions) do
  if type(v) == "function" then
    _G[i] = v
    --outputChatBox('<export function="' .. i .. '" type="client" />')
  end
end

prefix = nil