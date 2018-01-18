THREE = require "three"

Viewer= require "./module/viewer"
Painter = require "./module/painter"
Page = require "./module/page"

$colorPicker = ($ "#spectrumColorPicker").spectrum color: "#fff"
$lineWidthSelector = $ "#lineWidthSelector"
viewer = null

createViewer = ->
  new Viewer
    canvas: sushiViewerCanvas
    netaCanvas: netaPainterCanvas
    shariCanvas: shariPainterCanvas
    saraCanvas: saraPainterCanvas

netaPainter = new Painter
  canvas: netaPainterCanvas
  $colorPicker: $colorPicker
  $lineWidthSelector: $lineWidthSelector
  init: (ctx) ->
    ctx.fillStyle = "#ff4c4c"
    ctx.fillRect 0, 0, ctx.canvas.width, ctx.canvas.height

shariPainter = new Painter
  canvas: shariPainterCanvas
  $colorPicker: $colorPicker
  $lineWidthSelector: $lineWidthSelector
  init: (ctx) ->
    steps = 4
    ctx.fillStyle = "#f8f8f8"
    for stepX in [0..steps]
      for stepY in [0..steps]
        offsetStepX = if stepY % 2 is 0 then 0 else .5
        x = ctx.canvas.width * (stepX + offsetStepX) / steps
        y = ctx.canvas.height * stepY / steps
        ctx.beginPath()
        ctx.arc x, y, ctx.canvas.width / steps / 4, 0, Math.PI * 2
        ctx.fill()

saraPainter = new Painter
  canvas: saraPainterCanvas
  $colorPicker: $colorPicker
  $lineWidthSelector: $lineWidthSelector
  init: (ctx) ->
    ctx.fillStyle = "#7bcef7"
    ctx.beginPath()
    ctx.arc(
      ctx.canvas.width / 2
      ctx.canvas.height / 2
      ctx.canvas.width / 2
      0
      Math.PI * 2
    )
    ctx.fill()
    ctx.fillStyle = "#fff"
    ctx.beginPath()
    ctx.arc(
      ctx.canvas.width / 2
      ctx.canvas.height / 2
      ctx.canvas.width / 2 - 64
      0
      Math.PI * 2
    )
    ctx.fill()

page = new Page
  $page: $ ".page"

nextButton.addEventListener "click", ->
  page.next()
  viewer = createViewer()

tick = (utime) ->
  time = utime / 1000

  viewer?.update time
  netaPainter.update time
  shariPainter.update time
  saraPainter.update time

  viewer?.render()
  netaPainter.render()
  shariPainter.render()
  saraPainter.render()

  requestAnimationFrame tick

tick()
viewer = createViewer()
