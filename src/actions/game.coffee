START_GAME = 'START_GAME'
NEXT_TURN = 'NEXT_TURN'
SET_PIECE_INDECES = 'SET_PIECE_INDECES'
DROP_PIECE = 'DROP_PIECE'
ROTATE_PIECE = 'ROTATE_PIECE'

module.exports.START_GAME = START_GAME
module.exports.NEXT_TURN = NEXT_TURN
module.exports.SET_PIECE_INDECES = SET_PIECE_INDECES
module.exports.DROP_PIECE = DROP_PIECE
module.exports.ROTATE_PIECE = ROTATE_PIECE

module.exports.Constants =
  START_GAME: START_GAME
  NEXT_TURN: NEXT_TURN
  SET_PIECE_INDECES: SET_PIECE_INDECES
  DROP_PIECE: DROP_PIECE
  ROTATE_PIECE: ROTATE_PIECE

GameAction =
  start: ->
    type: START_GAME

  restartGame: ->
    type: 'game:restartGame'

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
    type: 'game:queuePiece'

module.exports.creators = GameAction
