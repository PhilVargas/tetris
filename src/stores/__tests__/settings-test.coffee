Settings = require 'helpers/settings'

describe 'SettingsStore', ->
  Dispatcher = Store = callback = null

  beforeEach ->
    Dispatcher = require('dispatcher')
    Store = require.requireActual('stores/settings')
    callback = Dispatcher.register.mock.calls[0][0]
    Store.triggerChange = jest.genMockFunction()

  afterEach ->
    Store.triggerChange.mockClear()

  it 'registers a call with the dispatcher', ->
    expect(Dispatcher.register.mock.calls.length).toBe(1)

  describe 'dispatcher actions', ->
    initialValue = null
    describe 'settings:togglePause', ->
      payload = eventName: 'settings:togglePause'

      beforeEach ->
        initialValue = Store.get('isPaused')
        callback payload

      it 'toggles the `state.isPaused`', ->
        expect(Store.get('isPaused')).toBe !initialValue

      it 'calls Store.triggerChange', ->
        expect(Store.triggerChange).toBeCalled()

    describe 'settings:toggleQueue', ->
      payload = eventName: 'settings:toggleQueue'

      beforeEach ->
        initialValue =
          shouldAllowQueue: Store.get('shouldAllowQueue')
        callback payload

      it 'toggles the `state.shouldAllowQueue`', ->
        expect(Store.get('shouldAllowQueue')).toBe !initialValue.shouldAllowQueue

      it 'calls Store.triggerChange', ->
        expect(Store.triggerChange).toBeCalled()

    describe 'settings:toggleMute', ->
      payload = eventName: 'settings:toggleMute'

      beforeEach ->
        initialValue =
          isGhostVisible: Store.get('isMuted')
        callback payload

      it 'toggles the `state.isMuted`', ->
        expect(Store.get('isMuted')).toBe !initialValue.isMuted

      it 'calls Store.triggerChange', ->
        expect(Store.triggerChange).toBeCalled()

    describe 'settings:toggleGhost', ->
      payload = eventName: 'settings:toggleGhost'

      beforeEach ->
        initialValue =
          isGhostVisible: Store.get('isGhostVisible')
        callback payload

      it 'toggles the `state.isGhostVisible`', ->
        expect(Store.get('isGhostVisible')).toBe !initialValue.isGhostVisible

      it 'calls Store.triggerChange', ->
        expect(Store.triggerChange).toBeCalled()

    describe 'settings:setBoardDisplaySize', ->
      describe 'when a valid size is called', ->
        payload =
          eventName: 'settings:setBoardDisplaySize'
          value: 'small'

        beforeEach ->
          initialValue = Store.get('boardDisplaySize')
          callback payload

        it 'changes the board display size', ->
          expect(initialValue).toBe Settings.boardDisplayMap.medium
          expect(Store.get('boardDisplaySize')).toBe Settings.boardDisplayMap[payload.value]

        it 'calls Store.triggerChange', ->
          expect(Store.triggerChange).toBeCalled()

      describe 'when an invalid size is called', ->
        payload =
          eventName: 'settings:setBoardDisplaySize'
          value: 40

        beforeEach ->
          initialValue = Store.get('boardDisplaySize')
          callback payload

        it 'does not change the boardDisplaySize', ->
          expect(Store.get('boardDisplaySize')).toBe initialValue

        it 'does not call Store.triggerChange', ->
          expect(Store.triggerChange).not.toBeCalled()


