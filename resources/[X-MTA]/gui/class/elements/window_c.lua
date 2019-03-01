gui.functions.createWindow = function(px, py, width, height)
  return gui.createNewElement("window", {position = {px, py}, size = {width, height}}, (sourceResource or getThisResource()))
end