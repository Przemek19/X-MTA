--[[
X-MTA Gamemode
@author Pevo <pb.pb@onet.pl>
@copyright Pevo <pb.pb@onet.pl>
@license Dual GPLv3/MIT
]]--

if exports.GUI then
  GUI = exports.GUI
else
  addEventHandler("onClientResourceStart", getRootElement(), function(res)
    if res:getName() ~= "gui" then return end
    GUI = exports.GUI
  end)
end

if exports.CORE then
  CORE = exports.CORE
else
  addEventHandler("onClientResourceStart", getRootElement(), function(res)
    if res:getName() ~= "core" then return end
    CORE = exports.CORE
  end)
end

local TIME_TO_NEXT_SERVER_RESPOND = 500
local SERVER_REQUEST = nil
local LAST_REQUEST = 0

local TIME_TO_NEXT_CLICK = TIME_TO_NEXT_SERVER_RESPOND
local lastClick = 0

local sw, sh = GUI:screenSize()
local zoom = 1080 / sh

local GUI_BORDER

local defaultFont = GUI:getConfigProperty("defaultFont")

local itemNameFont = GUI:font(defaultFont, 22 / zoom, "bold")
local itemInfoFont = GUI:font(defaultFont, 16 / zoom, "regular")
local itemDescriptionFont = GUI:font(defaultFont, 14 / zoom, "light")
local categoryFont = GUI:font(defaultFont, 16 / zoom, "light")
local buttonsFont = GUI:font(defaultFont, 14 / zoom, "light")

local primaryColor = GUI:getConfigProperty("defaultColor").primary
PRIMARY_COLOR = tocolor(primaryColor[1], primaryColor[2], primaryColor[3])
primaryColor = nil

SLOT_SIZE = SLOT_SIZE / zoom
SLOTS_MARGIN = SLOTS_MARGIN / zoom
SLOT_PADDING = SLOT_PADDING / zoom

FULL_SLOT_SIZE = SLOT_SIZE + SLOTS_MARGIN

--outputChatBox(FULL_SLOT_SIZE * INVENTORY_SIZE[2])

WINDOW_SIZE = {FULL_SLOT_SIZE * INVENTORY_SIZE[1] + SLOTS_MARGIN, FULL_SLOT_SIZE * INVENTORY_SIZE[2] + SLOTS_MARGIN}
--WINDOW_SIZE = {WINDOW_SIZE[1] / zoom, WINDOW_SIZE[2] / zoom}
WINDOW_POSITION = {sw / 2 -  WINDOW_SIZE[1] / 2, sh / 2 -  WINDOW_SIZE[2] / 2}

slotID = 1
for i = 1, INVENTORY_SIZE[2] do
  for ii = 1, INVENTORY_SIZE[1] do
    ITEMS_POSITIONS[slotID] = {WINDOW_POSITION[1] + (ii * (SLOTS_MARGIN + SLOT_SIZE)) - SLOT_SIZE, WINDOW_POSITION[2] + (i * (SLOTS_MARGIN + SLOT_SIZE)) - SLOT_SIZE}
    slotID = slotID + 1
  end
end
slotID = nil

EQ = {}

function isCursorInPosition(cx, cy, width, height)
  local x, y = getCursorPosition()
  x, y = (x or 0) * sw, (y or 0) * sh
  return (cx <= x and cy <= y and cx + width >= x and cy + height >= y) and isCursorShowing()
end

inventoryStatus = nil
clicks = 0
serverResponds = 0

bindKey("I", "down", function()
  if not localPlayer:getData("uid") then return end
  if CORE:getGlobalData(localPlayer, "EQ") then
    EQ = CORE:getGlobalData(localPlayer, "EQ")
  end

  doThisFunctionIfConnectedToServer(function()
    inventoryStatus = not inventoryStatus
    setInventoryStatus(inventoryStatus)
  end)

  --[[if not (lastClick + TIME_TO_NEXT_CLICK <= getTickCount()) then lastClick = getTickCount() triggerEvent("onClientAddNotification", localPlayer, "Klikasz za szybko! Zwolnij!", {222, 10, 32}, nil, 14) return end
  if clicks ~= serverResponds then triggerEvent("onClientAddNotification", localPlayer, "Poczekaj na odpowiedź od serwera!", {222, 10, 32}, 14) return end
  lastClick = getTickCount()
  clicks = clicks + 1
  triggerServerEvent("inventory-changeEQStatus->server", localPlayer)]]--
end)

