--[[
X-MTA Gamemode
@author Pevo <pb.pb@onet.pl>
@copyright Pevo <pb.pb@onet.pl>
@license Dual GPLv3/MIT
]]--

local notifications = {}

if exports.gui then
  GUI = exports.gui
  zoom = GUI:zoom()
  sw, sh = GUI:screenSize()
  defaultFont = GUI:getConfigProperty("defaultFont")
else
  addEventHandler("onClientResourceStart", getRootElement(), function(res)
    if res:getName() ~= "gui" then return end
    GUI = exports.gui
    zoom = GUI:zoom()
    sw, sh = GUI:screenSize()
    defaultFont = GUI:getConfigProperty("defaultFont")
  end)
end

local isRendering

function addNotification(text, color, time, fontSize)
  if not color or not color[3] then color = {5, 60, 215} end
  if not time then time = 4000 end
  time = time + 400
  --outputChatBox(text, color[1], color[2], color[3], true)

  table.insert(notifications, {text = text, color = color, color2 = GUI:updateColorContrast(color, 0.25), font = (GUI:font(defaultFont, (fontSize or 10) / zoom, "light")), time = time, startTime = getTickCount(), endTime = getTickCount() + time})
  setRender(true)
end

addEvent("onClientAddNotification", true)
addEventHandler("onClientAddNotification", localPlayer, addNotification)

function renderAll()
  local ad = 0
  if not localPlayer:getData("uid") then
    ad = 280 / zoom
  end
  for i, v in pairs(notifications) do
    if v.endTime <= getTickCount() then
      table.remove(notifications, i)
      if #notifications < 1 then setRender(false) end
    else
      local anim = interpolateBetween(-442 / zoom, 0, 0, 0, 0, 0, (getTickCount() - v.startTime) / 400, "InOutBack")
      local anim2
      if v.endTime - getTickCount() <= 500 then
        anim2 = 200 - interpolateBetween(0, 0, 0, 200, 0, 0, (v.endTime - getTickCount()) / 500, "Linear")
      else
        anim2 = 0
      end

      --dxDrawRectangle((18 / zoom) + anim, sh - 362 / zoom, 4 / zoom, 60 / zoom, tocolor(v.color[1], v.color[2], v.color[3]), true)
      dxDrawRectangle((18 / zoom) + anim, sh - 366 / zoom - ((i - 1) * 80) + ad, 424 / zoom, 60 / zoom, tocolor(11, 12, 13, 200 - anim2), true)
      dxDrawRectangle((18 / zoom) + anim, sh - 306 / zoom - ((i - 1) * 80) + ad, (424 / zoom), 4 / zoom, tocolor(v.color2[1], v.color2[2], v.color2[3], 200 - anim2), true)
      dxDrawRectangle((18 / zoom) + anim, sh - 306 / zoom - ((i - 1) * 80) + ad, (424 / zoom) * math.max(math.min(((getTickCount() - v.startTime - 400) / (v.time - 400)), 1), 0), 4 / zoom, tocolor(v.color[1], v.color[2], v.color[3], 200 - anim2), true)
      if math.max(math.min(((getTickCount() - v.startTime - 400) / (v.time - 400)), 1), 0) ~= 0 then
        dxDrawText(v.text, (22 / zoom) + anim, (sh - 366 / zoom - ((i - 1) * 80) + ad) * 2, 420 / zoom, 60 / zoom, tocolor(240, 240, 240, 255 - anim2), 1, v.font, nil, "center", nil, true, true)
      end
    end
  end
end

function setRender(isRenderOn)
  if isRenderOn then
    if not isRendering then
      addEventHandler("onClientRender", root, renderAll)
      isRendering = true
    end
  else
    if isRendering then
      removeEventHandler("onClientRender", root, renderAll)
      isRendering = nil
    end 
  end
end