Dispatcher = require 'dispatcher'

Action =
  toggleColorBlindMode: ->
    Dispatcher.dispatch
      eventName: 'settings:toggleColorBlindMode'

  toggleMute: ->
    Dispatcher.dispatch
      eventName: 'settings:toggleMute'

  togglePause: ->
    Dispatcher.dispatch
      eventName: 'settings:togglePause'

  toggleQueue: ->
    Dispatcher.dispatch
      eventName: 'settings:toggleQueue'

  toggleGhost: ->
    Dispatcher.dispatch
      eventName: 'settings:toggleGhost'

  setBoardDisplaySize: (size) ->
    Dispatcher.dispatch
      eventName: 'settings:setBoardDisplaySize'
      value: size

module.exports = Action
