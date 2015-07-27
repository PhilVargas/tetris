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
    hasGameBegun: boardData.hasGameBegun
    xIndex: boardData.xIndex
    yIndex: boardData.yIndex
    ghostYIndex: boardData.ghostYIndex
    turnCount: boardData.turnCount
    currentPieceType: boardData.currentPieceType
    nextPieceType: boardData.nextPieceType
    queuePieceType: boardData.queuePieceType
    canQueuePiece: boardData.canQueuePiece
    cells: boardData.cells
    rotation: boardData.rotation
    isGameOver: boardData.isGameOver
    isPaused: boardData.isPaused
    score: boardData.score
    scoreThisTurn: boardData.scoreThisTurn
    linesCleared: boardData.linesCleared
    isGhostVisible: boardData.isGhostVisible
    shouldAllowQueue: boardData.shouldAllowQueue
    linesCleared: boardData.linesCleared

  triggerChange: ->
    @trigger('change')

  unbindChange: (callback) ->
    @unbind('change', callback)

  bindChange: (callback) ->
    @bind('change', callback)

  isCollisionFree: (nextPosition, rotation) ->
    boardData.isCollisionFree(nextPosition, rotation)

  didPlayerLose: ->
    boardData.didPlayerLose()

  calculateScoreThisTurn: (linesClearedThisTurn)->
    boardData.calculateScoreThisTurn(linesClearedThisTurn)

  level: ->
    boardData.level()

  turnDelay: ->
    Math.max(Settings.minTurnDelay, Settings.initialTurnDelay - (50*@level()))

