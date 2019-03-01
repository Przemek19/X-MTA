gui.fonts = {}

gui.getFont = function(name, size, weight)
  if not weight then weight = "regular" end
  if not gui.fonts[name] then gui.fonts[name] = {} end
  if not gui.fonts[name][weight] then gui.fonts[name][weight] = {} end
  if not gui.fonts[name][weight][size] then gui.fonts[name][weight][size] = dxCreateFont(gui.config.fontsDIR .. name .. "/" .. weight .. ".ttf", size) end
  return gui.fonts[name][weight][size]
end