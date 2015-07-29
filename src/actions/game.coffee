Dispatcher = require('dispatcher')

GameAction =
  init: ->
    Dispatcher.dispatch
      eventName: 'game:init'

  startGame: ->
    Dispatcher.dispatch
      eventName: 'game:startGame'

  restartGame: ->
    Dispatcher.dispatch
      eventName: 'game:restartGame'

  setPieceIndeces: (indeces)->
    Dispatcher.dispatch
      eventName: 'game:setPieceIndeces'
      value:
        xIndex: indeces.xIndex
        yIndex: indeces.yIndex

  nextTurn: ->
    Dispatcher.dispatch
      eventName: 'game:nextTurn'

  rotateClockwise: ->
    Dispatcher.dispatch
      eventName: 'game:rotatePiece'
      value: 1

  rotateCounterClockwise: ->
    Dispatcher.dispatch
      eventName: 'game:rotatePiece'
      value: -1

  dropPiece: ->
    Dispatcher.dispatch
      eventName: 'game:dropPiece'

  togglePause: ->
    Dispatcher.dispatch
      eventName: 'game:togglePause'

  queuePiece: ->
    Dispatcher.dispatch
      eventName: 'game:queuePiece'

  toggleQueue: ->
    Dispatcher.dispatch
      eventName: 'game:toggleQueue'

  toggleGhost: ->
    Dispatcher.dispatch
      eventName: 'game:toggleGhost'

module.exports = GameAction
