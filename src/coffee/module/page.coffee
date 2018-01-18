module.exports = class Page
  constructor: ({@$page}) ->
    @navigate 0

  next: ->
    @navigate @index + 1

  navigate: (index) ->
    @index = index % @$page.length
    @render()

  render: ->
    @$page.hide().eq(@index).show()