--[[addEvent("inventory-changeEQStatus->client", true)
addEventHandler("inventory-changeEQStatus->client", localPlayer, function()
  serverResponds = serverResponds + 1
  inventoryStatus = not inventoryStatus
  setInventoryStatus(inventoryStatus)
end)]]--

cursorInSlot = nil

local functionToDO = {} --{func = func, arg = {...}}

function doThisFunctionIfConnectedToServer(func, ...)
  if not (LAST_REQUEST + TIME_TO_NEXT_SERVER_RESPOND <= getTickCount()) then LAST_REQUEST = getTickCount() triggerEvent("onClientAddNotification", localPlayer, "Używasz tego za szybko! Zwolnij!", {222, 10, 32}, nil, 14) return false end
  if SERVER_REQUEST then triggerEvent("onClientAddNotification", localPlayer, "Poczekaj na odpowiedź od serwera!", {222, 10, 32}, nil, 14) return false end
  SERVER_REQUEST = true
  LAST_REQUEST = getTickCount()
  functionToDO = {func = func, arg = arg}
  triggerServerEvent("inventory-doThisFunctionIfConnectedToServer", localPlayer)
end

addEvent("inventory-doThisFunctionIfConnectedToServer", true)
addEventHandler("inventory-doThisFunctionIfConnectedToServer", getRootElement(), function()
  functionToDO.func(functionToDO.arg)
  functionToDO = {}
  SERVER_REQUEST = false
end)

--[[
doThisFunctionIfConnectedToServer(function(table)
  outputChatBox(table[2])
end, 1, 2, 3)]]--

function refreshCursorInSlot()
  local r = false
  for i = 1, #ITEMS_POSITIONS do
    if isCursorInPosition(ITEMS_POSITIONS[i][1], ITEMS_POSITIONS[i][2], SLOT_SIZE, SLOT_SIZE) and EQ[i] then
      cursorInSlot = i
      r = true
      break
    end
  end
  if not r then cursorInSlot = nil end
end

ITEM_INFO_BOX_SIZE = {300 / zoom, 500 / zoom}
ITEM_INFO_BOX_POSITION = {- 320 / zoom, 0}

local guiElements = {}
guiElements.button = {}
guiElements.window = {}

