redux = require 'react-redux'

Game = require 'components/game'
SettingsActions = require 'actions/settings'
GameAction = require 'actions/game'
assign = require 'object-assign'

mapStateToProps = (state) ->
  assign {},
    hasGameBegun: state.game.hasGameBegun
    isGameOver: state.game.isGameOver
    isPaused: state.settings.isPaused
    xIndex: state.game.xIndex
    yIndex: state.game.yIndex


Container = redux.connect(
  mapStateToProps,
  dropPiece: GameAction.creators.dropPiece
  setPieceIndeces: GameAction.creators.setPieceIndeces
  togglePause: SettingsActions.creators.togglePause
  rotateClockwise: GameAction.creators.rotateClockwise
  rotateCounterClockwise: GameAction.creators.rotateCounterClockwise
  queuePiece: GameAction.creators.queuePiece
)(Game)

module.exports = Container


