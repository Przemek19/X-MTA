gui.functions.createImage = function(px, py, width, height, src)
  local element = gui.createNewElement("image", {position = {px, py}, size = {width, height}, texture = dxCreateTexture(src)}, (sourceResource or getThisResource()))
  return element
end