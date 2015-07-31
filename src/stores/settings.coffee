Dispatcher = require 'dispatcher'
MicroEvent = require 'microevent-github'

assign = require 'object-assign'

Store =
  get: (attr) ->
    settingsData[attr]

  getAll: ->
    isMuted: settingsData.isMuted
    shouldAllowQueue: settingsData.shouldAllowQueue
    isGhostVisible: settingsData.isGhostVisible
    boardDisplaySize: settingsData.boardDisplaySize
    isPaused: settingsData.isPaused

  triggerChange: ->
    @trigger('change')

  unbindChange: (callback) ->
    @unbind('change', callback)

  bindChange: (callback) ->
    @bind('change', callback)

class SettingsData
  constructor: ->
    @isMuted = false
    @isPaused = false
    @shouldAllowQueue = true
    @isGhostVisible = true
    @boardDisplaySize = 5

  updateAttribs: (attribs) ->
    assign(this, attribs)

settingsData = new SettingsData()
Dispatcher.register (payload) ->
  switch payload.eventName
    when 'settings:toggleMute'
      settingsData.updateAttribs(isMuted: !settingsData.isMuted)
      Store.triggerChange()
    when 'settings:toggleQueue'
      settingsData.updateAttribs(shouldAllowQueue: !settingsData.shouldAllowQueue)
      Store.triggerChange()
    when 'settings:toggleGhost'
      settingsData.updateAttribs(isGhostVisible: !settingsData.isGhostVisible)
      Store.triggerChange()
    when 'settings:setBoardDisplaySize'
      settingsData.updateAttribs(boardDisplaySize: payload.value)
      Store.triggerChange()
    when 'settings:togglePause'
      settingsData.updateAttribs(isPaused: !settingsData.isPaused)
      Store.triggerChange()

MicroEvent.mixin( Store )
module.exports = Store
