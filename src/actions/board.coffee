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

  nextTurn: ->
    Dispatcher.dispatch
      eventName: 'board:nextTurn'

  rotateClockwise: ->
    Dispatcher.dispatch
      eventName: 'board:rotatePiece'
      value: 1

  rotateCounterClockwise: ->
    Dispatcher.dispatch
      eventName: 'board:rotatePiece'
      value: -1

module.exports = BoardAction
