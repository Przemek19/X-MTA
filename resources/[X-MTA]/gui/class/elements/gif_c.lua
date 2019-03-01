gui.htmlContent.gif = [[
  <html>
    <head>
      <style>
        * {
          margin: 0;
          padding: 0;
          outline: none;
        }

        body {
          background-size: 100% 100%;
          background: #111; 
        }
      </style>
    </head>
    <body>
    </body>
  </html>
]]

gui.functions.createGif = function(px, py, width, height)
  local element = gui.createNewBrowserElement("gif", {position = {px, py}, size = {width, height}}, gui.htmlContent.gif, px, py, width, height, (sourceResource or getThisResource()), nil, true)
  return element
end