function renderAll()
  refreshCursorInSlot()
  dxDrawRectangle(WINDOW_POSITION[1], WINDOW_POSITION[2], WINDOW_SIZE[1], WINDOW_SIZE[2], WINDOW_COLOR)
  for i, v in pairs(ITEMS_POSITIONS) do
    dxDrawRectangle(v[1], v[2], SLOT_SIZE, SLOT_SIZE, SLOT_COLOR)
    local slot = getSlotInfo(i)
    if slot then
      local item = getItemInfo(slot.itemID)
      dxDrawImage(v[1] + SLOT_PADDING, v[2] + SLOT_PADDING, SLOT_SIZE - SLOT_PADDING * 2, SLOT_SIZE - SLOT_PADDING * 2, TEX[item.img])
    end
  end
  if cursorInSlot and #guiElements.button.actions == 0 then
    local slotInfo = getSlotInfo(cursorInSlot)
    local itemInfo = getItemInfo(slotInfo.itemID)
    local cx, cy = getCursorPosition()
    cx, cy = cx * sw, cy * sh
    cx, cy = cx + 15, cy + 15

    local name = itemInfo.name
    local description = itemInfo.description
    description = description:gsub("||SUBTYPE||", slotInfo.subtype)
    local count = slotInfo.count
    local category = itemInfo.category

    -- ITEM_INFO_BOX_POSITION[1]
    -- ITEM_INFO_BOX_POSITION[2]

    -- + ITEM_INFO_BOX_POSITION[1]
    -- + ITEM_INFO_BOX_POSITION[2]

    dxDrawRectangle(cx - 10 / zoom - 2 + ITEM_INFO_BOX_POSITION[1], cy - 10 + ITEM_INFO_BOX_POSITION[2], 2, ITEM_INFO_BOX_SIZE[2] + 20 / zoom, PRIMARY_COLOR)
    dxDrawRectangle(cx - 10 / zoom + ITEM_INFO_BOX_POSITION[1], cy - 10 + ITEM_INFO_BOX_POSITION[2], ITEM_INFO_BOX_SIZE[1] + 20 / zoom, ITEM_INFO_BOX_SIZE[2] + 20 / zoom, WINDOW_COLOR)
    dxDrawRectangle(cx - 10 / zoom + ITEM_INFO_BOX_POSITION[1], cy - 10 + ITEM_INFO_BOX_SIZE[1] / 2 + 20 / zoom + ITEM_INFO_BOX_POSITION[2], ITEM_INFO_BOX_SIZE[1] + 20 / zoom, ITEM_INFO_BOX_SIZE[2] - ITEM_INFO_BOX_SIZE[1] / 2, SLOT_COLOR)

    dxDrawImage(cx + ITEM_INFO_BOX_SIZE[1] / 4 + ITEM_INFO_BOX_POSITION[1], cy + ITEM_INFO_BOX_POSITION[2], ITEM_INFO_BOX_SIZE[1] / 2, ITEM_INFO_BOX_SIZE[1] / 2, TEX[itemInfo.img])

    dxDrawText(name, cx + 1 + ITEM_INFO_BOX_POSITION[1], cy + ITEM_INFO_BOX_SIZE[1] / 2  + 20 / zoom + 1 + ITEM_INFO_BOX_POSITION[2], ITEM_INFO_BOX_SIZE[1], ITEM_INFO_BOX_SIZE[2], tocolor(0, 0, 0), 1, itemNameFont, nil, nil, nil, true)
    dxDrawText(name, cx + ITEM_INFO_BOX_POSITION[1], cy + ITEM_INFO_BOX_SIZE[1] / 2 + 20 / zoom + ITEM_INFO_BOX_POSITION[2], ITEM_INFO_BOX_SIZE[1], ITEM_INFO_BOX_SIZE[2], PRIMARY_COLOR, 1, itemNameFont, nil, nil, nil, true)
    dxDrawText("Ilość: " .. count, cx + 1 + ITEM_INFO_BOX_POSITION[1], cy + ITEM_INFO_BOX_POSITION[2] + dxGetFontHeight(1, itemNameFont) + 30 + ITEM_INFO_BOX_SIZE[1] / 2 + 1, ITEM_INFO_BOX_SIZE[1], ITEM_INFO_BOX_SIZE[2], tocolor(0, 0, 0), 1, itemInfoFont, nil, nil, nil, true)
    dxDrawText("Ilość: " .. count, cx + ITEM_INFO_BOX_POSITION[1], cy + ITEM_INFO_BOX_POSITION[2] + dxGetFontHeight(1, itemNameFont) + 30 + ITEM_INFO_BOX_SIZE[1] / 2, ITEM_INFO_BOX_SIZE[1], ITEM_INFO_BOX_SIZE[2], PRIMARY_COLOR, 1, itemInfoFont, nil, nil, nil, true)

    dxDrawText("(" .. category .. ")", cx + ITEM_INFO_BOX_POSITION[1] + 1, cy + ITEM_INFO_BOX_POSITION[2] + dxGetFontHeight(1, itemNameFont) + dxGetFontHeight(1, itemInfoFont) + 40 + ITEM_INFO_BOX_SIZE[1] / 2 + 1, ITEM_INFO_BOX_SIZE[1], ITEM_INFO_BOX_SIZE[2], tocolor(0, 0, 0), 1, categoryFont, nil, nil, nil, true)
    dxDrawText("(" .. category .. ")", cx + ITEM_INFO_BOX_POSITION[1], cy + ITEM_INFO_BOX_POSITION[2] + dxGetFontHeight(1, itemNameFont) + dxGetFontHeight(1, itemInfoFont) + 40 + ITEM_INFO_BOX_SIZE[1] / 2, ITEM_INFO_BOX_SIZE[1], ITEM_INFO_BOX_SIZE[2], PRIMARY_COLOR, 1, categoryFont, nil, nil, nil, true)

    dxDrawText(description .. "\n\n#888888(Kliknij na przedmiot, aby \nzobaczyć możliwe opcje)", cx + ITEM_INFO_BOX_POSITION[1] + 1, cy + ITEM_INFO_BOX_POSITION[2] + 1 + dxGetFontHeight(1, itemNameFont) + dxGetFontHeight(1, itemInfoFont) + dxGetFontHeight(1, categoryFont) + 50 + ITEM_INFO_BOX_SIZE[1] / 2, ITEM_INFO_BOX_SIZE[1], ITEM_INFO_BOX_SIZE[2], tocolor(0, 0, 0), 1, itemDescriptionFont, nil, nil, nil, true, nil, true)
    dxDrawText(description .. "\n\n#888888(Kliknij na przedmiot, aby \nzobaczyć możliwe opcje)", cx + ITEM_INFO_BOX_POSITION[1], cy + ITEM_INFO_BOX_POSITION[2] + dxGetFontHeight(1, itemNameFont) + dxGetFontHeight(1, itemInfoFont) + dxGetFontHeight(1, categoryFont) + 50 + ITEM_INFO_BOX_SIZE[1] / 2, ITEM_INFO_BOX_SIZE[1], ITEM_INFO_BOX_SIZE[2], tocolor(255, 255, 255), 1, itemDescriptionFont, nil, nil, nil, true, nil, true)

  end
