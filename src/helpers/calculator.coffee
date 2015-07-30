Settings = require 'helpers/settings'

Calculate =
  turnDelay: (level) ->
    Math.max(Settings.minTurnDelay, Settings.initialTurnDelay - (50*level))

  level: (totalLinesCleared) ->
    Math.min(10, totalLinesCleared // 10)

  scoreThisTurn: (linesClearedThisTurn, scoreMultiplier) ->
    [0,40,100,300,1200][linesClearedThisTurn] * ( 1 + scoreMultiplier )

  rotation: (currentRotation, increment) ->
    Math.abs((4 + increment + currentRotation) % 4)

  cellIndexFromCoords: (xIndex, yIndex) ->
    xIndex + (Settings.boardWidth*yIndex)

  cellEdgeLength: (boardDisplaySize = 0) ->
    Settings.cellEdgeLength + boardDisplaySize

module.exports = Calculate
