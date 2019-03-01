--[[
X-MTA Gamemode
@author Pevo <pb.pb@onet.pl>
@copyright Pevo <pb.pb@onet.pl>
@license Dual GPLv3/MIT
]]--

gui = {}
gui.elements = {}
gui.functions = {}
gui.globalFunctions = {}
gui.data = {}
gui.htmlContent = {}
gui.data.currentID = 0

gui.sw, gui.sh = guiGetScreenSize()
gui.zoom = 1920 / gui.sw

gui.color = {
  white = {255,255,255},
  black = {0,0,0},
  red = {255,0,0},
  green = {0,255,0},
  blue = {9,132,227},
  orange = {243,156,18},
  lightBlack = {44,46,49},
  lightPurple = {83, 82, 237},
}

gui.color.default = gui.color.blue

gui.config = {}
gui.config.functionsPrefix = "DXGUI"
gui.config.filesDIR = "./files/"
gui.config.imagesDIR = gui.config.filesDIR .. "images/"
gui.config.shadersDIR = gui.config.filesDIR .. "shaders/"
gui.config.fontsDIR = gui.config.filesDIR .. "fonts/"
gui.config.defaultFont = "Lato"
gui.config.defaultFontSize = 12
gui.config.postGUI = false
gui.config.defaultColor = {
  primary = gui.color.blue,
  background = {30,32,36,160},
  text = gui.color.white,
  border = gui.color.blue,
}
gui.config.defaultHTMLColor = {
  primary = gui.color.blue,
  background = {30,32,36,160},
  text = gui.color.black,
  ["border-color"] = gui.color.blue,
  selection = gui.color.blue,
  border = gui.color.blue,
  color = gui.color.white,
}
gui.config.windowBorderHeight = 26 / gui.zoom

gui.data.jsContent = [[
  var css = '||ALL_CSS||';
  var style = document.createElement('style');

  if (style.styleSheet) {
      style.styleSheet.cssText = css;
  } else {
      style.appendChild(document.createTextNode(css));
  }

  document.getElementsByTagName('head')[0].appendChild(style);
]]

gui.screenSource = dxCreateScreenSource(gui.sw, gui.sh)
dxUpdateScreenSource(gui.screenSource)

gui.createNewElement = function(elementType, data, resource)
  gui.data.currentID = gui.data.currentID + 1

  local element = Element("GUI")

  element:setID("GUI_" .. elementType .. "_" .. gui.data.currentID)
  table.insert(gui.elements, {id = gui.data.currentID, type = elementType, resource = (resource or getThisResource()), element = element, data = data})

  gui.setRenderStatus(true)

  for i, v in pairs(gui.config.defaultColor) do
    gui.globalFunctions.setColor(element, i, v)
  end

  gui.globalFunctions.setFont(element, gui.config.defaultFont)

  gui.globalFunctions.setPostGUI(element, gui.config.postGUI)

  return element
end

gui.isGUIElement = function(element)
  if not element or not isElement(element) then return false end
  return getElementType(element) == "GUI"
end

gui.getElementInfo = function(element)
  if not gui.isGUIElement(element) then return false end
  for i,v in pairs(gui.elements) do
    if v.element == element then return v, i end
  end
  return false
end

gui.getElementData = function(element)
  if not gui.isGUIElement(element) then return false end
  return gui.getElementInfo(element).data or false
end

gui.getElementIndex = function(element)
  if not gui.isGUIElement(element) then return false end
  for i,v in pairs(gui.elements) do
    if v.element == element then return i end
  end
  return false
end

gui.setElementInfo = function(element, name, value)
  if not gui.isGUIElement(element) then return false end
  gui.elements[gui.getElementIndex(element)][name] = value
end

gui.setElementData = function(element, name, value)
  if not gui.isGUIElement(element) then return false end
  gui.elements[gui.getElementIndex(element)].data[name] = value
end

gui.getElementID = function(element)
  if not gui.isGUIElement(element) then return false end
  return gui.getElementInfo(element).id or false
end

gui.getElementType = function(element)
  if not gui.isGUIElement(element) then return false end
  return split(element:getID(), "_")[2] or false
end

gui.getElementResource = function(element)
  if not gui.isGUIElement(element) then return false end
  return gui.getElementInfo(element).resource or false
end

gui.getElementBrowser = function(element)
  if not gui.isGUIElement(element) then return false end
  return gui.getElementInfo(element).browser or false
end

