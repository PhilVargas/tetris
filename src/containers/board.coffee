redux = require 'react-redux'

Board = require 'components/board'
GameAction = require 'actions/game'
SettingsActions = require 'actions/settings'

assign = require 'object-assign'

mapStateToProps = (state) ->
  assign {}, state.game,
    isPaused: state?.settings?.isPaused
    isGhostVisible: state?.settings?.isGhostVisible
    isMuted: state?.settings?.isMuted
    isColorblindActive: state?.settings?.isColorblindActive
    cellEdgeLength: state?.settings?.boardDisplaySize

Container = redux.connect(
  mapStateToProps,
  startGame: GameAction.creators.startGame
  restartGame: GameAction.creators.restartGame
  nextTurn: GameAction.creators.nextTurn
)(Board)

module.exports = Container

