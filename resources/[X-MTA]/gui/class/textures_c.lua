gui.textures = {
  ["corner"] =  "corner.png",
}

for i,v in pairs(gui.textures) do
  gui.textures[i] = dxCreateTexture(gui.config.imagesDIR .. v)
end