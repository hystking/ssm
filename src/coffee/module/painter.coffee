_ = require "lodash"
getMousePosition = require "./get-mouse-position"

createLine = ({width, color, startPoint}) ->
  width: width
  color: color
  points: [_.clone startPoint]

pushPointToLine = (point, line) ->
  line.points.push _.clone point

distance = (point1, point2) ->
  Math.sqrt (point1.x - point2.x) ** 2 + (point1.y - point2.y) ** 2

module.exports = class Painter
  constructor: ({canvas, @$colorPicker, @$lineWidthSelector, @init}) ->
    @ctx = canvas.getContext "2d"
    @currentLine = null
    @lines = []
    @mouse = getMousePosition canvas

    canvas.addEventListener "mousedown", @onMouseDown
    canvas.addEventListener "mouseup", @onMouseUp

    @ctx.lineCap = "round"
    @ctx.lineJoin = "round"
    @ctx.fillStyle = "#fff"

  onMouseUp: =>
    @currentLine = null

  onMouseDown: =>
    @currentLine = createLine
      width: @$lineWidthSelector.val()
      color: (@$colorPicker.spectrum "get").toHexString()
      startPoint: @mouse
    @lines.push @currentLine

  update: ->
    return unless @currentLine
    return if 4 > distance @mouse, _.last @currentLine.points
    pushPointToLine @mouse, @currentLine

  render: ->
    @ctx.fillRect 0, 0, @ctx.canvas.width, @ctx.canvas.height
    @ctx.save()
    @init? @ctx
    @ctx.restore()
    for line in @lines
      @ctx.save()
      @ctx.strokeStyle = line.color
      @ctx.lineWidth = line.width
      @ctx.beginPath()
      for point in line.points
        @ctx.lineTo point.x, point.y
      @ctx.stroke()
      @ctx.restore()

