redux = require 'react-redux'

Game = require 'components/game'
SettingsActions = require 'actions/settings'
GameAction = require 'actions/game'
assign = require 'object-assign'

mapStateToProps = (state) ->
  assign {}, state.game, state.settings


Container = redux.connect(
  mapStateToProps,
  assign({}, SettingsActions.creators, GameAction.creators)
)(Game)

module.exports = Container


