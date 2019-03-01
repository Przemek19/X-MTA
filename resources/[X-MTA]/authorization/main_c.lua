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

local serverColor = {9,132,227}

local logoPath = ":FILES/images/logo.png"

local sw, sh = guiGetScreenSize()
local cx, cy = sw / 2, sh / 2
local zoom = 1920 / sw
local zoom2 = 1080 / sh
local sound

local cooldownTime = 2400

local guiElements = {
  editbox = {},
  button = {},
  shader = {},
  label = {},
  images = {},
  rectangle = {},
}

function alert(text, color, size)
  triggerEvent("onClientAddNotification", localPlayer, text, color, nil, size or 24)
end

local function scale(x)
  return x / zoom2
end

local cameraX, cameraY = 2400, 2400
local soundBass = 0.1

local function changeCameraPosition()
  cameraX, cameraY = cameraX - 0.1 - soundBass * 0.1, cameraY - 0.1 - soundBass * 0.1
  setCameraMatrix(cameraX, cameraY, 400, cameraX + 1, cameraY + 1, 0)

  if sound then
    local soundFFT = getSoundFFTData(sound, 2048, 256)
    if soundFFT then
      soundBass = math.sqrt(soundFFT[1]) * 4
      if soundBass ~= soundBass or not tonumber(soundBass) then soundBass = 0.1 end
      GUI:setPosition(guiElements.images["logo2"], (cx - scale(512 * (340 / 512) / 2)) + soundBass, (cy - scale((128 + 292) * (340 / 512))) + soundBass)
      GUI:setPosition(guiElements.images["logo"], (cx - scale(512 * (340 / 512) / 2)) - soundBass, (cy - scale((128 + 292) * (340 / 512))) - soundBass)
      GUI:setColor(guiElements.images["shadow"], "image", {serverColor[1], serverColor[2], serverColor[3], soundBass * 12})
    end
  end
end

--[[local function animElementsPosition()
  if guiElements.rectangle["background"] then
    for i, v in pairs(guiElements) do
      if type(v) == "table" then
        for ii, vv in pairs(v) do
          if not GUI:getAnimation("authorizationGUI") then
            removeEventHandler("onClientRender", root, animElementsPosition)
          else
            if i == "label" and ii == "register" then
              GUI:setSize(vv, (scale(340) + cx - scale(170)) * GUI:getAnimation("authorizationGUI") / 2000)
            else
              GUI:setPosition(vv, (cx - GUI:getSize(vv)[1] / 2) * GUI:getAnimation("authorizationGUI") / 2000)
            end
          end
        end
      end
    end
  end
end]]--

