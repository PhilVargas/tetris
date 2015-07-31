Settings = require 'helpers/settings'

Calculate =
  cellIndexFromCoords: (xIndex, yIndex) ->
    xIndex + (Settings.boardWidth*yIndex)

  level: (totalLinesCleared) ->
    Math.min(10, totalLinesCleared // 10)

  rotation: (currentRotation, increment) ->
    Math.abs((4 + increment + currentRotation) % 4)

  scoreThisTurn: (linesClearedThisTurn, scoreMultiplier) ->
    [0,40,100,300,1200][linesClearedThisTurn] * ( 1 + scoreMultiplier )

  turnDelay: (level) ->
    Math.max(Settings.minTurnDelay, Settings.initialTurnDelay - (50*level))

module.exports = Calculate