end
--addEventHandler("onClientRender", root, renderAll)

function setInventoryStatus(status)
  setRender(status)
  if status then
    addEventHandler("onClientClick", root, onClick)
    showCursor(true)
    destroyElements(guiElements.button.actions)
    guiElements.button.actions = {}
    guiElements.window = GUI:createWindow(WINDOW_POSITION[1], WINDOW_POSITION[2] - GUI:getConfigProperty("windowBorderHeight"), WINDOW_SIZE[1], 0)
    GUI:setText(guiElements.window, "Ekwipunek")
  else
    removeEventHandler("onClientClick", root, onClick)
    showCursor(false)
    destroyElements(guiElements.button.actions)
    destroyElements(guiElements)
    guiElements.button.actions = {}
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

function destroyElements(table)
  for i, v in pairs(table) do
    if isElement(v) then
      v:destroy()
    end
  end
end

guiElements.button.actions = {}

function isClickedOnActionButton(x, y)
  for i, v in pairs(guiElements.button.actions) do
    if isElement(v) then
      local position = GUI:getPosition(v)
      local size = GUI:getSize(v)
      if isCursorInPosition(position[1], position[2], size[1], size[2]) then
        return true
      end
    else
      table.remove(guiElements.button.actions, i)
    end
  end
  return false
end

function onClick(bttn, state, x, y)
  if bttn ~= "left" or state ~= "down" then return end
  if isClickedOnActionButton(x, y) then destroyElements(guiElements.button.actions) guiElements.button.actions = {} return end
  destroyElements(guiElements.button.actions)
  guiElements.button.actions = {}
  for i, v in pairs(ITEMS_POSITIONS) do
    if isCursorInPosition(v[1], v[2], SLOT_SIZE, SLOT_SIZE) then
      -- i - CLICKED SLOT
      if not getSlotInfo(i) then return end
      local itemInfo = getItemInfo(getSlotInfo(i).itemID)

      if itemInfo.actions then

        for ii, vv in pairs(itemInfo.actions) do
          guiElements.button.actions[#guiElements.button.actions + 1] = GUI:createButton(x - dxGetTextWidth(vv, 1, GUI:font(defaultFont, 14 / zoom, "light")) / 2 - 10, (y + 1) + ((ii - 1) * 44), dxGetTextWidth(vv, 1, GUI:font(defaultFont, 14 / zoom, "light")) + 20, 32 / zoom, vv)
          GUI:setFont(guiElements.button.actions[#guiElements.button.actions], defaultFont, 14 / zoom, "light")
          GUI:setBorderRadius(guiElements.button.actions[#guiElements.button.actions], 4)
          addEventHandler("onDXGUIClick", guiElements.button.actions[#guiElements.button.actions], function(button, state)
            if bttn ~= "left" or state ~= "down" then return end
            if vv == DROP_NAME then
              dropItem(i)
            else
              doThisFunctionIfConnectedToServer(function(table)
                triggerEvent("onInventoryActionClick", localPlayer, table[1], table[2], table[3])
                if table[1].expandable then
                  takeItemFromSlot(i, 1)
                end               
              end, itemInfo, getSlotInfo(i), vv)
            end
          end)
        end

      end
      break
    end
  end
end

addEvent("onInventoryActionClick", true)