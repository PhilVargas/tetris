Dispatcher = require('dispatcher')

BoardAction =
  init: ->
    Dispatcher.dispatch
      eventName: 'board:init'

  setPieceIndeces: (indeces)->
    Dispatcher.dispatch
      eventName: 'board:setPieceIndeces'
      value:
        xIndex: indeces.xIndex
        yIndex: indeces.yIndex

module.exports = BoardAction
