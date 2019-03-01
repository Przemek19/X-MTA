--[[
X-MTA Gamemode
@author Pevo <pb.pb@onet.pl>
@copyright Pevo <pb.pb@onet.pl>
@license Dual GPLv3/MIT
]]--

GUI = exports.GUI

local colors = GUI:getConfigProperty("defaultColor")
colors.primary = CONFIG["ServerColor"]
colors.border = CONFIG["ServerColor"]
GUI:setConfigProperty("defaultColor", colors)

local colors = GUI:getConfigProperty("defaultHTMLColor")
colors.primary = CONFIG["ServerColor"]
colors.border = CONFIG["ServerColor"]
colors.selection = CONFIG["ServerColor"]
GUI:setConfigProperty("defaultHTMLColor", colors)
colors = nil

function getServerConfig(name)
  return CONFIG[name] or false
end