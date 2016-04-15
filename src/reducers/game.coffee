Settings = require 'helpers/settings'
Calculate = require 'helpers/calculator'
Helper = require 'helpers/game'
Constants = require('actions/game').Constants

assign = require 'object-assign'

initialState =
  canQueuePiece: true
  level: 0
  yIndex: Settings.initialY
  xIndex: Settings.initialX
  hasGameBegun: false
  currentPieceType: Helper.randomPiece()
  ghostYIndex: 0
  isGameOver: false
  isPaused: false
  linesCleared: 0
  nextPieceType: Helper.randomPiece()
  queuePieceType: ''
  rotation: 0
  score: 0
  scoreThisTurn: 0
  turnCount: 0
  cells: Helper.generateCells()

game = (state, action) ->
  return initialState unless state?

  switch action.type
    when Constants.RESTART_GAME
      state = assign {}, state,
        currentPieceType: Helper.randomPiece()
        ghostYindex: 0
        isGameOver: false
        isPaused: false
        linesCleared: 0
        nextPieceType: Helper.randomPiece()
        queuePieceType: ''
        rotation: 0
        score: 0
        scoreThisTurn: 0
        turnCount: 0
        cells: Helper.generateCells()
      assign({}, state, ghostYIndex: Helper.ghostPosition(state))
    when Constants.START_GAME
      assign({}, state, hasGameBegun: true, ghostYIndex: Helper.ghostPosition(state))
    when Constants.SET_PIECE_INDECES
      if Helper.isCollisionFree({xIndex: action.value.xIndex, yIndex: action.value.yIndex}, state.rotation, state)
        state = assign({}, state, xIndex: action.value.xIndex, yIndex: action.value.yIndex)
      assign({}, state, ghostYIndex: Helper.ghostPosition(state))
    when Constants.DROP_PIECE
      scoreThisTurn = 0
      while Helper.isCollisionFree({xIndex: state.xIndex, yIndex: state.yIndex + 1}, state.rotation, state)
        scoreThisTurn++
        state = assign({}, state, yIndex: state.yIndex + 1)
      if scoreThisTurn
        state = assign({}, state, score: state.score + scoreThisTurn, scoreThisTurn: scoreThisTurn)
      state
    when Constants.ROTATE_PIECE
      rotation = Calculate.rotation(state.rotation, action.value)
      if Helper.isCollisionFree({ xIndex: state.xIndex, yIndex: state.yIndex }, rotation, state)
        state = assign({}, state, rotation: rotation)
      assign({}, state, ghostYIndex: Helper.ghostPosition(state))
    when Constants.QUEUE_PIECE
      if state.canQueuePiece && state.shouldAllowQueue
        state = assign {}, state,
          yIndex: Settings.initialY
          xIndex: Settings.initialX
          rotation: 0
        if state.queuePieceType
          state = assign {}, state,
            queuePieceType: state.currentPieceType
            currentPieceType: state.queuePieceType
        else
          state = assign {}, state,
            queuePieceType: state.currentPieceType
            currentPieceType: state.nextPieceType
            nextPieceType: Helper.randomPiece()
        state = assign({}, state, canQueuePiece: false, ghostYIndex: Helper.ghostPosition(state))
      state
    when Constants.NEXT_TURN
      return state if state.isPaused
      if Helper.isCollisionFree({xIndex: state.xIndex, yIndex: state.yIndex + 1}, state.rotation, state)
        return assign({}, state, yIndex: state.yIndex + 1)
      else
        state = assign {}, state, Helper.freezeCells(state)
        if Helper.didPlayerLose(state.cells)
          state = assign {}, state, isGameOver: true
        else
          { scoreThisTurn, linesClearedThisTurn } = Helper.scoreRows(state.cells, state.linesCleared)
          nextPiece = Helper.randomPiece()
          state = assign({}, state,
            linesCleared: state.linesCleared + linesClearedThisTurn
            score: state.score + scoreThisTurn
            yIndex: Settings.initialY
            xIndex: Settings.initialX
            rotation: 0
            currentPieceType: state.nextPieceType
            nextPieceType: nextPiece
            canQueuePiece: true
          )
          if scoreThisTurn
            state = assign({}, state, scoreThisTurn: scoreThisTurn)
            state = assign({}, state, level: Calculate.level(state.linesCleared))
          state = assign({}, state, ghostYIndex: Helper.ghostPosition(state))
      state
    else state

module.exports = game