gui.isCursorInPosition = function(cx, cy, width, height)
  local x, y = getCursorPosition()
  x, y = (x or 0) * gui.sw, (y or 0) * gui.sh
  return (cx <= x and cy <= y and cx + width >= x and cy + height >= y) and isCursorShowing()
end

gui.tocolor = function(table)
  if not table or (not table[3] and not gui.color[table]) then return tocolor(gui.config.defaultColor[1], gui.config.defaultColor[2], gui.config.defaultColor[3], (gui.config.defaultColor[4] or 255)) end
  if gui.color[tostring(table)] then table = gui.color[tostring(table)] end
  return tocolor(table[1], table[2], table[3], (table[4] or 255))
end

gui.updateColorContrast = function(rgb, contrast, isColor)
  if not rgb or not rgb[3] then return false end
  if isColor then
    return tocolor(math.min(rgb[1] * contrast, 255), math.min(rgb[2] * contrast, 255), math.min(rgb[3] * contrast, 255), (rgb[4] or 255))
  else
    return {math.min(rgb[1] * contrast, 255), math.min(rgb[2] * contrast, 255), math.min(rgb[3] * contrast, 255), (rgb[4] or 255)}
  end
end

gui.getElementsWithBrowser = function()
  local elements = {}
  for i,v in pairs(gui.elements) do
    if v.browser then
      table.insert(elements, v.element)
    end
  end
  return elements
end

gui.isCursorInElement = function(element)
  if not gui.isGUIElement(element) then return false end
  local pos = gui.getElementData(element).position
  local size = gui.getElementData(element).size
  return gui.isCursorInPosition(pos[1], pos[2], size[1], size[2])
end

