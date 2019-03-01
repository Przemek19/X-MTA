--[[
X-MTA Gamemode
@author Pevo <pb.pb@onet.pl>
@copyright Pevo <pb.pb@onet.pl>
@license Dual GPLv3/MIT
]]--

DB = exports.DB

function encrypt(text)
  return md5("5289#J8jd9211209#(#(&c$%ddjd3479283" .. text .. "dh2378dh23879u2h398U*(udj82")
end

function getServerConfig(name)
  return CONFIG[name] or false
end