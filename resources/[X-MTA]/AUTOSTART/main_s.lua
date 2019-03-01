--[[
X-MTA Gamemode
@author Pevo <pb.pb@onet.pl>
@copyright Pevo <pb.pb@onet.pl>
@license Dual GPLv3/MIT
]]--

resourcesToStart = {
  "FILES",
  --"DATA",
  "DB",
  "gui",
  "core",
  "notification",
  "markers",
  "radar",
  "authorization",
  "inventory",
  "vehicles",
}

for _, v in pairs(resourcesToStart) do
  local resource = getResourceFromName(v)
  if resource then
    if resource:getState() ~= "running" then
      resource:start()
    end
  end
end