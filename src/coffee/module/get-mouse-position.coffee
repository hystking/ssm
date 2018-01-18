module.exports = getMousePosition = (dom) ->
  position =
    x: null
    y: null

  onMouseMove = (e) ->
    position.x = e.pageX - dom.offsetLeft
    position.y = e.pageY - dom.offsetTop

  dom.addEventListener "mousemove", onMouseMove

  position
