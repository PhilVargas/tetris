Dispatcher = require 'dispatcher'
MicroEvent = require 'microevent-github'
DefaultSettings = require 'helpers/settings'

assign = require 'object-assign'

Store =
  get: (attr) ->
    settingsData[attr]

  getAll: ->
    isColorblindActive: settingsData.isColorblindActive
    boardDisplaySize: settingsData.boardDisplaySize
    isGhostVisible: settingsData.isGhostVisible
    isMuted: settingsData.isMuted
    isPaused: settingsData.isPaused
    shouldAllowQueue: settingsData.shouldAllowQueue

  triggerChange: ->
    @trigger('change')

  unbindChange: (callback) ->
    @unbind('change', callback)

  bindChange: (callback) ->
    @bind('change', callback)

class SettingsData
  constructor: ->
    @boardDisplaySize = DefaultSettings.boardDisplayMap.medium
    @isGhostVisible = true
    @isMuted = false
    @isPaused = false
    @shouldAllowQueue = true
    @isColorblindActive = false

  updateAttribs: (attribs) ->
    assign(this, attribs)

settingsData = new SettingsData()
Dispatcher.register (payload) ->
  switch payload.eventName
    when 'settings:toggleColorBlindMode'
      settingsData.updateAttribs(isColorblindActive: !settingsData.isColorblindActive)
      Store.triggerChange()
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
      if size = DefaultSettings.boardDisplayMap[payload.value]
        settingsData.updateAttribs(boardDisplaySize: size)
        Store.triggerChange()
    when 'settings:togglePause'
      settingsData.updateAttribs(isPaused: !settingsData.isPaused)
      Store.triggerChange()

MicroEvent.mixin( Store )
module.exports = Store
