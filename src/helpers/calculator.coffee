Settings = require 'helpers/settings'

Calculate =
  turnDelay: (level) ->
    Math.max(Settings.minTurnDelay, Settings.initialTurnDelay - (50*level))

  level: (totalLinesCleared) ->
    # Math.min(10, @linesCleared // 10)
module.exports = Calculate
