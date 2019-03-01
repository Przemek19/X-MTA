gui.functions.createRectangle = function(px, py, width, height)
  local element = gui.createNewElement("rectangle", {position = {px, py}, size = {width, height}}, (sourceResource or getThisResource()))
  return element
end