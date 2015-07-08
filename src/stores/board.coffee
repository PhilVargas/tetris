Dispatcher = require 'dispatcher'
MicroEvent = require 'microevent-github'
PieceMap = require 'helpers/piece-map'

assign = require 'object-assign'

boardData = null
BoardStore =
  get: (attr) ->
    boardData[attr]

  getAll: ->
    xIndex: boardData.xIndex
    yIndex: boardData.yIndex
    initialX: boardData.initialX
    initialY: boardData.initialY
    width: boardData.width
    height: boardData.height
    cellWidth: boardData.cellWidth
    cellHeight: boardData.cellHeight
    hiddenRows: boardData.hiddenRows
    turnCount: boardData.turnCount
    currentPieceType: boardData.currentPieceType
    cells: boardData.cells
    rotation: boardData.rotation
    isGameOver: boardData.isGameOver

  triggerChange: ->
    @trigger('change')

  unbindChange: (callback) ->
    @unbind('change', callback)

  bindChange: (callback) ->
    @bind('change', callback)

class BoardData
  constructor: ->
    @xIndex = 5
    @yIndex = 0
    @initialX = 200
    @initialY = 0
    @width = 10
    @height = 22
    @cellWidth = 20
    @cellHeight = 20
    @hiddenRows = 2
    @turnCount = 0
    @currentPieceType = @randomPiece()
    @cells = @generateCells()
    @rotation = 0
    @isGameOver = false

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
    for a in PieceMap[@currentPieceType][rotation] when !(0 <= nextPosition.xIndex + a.x < 10) || nextPosition.yIndex + a.y >= 22 || @isFrozenCell(x: nextPosition.xIndex + a.x, y: nextPosition.yIndex + a.y)
      isCollisionFree = false
    isCollisionFree

  getPieceIndeces: (position = {x: @xIndex, y: @yIndex})->
    indeces = []
    for a in PieceMap[@currentPieceType][@rotation]
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
      cell.color = 'red'

  didPlayerLose: ->
    isGameOver = false
    frozenCellIds = (cell.id for cell in @frozenCells())
    console.log frozenCellIds
    isGameOver = true for id in frozenCellIds when id in [0...20]
    isGameOver

Dispatcher.register (payload) ->
  switch payload.eventName
    when 'board:init'
      boardData = new BoardData()
    when 'board:setPieceIndeces'
      if boardData.isCollisionFree({xIndex: payload.value.xIndex, yIndex: payload.value.yIndex})
        boardData.updateAttribs(xIndex: payload.value.xIndex, yIndex: payload.value.yIndex)
        BoardStore.triggerChange()
    when 'board:dropPiece'
      while boardData.isCollisionFree({xIndex: boardData.xIndex, yIndex: boardData.yIndex + 1})
        boardData.updateAttribs(yIndex: boardData.yIndex + 1)
      BoardStore.triggerChange()
    when 'board:nextTurn'
      boardData.updateAttribs(turnCount: boardData.turnCount + 1)
      if boardData.isCollisionFree({xIndex: boardData.xIndex, yIndex: boardData.yIndex + 1})
        boardData.updateAttribs(yIndex: boardData.yIndex + 1)
      else
        boardData.freezeCells()
        if boardData.didPlayerLose()
          boardData.updateAttribs(isGameOver: true)
        else
          boardData.updateAttribs(yIndex: 0, xIndex: 5, currentPieceType: boardData.randomPiece())
      BoardStore.triggerChange()
    when 'board:rotatePiece'
      rotation = Math.abs((4 + payload.value + boardData.rotation) % 4)
      if boardData.isCollisionFree({xIndex: boardData.xIndex, yIndex: boardData.yIndex}, rotation)
        boardData.updateAttribs(rotation: rotation)
        BoardStore.triggerChange()

MicroEvent.mixin( BoardStore )
module.exports = BoardStore
