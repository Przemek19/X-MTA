gui.shaders = {
  ["blackWhite"] =  "blackwhite.fx",
}

for i,v in pairs(gui.shaders) do
  gui.shaders[i] = dxCreateShader(gui.config.shadersDIR .. v)
  dxSetShaderValue(gui.shaders[i], "screenSource", gui.screenSource)
end

gui.functions.createShader = function(name, px, py, width, height)
  local element = gui.createNewElement("shader", {position = {px, py}, size = {width, height}, shaderName = name}, (sourceResource or getThisResource()))
  return element
end