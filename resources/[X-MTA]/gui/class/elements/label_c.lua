gui.functions.createLabel = function(px, py, width, height, text, alignX, alignY)
  local element = gui.createNewElement("label", {position = {px, py}, size = {width, height}, text = (text or ""), alignX = (alignX or "left"), alignY = (alignY or "top"), font = {name = gui.config.defaultFont, size = gui.config.defaultFontSize, weight = "regular"}}, (sourceResource or getThisResource()))
  return element
end