addEventHandler("onClientElementDestroy", getRootElement(), function()
  if not gui.isGUIElement(source) then return end
  if not gui.elements then return end
  if gui.getElementInfo(source).ceguiBrowser and isElement(gui.getElementInfo(source).ceguiBrowser) then gui.getElementInfo(source).ceguiBrowser:destroy() end
  if gui.getElementIndex(source) then table.remove(gui.elements, gui.getElementIndex(source)) end
  gui.setRenderStatus(not (#gui.elements < 1))
  gui.setHTMLRenderStatus(not (#gui.getElementsWithBrowser() < 1))
end)

addEventHandler("onClientResourceStop", getRootElement(), function(resource)
  local elementsToDestroy = {}
  for i,v in pairs(gui.elements) do
    if v.resource == resource then
      table.insert(elementsToDestroy, v.element)
    end
  end
  for i,v in pairs(elementsToDestroy) do
    v:destroy()
  end
end)

gui.loadHTMLCodeIntoFile = function(fileName, htmlCode)
  fileName = "html/" .. fileName .. ".html"
  local file
  if fileExists(fileName) then
    file = fileOpen(fileName)
    if htmlCode ~= fileRead(file, fileGetSize(file)) then
      fileClose(file)
      fileDelete(fileName)
      file = fileCreate(fileName)
      fileWrite(file, htmlCode)
      fileClose(file)
    else
      fileClose(file)
    end
  else
    file = fileCreate(fileName)
    fileWrite(file, htmlCode)
    fileClose(file)
  end

  return "http://mta/local/" .. fileName
end

gui.colorToHTMLColor = function(rgb)
  if not rgb or not rgb[3] then return false end
  return "rgba(" .. rgb[1] .. "," .. rgb[2] .. "," .. rgb[3] .. "," .. (rgb[4] or 255) / 255 .. ")"
end

gui.fontSizeToHTMLSize = function(size)
  return size .. "px"
end

gui.executeCSSToElementBrowser = function(element, css)
  if not gui.isGUIElement(element) then return false end
  local browser = gui.getElementBrowser(element)
  if not browser then return false end
  executeBrowserJavascript(browser, gui.data.jsContent:gsub("||ALL_CSS||", css))
end

gui.changeElementBrowserProperty = function(element, property, value)
  if not gui.isGUIElement(element) then return false end
  local browser = gui.getElementBrowser(element)
  if not browser then return false end
  executeBrowserJavascript(browser, "document.getElementById('" .. gui.getElementType(element) .. "')['" .. property .. "'] = " .. "'" .. value .. "'")
end

gui.changeElementBrowserCSS = function(element, property, value)
  if not gui.isGUIElement(element) then return false end
  local browser = gui.getElementBrowser(element)
  if not browser then return false end
  executeBrowserJavascript(browser, "document.getElementById('" .. gui.getElementType(element) .. "').style['" .. property .. "'] = " .. "'" .. value .. "'")
end

gui.getElementByBrowser = function(browser)
  for i,v in pairs(gui.elements) do
    if v.browser and v.browser == browser then return v.element end
  end
  return false
end

gui.createNewBrowserElement = function(elementType, data, htmlContent, px, py, width, height, resource, isGlobal, isDisabled)
  gui.data.currentID = gui.data.currentID + 1

  local element = Element("GUI")
  local ceguiBrowser = guiCreateBrowser(px, py, width, height, not isGlobal, true, false)
  if isDisabled then
    guiSetEnabled(ceguiBrowser, false)
  end
  guiSetAlpha(ceguiBrowser, 0)
  local browser = guiGetBrowser(ceguiBrowser)

  element:setID("GUI_" .. elementType .. "_" .. gui.data.currentID)
  table.insert(gui.elements, {id = gui.data.currentID, type = elementType, isGlobal = isGlobal, ceguiBrowser = ceguiBrowser, browser = browser, resource = (resource or getThisResource()), element = element, data = data})

  gui.globalFunctions.setColor(element, "browser", {255, 255, 255})

  addEventHandler("onClientBrowserCreated", browser, function()
    local element = gui.getElementByBrowser(source)
    local elementInfo = gui.getElementInfo(element)
    if element and elementInfo and not elementInfo.isGlobal then
      loadBrowserURL(source, gui.loadHTMLCodeIntoFile(elementInfo.type, gui.htmlContent[elementInfo.type]))
      addEventHandler("onClientBrowserDocumentReady", source, function()
        gui.loadBrowser(gui.getElementByBrowser(source))
      end)
    else
      gui.loadBrowser(gui.getElementByBrowser(source))
    end
	end)

  gui.setRenderStatus(true)
  gui.setHTMLRenderStatus(true)

  return element
end

gui.loadBrowser = function(element)
  local elementInfo = gui.getElementInfo(element)
  triggerEvent("on" .. gui.config.functionsPrefix .. "BrowserCreated", element, source)
  gui.setElementData(element, "isBrowserCreated", true)
  for i, v in pairs(gui.config.defaultHTMLColor) do
    gui.globalFunctions.setColor(element, i, v)
  end
  if elementInfo.data and elementInfo.data.size then gui.globalFunctions.setFont(element, gui.config.defaultFont, (elementInfo.data.size[2] or 0)/2, "regular") end
  gui.globalFunctions.setPostGUI(element, gui.config.postGUI)
  
  if elementInfo.data.changesToDo then
    for i,v in pairs(elementInfo.data.changesToDo) do
      if v.text then
        gui.globalFunctions.setText(element, v.text)
      elseif v.color then
        gui.globalFunctions.setColor(element, v.color.type, v.color.rgb)
      elseif v.radius then
        gui.globalFunctions.setBorderRadius(element, v.radius)
      elseif v.fontName or v.fontSize or v.fontWeight then
        gui.globalFunctions.setFont(element, v.fontName, v.fontSize, v.fontWeight)
      elseif v.masked then
        gui.globalFunctions.setMasked(element, v.masked)
      elseif v.placeholder then
        gui.globalFunctions.setPlaceholder(element, v.placeholder)
      elseif v.browserImage then
        gui.globalFunctions.setBrowserImage(element, v.browserImage)
      elseif v.browserUrl then
        gui.globalFunctions.setBrowserUrl(element, v.browserUrl)
      end
    end
    gui.setElementData(element, "changesToDo", nil)
  end
end

addEventHandler("onClientResourceStart", getRootElement(), function(resource)
  if resource ~= getThisResource() then return end
  addEventHandler("on" .. gui.config.functionsPrefix .. "BrowserCreated", createEditBox(0,0,0,0), function()
    source:destroy()
  end)
end)

addEventHandler("onClientClick", root, function(bttn, state, x, y)
  if #gui.elements < 1 then return end
  --[[for _, v in pairs(gui.elements) do
    if gui.isCursorInElement(v.element) and not v.data.isNotVisible then
      triggerEvent("on" .. gui.config.functionsPrefix .. "Click", v.element, bttn, state)
      break
    end
  end]]--

  for i = #gui.elements, 1, -1 do
    local v = gui.elements[i]
    if gui.isCursorInElement(v.element) and not v.data.isNotVisible then
      triggerEvent("on" .. gui.config.functionsPrefix .. "Click", v.element, bttn, state)
      break
    end   
  end
end)

addEvent("on" .. gui.config.functionsPrefix .. "Click", true)
addEvent("on" .. gui.config.functionsPrefix .. "BrowserCreated", true)