class BoardData
  constructor: ->
    @xIndex = Settings.initialX
    @yIndex = Settings.initialY
    @linesCleared = 0
    @ghostYIndex = 0
    @width = Settings.boardWidth
    @height = Settings.boardHeight
    @hiddenRows = Settings.hiddenRows
    @turnCount = 0
    @currentPieceType = @randomPiece()
    @nextPieceType = @randomPiece()
    @queuePieceType = ''
    @canQueuePiece = true
    @cells = @generateCells()
    @rotation = 0
    @isGameOver = false
    @isPaused = false
    @color = PieceMap[@currentPieceType].color
    @score = 0
    @scoreThisTurn = 0
    @isGhostVisible = true
    @shouldAllowQueue = true
    @hasGameBegun = false

  initialGameState: ->
    currentPieceType = @randomPiece()
    linesCleared: 0
    ghostYindex: 0
    turnCount: 0
    currentPieceType: currentPieceType
    nextPieceType: @randomPiece()
    queuePieceType: ''
    rotation: 0
    isGameOver: false
    isPaused: false
    cells: @generateCells()
    color: PieceMap[currentPieceType].color
    score: 0
    scoreThisTurn: 0

  generateCells: ->
    cells =[]
    count = 0
    for y in [0...@height]
      for x in [0...@width]
        cells.push { id: count, yIndex: y, xIndex: x, isFrozen: false, color: Settings.defaultCellBackgroundColor }
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

  hasCollision: (nextPosition, cell) ->
    !(0 <= nextPosition.xIndex + cell.x < @width) ||
      nextPosition.yIndex + cell.y >= @height ||
      @isFrozenCell(x: nextPosition.xIndex + cell.x, y: nextPosition.yIndex + cell.y)

  isCollisionFree: (nextPosition, rotation = @rotation) =>
    isCollisionFree = true
    for cell in PieceMap[@currentPieceType].shapes[rotation] when @hasCollision(nextPosition, cell)
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
      cell.x + (@width*cell.y)
    cellIds

  freezeCells: ->
    cellIds = @getCellIdsFromIndeces()
    for cell in @cells when cell.id in cellIds
      cell.isFrozen = true
      cell.color = @color

  didPlayerLose: ->
    isGameOver = false
    frozenCellIds = (cell.id for cell in @frozenCells())
    isGameOver = true for id in frozenCellIds when id in [0...(@width * @hiddenRows)]
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
      cell.color = Settings.defaultCellBackgroundColor

  drawGhost: ->
    yIndex = @yIndex
    @updateAttribs(ghostYIndex: yIndex) unless boardData.isCollisionFree({xIndex: @xIndex, yIndex: yIndex + 1})
    while boardData.isCollisionFree({xIndex: @xIndex, yIndex: yIndex + 1})
      @updateAttribs(ghostYIndex: yIndex + 1)
      yIndex++

  level: ->
    Math.min(10, @linesCleared // 10)

  calculateScoreThisTurn: (linesClearedThisTurn)->
    [0,40,100,300,1200][linesClearedThisTurn] * ( 1 + @level() )

  scoreRows: ->
    linesClearedThisTurn = 0
    while @isAnyRowFrozen()
      linesClearedThisTurn++
      @clearFrozenRow(@getRows())
    scoreThisTurn = @calculateScoreThisTurn(linesClearedThisTurn)
    {scoreThisTurn, linesClearedThisTurn}

Dispatcher.register (payload) ->
  switch payload.eventName
    when 'board:init'
      boardData = new BoardData()
      boardData.drawGhost()
      BoardStore.triggerChange()
    when 'board:startGame'
      boardData.updateAttribs(hasGameBegun: true)
      BoardStore.triggerChange()
    when 'board:restartGame'
      boardData.updateAttribs(boardData.initialGameState())
      boardData.drawGhost()
      BoardStore.triggerChange()
    when 'board:setPieceIndeces'
      if BoardStore.isCollisionFree({xIndex: payload.value.xIndex, yIndex: payload.value.yIndex})
        boardData.updateAttribs(xIndex: payload.value.xIndex, yIndex: payload.value.yIndex)
      boardData.drawGhost()
      BoardStore.triggerChange()
    when 'board:dropPiece'
      scoreThisTurn = 0
      while BoardStore.isCollisionFree({xIndex: boardData.xIndex, yIndex: boardData.yIndex + 1})
        scoreThisTurn++
        boardData.updateAttribs(yIndex: boardData.yIndex + 1)
      boardData.updateAttribs(score: boardData.score + scoreThisTurn, scoreThisTurn: scoreThisTurn) if scoreThisTurn
      BoardStore.triggerChange()
    when 'board:togglePause'
      boardData.updateAttribs(isPaused: !boardData.isPaused)
      BoardStore.triggerChange()
    when 'board:nextTurn'
      return if BoardStore.get('isPaused')
      boardData.updateAttribs(turnCount: boardData.turnCount + 1)
      if BoardStore.isCollisionFree({xIndex: boardData.xIndex, yIndex: boardData.yIndex + 1})
        boardData.updateAttribs(yIndex: boardData.yIndex + 1)
      else
        boardData.freezeCells()
        if BoardStore.didPlayerLose()
          boardData.updateAttribs(isGameOver: true)
        else
          { scoreThisTurn, linesClearedThisTurn } = boardData.scoreRows()
          nextPiece = boardData.randomPiece()
          boardData.updateAttribs(
            linesCleared: boardData.linesCleared + linesClearedThisTurn
            score: boardData.score + scoreThisTurn
            yIndex: Settings.initialY
            xIndex: Settings.initialX
            rotation: 0
            currentPieceType: boardData.nextPieceType
            color: PieceMap[boardData.nextPieceType].color
            nextPieceType: nextPiece
            canQueuePiece: true
          )
          boardData.updateAttribs(scoreThisTurn: scoreThisTurn) if scoreThisTurn
          boardData.drawGhost()
      BoardStore.triggerChange()
    when 'board:rotatePiece'
      rotation = Math.abs((4 + payload.value + boardData.rotation) % 4)
      if BoardStore.isCollisionFree({ xIndex: boardData.xIndex, yIndex: boardData.yIndex }, rotation)
        boardData.updateAttribs(rotation: rotation)
        boardData.drawGhost()
        BoardStore.triggerChange()
    when 'board:queuePiece'
      if BoardStore.get('canQueuePiece') && BoardStore.get('shouldAllowQueue')
        boardData.updateAttribs
          yIndex: Settings.initialY
          xIndex: Settings.initialX
          rotation: 0
        if BoardStore.get('queuePieceType')
          boardData.updateAttribs
            queuePieceType: BoardStore.get('currentPieceType')
            currentPieceType: BoardStore.get('queuePieceType')
            color: PieceMap[BoardStore.get('queuePieceType')].color
        else
          boardData.updateAttribs
            queuePieceType: BoardStore.get('currentPieceType')
            currentPieceType: BoardStore.get('nextPieceType')
            color: PieceMap[boardData.nextPieceType].color
            nextPieceType: boardData.randomPiece()
      boardData.drawGhost()
      boardData.updateAttribs(canQueuePiece: false)
      BoardStore.triggerChange()
    when 'board:toggleQueue'
      boardData.updateAttribs(shouldAllowQueue: !boardData.shouldAllowQueue)
      BoardStore.triggerChange()
    when 'board:toggleGhost'
      boardData.updateAttribs(isGhostVisible: !boardData.isGhostVisible)
      BoardStore.triggerChange()


MicroEvent.mixin( BoardStore )
module.exports = BoardStore
