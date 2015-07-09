Dispatcher = require 'dispatcher'
MicroEvent = require 'microevent-github'
PieceMap = require 'helpers/piece-map'
Settings = require 'helpers/settings'

assign = require 'object-assign'

boardData = null
BoardStore =
  get: (attr) ->
    boardData[attr]

  getAll: ->
    xIndex: boardData.xIndex
    yIndex: boardData.yIndex
    ghostYIndex: boardData.ghostYIndex
    turnCount: boardData.turnCount
    currentPieceType: boardData.currentPieceType
    cells: boardData.cells
    rotation: boardData.rotation
    isGameOver: boardData.isGameOver
    isPaused: boardData.isPaused

  triggerChange: ->
    @trigger('change')

  unbindChange: (callback) ->
    @unbind('change', callback)

  bindChange: (callback) ->
    @bind('change', callback)

class BoardData
  constructor: ->
    @xIndex = Settings.initialX
    @yIndex = Settings.initialY
    @ghostYIndex = 0
    @width = Settings.boardWidth
    @height = Settings.boardHeight
    @turnCount = 0
    @currentPieceType = @randomPiece()
    @cells = @generateCells()
    @rotation = 0
    @isGameOver = false
    @isPaused = false
    @color = PieceMap[@currentPieceType].color

  generateCells: ->
    cells =[]
    count = 0
    for y in [0...@height]
      for x in [0...@width]
        cells.push { id: count, yIndex: y, xIndex: x, isFrozen: false, color: 'white' }
        count++
    cells

  frozenCells: ->
    cell for cell in @cells when cell.isFrozen

  isFrozenCell: (position)->
    for cell in @frozenCells() when position.x == cell.xIndex && position.y == cell.yIndex
      return true

  randomPiece: ->
    randomInt = Math.floor(Math.random() * Object.keys(PieceMap).length)
    Object.keys(PieceMap)[randomInt]

  updateAttribs: (attribs) ->
    assign(this, attribs)

  isCollisionFree: (nextPosition, rotation = @rotation) =>
    isCollisionFree = true
    for a in PieceMap[@currentPieceType].shapes[rotation] when !(0 <= nextPosition.xIndex + a.x < 10) || nextPosition.yIndex + a.y >= 22 || @isFrozenCell(x: nextPosition.xIndex + a.x, y: nextPosition.yIndex + a.y)
      isCollisionFree = false
    isCollisionFree

  getPieceIndeces: (position = {x: @xIndex, y: @yIndex})->
    indeces = []
    for a in PieceMap[@currentPieceType].shapes[@rotation]
      indeces.push {x: position.x + a.x, y: position.y + a.y}
    indeces

  getCellIdsFromIndeces: ->
    piece = @getPieceIndeces()
    cellIds = for cell in piece
      cell.x + (10*cell.y)
    cellIds

  freezeCells: ->
    cellIds = @getCellIdsFromIndeces()
    for cell in @cells when cell.id in cellIds
      cell.isFrozen = true
      cell.color = @color

  didPlayerLose: ->
    isGameOver = false
    frozenCellIds = (cell.id for cell in @frozenCells())
    isGameOver = true for id in frozenCellIds when id in [0...20]
    isGameOver

  getRows: ->
    rows = []
    for i in [0...@height]
      rows.push @cells[@width*i...@width*(i+1)]
    rows

  isAnyRowFrozen: ->
    isAnyRowFrozen = false
    isAnyRowFrozen = true for row in @getRows() when @isRowFrozen(row)
    isAnyRowFrozen

  isRowFrozen: (row) ->
    isRowFrozen = true
    isRowFrozen = false for cell in row when not cell.isFrozen
    isRowFrozen

  clearFrozenRow: (rows) ->
    frozenIndex = null
    for row, i in rows when @isRowFrozen(row)
      frozenIndex = i
      break
    if frozenIndex > 0
      prevRow = rows[frozenIndex - 1]
      row = rows[frozenIndex]
      for cell, j in row
        [row[j].isFrozen, row[j].color,prevRow[j].isFrozen, prevRow[j].color] = [prevRow[j].isFrozen, prevRow[j].color, row[j].isFrozen, row[j].color]
      @clearFrozenRow(rows)
    for cell in rows[0]
      cell.isFrozen = false
      cell.color = 'white'

  drawGhost: ->
    yIndex = @yIndex
    while boardData.isCollisionFree({xIndex: @xIndex, yIndex: yIndex + 1})
      @updateAttribs(ghostYIndex: yIndex + 1)
      yIndex++

Dispatcher.register (payload) ->
  switch payload.eventName
    when 'board:init'
      boardData = new BoardData()
      boardData.drawGhost()
      BoardStore.triggerChange()
    when 'board:setPieceIndeces'
      if boardData.isCollisionFree({xIndex: payload.value.xIndex, yIndex: payload.value.yIndex})
        boardData.updateAttribs(xIndex: payload.value.xIndex, yIndex: payload.value.yIndex)
      boardData.drawGhost()
      BoardStore.triggerChange()
    when 'board:dropPiece'
      while boardData.isCollisionFree({xIndex: boardData.xIndex, yIndex: boardData.yIndex + 1})
        boardData.updateAttribs(yIndex: boardData.yIndex + 1)
      BoardStore.triggerChange()
    when 'board:togglePause'
      boardData.updateAttribs(isPaused: !boardData.isPaused)
      BoardStore.triggerChange()
    when 'board:nextTurn'
      return if boardData.isPaused
      boardData.updateAttribs(turnCount: boardData.turnCount + 1)
      if boardData.isCollisionFree({xIndex: boardData.xIndex, yIndex: boardData.yIndex + 1})
        boardData.updateAttribs(yIndex: boardData.yIndex + 1)
      else
        boardData.freezeCells()
        if boardData.didPlayerLose()
          boardData.updateAttribs(isGameOver: true)
        else
          while boardData.isAnyRowFrozen()
            boardData.clearFrozenRow(boardData.getRows())
          nextPiece = boardData.randomPiece()
          boardData.updateAttribs(yIndex: 0, xIndex: 5, currentPieceType: nextPiece, color: PieceMap[nextPiece].color)
          boardData.drawGhost()
      BoardStore.triggerChange()
    when 'board:rotatePiece'
      rotation = Math.abs((4 + payload.value + boardData.rotation) % 4)
      if boardData.isCollisionFree({xIndex: boardData.xIndex, yIndex: boardData.yIndex}, rotation)
        boardData.updateAttribs(rotation: rotation)
        boardData.drawGhost()
        BoardStore.triggerChange()

MicroEvent.mixin( BoardStore )
module.exports = BoardStore
