gui.htmlContent.browser = [[
  <html>
    <head>
      <style>
        * {
          margin: 0;
          padding: 0;
          outline: none;
        }

        body {
          background: #111; 
        }
      </style>
    </head>
    <body>
      Loading...
    </body>
  </html>
]]

gui.functions.createBrowserWindow = function(px, py, width, height, isGlobal)
  local element = gui.createNewBrowserElement("browser", {position = {px, py}, size = {width, height}}, gui.htmlContent.browser, px, py, width, height, (sourceResource or getThisResource()), isGlobal)
  return element
end