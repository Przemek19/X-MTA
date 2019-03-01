gui.renderStatus = false
gui.HTMLrenderStatus = false

gui.setRenderStatus = function(bool)
  if bool then
    if not gui.renderStatus then addEventHandler("onClientRender", root, gui.render) gui.renderStatus = true end
  else
    if gui.renderStatus then removeEventHandler("onClientRender", root, gui.render) gui.renderStatus = false end
  end
end

gui.setHTMLRenderStatus = function(bool)
  if bool then
    if not gui.HTMLrenderStatus then addEventHandler("onClientRender", root, gui.HTMLrender) gui.HTMLrenderStatus = true end
  else
    if gui.HTMLrenderStatus then removeEventHandler("onClientRender", root, gui.HTMLrender) gui.HTMLrenderStatus = false end
  end
end

gui.renderBorderOfElement = function(element)
  local elementData = gui.getElementData(element)

  if not elementData.border then return end
  if not elementData.color then return end
  if not elementData.color.border then return end
  
  if elementData.border["top"] then
    dxDrawRectangle(elementData.position[1], elementData.position[2] - elementData.border["top"], elementData.size[1], elementData.border["top"], elementData.color.border)
  end
  if elementData.border["bottom"] then
    dxDrawRectangle(elementData.position[1], elementData.position[2] + elementData.size[2], elementData.size[1], elementData.border["bottom"], elementData.color.border)
  end
  if elementData.border["left"] then
    dxDrawRectangle(elementData.position[1] - elementData.border["left"], elementData.position[2], elementData.border["left"], elementData.size[2], elementData.color.border)
  end
  if elementData.border["right"] then
    dxDrawRectangle(elementData.position[1] + elementData.size[1], elementData.position[2], elementData.border["right"], elementData.size[2], elementData.color.border)
  end

  if elementData.border["top"] and elementData.border["left"] then
    dxDrawRectangle(elementData.position[1] - elementData.border["left"], elementData.position[2] - elementData.border["top"], elementData.border["left"], elementData.border["top"], elementData.color.border)
  end

  if elementData.border["top"] and elementData.border["right"] then
    dxDrawRectangle(elementData.position[1] + elementData.size[1], elementData.position[2] - elementData.border["top"], elementData.border["right"], elementData.border["top"], elementData.color.border)
  end

  if elementData.border["bottom"] and elementData.border["left"] then
    dxDrawRectangle(elementData.position[1] - elementData.border["left"], elementData.position[2] + elementData.size[2], elementData.border["left"], elementData.border["bottom"], elementData.color.border)
  end

  if elementData.border["bottom"] and elementData.border["right"] then
    dxDrawRectangle(elementData.position[1] + elementData.size[1], elementData.position[2] + elementData.size[2], elementData.border["right"], elementData.border["bottom"], elementData.color.border)
  end
end

gui.renderBorderRadius = function(px, py, size, type, color, postGUI)
  if type == "left-top" then
    dxDrawImage(px, py, size, size, gui.textures.corner, 0, 0, 0, color, postGUI)
  elseif type == "right-top" then
    dxDrawImage(px, py, size, size, gui.textures.corner, 90, 0, 0, color, postGUI)
  elseif type == "left-bottom" then
    dxDrawImage(px, py, size, size, gui.textures.corner, 270, 0, 0, color, postGUI)
  elseif type == "right-bottom" then
    dxDrawImage(px, py, size, size, gui.textures.corner, 180, 0, 0, color, postGUI)
  end
end

