gui.functions.createCheckBox = function(px, py, size)
  local element = gui.createNewElement("checkbox", {position = {px, py}, size = {size * 2, size}}, (sourceResource or getThisResource()))
  addEventHandler("on" .. gui.config.functionsPrefix .. "Click", element, function(bttn, state)
    if bttn ~= "left" or state ~= "down" then return end
    gui.globalFunctions.setStatus(source, not gui.globalFunctions.getStatus(source))
    triggerEvent("on" .. gui.config.functionsPrefix .. "CheckBoxChanged", source, gui.globalFunctions.getStatus(source))
  end)
  return element
end

addEvent("on" .. gui.config.functionsPrefix .. "CheckBoxChanged", true)