local function createPanel()
  if not CORE or not GUI then
    addEventHandler("onClientResourceStart", getRootElement(), function(res)
      if res:getName() == "core" then CORE = exports.CORE createPanel() return end
      if res:getName() == "gui" then GUI = exports.GUI createPanel() return end
    end)
    return
  end

  showCursor(true)
  showChat(false)
  fadeCamera(true, 0)
  setPlayerHudComponentVisible("all", false)
  sound = playSound("music/authorization.mp3", true)
  setFogDistance(1000)
  setFarClipDistance(1000)
  setCloudsEnabled(false)

  --GUI:createAnimation("authorizationGUI", 0, 2000, 1500, "OutBounce", true)

  addEventHandler("onClientRender", root, changeCameraPosition)
  --addEventHandler("onClientRender", root, animElementsPosition)

  guiElements.shader["background"] = GUI:createShader("blackWhite", 0, 0, sw, sh)

  guiElements.rectangle["background"] = GUI:createRectangle(0, 0, sw, sh)
  GUI:setColor(guiElements.rectangle["background"], "primary", {11, 11, 11, 150})

  --guiElements.rectangle["window"] = GUI:createRectangle(cx - scale(190), cy - scale((128 + 292) * (340 / 512) + 20), scale(380), scale(560))
  --GUI:setColor(guiElements.rectangle["window"], "primary", {0, 0, 0, 50})
  --GUI:setBorder(guiElements.rectangle["window"], 1, "all")

  guiElements.images["shadow"] = GUI:createImage(0, 0, sw, sh, ":FILES/images/shadow.png")
  GUI:setColor(guiElements.images["shadow"], "image", {0, 0, 0, 0})

  guiElements.images["logo2"] = GUI:createImage(cx - scale(512 * (340 / 512) / 2), cy - scale((128 + 292) * (340 / 512)), scale(512 * (340 / 512)), scale(256 * (340 / 512)), logoPath)
  GUI:setColor(guiElements.images["logo2"], "image", {0, 0, 0, 80})

  guiElements.images["logo"] = GUI:createImage(cx - scale(512 * (340 / 512) / 2), cy - scale((128 + 292) * (340 / 512)), scale(512 * (340 / 512)), scale(256 * (340 / 512)), logoPath)
  GUI:setColor(guiElements.images["logo"], "image", "default")

  guiElements.editbox["login"] = GUI:createEditBox(cx - scale(170), cy - scale(25) - scale(35), scale(340), scale(50))
  GUI:setFont(guiElements.editbox["login"], nil, nil, "light")
  GUI:setPlaceholder(guiElements.editbox["login"], "Login...")
  GUI:setBorder(guiElements.editbox["login"], 1, "bottom")
  GUI:setBorderRadius(guiElements.editbox["login"], 2)

  guiElements.editbox["email"] = GUI:createEditBox(cx - scale(170), cy - scale(25) + scale(35), scale(340), scale(50))
  GUI:setFont(guiElements.editbox["email"], nil, nil, "light")
  GUI:setPlaceholder(guiElements.editbox["email"], "Email...")
  GUI:setBorder(guiElements.editbox["email"], 1, "bottom")
  GUI:setBorderRadius(guiElements.editbox["email"], 2)
  GUI:setVisible(guiElements.editbox["email"], false)

  guiElements.editbox["password"] = GUI:createEditBox(cx - scale(170), cy - scale(25) + scale(35), scale(340), scale(50))
  GUI:setFont(guiElements.editbox["password"], nil, nil, "light")
  GUI:setPlaceholder(guiElements.editbox["password"], "Hasło...")
  GUI:setMasked(guiElements.editbox["password"], true)
  GUI:setBorder(guiElements.editbox["password"], 1, "bottom")
  GUI:setBorderRadius(guiElements.editbox["password"], 2)

  guiElements.button["login"] = GUI:createButton(cx - scale(170), cy + scale(110), scale(340), scale(60), "Zaloguj się")
  GUI:setFont(guiElements.button["login"], nil, nil, "light")
  GUI:setBorderRadius(guiElements.button["login"], 3)

  guiElements.button["register"] = GUI:createButton(cx - scale(170), cy + scale(145) + scale(35), scale(340), scale(60), "Zarejestruj się")
  GUI:setFont(guiElements.button["register"], nil, nil, "light")
  GUI:setBorderRadius(guiElements.button["register"], 3)
  GUI:setVisible(guiElements.button["register"], false)

  guiElements.button["startRegister"] = GUI:createButton(cx - scale(100), cy + scale(190), scale(200), scale(28), "Rejestracja")
  GUI:setFont(guiElements.button["startRegister"], nil, scale(14), "light")
  GUI:setBorderRadius(guiElements.button["startRegister"], 3)
  GUI:setVisible(guiElements.button["startRegister"], true)

  guiElements.button["startLogging"] = GUI:createButton(cx - scale(100), cy + scale(260), scale(200), scale(28), "Logowanie")
  GUI:setFont(guiElements.button["startLogging"], nil, scale(14), "light")
  GUI:setBorderRadius(guiElements.button["startLogging"], 3)
  GUI:setVisible(guiElements.button["startLogging"], false)

  for i, v in pairs(guiElements.button) do
    GUI:setColor(v, "primary", {100, 100, 100, 160})
  end

  addEventHandler("onDXGUIClick", root, onDXGUIClickHandler)
end

