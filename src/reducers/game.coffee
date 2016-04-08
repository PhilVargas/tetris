Settings = require 'helpers/settings'
PieceMap = require 'helpers/piece-map'
Calculate = require 'helpers/calculator'
Constants = require('actions/game').Constants

assign = require 'object-assign'

Helper =
  getRows: (cells) ->
    for i in [0...Settings.boardHeight]
      cells[Settings.boardWidth * i...Settings.boardWidth * (i + 1)]

  isAnyRowFrozen: (cells) ->
    Helper.getRows(cells).some Helper.isRowFrozen

  isRowFrozen: (row) ->
    row.every (cell) -> cell.isFrozen

  clearFrozenRow: (rows) ->
    frozenIndex = null
    for row, i in rows when Helper.isRowFrozen(row)
      frozenIndex = i
      break
    if frozenIndex > 0
      prevRow = rows[frozenIndex - 1]
      row = rows[frozenIndex]
      for cell, j in row
        [row[j].isFrozen, row[j].cellPieceType,prevRow[j].isFrozen, prevRow[j].cellPieceType] = [prevRow[j].isFrozen, prevRow[j].cellPieceType, row[j].isFrozen, row[j].cellPieceType]
      Helper.clearFrozenRow(rows)
    for cell in rows[0]
      cell.isFrozen = false
      cell.cellPieceType = 'E'

  level: (linesCleared) ->
    Calculate.level(linesCleared)

  calculateScoreThisTurn: (linesClearedThisTurn, totalLinesCleared) ->
    Calculate.scoreThisTurn(linesClearedThisTurn, Helper.level(totalLinesCleared))

  scoreRows: (cells, totalLinesCleared) ->
    linesClearedThisTurn = 0
    while Helper.isAnyRowFrozen(cells)
      linesClearedThisTurn++
      Helper.clearFrozenRow(Helper.getRows(cells))
    scoreThisTurn = Helper.calculateScoreThisTurn(linesClearedThisTurn, totalLinesCleared)
    {scoreThisTurn, linesClearedThisTurn}

  didPlayerLose: (cells) ->
    cells.some (cell) => cell.isFrozen && cell.id in [0...(Settings.boardWidth * Settings.hiddenRows)]

  randomPiece: ->
    possiblePieces = ['I', 'Z', 'S', 'O', 'J', 'L', 'T']
    randomInt = (Math.random() * possiblePieces.length) // 1
    possiblePieces[randomInt]


  generateCells: ->
    cells = []
    count = 0
    for y in [0...Settings.boardHeight]
      for x in [0...Settings.boardWidth]
        cells.push { id: count, yIndex: y, xIndex: x, isFrozen: false, cellPieceType: 'E' }
        count++
    cells

  hasCollision: (nextPosition, cell, cells) ->
    cellIndex = Calculate.cellIndexFromCoords(nextPosition.xIndex + cell.x, nextPosition.yIndex + cell.y)
    !(0 <= nextPosition.xIndex + cell.x < Settings.boardWidth) ||
      nextPosition.yIndex + cell.y >= Settings.boardHeight ||
      cells[cellIndex].isFrozen

  isCollisionFree: (nextPosition, rotation, state) ->
    !PieceMap[state.currentPieceType].shapes[rotation].some (cell) =>
      Helper.hasCollision(nextPosition, cell, state.cells)

  freezeCells: (state) ->
    cellIds = Helper.getCellIdsForPiece(state)
    for cell in state.cells when cell.id in cellIds
      cell.isFrozen = true
      cell.cellPieceType = state.currentPieceType
    return state

  getCellIdsForPiece: (state) ->
    position = {x: state.xIndex, y: state.yIndex}
    for pieceCell in PieceMap[state.currentPieceType].shapes[state.rotation]
      Calculate.cellIndexFromCoords(position.x + pieceCell.x, position.y + pieceCell.y)

  ghostPosition: (state) ->
    nextYIndex = state.yIndex + 1
    while Helper.isCollisionFree({xIndex: state.xIndex, yIndex: nextYIndex}, state.rotation, state)
      nextYIndex++
    return nextYIndex - 1

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
