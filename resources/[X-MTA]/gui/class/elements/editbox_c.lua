gui.htmlContent.editbox = [[
  <html>
    <head>
      <style>
        @font-face {
          font-family: font;
          src: (../files/fonts/Lato/regular.ttf);
        }
        * {
          margin: 0;
          padding: 0;
          outline: none;
        }
        input {
          width: 100%;
          height: 100%;
          border: 0;
          font-family: font;
          padding: 8px;
          border: transparent;
        }
        
      </style>
    </head>
    <body>
      <input id="editbox" type="text" value="" spellcheck="false" />
    </body>
  </html>
]]

gui.functions.createEditBox = function(px, py, width, height)
  local element = gui.createNewBrowserElement("editbox", {position = {px, py}, size = {width, height}}, gui.htmlContent.editbox, px, py, width, height, (sourceResource or getThisResource()))
  return element
end