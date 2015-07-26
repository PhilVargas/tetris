describe 'BoardStore', ->
  Dispatcher = BoardStore = callback = null

  beforeEach ->
    Dispatcher = require('dispatcher')
    BoardStore = require.requireActual('stores/board')
    callback = Dispatcher.register.mock.calls[0][0]
    BoardStore.triggerChange = jest.genMockFunction()

  it 'registers a call with the dispatcher', ->
    expect(Dispatcher.register.mock.calls.length).toBe(1)