function onDXGUIClickHandler(bttn, state)
  if not (bttn == "left" and state == "down") then return end
  if source == guiElements.button["startRegister"] then
    GUI:setVisible(guiElements.button["startRegister"], false)
    GUI:setVisible(guiElements.button["startLogging"], true)

    GUI:setVisible(guiElements.editbox["email"], true)
    GUI:setVisible(guiElements.button["login"], false)
    GUI:setVisible(guiElements.button["register"], true)

    GUI:setPosition(guiElements.editbox["password"], nil, cy - scale(25) + scale(105))
  elseif source == guiElements.button["startLogging"] then
    GUI:setVisible(guiElements.button["startLogging"], false)
    GUI:setVisible(guiElements.button["startRegister"], true)
    
    GUI:setVisible(guiElements.editbox["email"], false)
    GUI:setVisible(guiElements.button["login"], true)
    GUI:setVisible(guiElements.button["register"], false)
    GUI:setPosition(guiElements.editbox["password"], nil, cy - scale(25) + scale(35))
  elseif source == guiElements.button["login"] then
    initLogging()
  elseif source == guiElements.button["register"] then
    initRegister()
  end
end

addEventHandler("onClientResourceStart", getRootElement(), function(res)
  if res ~= getThisResource() then return end
  if localPlayer:getData("uid") then return false end
  createPanel()
end)

function destroyPanel()
  removeEventHandler("onClientRender", root, changeCameraPosition)
  if isEventHandlerAdded("onClientRender", root, animElementsPosition) then removeEventHandler("onClientRender", root, animElementsPosition) end
  if sound then sound:stop() sound = nil end
  showCursor(false)
  showChat(true)
  resetFogDistance()
  resetFarClipDistance()
  setCloudsEnabled(true)
  for i, v in pairs(guiElements) do
    for ii, vv in pairs(v) do
      vv:destroy()
    end
  end
  setCameraTarget(localPlayer)
  alert("Autoryzacja przebiegła pomyślnie!", {10, 220, 30}, 14)
  removeEventHandler("onDXGUIClick", root, onDXGUIClickHandler)
  guiElements = nil
end

addEvent("authorization-destroyPanel", true)
addEventHandler("authorization-destroyPanel", root, destroyPanel)

function checkLength(login, password, email)
  if string.len(login) < 3 then
    alert("Twój login jest za krótki!", {200, 30, 10})
    return false
  end
  if string.len(login) > 24 then
    alert("Twój login jest za długi!", {200, 30, 10})
    return false
  end

  if login:find("#") or login:find("<") or login:find(">") or login:find(":") or login:find("*") or login:find("{") or login:find("}") or login:find("\\") then
    alert("Twój login zawiera niedozwolone znaki!", {200, 30, 10}, 14)
    return false
  end

  if string.len(password) < 5 then
    alert("Twoje hasło jest za krótkie!", {200, 30, 10}, 14)
    return false
  end
  if string.len(password) > 100 then
    alert("Twoje hasło jest za długie!", {200, 30, 10})
    return false
  end

  if email then
    if string.len(email) < 5 or string.len(email) > 40 or not string.find(email, "@") or not string.find(email, ".", nil, true) then
      alert("Taki email nie istnieje!", {200, 30, 10})
      return false
    end
    if email:find("#") or email:find("<") or email:find(">") or email:find(":") or email:find("*") or email:find("{") or email:find("}") or email:find("\\") then
      alert("Twój email zawiera niedozwolone znaki!", {200, 30, 10}, 14)
      return false
    end
  end
  
  return true
end

function initLogging()
  if blockingTimer then alert("Klikasz za szybko! Zwolnij!", {220, 30, 10}) return false end
  blockingTimer = setTimer(function() blockingTimer = nil end, cooldownTime, 1)
  local login = GUI:getText(guiElements.editbox["login"])
  local password = GUI:getText(guiElements.editbox["password"])
  if not checkLength(login, password) then return false end
  if localPlayer:getData("uid") then return false end

  triggerServerEvent("authorization-logging", localPlayer, login, password)
end

function initRegister()
  if blockingTimer then alert("Klikasz za szybko! Zwolnij!", {220, 30, 10}) return false end
  blockingTimer = setTimer(function() blockingTimer = nil end, cooldownTime, 1)
  local login = GUI:getText(guiElements.editbox["login"])
  local email = GUI:getText(guiElements.editbox["email"])
  local password = GUI:getText(guiElements.editbox["password"])
  if not checkLength(login, password, email) then return false end
  if localPlayer:getData("uid") then return false end

  triggerServerEvent("authorization-register", localPlayer, login, email, password)
end



