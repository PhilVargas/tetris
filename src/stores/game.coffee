Dispatcher = require 'dispatcher'
MicroEvent = require 'microevent-github'
PieceMap = require 'helpers/piece-map'
Settings = require 'helpers/settings'
Calculate = require 'helpers/calculator'
SettingsStore = require 'stores/settings'

assign = require 'object-assign'

gameData = null
Store =
  get: (attr) ->
    gameData[attr]

  getAll: ->
    canQueuePiece: gameData.canQueuePiece
    cells: gameData.cells
    currentPieceType: gameData.currentPieceType
    ghostYIndex: gameData.ghostYIndex
    hasGameBegun: gameData.hasGameBegun
    isGameOver: gameData.isGameOver
    linesCleared: gameData.linesCleared
    nextPieceType: gameData.nextPieceType
    queuePieceType: gameData.queuePieceType
    rotation: gameData.rotation
    score: gameData.score
    scoreThisTurn: gameData.scoreThisTurn
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

  calculateScoreThisTurn: (linesClearedThisTurn) ->
    gameData.calculateScoreThisTurn(linesClearedThisTurn)

  level: ->
    gameData.level()

  scoreRows: ->
    gameData.scoreRows()

  turnDelay: ->
    Calculate.turnDelay(@level())

class BoardData
  constructor: ->
    @canQueuePiece = true
    @currentPieceType = @randomPiece()
    @ghostYIndex = 0
    @hasGameBegun = false
    @height = Settings.boardHeight
    @hiddenRows = Settings.hiddenRows
    @isGameOver = false
    @linesCleared = 0
    @nextPieceType = @randomPiece()
    @queuePieceType = ''
    @rotation = 0
    @score = 0
    @scoreThisTurn = 0
    @turnCount = 0
    @width = Settings.boardWidth
    @xIndex = Settings.initialX
    @yIndex = Settings.initialY
    @cells = @generateCells()

  initialGameState: ->
    currentPieceType: @randomPiece()
    ghostYindex: 0
    isGameOver: false
    isPaused: false
    linesCleared: 0
    nextPieceType: @randomPiece()
    queuePieceType: ''
    rotation: 0
    score: 0
    scoreThisTurn: 0
    turnCount: 0
    cells: @generateCells()

  generateCells: ->
    cells = []
    count = 0
    for y in [0...@height]
      for x in [0...@width]
        cells.push { id: count, yIndex: y, xIndex: x, isFrozen: false, cellPieceType: 'E' }
        count++
    cells

  randomPiece: ->
    possiblePieces = ['I', 'Z', 'S', 'O', 'J', 'L', 'T']
    randomInt = (Math.random() * possiblePieces.length) // 1
    possiblePieces[randomInt]

  updateAttribs: (attribs) ->
    assign(this, attribs)

  hasCollision: (nextPosition, cell) ->
    cellIndex = Calculate.cellIndexFromCoords(nextPosition.xIndex + cell.x, nextPosition.yIndex + cell.y)
    !(0 <= nextPosition.xIndex + cell.x < @width) ||
      nextPosition.yIndex + cell.y >= @height ||
      @cells[cellIndex].isFrozen

  isCollisionFree: (nextPosition, rotation = @rotation) =>
    !PieceMap[@currentPieceType].shapes[rotation].some (cell) =>
      @hasCollision(nextPosition, cell)

  getCellIdsForPiece: (position = {x: @xIndex, y: @yIndex}) ->
    for pieceCell in PieceMap[@currentPieceType].shapes[@rotation]
      Calculate.cellIndexFromCoords(position.x + pieceCell.x, position.y + pieceCell.y)

  freezeCells: ->
    cellIds = @getCellIdsForPiece()
    for cell in @cells when cell.id in cellIds
      cell.isFrozen = true
      cell.cellPieceType = @currentPieceType

  didPlayerLose: ->
    @cells.some (cell) => cell.isFrozen && cell.id in [0...(@width * @hiddenRows)]

  getRows: ->
    for i in [0...@height]
      @cells[@width * i...@width * (i + 1)]

  isAnyRowFrozen: =>
    @getRows().some @isRowFrozen

  isRowFrozen: (row) ->
    row.every (cell) -> cell.isFrozen

  clearFrozenRow: (rows) ->
    frozenIndex = null
    for row, i in rows when @isRowFrozen(row)
      frozenIndex = i
      break
    if frozenIndex > 0
      prevRow = rows[frozenIndex - 1]
      row = rows[frozenIndex]
      for cell, j in row
        [row[j].isFrozen, row[j].cellPieceType,prevRow[j].isFrozen, prevRow[j].cellPieceType] = [prevRow[j].isFrozen, prevRow[j].cellPieceType, row[j].isFrozen, row[j].cellPieceType]
      @clearFrozenRow(rows)
    for cell in rows[0]
      cell.isFrozen = false
      cell.cellPieceType = 'E'

  drawGhost: ->
    nextYIndex = @yIndex + 1
    @updateAttribs(ghostYIndex: @yIndex)
    while gameData.isCollisionFree({xIndex: @xIndex, yIndex: nextYIndex})
      @updateAttribs(ghostYIndex: nextYIndex)
      nextYIndex++

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
      Store.triggerChange()
    when 'xgame:startGame'
      gameData.updateAttribs(hasGameBegun: true)
      Store.triggerChange()
    when 'xgame:restartGame'
      gameData.updateAttribs(gameData.initialGameState())
      gameData.drawGhost()
      Store.triggerChange()
    when 'xgame:setPieceIndeces'
      if Store.isCollisionFree({xIndex: payload.value.xIndex, yIndex: payload.value.yIndex})
        gameData.updateAttribs(xIndex: payload.value.xIndex, yIndex: payload.value.yIndex)
      gameData.drawGhost()
      Store.triggerChange()
    when 'xgame:dropPiece'
      scoreThisTurn = 0
      while Store.isCollisionFree({xIndex: gameData.xIndex, yIndex: gameData.yIndex + 1})
        scoreThisTurn++
        gameData.updateAttribs(yIndex: gameData.yIndex + 1)
      gameData.updateAttribs(score: gameData.score + scoreThisTurn, scoreThisTurn: scoreThisTurn) if scoreThisTurn
      Store.triggerChange()
    when 'xgame:nextTurn'
      return if SettingsStore.get('isPaused')
      gameData.updateAttribs(turnCount: gameData.turnCount + 1)
      if Store.isCollisionFree(xIndex: gameData.xIndex, yIndex: gameData.yIndex + 1)
        gameData.updateAttribs(yIndex: gameData.yIndex + 1)
      else
        gameData.freezeCells()
        if Store.didPlayerLose()
          gameData.updateAttribs(isGameOver: true)
        else
          { scoreThisTurn, linesClearedThisTurn } = Store.scoreRows()
          nextPiece = gameData.randomPiece()
          gameData.updateAttribs(
            linesCleared: gameData.linesCleared + linesClearedThisTurn
            score: gameData.score + scoreThisTurn
            yIndex: Settings.initialY
            xIndex: Settings.initialX
            rotation: 0
            currentPieceType: gameData.nextPieceType
            nextPieceType: nextPiece
            canQueuePiece: true
          )
          gameData.updateAttribs(scoreThisTurn: scoreThisTurn) if scoreThisTurn
          gameData.drawGhost()
      Store.triggerChange()
    when 'xgame:rotatePiece'
      rotation = gameData.calculateRotation(payload.value)
      if Store.isCollisionFree({ xIndex: gameData.xIndex, yIndex: gameData.yIndex }, rotation)
        gameData.updateAttribs(rotation: rotation)
        gameData.drawGhost()
        Store.triggerChange()
    when 'xgame:queuePiece'
      if Store.get('canQueuePiece') && SettingsStore.get('shouldAllowQueue')
        gameData.updateAttribs
          yIndex: Settings.initialY
          xIndex: Settings.initialX
          rotation: 0
        if Store.get('queuePieceType')
          gameData.updateAttribs
            queuePieceType: Store.get('currentPieceType')
            currentPieceType: Store.get('queuePieceType')
        else
          gameData.updateAttribs
            queuePieceType: Store.get('currentPieceType')
            currentPieceType: Store.get('nextPieceType')
            nextPieceType: gameData.randomPiece()
        gameData.drawGhost()
        gameData.updateAttribs(canQueuePiece: false)
        Store.triggerChange()


MicroEvent.mixin( Store )
module.exports = Store
