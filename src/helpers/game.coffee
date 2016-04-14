Settings = require 'helpers/settings'
Calculate = require 'helpers/calculator'
PieceMap = require 'helpers/piece-map'

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

