Constants = require('actions/settings').constants
DefaultSettings = require 'helpers/settings'

assign = require('object-assign')

initialState =
    boardDisplaySize: DefaultSettings.boardDisplayMap.medium
    isGhostVisible: true
    isMuted: false
    isPaused: false
    shouldAllowQueue: true
    isColorblindActive: false

settings = (state, action) ->
  return initialState unless state?

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
      size = DefaultSettings.boardDisplayMap[action.payload]
      assign({}, state, boardDisplaySize: size)
    else state

module.exports = settings
