Dispatcher = require('dispatcher')

BoardAction =
  init: ->
    Dispatcher.dispatch
      eventName: 'board:init'

  startGame: ->
    Dispatcher.dispatch
      eventName: 'board:startGame'

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

  dropPiece: ->
    Dispatcher.dispatch
      eventName: 'board:dropPiece'

  togglePause: ->
    Dispatcher.dispatch
      eventName: 'board:togglePause'

  queuePiece: ->
    Dispatcher.dispatch
      eventName: 'board:queuePiece'

  toggleQueue: ->
    Dispatcher.dispatch
      eventName: 'board:toggleQueue'

  toggleGhost: ->
    Dispatcher.dispatch
      eventName: 'board:toggleGhost'

module.exports = BoardAction
