Action = require.requireActual 'actions/settings'
Dispatcher = require 'dispatcher'

describe 'SettingsAction', ->
  beforeEach ->
    Dispatcher.dispatch.mockClear()

  describe '#toggleQueue', ->
    beforeEach ->
      Action.toggleQueue()

    it 'calls `Dispatcher.dispatch` with an `eventName: "settings:toggleQueue"`', ->
      expect('eventName' of Dispatcher.dispatch.mock.calls[0][0]).toBe true
      expect(Dispatcher.dispatch.mock.calls[0][0]['eventName' ]).toBe 'settings:toggleQueue'

  describe '#toggleGhost', ->
    beforeEach ->
      Action.toggleGhost()

    it 'calls `Dispatcher.dispatch` with an `eventName: "settings:toggleGhost"`', ->
      expect('eventName' of Dispatcher.dispatch.mock.calls[0][0]).toBe true
      expect(Dispatcher.dispatch.mock.calls[0][0]['eventName' ]).toBe 'settings:toggleGhost'

  describe '#togglePause', ->
    beforeEach ->
      Action.togglePause()

    it 'calls `Dispatcher.dispatch` with an `eventName: "settings:togglePause"`', ->
      expect('eventName' of Dispatcher.dispatch.mock.calls[0][0]).toBe true
      expect(Dispatcher.dispatch.mock.calls[0][0]['eventName' ]).toBe 'settings:togglePause'

  describe '#toggleMute', ->
    beforeEach ->
      Action.toggleMute()

    it 'calls `Dispatcher.dispatch` with an `eventName: "settings:toggleMute"`', ->
      expect('eventName' of Dispatcher.dispatch.mock.calls[0][0]).toBe true
      expect(Dispatcher.dispatch.mock.calls[0][0]['eventName' ]).toBe 'settings:toggleMute'

  describe '#setBoardDisplaySize', ->
    size = 'small'
    beforeEach ->
      Action.setBoardDisplaySize(size)

    it 'calls `Dispatcher.dispatch` with an `eventName: "settings:setBoardDisplaySize"`', ->
      expect('eventName' of Dispatcher.dispatch.mock.calls[0][0]).toBe true
      expect(Dispatcher.dispatch.mock.calls[0][0]['eventName' ]).toBe 'settings:setBoardDisplaySize'

    it "calls `Dispatcher.dispatch` with a `value: '#{size}'`", ->
      expect('eventName' of Dispatcher.dispatch.mock.calls[0][0]).toBe true
      expect(Dispatcher.dispatch.mock.calls[0][0]['value' ]).toBe size

