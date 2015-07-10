Dispatcher = require 'dispatcher'

Action =
  toggleMute: ->
    Dispatcher.dispatch
      eventName: 'audio:toggleMute'

module.exports = Action
