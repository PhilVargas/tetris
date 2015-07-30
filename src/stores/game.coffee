Dispatcher = require 'dispatcher'
MicroEvent = require 'microevent-github'
PieceMap = require 'helpers/piece-map'
Settings = require 'helpers/settings'
Calculate = require 'helpers/calculator'

assign = require 'object-assign'

gameData = null
GameStore =
  get: (attr) ->
    gameData[attr]

  getAll: ->
    boardDisplaySize: gameData.boardDisplaySize
    canQueuePiece: gameData.canQueuePiece
    cells: gameData.cells
    currentPieceType: gameData.currentPieceType
    ghostYIndex: gameData.ghostYIndex
    hasGameBegun: gameData.hasGameBegun
    isGameOver: gameData.isGameOver
    isGhostVisible: gameData.isGhostVisible
    isPaused: gameData.isPaused
    linesCleared: gameData.linesCleared
    nextPieceType: gameData.nextPieceType
    queuePieceType: gameData.queuePieceType
    rotation: gameData.rotation
    score: gameData.score
    scoreThisTurn: gameData.scoreThisTurn
    shouldAllowQueue: gameData.shouldAllowQueue
    turnCount: gameData.turnCount
    xIndex: gameData.xIndex
    yIndex: gameData.yIndex

  triggerChange: ->
    @trigger('change')

  unbindChange: (callback) ->
    @unbind('change', callback)

  bindChange: (callback) ->
    @bind('change', callback)

  isCollisionFree: (nextPosition, rotation) ->
    gameData.isCollisionFree(nextPosition, rotation)

  didPlayerLose: ->
    gameData.didPlayerLose()

  calculateScoreThisTurn: (linesClearedThisTurn)->
    gameData.calculateScoreThisTurn(linesClearedThisTurn)

  level: ->
    gameData.level()

  scoreRows: ->
    gameData.scoreRows()

  turnDelay: ->
    Calculate.turnDelay(@level())

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
    @boardDisplaySize = 5

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

  randomPiece: ->
    randomInt = Math.floor(Math.random() * Object.keys(PieceMap).length)
    Object.keys(PieceMap)[randomInt]

  updateAttribs: (attribs) ->
    assign(this, attribs)

  hasCollision: (nextPosition, cell) ->
    cellIndex = Calculate.cellIndexFromCoords(nextPosition.xIndex + cell.x, nextPosition.yIndex + cell.y)
    !(0 <= nextPosition.xIndex + cell.x < @width) ||
      nextPosition.yIndex + cell.y >= @height ||
      @cells[cellIndex].isFrozen

  isCollisionFree: (nextPosition, rotation = @rotation) =>
    isCollisionFree = true
    for cell in PieceMap[@currentPieceType].shapes[rotation] when @hasCollision(nextPosition, cell)
      isCollisionFree = false
      break
    isCollisionFree

  getPieceIndeces: (position = {x: @xIndex, y: @yIndex})->
    indeces = []
    for a in PieceMap[@currentPieceType].shapes[@rotation]
      indeces.push {x: position.x + a.x, y: position.y + a.y}
    indeces

  getCellIdsForPiece: ->
    piece = @getPieceIndeces()
    cellIds = for cell in piece
      Calculate.cellIndexFromCoords(cell.x, cell.y)
    cellIds

  freezeCells: ->
    cellIds = @getCellIdsForPiece()
    for cell in @cells when cell.id in cellIds
      cell.isFrozen = true
      cell.color = @color

  didPlayerLose: ->
    isGameOver = false
    for cell in @cells when cell.isFrozen && cell.id in [0...(@width * @hiddenRows)]
      isGameOver = true
      break
    isGameOver

  getRows: ->
    rows = []
    for i in [0...@height]
      rows.push @cells[@width*i...@width*(i+1)]
    rows

  isAnyRowFrozen: ->
    isAnyRowFrozen = false
    for row in @getRows() when @isRowFrozen(row)
      isAnyRowFrozen = true
      break
    isAnyRowFrozen

  isRowFrozen: (row) ->
    isRowFrozen = true
    for cell in row when not cell.isFrozen
      isRowFrozen = false
      break
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
    @updateAttribs(ghostYIndex: yIndex) unless gameData.isCollisionFree({xIndex: @xIndex, yIndex: yIndex + 1})
    while gameData.isCollisionFree({xIndex: @xIndex, yIndex: yIndex + 1})
      @updateAttribs(ghostYIndex: yIndex + 1)
      yIndex++

  level: ->
    Calculate.level(@linesCleared)

  calculateScoreThisTurn: (linesClearedThisTurn) ->
    Calculate.scoreThisTurn(linesClearedThisTurn, @level())

  calculateRotation: (increment) ->
    Calculate.rotation(@rotation, increment)

  scoreRows: ->
    linesClearedThisTurn = 0
    while @isAnyRowFrozen()
      linesClearedThisTurn++
      @clearFrozenRow(@getRows())
    scoreThisTurn = @calculateScoreThisTurn(linesClearedThisTurn)
    {scoreThisTurn, linesClearedThisTurn}

