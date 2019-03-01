--[[
X-MTA Gamemode
@author Pevo <pb.pb@onet.pl>
@copyright Pevo <pb.pb@onet.pl>
@license Dual GPLv3/MIT
]]--

gui.globalFunctions = {
  scale = function(x)
    return x / gui.zoom
  end,

  setPosition = function(element, px, py)
    if not gui.isGUIElement(element) then return false end
    if px then
      gui.elements[gui.getElementIndex(element)].data.position[1] = px
    end
    if py then
      gui.elements[gui.getElementIndex(element)].data.position[2] = py
    end
    if gui.getElementBrowser(element) then
      guiSetPosition(gui.getElementInfo(element).ceguiBrowser, gui.elements[gui.getElementIndex(element)].data.position[1], gui.elements[gui.getElementIndex(element)].data.position[2], false)
    end
  end,

  setSize = function(element, sx, sy)
    if not gui.isGUIElement(element) then return false end
    if sx then
      gui.elements[gui.getElementIndex(element)].data.size[1] = sx
    end
    if sy then
      gui.elements[gui.getElementIndex(element)].data.size[2] = sy
    end
    if gui.getElementBrowser(element) then
      guiSetSize(gui.getElementInfo(element).ceguiBrowser, gui.elements[gui.getElementIndex(element)].data.size[1], gui.elements[gui.getElementIndex(element)].data.size[2], false)
    end
  end,

  getPosition = function(element)
    if not gui.isGUIElement(element) then return false end
    return gui.elements[gui.getElementIndex(element)].data.position
  end,

  getSize = function(element)
    if not gui.isGUIElement(element) then return false end
    return gui.elements[gui.getElementIndex(element)].data.size
  end,

  setColor = function(element, type, rgb)
    if not gui.isGUIElement(element) then return false end
    type = type or "primary"
    if not gui.elements[gui.getElementIndex(element)].data.color then gui.elements[gui.getElementIndex(element)].data.color = {} end
    if not gui.elements[gui.getElementIndex(element)].data.colortable then gui.elements[gui.getElementIndex(element)].data.colortable = {} end
    
    if not rgb then rgb = gui.config.defaultColor end

    gui.elements[gui.getElementIndex(element)].data.color[type] = gui.tocolor(rgb)
    gui.elements[gui.getElementIndex(element)].data.colortable[type] = rgb

    if gui.getElementBrowser(element) then
      if gui.getElementInfo(element).isGlobal then return false end
      if gui.getElementData(element).isBrowserCreated then
        if type == "selection" then
          gui.executeCSSToElementBrowser(element, "::selection { background: " .. gui.colorToHTMLColor(rgb) .. "; }")
        else
          gui.changeElementBrowserCSS(element, type, gui.colorToHTMLColor(rgb))
        end
      else
        local changes = gui.getElementData(element).changesToDo or {}
        table.insert(changes, {color = {type = type, rgb = rgb}})
        gui.setElementData(element, "changesToDo", changes)
      end
    end
  end,

  getColor = function(element, type, isTable)
    if not gui.isGUIElement(element) then return false end
    type = type or "primary"
    if not isTable then
      if not gui.elements[gui.getElementIndex(element)].data.color then return false end
      return gui.elements[gui.getElementIndex(element)].data.color[type] or false
    else
      if not gui.elements[gui.getElementIndex(element)].data.colortable then return false end
      return gui.elements[gui.getElementIndex(element)].data.colortable[type] or false    
    end
  end,

  setBorderRadius = function(element, px)
    if not gui.isGUIElement(element) then return false end
    if px == 0 or not px then
      gui.setElementData(element, "borderRadius", nil)
      if gui.getElementBrowser(element) then
        if gui.getElementInfo(element).isGlobal then return false end
        if gui.getElementData(element).isBrowserCreated then
          gui.changeElementBrowserCSS(element, "border-radius", 0)
        else
          local changes = gui.getElementData(element).changesToDo or {}
          table.insert(changes, {radius = px})
          gui.setElementData(element, "changesToDo", changes)
        end
      end
    else
      gui.setElementData(element, "borderRadius", tonumber(px))
      if gui.getElementBrowser(element) then
        if gui.getElementInfo(element).isGlobal then return false end
        if gui.getElementData(element).isBrowserCreated then
          gui.changeElementBrowserCSS(element, "border-radius", px .. "px")
        else
          local changes = gui.getElementData(element).changesToDo or {}
          table.insert(changes, {radius = px})
          gui.setElementData(element, "changesToDo", changes)
        end
      end
    end
  end,

  setText = function(element, text)
    if not gui.isGUIElement(element) then return false end
    gui.setElementData(element, "text", tostring(text))
    if gui.getElementBrowser(element) then
      if gui.getElementInfo(element).isGlobal then return false end
      if gui.getElementData(element).isBrowserCreated then
        gui.changeElementBrowserProperty(element, "value", text)
      else
        local changes = gui.getElementData(element).changesToDo or {}
        table.insert(changes, {text = text})
        gui.setElementData(element, "changesToDo", changes)
      end
    end
  end,

  getText = function(element)
    if not gui.isGUIElement(element) then return false end
    return gui.getElementData(element).text or false
  end,

  setFont = function(element, name, size, weight)
    if not gui.isGUIElement(element) then return false end
    if not gui.elements[gui.getElementIndex(element)].data.font then gui.elements[gui.getElementIndex(element)].data.font = {} end
    if name then
      gui.elements[gui.getElementIndex(element)].data.font.name = name
    end
    if size then
      gui.elements[gui.getElementIndex(element)].data.font.size = size
    end
    if weight then
      gui.elements[gui.getElementIndex(element)].data.font.weight = weight
    end
    if gui.getElementBrowser(element) then
      if gui.getElementInfo(element).isGlobal then return false end
      if gui.getElementData(element).isBrowserCreated then
        local fontInfo = gui.elements[gui.getElementIndex(element)].data.font
        if fontInfo.name then
          gui.executeCSSToElementBrowser(element, "@font-face { font-family: font; src: url(../files/fonts/" .. fontInfo.name .. "/" .. (fontInfo.weight or "regular") .. ".ttf); }")
          gui.changeElementBrowserCSS(element, "font-face", "font")
        end
        if fontInfo.size then
          gui.changeElementBrowserCSS(element, "font-size", fontInfo.size .. "px")
        end
        if fontInfo.weight then
          if fontInfo.weight == "light" then
            gui.changeElementBrowserCSS(element, "font-weight", 300)
          end
          if fontInfo.weight == "regular" then
            gui.changeElementBrowserCSS(element, "font-weight", 400)
          end
          if fontInfo.weight == "bold" then
            gui.changeElementBrowserCSS(element, "font-weight", 500)
          end
        end

      else
        local changes = gui.getElementData(element).changesToDo or {}

        local fontInfo = gui.elements[gui.getElementIndex(element)].data.font
        if fontInfo.name then
          table.insert(changes, {fontName = fontInfo.name})
        end
        if fontInfo.size then
          table.insert(changes, {fontSize = fontInfo.size})
        end
        if fontInfo.weight then
          table.insert(changes, {fontWeight = fontInfo.weight})
        end

        gui.setElementData(element, "changesToDo", changes)

      end
    end
  end,

  setPostGUI = function(element, bool)
    if not gui.isGUIElement(element) then return false end
    gui.setElementData(element, "postGUI", bool)
  end,

  setBorder = function(element, px, type)
    if not gui.isGUIElement(element) then return false end
    if not type then type = "all" end
    if not gui.elements[gui.getElementIndex(element)].data.border then gui.elements[gui.getElementIndex(element)].data.border = {} end
    if px == 0 or not px then
      px = nil
    end
    if type == "all" then
      gui.elements[gui.getElementIndex(element)].data.border["top"] = px
      gui.elements[gui.getElementIndex(element)].data.border["bottom"] = px
      gui.elements[gui.getElementIndex(element)].data.border["left"] = px
      gui.elements[gui.getElementIndex(element)].data.border["right"] = px
    else
      gui.elements[gui.getElementIndex(element)].data.border[type] = px
    end
  end,

  setColorCoded = function(element, bool)
    if not gui.isGUIElement(element) then return false end
    gui.setElementData(element, "colorCoded", bool)
  end,

  setWordBreak = function(element, bool)
    if not gui.isGUIElement(element) then return false end
    gui.setElementData(element, "wordBreak", bool)
  end,

  setConfigProperty = function(property, value)
    gui.config[property] = value
  end,

  getConfigProperty = function(property)
    return gui.config[property] or nil
  end,

  changeBrowserCSS = gui.changeElementBrowserCSS,

  executeCSSToBrowser = gui.executeCSSToElementBrowser,

  setMasked = function(element, isMasked)
    if not gui.isGUIElement(element) then return false end
    if gui.getElementInfo(element).isGlobal then return false end
    if gui.getElementData(element).isBrowserCreated then
      if isMasked then
        executeBrowserJavascript(gui.getElementBrowser(element), "document.getElementById('editbox').type='password'")
      else
        executeBrowserJavascript(gui.getElementBrowser(element), "document.getElementById('editbox').type='text'")
      end
    else
      local changes = gui.getElementData(element).changesToDo or {}
      table.insert(changes, {masked = isMasked})
      gui.setElementData(element, "changesToDo", changes)
    end
  end,

  setPlaceholder = function(element, text)
    if not gui.isGUIElement(element) then return false end
    if gui.getElementInfo(element).isGlobal then return false end
    if gui.getElementData(element).isBrowserCreated then
      executeBrowserJavascript(gui.getElementBrowser(element), "document.getElementById('editbox').placeholder='" .. text .. "'")
    else
      local changes = gui.getElementData(element).changesToDo or {}
      table.insert(changes, {placeholder = text})
      gui.setElementData(element, "changesToDo", changes)
    end
  end,

  setVisible = function(element, isVisible)
    if not gui.isGUIElement(element) then return false end
    gui.setElementData(element, "isNotVisible", not isVisible)
    if gui.getElementBrowser(element) then
      guiSetEnabled(gui.getElementInfo(element).ceguiBrowser, isVisible)
    end
  end,

  getVisible = function(element)
    if not gui.isGUIElement(element) then return false end
    return not gui.getElementData(element).isNotVisible or false
  end,

  getStatus = function(element)
    if not gui.isGUIElement(element) then return false end
    return gui.getElementData(element).status or false   
  end,

  setStatus = function(element, status)
    if not gui.isGUIElement(element) then return false end
    gui.setElementData(element, "status", status or false) 
  end,

  RGBToHex = function(table)
    if table[4] then
      return string.format("#%.2X%.2X%.2X%.2X", table[1], table[2], table[3], table[4])
    else
      return string.format("#%.2X%.2X%.2X", table[1], table[2], table[3])
    end
  end,

  font = function(name, size, weight)
    return gui.getFont(name, size, weight)
  end,

  zoom = function()
    return gui.zoom
  end,

  screenSize = function()
    return gui.sw, gui.sh
  end,

  updateColorContrast = function(rgb, contrast, isColor)
    return gui.updateColorContrast(rgb, contrast, isColor)
  end,

  setBrowserImage = function(element, path)
    if not gui.isGUIElement(element) then return false end
    if gui.getElementInfo(element).isGlobal then return false end
    if gui.getElementData(element).isBrowserCreated then
      executeBrowserJavascript(gui.getElementBrowser(element), "document.body.style.background = 'url(http://mta/local/" .. path .. ")'")
      executeBrowserJavascript(gui.getElementBrowser(element), "document.body.style['background-size'] = '100% 100%'")
    else
      local changes = gui.getElementData(element).changesToDo or {}
      table.insert(changes, {browserImage = path})
      gui.setElementData(element, "changesToDo", changes)
    end
  end,
  setBrowserUrl = function(element, url)
    if not gui.isGUIElement(element) then return false end
    if gui.getElementData(element).isBrowserCreated then
      loadBrowserURL(gui.getElementInfo(element).browser, url)
    else
      local changes = gui.getElementData(element).changesToDo or {}
      table.insert(changes, {browserUrl = url})
      gui.setElementData(element, "changesToDo", changes)
    end
  end,
  addButtonEffect = function(element, name)
    if not gui.isGUIElement(element) then return false end
    if gui.getElementType(element) ~= "button" then return false end
    gui.setElementData(element, "effect", name)
    gui.setElementData(element, "effect_" .. name, 0)
  end -- TODO: Funkcja na dodawanie efektów przycisku
}