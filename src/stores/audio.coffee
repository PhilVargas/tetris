Dispatcher = require 'dispatcher'
MicroEvent = require 'microevent-github'

assign = require 'object-assign'

AudioStore =
  get: (attr) ->
    audioData[attr]

  getAll: ->
    isMuted: audioData.isMuted

  triggerChange: ->
    @trigger('change')

  unbindChange: (callback) ->
    @unbind('change', callback)

  bindChange: (callback) ->
    @bind('change', callback)

class AudioData
  constructor: ->
    @isMuted = false

  updateAttribs: (attribs) ->
    assign(this, attribs)

audioData = new AudioData()
Dispatcher.register (payload) ->
  switch payload.eventName
    when 'audio:toggleMute'
      audioData.updateAttribs(isMuted: !audioData.isMuted)
      AudioStore.triggerChange()

MicroEvent.mixin( AudioStore )
module.exports = AudioStore
