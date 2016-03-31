Constants = require('actions/settings').constants

assign = require('object-assign')

settings = (state, action) ->
  switch action.type
    when Constants.TOGGLE_COLOR_BLIND_MODE
      assign({}, state, isColorblindActive: !state.isColorblindActive)
    when Constants.TOGGLE_MUTE
      assign({}, state, isMuted: !state.isMuted)
    when Constants.TOGGLE_GHOST
      assign({}, state, isGhostVisible: !state.isGhostVisible)
    when Constants.TOGGLE_PAUSE
      assign({}, state, isPaused: !state.isPaused)
    when Constants.TOGGLE_QUEUE
      assign({}, state, shouldAllowQueue: !state.shouldAllowQueue)
    when Constants.SET_BOARD_DISPLAY_SIZE
      assign({}, state, boardDisplaySize: action.payload)
    else state

module.exports = settings