Dispatcher.register (payload) ->
  switch payload.eventName
    when 'game:init'
      gameData = new BoardData()
      gameData.drawGhost()
      GameStore.triggerChange()
    when 'game:startGame'
      gameData.updateAttribs(hasGameBegun: true)
      GameStore.triggerChange()
    when 'game:restartGame'
      gameData.updateAttribs(gameData.initialGameState())
      gameData.drawGhost()
      GameStore.triggerChange()
    when 'game:setPieceIndeces'
      if GameStore.isCollisionFree({xIndex: payload.value.xIndex, yIndex: payload.value.yIndex})
        gameData.updateAttribs(xIndex: payload.value.xIndex, yIndex: payload.value.yIndex)
      gameData.drawGhost()
      GameStore.triggerChange()
    when 'game:dropPiece'
      scoreThisTurn = 0
      while GameStore.isCollisionFree({xIndex: gameData.xIndex, yIndex: gameData.yIndex + 1})
        scoreThisTurn++
        gameData.updateAttribs(yIndex: gameData.yIndex + 1)
      gameData.updateAttribs(score: gameData.score + scoreThisTurn, scoreThisTurn: scoreThisTurn) if scoreThisTurn
      GameStore.triggerChange()
    when 'game:togglePause'
      unless GameStore.get('isGameOver')
        gameData.updateAttribs(isPaused: !gameData.isPaused)
        GameStore.triggerChange()
    when 'game:nextTurn'
      return if GameStore.get('isPaused')
      gameData.updateAttribs(turnCount: gameData.turnCount + 1)
      if GameStore.isCollisionFree(xIndex: gameData.xIndex, yIndex: gameData.yIndex + 1)
        gameData.updateAttribs(yIndex: gameData.yIndex + 1)
      else
        gameData.freezeCells()
        if GameStore.didPlayerLose()
          gameData.updateAttribs(isGameOver: true)
        else
          { scoreThisTurn, linesClearedThisTurn } = GameStore.scoreRows()
          nextPiece = gameData.randomPiece()
          gameData.updateAttribs(
            linesCleared: gameData.linesCleared + linesClearedThisTurn
            score: gameData.score + scoreThisTurn
            yIndex: Settings.initialY
            xIndex: Settings.initialX
            rotation: 0
            currentPieceType: gameData.nextPieceType
            color: PieceMap[gameData.nextPieceType].color
            nextPieceType: nextPiece
            canQueuePiece: true
          )
          gameData.updateAttribs(scoreThisTurn: scoreThisTurn) if scoreThisTurn
          gameData.drawGhost()
      GameStore.triggerChange()
    when 'game:rotatePiece'
      rotation = gameData.calculateRotation(payload.value)
      if GameStore.isCollisionFree({ xIndex: gameData.xIndex, yIndex: gameData.yIndex }, rotation)
        gameData.updateAttribs(rotation: rotation)
        gameData.drawGhost()
        GameStore.triggerChange()
    when 'game:queuePiece'
      if GameStore.get('canQueuePiece') && GameStore.get('shouldAllowQueue')
        gameData.updateAttribs
          yIndex: Settings.initialY
          xIndex: Settings.initialX
          rotation: 0
        if GameStore.get('queuePieceType')
          gameData.updateAttribs
            queuePieceType: GameStore.get('currentPieceType')
            currentPieceType: GameStore.get('queuePieceType')
            color: PieceMap[GameStore.get('queuePieceType')].color
        else
          gameData.updateAttribs
            queuePieceType: GameStore.get('currentPieceType')
            currentPieceType: GameStore.get('nextPieceType')
            color: PieceMap[gameData.nextPieceType].color
            nextPieceType: gameData.randomPiece()
        gameData.drawGhost()
        gameData.updateAttribs(canQueuePiece: false)
        GameStore.triggerChange()
    when 'game:toggleQueue'
      gameData.updateAttribs(shouldAllowQueue: !gameData.shouldAllowQueue)
      GameStore.triggerChange()
    when 'game:toggleGhost'
      gameData.updateAttribs(isGhostVisible: !gameData.isGhostVisible)
      GameStore.triggerChange()
    when 'game:setBoardDisplaySize'
      gameData.updateAttribs(boardDisplaySize: payload.value)
      GameStore.triggerChange()


MicroEvent.mixin( GameStore )
module.exports = GameStore
