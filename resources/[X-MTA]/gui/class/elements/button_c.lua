gui.functions.createButton = function(px, py, width, height, text)
  local element = gui.createNewElement("button", {position = {px, py}, size = {width, height}, text = (text or "")}, (sourceResource or getThisResource()))
  gui.globalFunctions.setColor(element, "hover", gui.updateColorContrast(gui.globalFunctions.getColor(element, "primary", true), 0.8))
  gui.globalFunctions.setColor(element, "focus", gui.updateColorContrast(gui.globalFunctions.getColor(element, "primary", true), 0.6))
  return element
end