gui.render = function()
  for i,v in pairs(gui.elements) do
    local elementType = gui.getElementType(v.element)
    local elementInfo = gui.getElementInfo(v.element)
    local elementData = gui.getElementData(v.element)

    if not elementData.isNotVisible then

      if elementType == "window" then -- WINDOW
        if elementData.borderRadius then
          local rad = elementData.borderRadius

          dxDrawRectangle(elementData.position[1] + rad, elementData.position[2] + rad, elementData.size[1] - rad * 2, elementData.size[2] - rad * 2, elementData.color.background, elementData.postGUI)

          gui.renderBorderRadius(elementData.position[1], elementData.position[2] + elementData.size[2] - rad, rad, "left-bottom", elementData.color.background, elementData.postGUI)
          gui.renderBorderRadius(elementData.position[1] + elementData.size[1] - rad, elementData.position[2] + elementData.size[2] - rad, rad, "right-bottom", elementData.color.background, elementData.postGUI)
          dxDrawRectangle(elementData.position[1] + rad, elementData.position[2] + elementData.size[2] - rad, elementData.size[1] - rad * 2, rad, elementData.color.background)
          dxDrawRectangle(elementData.position[1], elementData.position[2] + gui.config.windowBorderHeight, rad, elementData.size[2] - rad - gui.config.windowBorderHeight, elementData.color.background)
          dxDrawRectangle(elementData.position[1] + elementData.size[1] - rad, elementData.position[2] + gui.config.windowBorderHeight, rad, elementData.size[2] - rad - gui.config.windowBorderHeight, elementData.color.background)

          if elementData.text then
            dxDrawRectangle(elementData.position[1] + rad, elementData.position[2], elementData.size[1] - rad * 2, gui.config.windowBorderHeight, elementData.color.primary, elementData.postGUI)
            dxDrawText(elementData.text, (elementData.position[1] + rad) * 2, (elementData.position[2]) * 2, elementData.size[1] - rad * 2, gui.config.windowBorderHeight, elementData.color.text, 1, gui.getFont(elementData.font.name, (elementData.font.size or (gui.config.windowBorderHeight / 2)), (elementData.font.weight or "regular")), "center", "center", false, false, elementData.postGUI, true)
          
            gui.renderBorderRadius(elementData.position[1], elementData.position[2], rad, "left-top", elementData.color.primary, elementData.postGUI)
            gui.renderBorderRadius(elementData.position[1] + elementData.size[1] - rad, elementData.position[2], rad, "right-top", elementData.color.primary, elementData.postGUI)

            dxDrawRectangle(elementData.position[1], elementData.position[2] + rad , rad, gui.config.windowBorderHeight  - rad, elementData.color.primary)
            dxDrawRectangle(elementData.position[1] + elementData.size[1] - rad, elementData.position[2] + rad, rad,gui.config.windowBorderHeight - rad, elementData.color.primary)
          end
        else
          dxDrawRectangle(elementData.position[1], elementData.position[2], elementData.size[1], elementData.size[2], elementData.color.background, elementData.postGUI)

          if elementData.text then
            dxDrawRectangle(elementData.position[1], elementData.position[2], elementData.size[1], gui.config.windowBorderHeight, elementData.color.primary, elementData.postGUI)
            dxDrawText(elementData.text, elementData.position[1] * 2, elementData.position[2] * 2, elementData.size[1], gui.config.windowBorderHeight, elementData.color.text, 1, gui.getFont(elementData.font.name, (elementData.font.size or (gui.config.windowBorderHeight / 2)), (elementData.font.weight or "regular")), "center", "center", false, false, elementData.postGUI, true)
          end
        end

      end -- WINDOW

      if elementType == "label" then -- LABEL
        dxDrawText(elementData.text, elementData.position[1], elementData.position[2], elementData.size[1], elementData.size[2], elementData.color.text, 1, gui.getFont(elementData.font.name, (elementData.font.size or gui.config.defaultFontSize), (elementData.font.weight or "regular")), elementData.alignX, elementData.alignY, false, elementData.wordBreak, elementData.postGUI, elementData.colorCoded)
      end -- LABEL

      if elementType == "editbox" then -- EDITBOX
        dxDrawImage(elementData.position[1], elementData.position[2], elementData.size[1], elementData.size[2], elementInfo.browser, 0, 0, 0, (elementData.color.browser or tocolor(255,255,255)), elementData.postGUI)
      end -- EDITBOX

      if elementType == "gif" then -- GIF
        dxDrawImage(elementData.position[1], elementData.position[2], elementData.size[1], elementData.size[2], elementInfo.browser, 0, 0, 0, (elementData.color.browser or tocolor(255,255,255)), elementData.postGUI)
      end -- GIF

      if elementType == "browser" then -- BROWSER
        dxDrawImage(elementData.position[1], elementData.position[2], elementData.size[1], elementData.size[2], elementInfo.browser, 0, 0, 0, (elementData.color.browser or tocolor(255,255,255)), elementData.postGUI)
      end -- BROWSER

      if elementType == "button" then -- BUTTON
        local colorType = elementData.color.primary
        if gui.isCursorInPosition(elementData.position[1], elementData.position[2], elementData.size[1], elementData.size[2]) then
          if getKeyState("mouse1") then
            colorType = elementData.color.focus
          else
            colorType = elementData.color.hover
          end
        end

        if elementData.borderRadius then
          local rad = math.min(elementData.borderRadius, math.min(elementData.size[1],elementData.size[2])/2)
          gui.renderBorderRadius(elementData.position[1], elementData.position[2], rad, "left-top", colorType, elementData.postGUI)
          gui.renderBorderRadius(elementData.position[1] + elementData.size[1] - rad, elementData.position[2], rad, "right-top", colorType, elementData.postGUI)
          gui.renderBorderRadius(elementData.position[1], elementData.position[2] + elementData.size[2] - rad, rad, "left-bottom", colorType, elementData.postGUI)
          gui.renderBorderRadius(elementData.position[1] + elementData.size[1] - rad, elementData.position[2] + elementData.size[2] - rad, rad, "right-bottom", colorType, elementData.postGUI)
          dxDrawRectangle(elementData.position[1], elementData.position[2] + rad, elementData.size[1], elementData.size[2] - rad * 2, colorType, elementData.postGUI)

          dxDrawRectangle(elementData.position[1] + rad, elementData.position[2], elementData.size[1] - rad * 2, rad, colorType, elementData.postGUI)
          dxDrawRectangle(elementData.position[1] + rad, elementData.position[2] + elementData.size[2] - rad, elementData.size[1] - rad * 2, rad, colorType, elementData.postGUI)
        else
          dxDrawRectangle(elementData.position[1], elementData.position[2], elementData.size[1], elementData.size[2], colorType, elementData.postGUI)
        end

        dxDrawText(elementData.text, elementData.position[1] * 2, elementData.position[2] * 2, elementData.size[1], elementData.size[2], elementData.color.text, 1, gui.getFont(elementData.font.name, (elementData.font.size or math.min(elementData.size[1],elementData.size[2])/4), (elementData.font.weight or "regular")), "center", "center", false, false, elementData.postGUI, true)
      end -- BUTTON

      if elementType == "checkbox" then -- CHECKBOX
        dxDrawRectangle(elementData.position[1], elementData.position[2], elementData.size[1], elementData.size[2], elementData.color.background, elementData.postGUI)
        if elementData.status then
          dxDrawRectangle(elementData.position[1] + elementData.size[2] * 0.125 + elementData.size[2], elementData.position[2] + elementData.size[2] * 0.125, elementData.size[2] * 0.75, elementData.size[2] * 0.75, elementData.color.primary, elementData.postGUI)
          dxDrawText("ON", elementData.position[1] * 2, elementData.position[2] * 2, elementData.size[2], elementData.size[2], elementData.color.primary, 1, gui.getFont(elementData.font.name, (elementData.font.size or (elementData.size[2] / 4)), (elementData.font.weight or "bold")), "center", "center", false, false, elementData.postGUI, true)
        else
          dxDrawRectangle(elementData.position[1] + elementData.size[2] * 0.125, elementData.position[2] + elementData.size[2] * 0.125, elementData.size[2] * 0.75, elementData.size[2] * 0.75, gui.updateColorContrast(elementData.colortable.background, 0.6, true), elementData.postGUI)
          dxDrawText("OFF", (elementData.position[1] + elementData.size[2]) * 2, elementData.position[2] * 2, elementData.size[2], elementData.size[2], elementData.color.text, 1, gui.getFont(elementData.font.name, (elementData.font.size or (elementData.size[2] / 4)), (elementData.font.weight or "bold")), "center", "center", false, false, elementData.postGUI, true)
        end
      end -- CHECKBOX

      if elementType == "shader" then -- SHADER
        if gui.shaders[elementData.shaderName] then
          dxUpdateScreenSource(gui.screenSource)
          dxDrawImage(elementData.position[1], elementData.position[2], elementData.size[1], elementData.size[2], gui.shaders[elementData.shaderName], 0, 0, 0, (elementData.color.shader or tocolor(255, 255, 255)), elementData.postGUI)
        end
      end -- SHADER

      if elementType == "image" then -- IMAGE
        dxDrawImage(elementData.position[1], elementData.position[2], elementData.size[1], elementData.size[2], elementData.texture, 0, 0, 0, (elementData.color.image or tocolor(255, 255, 255)), elementData.postGUI)
      end -- IMAGE

      if elementType == "rectangle" then -- RECTANGLE
        dxDrawRectangle(elementData.position[1], elementData.position[2], elementData.size[1], elementData.size[2], (elementData.color.primary or tocolor(255, 255, 255)), elementData.postGUI)
      end -- RECTANGLE

      gui.renderBorderOfElement(v.element)
    end
  end
end

gui.HTMLrender = function()
  for i,v in pairs(gui.getElementsWithBrowser()) do
    if gui.getElementType(v) == "editbox" then
      local elementInfo = gui.getElementInfo(v)
      executeBrowserJavascript(elementInfo.browser, "mta.triggerEvent('GUI_setEditBoxText', document.getElementById('editbox').value)")
    end
  end
end

addEvent("GUI_setEditBoxText", true)
addEventHandler("GUI_setEditBoxText", getRootElement(), function(text)
  local element = gui.getElementByBrowser(source)
  gui.setElementData(element, "text", text)
end)