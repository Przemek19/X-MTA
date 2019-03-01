--[[
X-MTA Gamemode
@author Pevo <pb.pb@onet.pl>
@copyright Pevo <pb.pb@onet.pl>
@license Dual GPLv3/MIT
]]--

function refreshEQ()
  CORE:setGlobalData(localPlayer, "EQ", EQ)
end

function getSlotInfo(slot)
  if not EQ[slot] then return false end
  return {itemID = EQ[slot].id, count = EQ[slot].count, subtype = EQ[slot].subtype, category = EQ[slot].category}
end

function getItemInfo(id)
  for i, v in pairs(items) do
    if id == v.id then return v end
  end
end

function getItemIndex(id)
  for i, v in pairs(items) do
    if id == v.id then return i end
  end
end

function takeItemFromSlot(slot, count)
  local slotInfo = getSlotInfo(slot)
  if not slotInfo then return false end
  if slotInfo.count > 1 then
    EQ[slot].count = EQ[slot].count - 1
  elseif slotInfo.count == 1 then
    EQ[slot] = nil
  end
  refreshEQ()
  return true
end

function __dropItem(slot)
  --TODO: Wyrzucanie przedmiotów z EQ
  outputChatBox("Wyrzucanie: " .. slot)
end

function dropItem(slot)
  doThisFunctionIfConnectedToServer(function(table)
    __dropItem(table[1])             
  end, slot)
end

function getEmptySlot()
  for i = 1, #ITEMS_POSITIONS do
    if not EQ[i] then return i end
  end
  return false
end

function getAllEmptySlots()
  local emptySlots = {}
  for i = 1, #ITEMS_POSITIONS do
    if not EQ[i] then table.insert(emptySlots, i) end
  end
  if #emptySlots == 0 then return false end
  return emptySlots
end

function getSlotsWithThisItem(id, subtype)
  --subtype = subtype or 0
  local slots = {}
  for i, v in pairs(EQ) do
    local slotInfo = getSlotInfo(i)
    if slotInfo.itemID == id and (not subtype or subtype == slotInfo.subtype) then
      table.insert(slots, i)
    end
  end
  if #slots == 0 then return false end
  return slots
end

function getSlotEmptyCount(slot)
  local slotInfo = getSlotInfo(slot)
  if not slotInfo then return false end
  local itemInfo = getItemInfo(slotInfo.itemID)
  if not itemInfo then return false end
  return itemInfo.maxInStack - slotInfo.count
end

function giveItem(id, count, subtype)
  count = math.ceil(count or 1)
  local itemInfo = getItemInfo(id)
  --subtype = subtype or 0
  local slotsWithThisItem = getSlotsWithThisItem(id, subtype)

  local itemsToGive = count

  -- TODO: Sprawdzenie wagi

  if slotsWithThisItem then -- JEŚLI SĄ SLOTY Z TYM ITEMEM
    for i, v in pairs(slotsWithThisItem) do
      local emptyCount = getSlotEmptyCount(v)

      if emptyCount > 0 then -- JEŚLI W TYM SLOCIE JEST JESZCZE MIEJSCE
        if emptyCount >= itemsToGive then -- JEŚLI ITEMÓW DO DANIA JEST MNIEJ LUB TYLE SAMO ILE WOLNEGO MIEJSCA
          EQ[v].count = itemsToGive + EQ[v].count
          itemsToGive = 0
          break
        else -- JEŚLI W TYM SLOCIE JEST TROCHĘ MIEJSCA
          EQ[v].count = EQ[v].count + emptyCount
          itemsToGive = itemsToGive - emptyCount
        end

      end

    end

  end

  if itemsToGive > 0 then -- JEŻELI JESZCZE TRZEBA DAĆ ITEMY
    if getAllEmptySlots() then
      for i, v in pairs(getAllEmptySlots()) do
        if itemsToGive > itemInfo.maxInStack then -- JEŚLI ITEMÓW DO DANIA JEST WIĘCEJ NIŻ MIEŚCI SLOT
          EQ[v] = {id = id, count = itemInfo.maxInStack, subtype = subtype or 0}
          itemsToGive = itemsToGive - itemInfo.maxInStack
        else -- JEŚLI ITEMÓW DO DANIA JEST MNIEJ NIŻ MIEŚCI SLOT
          EQ[v] = {id = id, count = itemsToGive, subtype = subtype or 0}
          itemsToGive = 0
          break
        end
      end
    end
  end

  refreshEQ()

  if itemsToGive == 0 then return true else return false, itemsToGive end

end

function takeItem(id, count, subtype)
  if not id then return false end
  count = math.ceil(count or 1)
  local itemsToTake = count

  for i = #ITEMS_POSITIONS, 1, -1 do
    local slotInfo = getSlotInfo(i)
    if slotInfo then -- JEŚLI W TYM SLOCIE COŚ JEST
      if slotInfo.itemID == id then -- JEŚLI W TYM SLOCIE JEST PRZEDMIOT Z TAKIM SAMYM ID
        if (not subtype or subtype == slotInfo.subtype) then -- JEŚLI NIE MA PODTYPU LUB PODTYP JEST TAKI SAM JAK W SLOCIE
          if slotInfo.count == itemsToTake then -- JEŚLI ITEMÓW DO ZABRANIA JEST TYLE SAMO CO W SLOCIE
            EQ[i] = nil
            itemsToTake = 0
            break
          elseif slotInfo.count < itemsToTake then -- JEŚLI ITEMÓW DO ZABRANIA JEST WIĘCEJ NIŻ W SLOCIE
            itemsToTake = itemsToTake - slotInfo.count
            EQ[i] = nil
          elseif slotInfo.count > itemsToTake then -- JEŚLI ITEMÓW DO ZABRANIA JEST MNIEJ NIŻ W SLOCIE
            EQ[i].count = EQ[i].count - itemsToTake
            itemsToTake = 0
            break
          end
        end
      end
    end
  end

  refreshEQ()

  if itemsToTake == 0 then return true else return false, itemsToTake end
end

function getItem(id, count, subtype)
  count = math.ceil(count or 1)
  local allCount = 0
  for i = #ITEMS_POSITIONS, 1, -1 do
    local slotInfo = getSlotInfo(i)
    if slotInfo then -- JEŚLI W TYM SLOCIE COŚ JEST
      if slotInfo.itemID == id then -- JEŚLI ID JEST TAKIE SAME
        if (not subtype or subtype == slotInfo.subtype) then -- JEŚLI NIE MA PODTYPU LUB PODTYP JEST TAKI SAM JAK W SLOCIE
          allCount = allCount + slotInfo.count
        end
      end
    end
  end
  if allCount == 0 then return false, count - allCount end
  if allCount < count then return false, count - allCount end
  return true, allCount
end