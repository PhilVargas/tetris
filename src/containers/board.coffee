redux = require 'react-redux'

Board = require 'components/board'
GameAction = require 'actions/game'
SettingsActions = require 'actions/settings'

assign = require 'object-assign'

mapStateToProps = (state) ->
  cellEdgeLength: state.settings.boardDisplaySize
  cells: state.game.cells
  hasGameBegun: state.game.hasGameBegun
  isColorblindActive: state?.settings?.isColorblindActive
  isGameOver: state.game.isGameOver
  level: state.game.level
  rotation: state.game.rotation
  xIndex: state.game.xIndex
  yIndex: state.game.yIndex

Container = redux.connect(
  mapStateToProps,
  startGame: GameAction.creators.startGame
  restartGame: GameAction.creators.restartGame
  nextTurn: GameAction.creators.nextTurn
)(Board)

module.exports = Container

