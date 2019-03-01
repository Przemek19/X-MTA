Resource: Radar 3D v1.1.4
Author: Ren712
Contact: knoblauch700@o2.pl

Description:

This resource replaces an old GTASA radar with gta5 like 3D radar.
It uses image2material3D class to transform map and radar areas
into 3d space.

Exported functions:
createCustomBlip(posX, posY, posZ, texture,[size,  colR, colG, colB, colA, visibleDistance])
destroyCustomBlip(customBlipElement)
setCustomBlipTexture(customBlipElement, texture)
setCustomBlipPosition(customBlipElement, posX, posY, posZ)
setCustomBlipSize(customBlipElement, size)
setCustomBlipColor(customBlipElement, colR, colG, colB, colA)
setCustomBlipVisibleDistance(customBlipElement, visibleDistance)
setCustomBlipInterior(customBlipElement, int interiorID)

createCustomTile(texture, posX, posY, posZ,[rotX, rotY, rotZ, sizX, sizY, colR, colG, colB, colA , isBillboard])
destroyCustomTile(customTileElement)
setCustomTileTexture(customTileElement, texture)
setCustomTilePosition(customTileElement, posX, posY, posZ)
setCustomTileSize(customTileElement, sizeX, [sizeY])
setCustomTileRotation(customTileElement, rotX, rotY, rotZ)
setCustomTileColor(customTileElement, colR, colG, colB, colA)
setCustomTileBillboard(customTileElement, boolean isBillboard)
setCustomTileCullMode(customTileElement, int cullMode)
setCustomTileInterior(customTileElement, int interiorID)

createCustomMaterialLine2D(pos1X, pos1Y, pos2X, pos2Y, [width, colR, colG, colB, colA , isBillboard, isSoft])	
createCustomMaterialBezierLine2D(pos1X, pos1Y, pos2X, pos2Y, pos3X, pos3Y, pos4X, pos4Y, [width, colR, colG, colB, colA , isBillboard, isSoft])
createCustomMaterialLine3D(pos1X, pos1Y, pos1Z,pos2X, pos2Y, pos2Z, [width, colR, colG, colB, colA, isBillboard, isSoft])	
createCustomMaterialBezierLine3D(pos1X, pos1Y, pos1Z, pos2X, pos2Y, pos2Z, pos3X, pos3Y, pos3Z, pos4X, pos4Y, pos4Z, [width, colR, colG, colB, colA , isBillboard, isSoft])
destroyCustomMaterial(customMaterialElement)
setCustomMaterialPosition(customMaterialElement, posX, posY, posZ)
setCustomMaterialPosition1(customMaterialElement, posX, posY, posZ)
setCustomMaterialPosition2(customMaterialElement, posX, posY, posZ)	
setCustomMaterialPosition3(customMaterialElement, posX, posY, posZ)
setCustomMaterialPosition4(customMaterialElement, posX, posY, posZ)	
setCustomMaterialRotation(customMaterialElement, rotX, rotY, rotZ)
setCustomMaterialColor(customMaterialElement, colR, colG, colB, colA)
setCustomMaterialSize(customMaterialElement, sizeX, [sizeY])
setCustomMaterialWidth(customMaterialElement, width)
setCustomMaterialBillboard(customMaterialElement, boolean isBillboard)
setCustomMaterialCullMode(customMaterialElement, int cullMode)
setCustomMaterialInterior(customMaterialElement, int interiorID)
