START_GAME = 'START_GAME'
NEXT_TURN = 'NEXT_TURN'
SET_PIECE_INDECES = 'SET_PIECE_INDECES'
DROP_PIECE = 'DROP_PIECE'
ROTATE_PIECE = 'ROTATE_PIECE'
QUEUE_PIECE = 'QUEUE_PIECE'
RESTART_GAME = 'RESTART_GAME'

module.exports.START_GAME = START_GAME
module.exports.NEXT_TURN = NEXT_TURN
module.exports.SET_PIECE_INDECES = SET_PIECE_INDECES
module.exports.DROP_PIECE = DROP_PIECE
module.exports.ROTATE_PIECE = ROTATE_PIECE
module.exports.QUEUE_PIECE = QUEUE_PIECE
module.exports.RESTART_GAME = RESTART_GAME

module.exports.Constants =
  START_GAME: START_GAME
  NEXT_TURN: NEXT_TURN
  SET_PIECE_INDECES: SET_PIECE_INDECES
  DROP_PIECE: DROP_PIECE
  ROTATE_PIECE: ROTATE_PIECE
  QUEUE_PIECE: QUEUE_PIECE
  RESTART_GAME: RESTART_GAME

GameAction =
  startGame: ->
    type: START_GAME

  restartGame: ->
    type: RESTART_GAME

  setPieceIndeces: (indeces)->
    type: SET_PIECE_INDECES
    value:
      xIndex: indeces.xIndex
      yIndex: indeces.yIndex

  nextTurn: ->
    type: NEXT_TURN

  rotateClockwise: ->
    type: ROTATE_PIECE
    value: 1

  rotateCounterClockwise: ->
    type: ROTATE_PIECE
    value: -1

  dropPiece: ->
    type: DROP_PIECE

  queuePiece: ->
    type: QUEUE_PIECE

module.exports.creators = GameAction
