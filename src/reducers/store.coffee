redux = require 'redux'

assign = require 'object-assign'

settingsReducer = require 'reducers/settings'
gameReducer = require 'reducers/game'

reducer = (state, action) ->
  gameState = null
  if state?.game then gameState = assign {}, state.game, isPaused: state.settings?.isPaused
  # gameState = assign {}, state?.game,
  #   isPaused: state?.settings?.isPaused
  settings: settingsReducer(state?.settings, action)
  game: gameReducer(gameState, action)

store = redux.createStore(reducer)

module.exports = store
