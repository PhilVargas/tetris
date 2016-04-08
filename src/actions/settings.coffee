# Dispatcher = require 'dispatcher'
#
# Action =
#   toggleColorBlindMode: ->
#     Dispatcher.dispatch
#       eventName: 'settings:toggleColorBlindMode'
#
#   toggleMute: ->
#     Dispatcher.dispatch
#       eventName: 'settings:toggleMute'
#
#   togglePause: ->
#     Dispatcher.dispatch
#       eventName: 'settings:togglePause'
#
#   toggleQueue: ->
#     Dispatcher.dispatch
#       eventName: 'settings:toggleQueue'
#
#   toggleGhost: ->
#     Dispatcher.dispatch
#       eventName: 'settings:toggleGhost'
#
#   setBoardDisplaySize: (size) ->
#     Dispatcher.dispatch
#       eventName: 'settings:setBoardDisplaySize'
#       value: size
#
# module.exports = Action
#

TOGGLE_COLOR_BLIND_MODE = 'TOGGLE_COLOR_BLIND_MODE'
TOGGLE_MUTE = 'TOGGLE_MUTE'
TOGGLE_PAUSE = 'TOGGLE_PAUSE'
TOGGLE_QUEUE = 'TOGGLE_QUEUE'
TOGGLE_GHOST = 'TOGGLE_GHOST'
SET_BOARD_DISPLAY_SIZE = 'SET_BOARD_DISPLAY_SIZE'

module.exports.TOGGLE_COLOR_BLIND_MODE = TOGGLE_COLOR_BLIND_MODE
module.exports.TOGGLE_MUTE = TOGGLE_MUTE
module.exports.TOGGLE_PAUSE = TOGGLE_PAUSE
module.exports.TOGGLE_QUEUE = TOGGLE_QUEUE
module.exports.TOGGLE_GHOST = TOGGLE_GHOST
module.exports.SET_BOARD_DISPLAY_SIZE = SET_BOARD_DISPLAY_SIZE

module.exports.constants =
  TOGGLE_COLOR_BLIND_MODE: TOGGLE_COLOR_BLIND_MODE
  TOGGLE_MUTE: TOGGLE_MUTE
  TOGGLE_PAUSE: TOGGLE_PAUSE
  TOGGLE_QUEUE: TOGGLE_QUEUE
  TOGGLE_GHOST: TOGGLE_GHOST
  SET_BOARD_DISPLAY_SIZE: SET_BOARD_DISPLAY_SIZE

Action =
  toggleColorBlindMode: ->
    type: TOGGLE_COLOR_BLIND_MODE

  toggleMute: ->
    type: TOGGLE_MUTE

  togglePause: ->
    type: TOGGLE_PAUSE

  toggleQueue: ->
    type: TOGGLE_QUEUE

  toggleGhost: ->
    type: TOGGLE_GHOST

  setBoardDisplaySize: (size) ->
    type: SET_BOARD_DISPLAY_SIZE
    payload: size

module.exports.creators = Action
