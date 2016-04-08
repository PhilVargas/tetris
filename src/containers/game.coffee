redux = require 'react-redux'

Game = require 'components/game'
SettingsActions = require 'actions/settings'
GameAction = require 'actions/game'
assign = require 'object-assign'

mapStateToProps = (state) ->
  assign {}, state.game,
    isPaused: state?.settings?.isPaused

Container = redux.connect(
  mapStateToProps,
  assign({}, SettingsActions.creators, GameAction.creators)
)(Game)

module.exports = Container


